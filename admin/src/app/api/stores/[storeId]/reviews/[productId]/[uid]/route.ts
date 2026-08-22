import { NextResponse } from "next/server";
import { deleteReview, dismissReviewReports } from "@/lib/reviews";
import {
  ForbiddenError,
  requireStoreOwner,
  UnauthorizedError,
} from "@/lib/api/admin-guard";

// Store-owner moderation: remove any review on one of this store's products.
// The shopper's own "delete my review" is the DELETE on the product's
// reviews route — gated on the review being theirs, not on store ownership.
//
// deleteReview reverses the review's contribution to the product's
// aggregates in the same transaction, and is a no-op on an already-deleted
// review, so a double-click can't drive the counts negative.
export async function DELETE(
  request: Request,
  {
    params,
  }: { params: Promise<{ storeId: string; productId: string; uid: string }> },
) {
  const { storeId, productId, uid } = await params;

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

  await deleteReview(storeId, productId, uid);
  return NextResponse.json({ ok: true });
}

// The other half of moderation: the owner has read the complaints and the
// review is fine. Clears them and leaves the review standing, so the
// moderation list doesn't keep re-presenting a decision already made.
export async function POST(
  request: Request,
  {
    params,
  }: { params: Promise<{ storeId: string; productId: string; uid: string }> },
) {
  const { storeId, productId, uid } = await params;

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

  await dismissReviewReports(storeId, productId, uid);
  return NextResponse.json({ ok: true });
}
