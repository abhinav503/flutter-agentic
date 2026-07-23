import { NextResponse } from "next/server";
import { getStorePaymentConfig, verifyWebhookSignature } from "@/lib/payments";
import { getOrderByPaymentId, setOrderRefund } from "@/lib/orders";
import type { RefundStatus } from "@/lib/types";

// Razorpay webhook receiver, scoped per store (each store's Razorpay account
// posts to its own URL). Today it exists to auto-settle refunds: a refund
// Razorpay accepts as "pending" settles asynchronously (days), and the
// `refund.processed` / `refund.failed` events are what flip our order's
// refundStatus without the owner pressing "Complete refund".
//
// Configure in the Razorpay dashboard (per store):
//   URL:     {ADMIN_ORIGIN}/api/stores/{storeId}/webhooks/razorpay
//   Secret:  paste into Settings → Razorpay → Webhook (stored encrypted)
//   Events:  refund.processed, refund.failed
//
// Security: the body signature is HMAC-verified against the store's webhook
// secret over the RAW request bytes, so we read request.text() before any
// JSON parse. Unknown/irrelevant events are acked with 200 so Razorpay stops
// retrying them.
type RefundWebhook = {
  event?: string;
  payload?: {
    refund?: {
      entity?: { id?: string; payment_id?: string; status?: string };
    };
  };
};

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  const rawBody = await request.text();
  const signature = request.headers.get("x-razorpay-signature");
  if (!signature) {
    return NextResponse.json({ error: "Missing signature" }, { status: 401 });
  }

  const config = await getStorePaymentConfig(storeId);
  if (!config?.webhookSecret) {
    // No webhook secret configured for this store — can't verify, so reject.
    return NextResponse.json(
      { error: "Webhook not configured for this store" },
      { status: 400 },
    );
  }

  if (!verifyWebhookSignature(config.webhookSecret, rawBody, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const body = JSON.parse(rawBody) as RefundWebhook;
  const refundStatus = REFUND_EVENT_STATUS[body.event ?? ""];
  if (!refundStatus) {
    // An event we don't act on (refund.created, payment.*, etc.) — ack it.
    return NextResponse.json({ ok: true, ignored: body.event ?? null });
  }

  const entity = body.payload?.refund?.entity;
  const paymentId = entity?.payment_id;
  const refundId = entity?.id;
  if (!paymentId || !refundId) {
    return NextResponse.json({ ok: true, ignored: "incomplete-payload" });
  }

  const order = await getOrderByPaymentId(storeId, paymentId);
  if (!order) {
    // Unknown payment for this store — nothing to reconcile. Ack so Razorpay
    // doesn't retry indefinitely.
    return NextResponse.json({ ok: true, ignored: "order-not-found" });
  }

  // Already settled — nothing to do (webhooks can be delivered more than once).
  if (order.refundStatus === refundStatus && order.refundId === refundId) {
    return NextResponse.json({ ok: true, unchanged: true });
  }

  await setOrderRefund(order.id, refundStatus, refundId);
  return NextResponse.json({ ok: true, orderId: order.id, refundStatus });
}

const REFUND_EVENT_STATUS: Record<string, RefundStatus | undefined> = {
  "refund.processed": "PROCESSED",
  "refund.failed": "FAILED",
};
