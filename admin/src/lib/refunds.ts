import {
  createRefund,
  findExistingRefund,
  getRefund,
  getStorePaymentConfig,
  toRefundStatus,
} from "./payments";
import { setOrderRefund } from "./orders";
import type { Order, RefundStatus } from "./types";

// The one place a refund is actually settled against the payment provider and
// persisted — shared by the auto-refund on cancel and the admin's manual
// "issue refund" action, so both behave identically for both providers.
//
// Idempotent on the provider side. A refund is created only when the payment
// has none:
//  - order already carries a refundId  -> refresh that refund's status.
//  - no refundId, but the provider already has a refund for the payment (a
//    create that succeeded before we could persist its id, or one issued by
//    hand in the provider's dashboard) -> adopt it, don't create a second.
//  - genuinely none                    -> create one.
//
// Stripe additionally dedupes on an Idempotency-Key derived from the payment
// id, so its create is safe to retry on its own; Razorpay's Refund API has no
// such header, which is why the lookup above is the shared guard.
//
// Never throws — a provider failure returns a status the caller can surface
// and the admin can retry, rather than 500ing after the order is already
// CANCELLED (which is exactly what stranded orders in PENDING before). The
// rule on failure: mark FAILED only when nothing was created yet; if a refund
// already exists, keep it PENDING so a transient lookup error never drops the
// refundId or implies the money wasn't returned.
export async function settleRefund(
  storeId: string,
  order: Order,
): Promise<{ refundStatus: RefundStatus; refundId: string }> {
  // Keyed to the provider that TOOK the payment, not the one the store uses
  // today. A store that has since switched still has to return money through
  // the account that received it — Stripe cannot refund a Razorpay charge, and
  // the ids aren't even the same shape. This is why both providers'
  // credentials are kept side by side rather than overwritten.
  const config = await getStorePaymentConfig(storeId, order.paymentProvider);
  if (!config) {
    await setOrderRefund(order.id, "FAILED", "");
    return { refundStatus: "FAILED", refundId: "" };
  }

  try {
    const refund = order.refundId
      ? await getRefund(config, order.refundId)
      : ((await findExistingRefund(config, order.paymentId)) ??
        (await createRefund(config, order.paymentId)));
    const refundStatus = toRefundStatus(config.provider, refund.status);
    await setOrderRefund(order.id, refundStatus, refund.id);
    return { refundStatus, refundId: refund.id };
  } catch {
    if (order.refundId) {
      return { refundStatus: "PENDING", refundId: order.refundId };
    }
    await setOrderRefund(order.id, "FAILED", "");
    return { refundStatus: "FAILED", refundId: "" };
  }
}
