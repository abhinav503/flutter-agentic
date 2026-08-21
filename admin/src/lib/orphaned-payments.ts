import { adminDb } from "./firebase-admin";
import {
  createRefund,
  findExistingRefund,
  getStorePaymentConfig,
  toRefundStatus,
  verifyPaymentOwnership,
} from "./payments";
import type { PaymentProvider } from "./payment-providers/types";
import type { OrphanedPaymentReason, RefundStatus } from "./types";

export type { OrphanedPaymentReason };

// A payment that was taken and never became an order.
//
// Checkout is two calls with a gap in the middle: the intent is created and
// paid, then the order route re-prices the cart, re-checks stock and writes
// the order. Anything that changes in that gap — the last unit sold to
// somebody else, a coupon hitting its limit, the address leaving the store's
// delivery areas — fails the second call with the money already captured.
// That used to be left for the store owner to notice and refund by hand from
// the dashboard.
//
// This is the automatic version. It is deliberately NOT settleRefund(): that
// one records the refund onto an order document, and the whole problem here
// is that no order exists.
type RefundOrphanedPaymentInput = {
  storeId: string;
  uid: string;
  provider: PaymentProvider;
  // The provider's intent/order id and the payment id — for Stripe both are
  // the PaymentIntent, same as everywhere else in this codebase.
  paymentOrderId: string;
  paymentId: string;
  // Razorpay's client-side signature; empty for Stripe, which has none.
  paymentSignature: string;
  reason: OrphanedPaymentReason;
};

function orphanedPaymentRef(storeId: string, paymentId: string) {
  return adminDb
    .collection("stores")
    .doc(storeId)
    .collection("orphanedPayments")
    .doc(paymentId);
}

// One case answers "false" for a benign reason: a Razorpay payment that was
// authorized but never captured (the cart failed verification before the
// capture step) has no money to return — the hold expires on its own and the
// bank releases it. Razorpay refuses to refund such a payment, so it records
// as FAILED here; nothing is owed, and the record says which payment it was.
//
// A refund settles asynchronously (Razorpay takes days), and the provider
// reports the outcome by webhook. Both webhook routes look the refund up by
// its payment id and find no order for these — which is correct, there isn't
// one — so this keeps the record honest instead of leaving it PENDING for
// ever. Returns false when the payment isn't one of ours, which is how the
// webhook tells "orphaned refund settled" from "unknown payment".
export async function settleOrphanedRefund(
  storeId: string,
  paymentId: string,
  refundId: string,
  refundStatus: RefundStatus,
): Promise<boolean> {
  const ref = orphanedPaymentRef(storeId, paymentId);
  const snap = await ref.get();
  if (!snap.exists) return false;
  await ref.set({ refundId, refundStatus }, { merge: true });
  return true;
}

// Returns whether the money is on its way back, so the route can tell the
// shopper which of the two things happened to them. Never throws: the
// shopper is already being handed a real error, and turning a failed refund
// into a 500 would replace an explainable message with an unexplainable one.
// A refund that couldn't be issued still leaves the record below, which is
// what the store owner (and support) works from.
export async function refundOrphanedPayment(
  input: RefundOrphanedPaymentInput,
): Promise<boolean> {
  const {
    storeId,
    uid,
    provider,
    paymentOrderId,
    paymentId,
    paymentSignature,
    reason,
  } = input;

  let refundId = "";
  let refundStatus: RefundStatus = "FAILED";
  // Only known once a refund exists — there is no order here to read a total
  // from, so without this the console could show that money moved but not how
  // much.
  let amountMinor: number | undefined;
  let currency: string | undefined;

  try {
    // Keyed to the provider that TOOK the payment, not the store's current
    // one — same rule as settleRefund.
    const config = await getStorePaymentConfig(storeId, provider);
    if (config) {
      // Before returning anyone's money, prove the proof is ours. Without
      // this, a shopper could submit a deliberately doomed cart naming a
      // stranger's payment id and have that stranger's payment refunded.
      const owned = await verifyPaymentOwnership(config, {
        orderId: paymentOrderId,
        paymentId,
        signature: paymentSignature,
      });
      if (owned) {
        // Same idempotency guard as settleRefund: a retry of this same
        // failed checkout must adopt the existing refund, never create a
        // second one.
        const refund =
          (await findExistingRefund(config, paymentId)) ??
          (await createRefund(config, paymentId));
        refundId = refund.id;
        refundStatus = toRefundStatus(config.provider, refund.status);
        amountMinor = refund.amount;
        currency = refund.currency?.toUpperCase();
      }
    }
  } catch {
    // Falls through to the record with FAILED — see above.
  }

  try {
    await orphanedPaymentRef(storeId, paymentId).set(
      {
        uid,
        paymentId,
        paymentOrderId,
        provider,
        reason,
        refundId,
        refundStatus,
        ...(amountMinor === undefined ? {} : { amountMinor }),
        ...(currency === undefined ? {} : { currency }),
        createdAtMs: Date.now(),
      },
      // Merged, not overwritten: a retried checkout hitting the same wall
      // updates the one record rather than stacking duplicates.
      { merge: true },
    );
  } catch {
    // Nothing left to do — the refund itself is what matters, and it either
    // happened or didn't.
  }

  return refundStatus !== "FAILED";
}
