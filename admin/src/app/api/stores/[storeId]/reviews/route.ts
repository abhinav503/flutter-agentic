import { NextResponse } from "next/server";
import { getProducts } from "@/lib/products";
import { getReviewsForStore } from "@/lib/reviews";
import { serializeReview } from "@/lib/api/serializers";
import {
  ForbiddenError,
  requireStoreOwner,
  UnauthorizedError,
} from "@/lib/api/admin-guard";

// The store owner's moderation list — every review across the store, newest
// first. Owner-only: this is the one view that puts a shopper's name next to
// every product they've reviewed, which no storefront needs.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;

  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    if (e instanceof ForbiddenError) {
      return NextResponse.json({ error: e.message }, { status: 403 });
    }
    throw e;
  }

  const [reviews, products] = await Promise.all([
    getReviewsForStore(storeId),
    getProducts(storeId),
  ]);
  // Resolved here rather than denormalized onto the review: a product rename
  // must not leave the moderation table naming something that no longer
  // exists (same policy as Banner.targetId / an order's brand resolution).
  const names = new Map(products.map((p) => [p.id, p.name]));

  return NextResponse.json({
    reviews: reviews.map((r) => ({
      ...serializeReview(r),
      // "" when the product has since been deleted — the row still shows the
      // review so the owner can clear it out.
      product_name: names.get(r.productId) ?? "",
    })),
  });
}
