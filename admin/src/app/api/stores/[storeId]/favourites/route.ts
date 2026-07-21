import { NextResponse } from "next/server";
import { addFavourite, getFavouriteIds, removeFavourite } from "@/lib/favourites";
import { getProduct } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";
import type { Product } from "@/lib/types";

// No shopper auth yet — same trusted-`userId` gap as cart.ts/recent-searches
// (see cart/route.ts), closed together once gravia sends a verified token.

export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const userId = new URL(request.url).searchParams.get("userId");
  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }

  const productIds = await getFavouriteIds(userId, storeId);
  const resolved = await Promise.all(
    productIds.map((id) => getProduct(storeId, id)),
  );
  // A product deleted from the catalog after being favourited silently
  // drops out here rather than surfacing a broken card, same as cart's GET.
  const favourites = resolved
    .filter((p): p is Product => p !== null)
    .map((p) => serializeProduct(p, true));
  return NextResponse.json({ favourites });
}

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const body = await request.json().catch(() => ({}));
  const userId = body.userId as string | undefined;
  const productId = body.productId as string | undefined;

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }
  if (!productId) {
    return NextResponse.json({ error: "productId is required" }, { status: 400 });
  }

  const productIds = await addFavourite(userId, storeId, productId);
  return NextResponse.json({ product_ids: productIds });
}

export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const searchParams = new URL(request.url).searchParams;
  const userId = searchParams.get("userId");
  const productId = searchParams.get("productId");

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }
  if (!productId) {
    return NextResponse.json({ error: "productId is required" }, { status: 400 });
  }

  const productIds = await removeFavourite(userId, storeId, productId);
  return NextResponse.json({ product_ids: productIds });
}
