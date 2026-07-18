import { NextResponse } from "next/server";
import { getCartItems, saveCartItems } from "@/lib/cart";
import { getProduct } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";
import type { CartItem } from "@/lib/types";

// No shopper auth yet (gravia doesn't have it — see
// docs/explanation/superapp-ecommerce-plan.md M1b) — `userId` is trusted
// as-is, the same gap the request/response shapes below are already
// designed to close later: once gravia sends a verified ID token, `userId`
// swaps from "read off the request" to "read off the verified token,"
// with no route signature change.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const userId = new URL(request.url).searchParams.get("userId");
  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }

  const cartItems = await getCartItems(userId, storeId);
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
  const body = await request.json();
  const userId = body.userId as string | undefined;
  const items = body.items as CartItem[] | undefined;

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }
  if (!Array.isArray(items)) {
    return NextResponse.json({ error: "items must be an array" }, { status: 400 });
  }

  await saveCartItems(userId, storeId, items);

  const resolved = await Promise.all(
    items.map(async (item) => {
      const product = await getProduct(storeId, item.productId);
      return product ? { product: serializeProduct(product), quantity: item.quantity } : null;
    }),
  );
  return NextResponse.json({ items: resolved.filter((i) => i !== null) });
}
