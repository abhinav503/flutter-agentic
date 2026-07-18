import { NextResponse } from "next/server";
import { getOrderForStore, updateOrderStatus } from "@/lib/orders";
import { requireStoreOwner, UnauthorizedError, ForbiddenError } from "@/lib/api/admin-guard";
import { serializeOrder } from "@/lib/api/serializers";
import type { OrderStatus } from "@/lib/types";

const VALID_STATUSES: OrderStatus[] = [
  "PENDING",
  "IN_PROCESS",
  "DELIVERED",
  "CANCELLED",
];

// Admin-only — the store owner advancing an order's lifecycle. Fetches the
// order by ID BEFORE checking store ownership so a mismatch (wrong store,
// or an order belonging to a different store entirely) always 404s rather
// than 403ing — that way a store owner probing another store's order IDs
// can't distinguish "wrong store" from "doesn't exist."
export async function PATCH(
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

  const body = await request.json();
  const status = body.status as OrderStatus | undefined;
  if (!status || !VALID_STATUSES.includes(status)) {
    return NextResponse.json({ error: "Invalid status" }, { status: 400 });
  }

  await updateOrderStatus(orderId, status);
  return NextResponse.json({ order: serializeOrder({ ...order, status }) });
}
