import { NextResponse } from "next/server";
import { getOrdersForStore } from "@/lib/orders";
import { getProducts } from "@/lib/products";
import { getReviewsForStore } from "@/lib/reviews";
import { serializeOrderReview, serializeReview } from "@/lib/api/serializers";
import {
  ForbiddenError,
  requireStoreOwner,
  UnauthorizedError,
} from "@/lib/api/admin-guard";

// The store owner's review lists, newest first. Owner-only: this is the one
// view that puts a shopper's name next to everything they've said.
//
// `?type=order` switches from **product reviews** (public, moderatable) to
// **order ratings** (private feedback about a delivery, which live on the
// order doc). They're two different subjects with different columns, so the
// route answers one or the other rather than a merged list the dashboard
// would have to pull apart again.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const isOrderReviews =
    new URL(request.url).searchParams.get("type") === "order";

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

  if (isOrderReviews) {
    const orders = await getOrdersForStore(storeId);
    // Only orders the shopper actually rated, newest rating first — the
    // list is about the feedback, so it orders by when that was given
    // rather than by when the order was placed.
    const rated = orders
      .filter((o) => o.rating > 0)
      .sort((a, b) => b.reviewedAt.localeCompare(a.reviewedAt));
    return NextResponse.json({ reviews: rated.map(serializeOrderReview) });
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
