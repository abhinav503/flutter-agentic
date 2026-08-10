import { NextResponse } from "next/server";
import { CouponError, couponErrorBody } from "@/lib/coupon-engine";
import { DeliveryUnserviceableError } from "@/lib/delivery";
import {
  createOrder,
  getOrderByPaymentId,
  getOrdersForStore,
  getOrdersForUser,
  OrderCreationError,
} from "@/lib/orders";
import {
  requireAuthedUser,
  verifyIdToken,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import { getStorePaymentConfig, verifyPayment } from "@/lib/payments";
import { quoteCart } from "@/lib/checkout-quote";
import { notifyOrderPlaced } from "@/lib/order-notifications";
import { serializeOrder } from "@/lib/api/serializers";
import type { CreateOrderItemInput } from "@/lib/orders";

// One route, two callers, distinguished by the verified token's role — not
// a client-supplied flag, which is what makes "list every order" un-spoofable:
//  - token owns this store (its `storeIds` claim includes storeId) -> the
//    admin view, every order for the store.
//  - any other signed-in shopper -> only their own order history, keyed on
//    the token's uid.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  let auth: { uid: string; storeIds: string[] };
  try {
    auth = await verifyIdToken(request);
  } catch (err) {
    if (err instanceof UnauthorizedError) {
      return NextResponse.json({ error: err.message }, { status: 401 });
    }
    throw err;
  }

  const orders = auth.storeIds.includes(storeId)
    ? await getOrdersForStore(storeId)
    : await getOrdersForUser(auth.uid, storeId);
  return NextResponse.json({ orders: orders.map(serializeOrder) });
}

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

  const body = await request.json();
  const items = body.items as CreateOrderItemInput[] | undefined;
  const addressId = body.addressId as string | undefined;
  const couponCode = typeof body.couponCode === "string" ? body.couponCode : "";
  // Neutral names since the provider split; the razorpay* spellings are what
  // app builds predating it send, so both are accepted. Drop the fallbacks
  // once no such build is in the wild.
  const paymentOrderId = (body.paymentOrderId ?? body.razorpayOrderId) as
    | string
    | undefined;
  const paymentId = (body.paymentId ?? body.razorpayPaymentId) as
    | string
    | undefined;
  const paymentSignature = (body.paymentSignature ?? body.razorpaySignature) as
    | string
    | undefined;

  if (!Array.isArray(items) || items.length === 0) {
    return NextResponse.json({ error: "items must be a non-empty array" }, { status: 400 });
  }
  if (!addressId) {
    return NextResponse.json({ error: "addressId is required" }, { status: 400 });
  }

  // Payment gate. A live store must present a verified payment before any
  // order is placed. A test store may skip payment entirely (the web-preview
  // path, which can't run a native checkout SDK) — but if it *does* send
  // payment fields (the mobile test flow), they're still verified, so a
  // tampered success callback is rejected in test too.
  //
  // What counts as "provided" differs by provider: Razorpay returns a
  // signature the client must hand back, Stripe returns none (verification is
  // a server-side re-fetch), so only the intent id is required there.
  const config = await getStorePaymentConfig(storeId);
  const paymentProvided =
    config?.provider === "stripe"
      ? Boolean(paymentOrderId)
      : Boolean(paymentOrderId && paymentId && paymentSignature);
  const paymentRequired = config !== null && !config.isTest;

  if (paymentRequired && !paymentProvided) {
    return NextResponse.json(
      { error: "Payment is required for this store" },
      { status: 402 },
    );
  }
  if (paymentProvided) {
    if (!config) {
      return NextResponse.json(
        { error: "This store has not configured payments" },
        { status: 400 },
      );
    }

    // Replay guard. Both providers' proofs are replayable on their own — a
    // Razorpay (orderId|paymentId|signature) triple stays valid forever, and
    // a succeeded Stripe intent id can be presented again — so a shopper
    // could otherwise settle a large cart with a small earlier payment. One
    // payment, one order.
    const alreadyUsed = await getOrderByPaymentId(
      storeId,
      paymentId ?? paymentOrderId!,
    );
    if (alreadyUsed) {
      return NextResponse.json(
        { error: "This payment has already been used for an order" },
        { status: 409 },
      );
    }

    // Re-derive what this cart costs and require the payment to be for
    // exactly that. Razorpay's signature already binds the order id, but
    // Stripe's verification has nothing to bind against without it — this is
    // what makes presenting somebody else's (or an older, cheaper) intent
    // useless.
    let quote;
    try {
      // addressId matters here, not just in the intent: the quote includes
      // the delivery fee, so re-deriving it without the address would come
      // out short of what was actually charged and fail every verification
      // for a store that charges for delivery.
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
        return NextResponse.json(
          { error: err.message, code: "unserviceable_address" },
          { status: 400 },
        );
      }
      throw err;
    }

    const valid = await verifyPayment(
      config,
      {
        orderId: paymentOrderId!,
        paymentId: paymentId ?? paymentOrderId!,
        signature: paymentSignature ?? "",
      },
      quote.totalMinor,
      quote.currency,
    );
    if (!valid) {
      return NextResponse.json(
        { error: "Payment verification failed" },
        { status: 400 },
      );
    }
  }

  try {
    const order = await createOrder(
      uid,
      storeId,
      items,
      addressId,
      // Stripe has no separate charge reference the client is trusted with —
      // the PaymentIntent id is both the intent and the payment — so it lands
      // in both fields. Razorpay fills them with genuinely distinct ids.
      paymentProvided ? (paymentId ?? paymentOrderId!) : "",
      paymentProvided ? paymentOrderId! : "",
      couponCode,
      config?.provider ?? "razorpay",
    );
    // Awaited, not fired and forgotten: on a serverless runtime the function
    // can be frozen the moment the response is returned, which would drop an
    // un-awaited send. notifyOrderPlaced never throws, so this cannot turn a
    // placed order into an error.
    await notifyOrderPlaced(order);
    return NextResponse.json({ order: serializeOrder(order) }, { status: 201 });
  } catch (err) {
    if (err instanceof OrderCreationError) {
      const status = err.message.startsWith("Insufficient stock") ? 409 : 400;
      return NextResponse.json(
        { error: err.message, productId: err.productId },
        { status },
      );
    }
    // A coupon that stopped qualifying between Apply and checkout (expired,
    // raced to its limit) — same shopper-facing 400 shape as above.
    if (err instanceof CouponError) {
      return NextResponse.json(couponErrorBody(err), { status: 400 });
    }
    // The address left the store's delivery areas between the intent and
    // here — either edited, or the owner narrowed the areas. A paid shopper
    // reaching this has an unplaced order against a captured payment, which
    // is the same recoverable state a failed stock check leaves and is
    // resolved the same way, by the store refunding from the dashboard.
    if (err instanceof DeliveryUnserviceableError) {
      return NextResponse.json(
        { error: err.message, code: "unserviceable_address" },
        { status: 400 },
      );
    }
    throw err;
  }
}
