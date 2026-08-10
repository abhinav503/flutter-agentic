import { NextResponse } from "next/server";
import { CouponError, couponErrorBody } from "@/lib/coupon-engine";
import { DeliveryUnserviceableError } from "@/lib/delivery";
import { OrderCreationError } from "@/lib/orders";
import { quoteCart } from "@/lib/checkout-quote";
import {
  createPaymentIntent,
  getStorePaymentConfig,
  PaymentProviderError,
} from "@/lib/payments";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { CreateOrderItemInput } from "@/lib/orders";

// Step 1 of the secure checkout: the shopper asks the server to create the
// payment intent their checkout sheet will be opened against — a Razorpay
// Order or a Stripe PaymentIntent, depending on what the store configured.
// The amount is computed server-side from live product prices (quoteCart) —
// the client never supplies it — and the intent is created with the *store's*
// credentials, so payment settles into that store's own provider account.
//
// Only public values come back (the publishable/key id, the provider's intent
// id, and Stripe's client_secret, which is scoped to this one intent); the key
// secret stays server-side. Step 2 (POST .../orders) verifies the completed
// payment before the order is actually placed.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const items = body.items as CreateOrderItemInput[] | undefined;
  if (!Array.isArray(items) || items.length === 0) {
    return NextResponse.json(
      { error: "items must be a non-empty array" },
      { status: 400 },
    );
  }

  const config = await getStorePaymentConfig(storeId);
  if (!config) {
    return NextResponse.json(
      { error: "This store has not configured payments" },
      { status: 400 },
    );
  }

  const couponCode =
    typeof body.couponCode === "string" ? body.couponCode : "";
  // Sent by the app since checkout gained an address step; used here only to
  // refuse an unserviceable address *before* the shopper is charged (the
  // order route re-checks it). Absent on older builds — see quoteCart.
  const addressId = typeof body.addressId === "string" ? body.addressId : "";

  let quote;
  try {
    quote = await quoteCart(storeId, uid, items, couponCode, addressId);
  } catch (err) {
    if (err instanceof OrderCreationError) {
      const status = err.message.startsWith("Insufficient stock") ? 409 : 400;
      return NextResponse.json(
        { error: err.message, productId: err.productId },
        { status },
      );
    }
    if (err instanceof CouponError) {
      return NextResponse.json(couponErrorBody(err), { status: 400 });
    }
    if (err instanceof DeliveryUnserviceableError) {
      // `code` so the app can tell this apart from a cart problem and point
      // the shopper at the address rather than at their basket.
      return NextResponse.json(
        { error: err.message, code: "unserviceable_address" },
        { status: 400 },
      );
    }
    throw err;
  }

  try {
    const intent = await createPaymentIntent(
      config,
      quote.totalMinor,
      quote.currency,
      // Razorpay caps a receipt at 40 chars — uid+timestamp keeps it unique
      // and traceable without exceeding that. Stripe reuses the same string
      // as its idempotency key, so a retried create returns the same intent.
      `rcpt_${uid.slice(0, 20)}_${Date.now()}`,
    );
    return NextResponse.json(
      {
        provider: config.provider,
        // The provider's id for this intent: a Razorpay order_… or a Stripe
        // pi_…. The app echoes it back on POST /orders as `paymentOrderId`.
        paymentOrderId: intent.id,
        // Razorpay key id / Stripe publishable key — public either way, and
        // what the client SDK is initialised with.
        publishableKey: config.keyId,
        // Stripe only; null for Razorpay, which has no such concept.
        clientSecret: intent.clientSecret,
        amount: intent.amount,
        currency: intent.currency,
        storeName: quote.storeName,
        // Transitional aliases for app builds shipped before the provider
        // split (the Play internal-testing track is running one). They read
        // these two keys and would fail to parse the response without them.
        // Safe to delete once no such build is in the wild; a Stripe store is
        // unreachable from those builds anyway, so mirroring the Razorpay
        // names here costs nothing.
        razorpayOrderId: intent.id,
        razorpayKeyId: config.keyId,
      },
      { status: 201 },
    );
  } catch (err) {
    if (err instanceof PaymentProviderError) {
      return NextResponse.json({ error: err.message }, { status: 502 });
    }
    throw err;
  }
}
