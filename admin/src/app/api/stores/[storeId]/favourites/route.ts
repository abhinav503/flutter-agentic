import { NextResponse } from "next/server";
import { addFavourite, getFavouriteIds, removeFavourite } from "@/lib/favourites";
import { getProduct } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { Product } from "@/lib/types";

// The shopper's own favourites — uid always comes off a verified Firebase
// ID token, never a client-supplied `userId`.

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

  const productIds = await getFavouriteIds(uid, storeId);
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
  const productId = body.productId as string | undefined;

  if (!productId) {
    return NextResponse.json({ error: "productId is required" }, { status: 400 });
  }

  const productIds = await addFavourite(uid, storeId, productId);
  return NextResponse.json({ product_ids: productIds });
}

export async function DELETE(
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

  const productId = new URL(request.url).searchParams.get("productId");
  if (!productId) {
    return NextResponse.json({ error: "productId is required" }, { status: 400 });
  }

  const productIds = await removeFavourite(uid, storeId, productId);
  return NextResponse.json({ product_ids: productIds });
}
