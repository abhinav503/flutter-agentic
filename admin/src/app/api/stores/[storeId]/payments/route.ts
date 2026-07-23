import { NextResponse } from "next/server";
import { priceCart, OrderCreationError } from "@/lib/orders";
import {
  createRazorpayOrder,
  getStorePaymentConfig,
  RazorpayError,
} from "@/lib/payments";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { CreateOrderItemInput } from "@/lib/orders";

// Step 1 of the secure checkout: the shopper asks the server to create a
// Razorpay order for their cart. The amount is computed server-side from
// live product prices (priceCart) — the client never supplies it — and the
// order is created with the *store's* credentials, so payment settles into
// that store's Razorpay account. Only the public keyId + the razorpay order
// id come back; the secret stays server-side. The app then opens the native
// checkout sheet against this, and step 2 (POST .../orders) verifies the
// resulting signature before the order is actually placed.
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

  let total: number;
  try {
    total = await priceCart(storeId, items);
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

  try {
    const order = await createRazorpayOrder(
      config,
      Math.round(total * 100),
      // A Razorpay receipt is capped at 40 chars — uid+timestamp keeps it
      // unique and traceable without exceeding that.
      `rcpt_${uid.slice(0, 20)}_${Date.now()}`,
    );
    return NextResponse.json(
      {
        razorpayOrderId: order.id,
        razorpayKeyId: config.keyId,
        amount: order.amount,
        currency: order.currency,
      },
      { status: 201 },
    );
  } catch (err) {
    if (err instanceof RazorpayError) {
      return NextResponse.json({ error: err.message }, { status: 502 });
    }
    throw err;
  }
}
