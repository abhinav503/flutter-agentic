import { NextResponse } from "next/server";
import {
  createOrder,
  getOrdersForStore,
  getOrdersForUser,
  OrderCreationError,
} from "@/lib/orders";
import {
  requireAuthedUser,
  verifyIdToken,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import {
  getStorePaymentConfig,
  verifyPaymentSignature,
} from "@/lib/payments";
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
  const razorpayOrderId = body.razorpayOrderId as string | undefined;
  const razorpayPaymentId = body.razorpayPaymentId as string | undefined;
  const razorpaySignature = body.razorpaySignature as string | undefined;

  if (!Array.isArray(items) || items.length === 0) {
    return NextResponse.json({ error: "items must be a non-empty array" }, { status: 400 });
  }
  if (!addressId) {
    return NextResponse.json({ error: "addressId is required" }, { status: 400 });
  }

  // Payment gate. A live store must present a verified Razorpay signature
  // before any order is placed. A test store may skip payment entirely (the
  // web-preview path, which can't run the native checkout SDK) — but if it
  // *does* send payment fields (the mobile test flow), they're still
  // verified, so a tampered success callback is rejected in test too.
  const paymentProvided = Boolean(
    razorpayOrderId && razorpayPaymentId && razorpaySignature,
  );
  const config = await getStorePaymentConfig(storeId);
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
    const valid = verifyPaymentSignature(
      config,
      razorpayOrderId!,
      razorpayPaymentId!,
      razorpaySignature!,
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
      paymentProvided ? razorpayPaymentId! : "",
    );
    return NextResponse.json({ order: serializeOrder(order) }, { status: 201 });
  } catch (err) {
    if (err instanceof OrderCreationError) {
      const status = err.message.startsWith("Insufficient stock") ? 409 : 400;
      return NextResponse.json(
        { error: err.message, productId: err.productId },
        { status },
      );
    }
    throw err;
  }
}
