import { NextResponse } from "next/server";
import { getProduct } from "@/lib/products";
import {
  deleteReview,
  getReviews,
  ReviewError,
  saveReview,
} from "@/lib/reviews";
import {
  serializeRatingSummary,
  serializeReview,
} from "@/lib/api/serializers";
import {
  optionalAuthedUid,
  requireAuthedUser,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import { filterBlockedAuthors } from "@/lib/blocked-shoppers";

// A product's reviews. Reading is public (the catalog is world-readable and
// a rating is part of a product's public face); writing needs a verified
// Firebase ID token, and the uid always comes off that token — a caller can
// only ever write or delete the review filed under their own uid.
//
// Any signed-in shopper may review, bought or not; `verified_purchase` is
// derived server-side and only badges the review. Rating a *delivered
// order* is a separate feature and does not live here.

// The list a client renders in one go. Reviews are short and a product's
// list is small in practice; a cursor can be added the day one isn't.
const PAGE_LIMIT = 50;

export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string; productId: string }> },
) {
  const { storeId, productId } = await params;

  // The summary comes off the product doc's aggregates, so the product read
  // is what makes this one call instead of two.
  const product = await getProduct(storeId, productId);
  if (!product) {
    return NextResponse.json({ error: "Product not found" }, { status: 404 });
  }

  const [allReviews, viewerUid] = await Promise.all([
    getReviews(storeId, productId, PAGE_LIMIT),
    optionalAuthedUid(request),
  ]);
  // Reviews by shoppers this reader has blocked are dropped from the list
  // they read, and only from theirs. The summary is unchanged — see the
  // product-details route for why.
  const reviews = await filterBlockedAuthors(allReviews, viewerUid);
  // `rating` is the same key (and shape) the product-details payload uses
  // for this summary — one name for one concept across both routes.
  return NextResponse.json({
    rating: serializeRatingSummary(product),
    reviews: reviews.map(serializeReview),
  });
}

// Body is `{ rating, text }`. Posting again replaces the caller's existing
// review rather than adding a second one (the doc id is their uid), so this
// is both "write" and "edit" — clients need no separate PUT.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string; productId: string }> },
) {
  const { storeId, productId } = await params;

  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const rating = typeof body.rating === "number" ? body.rating : NaN;
  const text = typeof body.text === "string" ? body.text : "";

  try {
    const review = await saveReview(
      auth.uid,
      auth.email,
      storeId,
      productId,
      rating,
      text,
    );
    // The recomputed rating rides back with the saved review, so a client
    // that only wants to repaint a header needs no follow-up GET (cordelia
    // reloads the list instead, since a new review also changes its order).
    const product = await getProduct(storeId, productId);
    return NextResponse.json({
      review: serializeReview(review),
      rating: product ? serializeRatingSummary(product) : null,
    });
  } catch (e) {
    if (e instanceof ReviewError) {
      return NextResponse.json({ error: e.message }, { status: 400 });
    }
    throw e;
  }
}

// Deletes the caller's own review. Store-owner moderation is a different
// route (/api/stores/[storeId]/reviews/...), gated on ownership rather than
// on the review being the caller's.
export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ storeId: string; productId: string }> },
) {
  const { storeId, productId } = await params;

  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  await deleteReview(storeId, productId, uid);
  const product = await getProduct(storeId, productId);
  return NextResponse.json({
    rating: product ? serializeRatingSummary(product) : null,
  });
}
