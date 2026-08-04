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
