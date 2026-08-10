import { NextResponse } from "next/server";
import {
  getStorePaymentConfig,
  toRefundStatus,
  verifyWebhookSignature,
} from "@/lib/payments";
import { getOrderByPaymentId, setOrderRefund } from "@/lib/orders";

// Stripe webhook receiver, scoped per store — the sibling of ../razorpay. Each
// store's own Stripe account posts to its own URL, because each store holds
// its own credentials and its own webhook secret.
//
// Today it exists to auto-settle refunds: a refund Stripe accepts as "pending"
// settles asynchronously, and these events are what flip our order's
// refundStatus without the owner pressing "Complete refund".
//
// Configure in the Stripe dashboard (per store, inside the right sandbox or
// live account):
//   URL:     {ADMIN_ORIGIN}/api/stores/{storeId}/webhooks/stripe
//   Events:  charge.refunded, refund.updated, refund.failed
//   Secret:  the whsec_… shown on the endpoint -> paste into
//            Settings -> Payments -> Webhook (stored encrypted)
//
// Security: the signature is HMAC-verified against the store's webhook secret
// over the RAW request bytes, so we read request.text() before any JSON parse.
// Stripe folds a timestamp into the signed payload (and we enforce a tolerance
// window) so a captured request can't be replayed later. Unknown events are
// acked with 200 so Stripe stops retrying them.

// Stripe nests the object differently per event: refund.* carries a refund,
// charge.refunded carries a charge whose `refunds.data[0]` is the refund. Both
// shapes are reduced to (refundId, paymentIntentId, status) below.
type StripeEvent = {
  type?: string;
  data?: {
    object?: {
      id?: string;
      object?: string;
      status?: string;
      payment_intent?: string;
      refunds?: { data?: { id?: string; status?: string }[] };
    };
  };
};

const HANDLED = new Set(["refund.updated", "refund.failed", "charge.refunded"]);

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  const rawBody = await request.text();
  const signature = request.headers.get("stripe-signature");
  if (!signature) {
    return NextResponse.json({ error: "Missing signature" }, { status: 401 });
  }

  // The stripe slot specifically — see the razorpay route for why this is
  // not the store's active provider.
  const config = await getStorePaymentConfig(storeId, "stripe");
  if (!config?.webhookSecret) {
    return NextResponse.json(
      { error: "Webhook not configured for this store" },
      { status: 400 },
    );
  }
  if (
    !verifyWebhookSignature("stripe", config.webhookSecret, rawBody, signature)
  ) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const event = JSON.parse(rawBody) as StripeEvent;
  if (!HANDLED.has(event.type ?? "")) {
    return NextResponse.json({ ok: true, ignored: event.type ?? null });
  }

  const object = event.data?.object;
  // charge.refunded hands us a charge; the refund we care about is its most
  // recent one. refund.* hands us the refund directly.
  const isCharge = object?.object === "charge";
  const refund = isCharge ? object?.refunds?.data?.[0] : object;
  const refundId = refund?.id;
  const paymentIntentId = object?.payment_intent;
  // A charge's `status` is the charge's, not the refund's — for that shape the
  // refund is settled by definition (Stripe only emits charge.refunded once
  // money has gone back), so treat it as succeeded.
  const rawStatus = isCharge ? (refund?.status ?? "succeeded") : object?.status;

  if (!refundId || !paymentIntentId || !rawStatus) {
    return NextResponse.json({ ok: true, ignored: "incomplete-payload" });
  }

  // Orders store the PaymentIntent id as their payment id (Stripe has no
  // separate charge reference the client is trusted with), so this is the
  // same lookup the Razorpay route does.
  const order = await getOrderByPaymentId(storeId, paymentIntentId);
  if (!order) {
    return NextResponse.json({ ok: true, ignored: "order-not-found" });
  }

  const refundStatus = toRefundStatus("stripe", rawStatus);

  // Already settled — nothing to do (webhooks can be delivered more than once).
  if (order.refundStatus === refundStatus && order.refundId === refundId) {
    return NextResponse.json({ ok: true, unchanged: true });
  }

  await setOrderRefund(order.id, refundStatus, refundId);
  return NextResponse.json({ ok: true, orderId: order.id, refundStatus });
}
