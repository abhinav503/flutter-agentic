import {
  getStorePaymentConfig,
  refundPayment,
  getRefund,
  getExistingRefund,
} from "./payments";
import { setOrderRefund } from "./orders";
import type { Order, RefundStatus } from "./types";

// The one place a refund is actually settled against Razorpay and persisted —
// shared by the auto-refund on cancel and the admin's manual "issue refund"
// action, so both behave identically.
//
// Idempotent on the provider side. A Razorpay refund is created only when the
// payment has none:
//  - order already carries a refundId  -> refresh that refund's status.
//  - no refundId, but Razorpay already has a refund for the payment (a create
//    that succeeded before we could persist its id) -> adopt it, don't create
//    a second. This is the idempotency guard — the Refund create API has no
//    idempotency-key header, so we look up existing refunds first.
//  - genuinely none                    -> create one.
//
// Never throws — a payment-provider failure returns a status the caller can
// surface and the admin can retry, rather than 500ing after the order is
// already CANCELLED (which is exactly what stranded orders in PENDING before).
// The rule on failure: mark FAILED only when nothing was created yet; if a
// refund already exists, keep it PENDING so a transient lookup error never
// drops the refundId or implies the money wasn't returned.
export async function settleRefund(
  storeId: string,
  order: Order,
): Promise<{ refundStatus: RefundStatus; refundId: string }> {
  const config = await getStorePaymentConfig(storeId);
  if (!config) {
    await setOrderRefund(order.id, "FAILED", "");
    return { refundStatus: "FAILED", refundId: "" };
  }

  try {
    let refund: { id: string; status: string };
    if (order.refundId) {
      refund = await getRefund(config, order.refundId);
    } else {
      refund =
        (await getExistingRefund(config, order.razorpayPaymentId)) ??
        (await refundPayment(config, order.razorpayPaymentId));
    }
    const refundStatus: RefundStatus =
      refund.status === "processed" ? "PROCESSED" : "PENDING";
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
