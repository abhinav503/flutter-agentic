import { adminDb } from "./firebase-admin";
import { getOrdersForUser } from "./orders";
import {
  EMPTY_RATING_BUCKETS,
  MAX_RATING,
  MIN_RATING,
  REVIEW_REPORT_REASONS,
  type RatingBuckets,
  type Review,
  type ReviewReport,
  type ReviewReportReason,
} from "./types";

// The one place product reviews are written. Every write moves the product
// doc's aggregates (ratingAverage/reviewCount/ratingBuckets) in the SAME
// transaction as the review itself, which is why reviews are server-only in
// firestore.rules — a client-SDK write would leave the two to drift.
//
// Runs on the Admin SDK like orders.ts/coupon-engine.ts, not the client SDK
// the dashboard's own CRUD uses.

// A client-input problem (rating out of range, empty review) — routes map
// this to a 400 with the message shown to the shopper as-is.
export class ReviewError extends Error {}

// A review's text can be long-ish but not unbounded — a runaway body would
// bloat both the product page payload and the dashboard table.
const MAX_TEXT_LENGTH = 2000;

function productRef(storeId: string, productId: string) {
  return adminDb
    .collection("stores")
    .doc(storeId)
    .collection("products")
    .doc(productId);
}

function reviewsRef(storeId: string, productId: string) {
  return productRef(storeId, productId).collection("reviews");
}

function reviewRef(storeId: string, productId: string, uid: string) {
  return reviewsRef(storeId, productId).doc(uid);
}

function mapReview(
  uid: string,
  data: FirebaseFirestore.DocumentData,
): Review {
  const createdAt = (data.createdAt as string) ?? "";
  return {
    uid,
    storeId: (data.storeId as string) ?? "",
    productId: (data.productId as string) ?? "",
    rating: (data.rating as number) ?? 0,
    text: (data.text as string) ?? "",
    userName: (data.userName as string) ?? "",
    userAvatarUrl: (data.userAvatarUrl as string) ?? "",
    verifiedPurchase: (data.verifiedPurchase as boolean) ?? false,
    createdAt,
    // An edit sets updatedAt; a review never edited reads back as posted.
    updatedAt: (data.updatedAt as string) ?? createdAt,
    // Absent on every review written before reporting existed, which reads
    // correctly as "nobody has complained".
    reportCount: (data.reportCount as number) ?? 0,
    lastReportedAt: (data.lastReportedAt as string) ?? "",
  };
}

function readBuckets(data: FirebaseFirestore.DocumentData): RatingBuckets {
  // Firestore returns map keys as strings — spread over a zeroed literal so
  // a partially-populated (or absent) map still yields all five buckets.
  const stored = (data.ratingBuckets as Partial<RatingBuckets>) ?? {};
  return { ...EMPTY_RATING_BUCKETS, ...stored };
}

// Averages are money-like enough to want a stable rounding: two decimals,
// so 4.333… reads as 4.33 everywhere rather than differing per client.
function roundAverage(sum: number, count: number): number {
  if (count <= 0) return 0;
  return Math.round((sum / count) * 100) / 100;
}

function assertRating(rating: number) {
  if (
    !Number.isInteger(rating) ||
    rating < MIN_RATING ||
    rating > MAX_RATING
  ) {
    throw new ReviewError(
      `rating must be a whole number from ${MIN_RATING} to ${MAX_RATING}`,
    );
  }
}

// Has this shopper actually received this product? Reuses the shopper's own
// order list (already indexed on storeId+uid) and scans in JS rather than
// adding an order-item index — a shopper has few orders per store, and this
// only decides a badge, so it must never be the reason a review write fails.
async function hasDeliveredPurchase(
  uid: string,
  storeId: string,
  productId: string,
): Promise<boolean> {
  try {
    const orders = await getOrdersForUser(uid, storeId);
    return orders.some(
      (order) =>
        order.status === "DELIVERED" &&
        order.items.some((item) => item.productId === productId),
    );
  } catch {
    return false;
  }
}

// The shopper's own profile, for the name/avatar snapshotted onto the
// review. Absent profile (or a shopper who never set a name) falls back to
// the caller's email local-part, and finally to a generic label — a review
// row must always have something to print above the stars.
async function reviewerIdentity(
  uid: string,
  email: string,
): Promise<{ userName: string; userAvatarUrl: string }> {
  const snap = await adminDb.collection("users").doc(uid).get();
  const data = snap.data();
  const profileName = ((data?.name as string | undefined) ?? "").trim();
  const fallback = email.split("@")[0] ?? "";
  return {
    userName: profileName || fallback || "Shopper",
    userAvatarUrl: (data?.avatarUrl as string | undefined) ?? "",
  };
}

// Creates the caller's review, or edits it if they already had one. Returns
// the stored review.
//
// The aggregates move by DELTA (remove the old rating's contribution, add
// the new one) rather than by re-reading every review — a product with
// thousands of reviews would otherwise re-read them all on every write. The
// transaction is what keeps that read-modify-write correct under concurrent
// reviews of the same product.
export async function saveReview(
  uid: string,
  email: string,
  storeId: string,
  productId: string,
  rating: number,
  text: string,
): Promise<Review> {
  assertRating(rating);
  const trimmed = text.trim().slice(0, MAX_TEXT_LENGTH);

  // Both are queries/reads outside the product doc, and Firestore forbids
  // reads after writes inside a transaction — resolve them up front.
  const [identity, verifiedPurchase] = await Promise.all([
    reviewerIdentity(uid, email),
    hasDeliveredPurchase(uid, storeId, productId),
  ]);

  const pRef = productRef(storeId, productId);
  const rRef = reviewRef(storeId, productId, uid);

  return adminDb.runTransaction(async (tx) => {
    const [productSnap, existingSnap] = await Promise.all([
      tx.get(pRef),
      tx.get(rRef),
    ]);
    if (!productSnap.exists) {
      throw new ReviewError("Product not found");
    }

    const productData = productSnap.data()!;
    const buckets = readBuckets(productData);
    let count = (productData.reviewCount as number) ?? 0;
    // The running sum isn't stored: it's the buckets' weighted total, which
    // means the average can never disagree with the histogram beside it.
    let sum = bucketsSum(buckets);

    const existing = existingSnap.exists
      ? mapReview(uid, existingSnap.data()!)
      : null;
    if (existing) {
      // An edit replaces the old star, it doesn't add a second one.
      buckets[existing.rating as keyof RatingBuckets] -= 1;
      sum -= existing.rating;
    } else {
      count += 1;
    }
    buckets[rating as keyof RatingBuckets] += 1;
    sum += rating;

    const now = new Date().toISOString();
    const review: Review = {
      uid,
      storeId,
      productId,
      rating,
      text: trimmed,
      ...identity,
      verifiedPurchase,
      // An edit keeps the original posting date — the list stays ordered by
      // when the shopper first reviewed, not by their last typo fix.
      createdAt: existing?.createdAt || now,
      updatedAt: now,
      // Reports survive an edit. Otherwise the way to launder a reported
      // review would be to edit it — the owner dismisses a report, the
      // author doesn't.
      reportCount: existing?.reportCount ?? 0,
      lastReportedAt: existing?.lastReportedAt ?? "",
    };

    tx.set(rRef, review);
    tx.update(pRef, {
      reviewCount: count,
      ratingAverage: roundAverage(sum, count),
      ratingBuckets: buckets,
    });
    return review;
  });
}

function bucketsSum(buckets: RatingBuckets): number {
  let sum = 0;
  for (let star = MIN_RATING; star <= MAX_RATING; star++) {
    sum += star * buckets[star as keyof RatingBuckets];
  }
  return sum;
}

// Removes a review and reverses its contribution to the aggregates. Used by
// the shopper deleting their own and by the store owner moderating; a
// missing review is a no-op, so a double-delete can't drive counts negative.
export async function deleteReview(
  storeId: string,
  productId: string,
  uid: string,
): Promise<void> {
  const pRef = productRef(storeId, productId);
  const rRef = reviewRef(storeId, productId, uid);

  await adminDb.runTransaction(async (tx) => {
    const [productSnap, reviewSnap] = await Promise.all([
      tx.get(pRef),
      tx.get(rRef),
    ]);
    if (!reviewSnap.exists) return;

    tx.delete(rRef);
    // The product may have been deleted while the review lived on — drop
    // the review anyway and skip the aggregates it no longer has.
    if (!productSnap.exists) return;

    const review = mapReview(uid, reviewSnap.data()!);
    const productData = productSnap.data()!;
    const buckets = readBuckets(productData);
    buckets[review.rating as keyof RatingBuckets] = Math.max(
      0,
      buckets[review.rating as keyof RatingBuckets] - 1,
    );
    const count = Math.max(0, ((productData.reviewCount as number) ?? 0) - 1);

    tx.update(pRef, {
      reviewCount: count,
      ratingAverage: roundAverage(bucketsSum(buckets), count),
      ratingBuckets: buckets,
    });
  });

  // Firestore keeps a subcollection alive after its parent doc is gone, so
  // an un-swept reports collection would be orphaned data about a review
  // nobody can read. Outside the transaction because it is a query.
  const reports = await reportsRef(storeId, productId, uid).get();
  await Promise.all(reports.docs.map((d) => d.ref.delete()));
}

function reportsRef(storeId: string, productId: string, uid: string) {
  return reviewRef(storeId, productId, uid).collection("reports");
}

export function isReviewReportReason(
  value: unknown,
): value is ReviewReportReason {
  return REVIEW_REPORT_REASONS.includes(value as ReviewReportReason);
}

// A shopper reports someone else's review. Required by App Store Review
// Guideline 1.2: an app carrying user-generated content has to give readers
// a way to flag it, and the store owner a way to act on it.
//
// The report doc is keyed by the REPORTER's uid, so reporting twice edits
// one report instead of inflating the count — `reportCount` is therefore a
// count of distinct complainants, which is what makes it worth sorting by.
// Both writes move in one transaction for the same reason the rating
// aggregates do: a count that can drift from the docs behind it is worse
// than no count.
//
// Reporting your own review is refused. It is never a real action, and
// allowing it would let an author manufacture the appearance of a dispute.
export async function reportReview(
  reporterUid: string,
  storeId: string,
  productId: string,
  reviewUid: string,
  reason: ReviewReportReason,
): Promise<number> {
  if (reporterUid === reviewUid) {
    throw new ReviewError("You cannot report your own review");
  }

  const rRef = reviewRef(storeId, productId, reviewUid);
  const reportRef = reportsRef(storeId, productId, reviewUid).doc(reporterUid);

  return adminDb.runTransaction(async (tx) => {
    const [reviewSnap, existingReport] = await Promise.all([
      tx.get(rRef),
      tx.get(reportRef),
    ]);
    if (!reviewSnap.exists) {
      throw new ReviewError("Review not found");
    }

    const now = new Date().toISOString();
    const report: ReviewReport = {
      reporterUid,
      reason,
      createdAt: now,
    };
    tx.set(reportRef, report);

    // Only a first-time reporter moves the count. Changing your mind about
    // the reason is an edit, not a second complaint.
    const current = (reviewSnap.data()?.reportCount as number) ?? 0;
    const count = existingReport.exists ? current : current + 1;
    tx.update(rRef, { reportCount: count, lastReportedAt: now });
    return count;
  });
}

// The store owner's "this review is fine" — clears the complaints and
// leaves the review standing. The counterpart to deleting it.
//
// Reports are removed rather than marked handled: keeping them would mean
// the same review re-surfaces at the top of the list forever, and a shopper
// who reports it again should still be heard.
export async function dismissReviewReports(
  storeId: string,
  productId: string,
  uid: string,
): Promise<void> {
  const snap = await reportsRef(storeId, productId, uid).get();
  await Promise.all(snap.docs.map((d) => d.ref.delete()));
  await reviewRef(storeId, productId, uid)
    .update({ reportCount: 0, lastReportedAt: "" })
    // The review may have been deleted between the console rendering the
    // row and the owner clicking; the reports are gone either way.
    .catch(() => {});
}

// Newest first. `limit` bounds the page a product-details payload carries;
// the full list is what the dedicated reviews endpoint pages through.
export async function getReviews(
  storeId: string,
  productId: string,
  limit?: number,
): Promise<Review[]> {
  let q = reviewsRef(storeId, productId).orderBy("createdAt", "desc");
  if (limit !== undefined) q = q.limit(limit);
  const snap = await q.get();
  return snap.docs.map((d) => mapReview(d.id, d.data()));
}

export async function getReview(
  storeId: string,
  productId: string,
  uid: string,
): Promise<Review | null> {
  const snap = await reviewRef(storeId, productId, uid).get();
  if (!snap.exists) return null;
  return mapReview(snap.id, snap.data()!);
}

// Every review across the store, newest first — the dashboard's moderation
// list. One collection-group query on the denormalized storeId, rather than
// one subcollection read per product (needs the composite index declared in
// firestore.indexes.json).
export async function getReviewsForStore(storeId: string): Promise<Review[]> {
  const snap = await adminDb
    .collectionGroup("reviews")
    .where("storeId", "==", storeId)
    .orderBy("createdAt", "desc")
    .get();
  return snap.docs.map((d) => mapReview(d.id, d.data()));
}
