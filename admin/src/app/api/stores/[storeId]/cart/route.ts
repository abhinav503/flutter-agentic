import { NextResponse } from "next/server";
import { getCartItems, saveCartItems } from "@/lib/cart";
import { getProduct } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { CartItem } from "@/lib/types";

// The shopper's own cart. The uid always comes off a verified Firebase ID
// token (gravia sends `Authorization: Bearer <idToken>`), never a
// client-supplied `userId` — so one shopper can never read or overwrite
// another's cart.
export async function GET(
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

  const cartItems = await getCartItems(uid, storeId);
  const resolved = await Promise.all(
    cartItems.map(async (item) => {
      const product = await getProduct(storeId, item.productId);
      return product ? { product: serializeProduct(product), quantity: item.quantity } : null;
    }),
  );

  // A product deleted from the catalog after being added to a cart
  // silently drops out here rather than surfacing a broken line item.
  return NextResponse.json({ items: resolved.filter((i) => i !== null) });
}

export async function PUT(
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
  const items = body.items as CartItem[] | undefined;

  if (!Array.isArray(items)) {
    return NextResponse.json({ error: "items must be an array" }, { status: 400 });
  }

  await saveCartItems(uid, storeId, items);

  const resolved = await Promise.all(
    items.map(async (item) => {
      const product = await getProduct(storeId, item.productId);
      return product ? { product: serializeProduct(product), quantity: item.quantity } : null;
    }),
  );
  return NextResponse.json({ items: resolved.filter((i) => i !== null) });
}
