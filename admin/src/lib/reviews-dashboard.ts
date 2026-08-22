// Reviews reach the dashboard over the owner-gated REST route, not the
// client SDK the other dashboard pages use. Two reasons: the store-wide list
// is a collection-group query (reviews live under each product), which would
// need its own `/{path=**}/reviews/{uid}` rule to open that shape up to
// client queries; and deleting a review has to move the product's rating
// aggregates transactionally, which is Admin-SDK work either way.
//
// Consequence: this list is fetched, not live. A review posted while the
// page is open appears on the next load — acceptable for a moderation view,
// unlike Orders, where a new order must surface immediately.

// serializeReview's wire shape plus the product name the route resolves.
export type StoreReview = {
  uid: string;
  productId: string;
  productName: string;
  rating: number;
  text: string;
  userName: string;
  userAvatarUrl: string;
  verifiedPurchase: boolean;
  createdAt: string;
  updatedAt: string;
  // How many distinct shoppers reported this review. Drives the "Reported"
  // filter and pushes the row to the top of the list.
  reportCount: number;
  lastReportedAt: string;
};

type ReviewResponse = {
  uid: string;
  product_id: string;
  product_name: string;
  rating: number;
  text: string;
  user_name: string;
  user_avatar_url: string;
  verified_purchase: boolean;
  created_at: string;
  updated_at: string;
  report_count?: number;
  last_reported_at?: string;
};

function toStoreReview(r: ReviewResponse): StoreReview {
  return {
    uid: r.uid,
    productId: r.product_id,
    productName: r.product_name,
    rating: r.rating,
    text: r.text,
    userName: r.user_name,
    userAvatarUrl: r.user_avatar_url,
    verifiedPurchase: r.verified_purchase,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
    reportCount: r.report_count ?? 0,
    lastReportedAt: r.last_reported_at ?? "",
  };
}

export async function fetchStoreReviews(
  storeId: string,
  token: string,
): Promise<StoreReview[]> {
  const res = await fetch(`/api/stores/${storeId}/reviews`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? "Could not load reviews");
  }
  const body = (await res.json()) as { reviews: ReviewResponse[] };
  return body.reviews.map(toStoreReview);
}

// A shopper's rating of one delivery. Deliberately not the same row as a
// product review: it is private feedback about an order, so it is identified
// by that order (id, date, total) and carries no delete — an owner removing
// feedback nobody else can see would only be destroying their own signal.
export type StoreOrderReview = {
  orderId: string;
  rating: number;
  text: string;
  reviewedAt: string;
  placedAt: string;
  total: number;
  customerName: string;
};

type OrderReviewResponse = {
  order_id: string;
  rating: number;
  text: string;
  reviewed_at: string;
  placed_at: string;
  total: number;
  customer_name: string;
};

export async function fetchStoreOrderReviews(
  storeId: string,
  token: string,
): Promise<StoreOrderReview[]> {
  const res = await fetch(`/api/stores/${storeId}/reviews?type=order`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? "Could not load order ratings");
  }
  const body = (await res.json()) as { reviews: OrderReviewResponse[] };
  return body.reviews.map((r) => ({
    orderId: r.order_id,
    rating: r.rating,
    text: r.text,
    reviewedAt: r.reviewed_at,
    placedAt: r.placed_at,
    total: r.total,
    customerName: r.customer_name,
  }));
}

// A review is identified by (productId, uid) — its doc id is the reviewer's
// uid, scoped to the product it hangs off.
export async function deleteStoreReview(
  storeId: string,
  productId: string,
  uid: string,
  token: string,
): Promise<void> {
  const res = await fetch(
    `/api/stores/${storeId}/reviews/${productId}/${uid}`,
    { method: "DELETE", headers: { Authorization: `Bearer ${token}` } },
  );
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? "Could not delete review");
  }
}

// "I've read the complaints and the review stays." Clears the reports so the
// row stops leading the list; the review itself is untouched.
export async function dismissStoreReviewReports(
  storeId: string,
  productId: string,
  uid: string,
  token: string,
): Promise<void> {
  const res = await fetch(
    `/api/stores/${storeId}/reviews/${productId}/${uid}`,
    { method: "POST", headers: { Authorization: `Bearer ${token}` } },
  );
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? "Could not dismiss the reports");
  }
}
