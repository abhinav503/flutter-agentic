import { NextResponse } from "next/server";
import {
  createOrder,
  getOrdersForStore,
  getOrdersForUser,
  OrderCreationError,
} from "@/lib/orders";
import { requireStoreOwner, UnauthorizedError, ForbiddenError } from "@/lib/api/admin-guard";
import { serializeOrder } from "@/lib/api/serializers";
import type { CreateOrderItemInput } from "@/lib/orders";

// Two callers, one route, split on the `userId` query param:
//  - present  -> a shopper's own order history (userId trusted as-is, same
//    gap as the cart routes — no shopper auth in gravia yet).
//  - absent   -> the admin dashboard's Orders page listing every order for
//    the store, which DOES have real auth today, so this branch requires
//    and verifies a store-owner bearer token.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const userId = new URL(request.url).searchParams.get("userId");

  if (userId) {
    const orders = await getOrdersForUser(userId, storeId);
    return NextResponse.json({ orders: orders.map(serializeOrder) });
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

  const orders = await getOrdersForStore(storeId);
  return NextResponse.json({ orders: orders.map(serializeOrder) });
}

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const body = await request.json();
  const userId = body.userId as string | undefined;
  const items = body.items as CreateOrderItemInput[] | undefined;
  const addressId = body.addressId as string | undefined;

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }
  if (!Array.isArray(items) || items.length === 0) {
    return NextResponse.json({ error: "items must be a non-empty array" }, { status: 400 });
  }
  if (!addressId) {
    return NextResponse.json({ error: "addressId is required" }, { status: 400 });
  }

  try {
    const order = await createOrder(userId, storeId, items, addressId);
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
