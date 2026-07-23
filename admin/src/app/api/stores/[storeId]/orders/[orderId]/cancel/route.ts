import { NextResponse } from "next/server";
import {
  cancelOrder,
  getOrderForStore,
  CancelNotAllowedError,
} from "@/lib/orders";
import {
  verifyIdToken,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import { settleRefund } from "@/lib/refunds";
import { serializeOrder } from "@/lib/api/serializers";
import type { Order } from "@/lib/types";

// Cancel an order. One route, two callers, distinguished by the verified
// token's role (same shape as GET /orders):
//  - token owns this store  -> admin cancelling any of the store's orders.
//  - the order's own shopper -> self-service cancel of their own order.
// Any other signed-in user is forbidden. The order is fetched store-scoped
// first, so a mismatched/unknown id 404s identically for everyone (an owner
// probing another store's ids can't tell "wrong store" from "doesn't exist").
//
// Cancelling reverses stock and, for a paid order, issues a full Razorpay
// refund — the refund is a distinct step after the cancel commits, so a
// refund failure still leaves the order cancelled (refundStatus FAILED) and
// retriable, never a half-cancelled order.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string; orderId: string }> },
) {
  const { storeId, orderId } = await params;

  let auth: { uid: string; storeIds: string[] };
  try {
    auth = await verifyIdToken(request);
  } catch (err) {
    if (err instanceof UnauthorizedError) {
      return NextResponse.json({ error: err.message }, { status: 401 });
    }
    throw err;
  }

  const order = await getOrderForStore(orderId, storeId);
  if (!order) {
    return NextResponse.json({ error: "Order not found" }, { status: 404 });
  }

  const isOwner = auth.storeIds.includes(storeId);
  const isShopper = order.uid === auth.uid;
  if (!isOwner && !isShopper) {
    return NextResponse.json({ error: "Not allowed" }, { status: 403 });
  }

  let cancelled: Order;
  try {
    cancelled = await cancelOrder(orderId);
  } catch (err) {
    if (err instanceof CancelNotAllowedError) {
      return NextResponse.json({ error: err.message }, { status: 409 });
    }
    throw err;
  }

  // Paid order → return the money. cancelOrder marked refundStatus PENDING;
  // settleRefund does the Razorpay call and records the outcome, and never
  // throws — so a provider failure leaves the order cancelled with a refund
  // the admin can retry (never a 500 that strands it in PENDING).
  if (cancelled.refundStatus === "PENDING") {
    const settled = await settleRefund(storeId, cancelled);
    cancelled = { ...cancelled, ...settled };
  }

  return NextResponse.json({ order: serializeOrder(cancelled) });
}
