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

  if (!Array.isArray(items) || items.length === 0) {
    return NextResponse.json({ error: "items must be a non-empty array" }, { status: 400 });
  }
  if (!addressId) {
    return NextResponse.json({ error: "addressId is required" }, { status: 400 });
  }

  try {
    const order = await createOrder(uid, storeId, items, addressId);
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
