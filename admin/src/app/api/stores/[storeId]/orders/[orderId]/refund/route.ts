import { NextResponse } from "next/server";
import { getOrderForStore } from "@/lib/orders";
import {
  requireStoreOwner,
  UnauthorizedError,
  ForbiddenError,
} from "@/lib/api/admin-guard";
import { settleRefund } from "@/lib/refunds";
import { serializeOrder } from "@/lib/api/serializers";

// Admin-only: issue (or complete) the refund on a cancelled order. This is the
// recourse when the automatic refund at cancel time didn't settle — it was
// declined, the provider errored, or Razorpay accepted it as "pending" and it
// needs reconciling. settleRefund is idempotent: it creates a Razorpay refund
// only if none exists yet, otherwise it just refreshes the existing one's
// status, so pressing this twice can't double-refund.
//
// The order is fetched store-scoped first, so an id from another store 404s
// identically to a missing one (same disclosure guard as the other routes).
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string; orderId: string }> },
) {
  const { storeId, orderId } = await params;

  const order = await getOrderForStore(orderId, storeId);
  if (!order) {
    return NextResponse.json({ error: "Order not found" }, { status: 404 });
  }

  try {
    await requireStoreOwner(request, storeId);
  } catch (err) {
    if (err instanceof UnauthorizedError) {
      return NextResponse.json({ error: err.message }, { status: 401 });
    }
    if (err instanceof ForbiddenError) {
      return NextResponse.json({ error: err.message }, { status: 403 });
    }
    throw err;
  }

  if (order.status !== "CANCELLED") {
    return NextResponse.json(
      { error: "Only a cancelled order can be refunded" },
      { status: 409 },
    );
  }
  if (!order.razorpayPaymentId) {
    return NextResponse.json(
      { error: "This order has no payment to refund" },
      { status: 400 },
    );
  }
  if (order.refundStatus === "PROCESSED") {
    return NextResponse.json(
      { error: "This order has already been refunded" },
      { status: 409 },
    );
  }

  const settled = await settleRefund(storeId, order);
  return NextResponse.json({ order: serializeOrder({ ...order, ...settled }) });
}
