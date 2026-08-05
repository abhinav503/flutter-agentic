"use client";

import { useEffect, useState } from "react";
import { Star } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import {
  fetchStoreReviews,
  fetchStoreOrderReviews,
  deleteStoreReview,
  type StoreOrderReview,
  type StoreReview,
} from "@/lib/reviews-dashboard";
import { MAX_RATING } from "@/lib/types";
import { formatMoney } from "@/lib/money";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { toast } from "sonner";

const COLUMN_COUNT = 6;
const ORDER_COLUMN_COUNT = 5;

/// Which subject's feedback the page is showing. Two different things —
/// a public product review versus private feedback about one delivery — so
/// they get their own columns and their own fetch rather than one merged
/// table with half its cells empty per row.
type ReviewKind = "product" | "order";

export default function ReviewsPage() {
  const { user } = useAuth();
  const { storeId, storeCurrency } = useStore();
  const [kind, setKind] = useState<ReviewKind>("product");
  const [reviews, setReviews] = useState<StoreReview[]>([]);
  const [orderReviews, setOrderReviews] = useState<StoreOrderReview[]>([]);
  const [loading, setLoading] = useState(true);
  const [deleting, setDeleting] = useState<StoreReview | null>(null);
  const [removing, setRemoving] = useState(false);

  // Re-runs on every switch, so each list is fetched only when it's actually
  // being looked at — the order list reads the whole orders collection, and
  // paying for that to render a tab nobody opened would be waste.
  useEffect(() => {
    if (!storeId || !user) return;
    let active = true;
    user
      .getIdToken()
      .then((token) =>
        kind === "order"
          ? fetchStoreOrderReviews(storeId, token).then((r) => {
              if (active) setOrderReviews(r);
            })
          : fetchStoreReviews(storeId, token).then((r) => {
              if (active) setReviews(r);
            }),
      )
      .then(() => {
        if (active) setLoading(false);
      })
      .catch((e: unknown) => {
        if (!active) return;
        setLoading(false);
        toast.error(e instanceof Error ? e.message : "Could not load reviews");
      });
    return () => {
      active = false;
    };
  }, [storeId, user, kind]);

  if (!storeId) return null;

  // The button path, deliberately separate from the mount effect above: it
  // may flip `loading` synchronously, which an effect body may not.
  async function refresh() {
    if (!storeId || !user) return;
    setLoading(true);
    try {
      const token = await user.getIdToken();
      if (kind === "order") {
        setOrderReviews(await fetchStoreOrderReviews(storeId, token));
      } else {
        setReviews(await fetchStoreReviews(storeId, token));
      }
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not load reviews");
    } finally {
      setLoading(false);
    }
  }

  // Switching shows the skeleton row until the new list lands, rather than
  // the previous subject's rows under the new heading.
  function switchKind(next: ReviewKind) {
    if (next === kind) return;
    setLoading(true);
    setKind(next);
  }

  async function confirmDelete() {
    if (!deleting || !user || !storeId) return;
    setRemoving(true);
    try {
      const token = await user.getIdToken();
      await deleteStoreReview(storeId, deleting.productId, deleting.uid, token);
      // Drop the row locally instead of refetching — the list isn't live, and
      // the product's rating is recomputed server-side either way.
      setReviews((prev) =>
        prev.filter(
          (r) =>
            !(r.uid === deleting.uid && r.productId === deleting.productId),
        ),
      );
      toast.success("Review deleted");
      setDeleting(null);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not delete review");
    } finally {
      setRemoving(false);
    }
  }

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Reviews</h1>
          <p className="text-sm text-muted-foreground">
            {kind === "product"
              ? "Product reviews from shoppers, most recent first. Deleting one updates that product's rating."
              : "How shoppers rated their deliveries, most recently rated first. Private feedback — it isn't shown anywhere in the storefront."}
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-2">
          {/* A segmented pair rather than a dropdown: two options, and which
              one is active should be readable without opening anything. */}
          <div className="flex rounded-md border border-border p-0.5">
            <Button
              variant={kind === "product" ? "default" : "ghost"}
              size="sm"
              onClick={() => switchKind("product")}
            >
              Products
            </Button>
            <Button
              variant={kind === "order" ? "default" : "ghost"}
              size="sm"
              onClick={() => switchKind("order")}
            >
              Orders
            </Button>
          </div>
          <Button
            variant="outline"
            size="sm"
            onClick={refresh}
            disabled={loading}
          >
            {loading ? "Refreshing…" : "Refresh"}
          </Button>
        </div>
      </div>

      {kind === "order" ? (
        <OrderReviewsTable
          storeCurrency={storeCurrency} reviews={orderReviews} loading={loading} />
      ) : (
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Date</TableHead>
              <TableHead>Product</TableHead>
              <TableHead>Customer</TableHead>
              <TableHead className="w-32">Rating</TableHead>
              <TableHead>Review</TableHead>
              <TableHead className="w-24 text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading && reviews.length === 0 && (
              <TableRow>
                <TableCell
                  colSpan={COLUMN_COUNT}
                  className="text-center text-muted-foreground"
                >
                  Loading…
                </TableCell>
              </TableRow>
            )}
            {!loading && reviews.length === 0 && (
              <TableRow>
                <TableCell
                  colSpan={COLUMN_COUNT}
                  className="text-center text-muted-foreground"
                >
                  No reviews yet.
                </TableCell>
              </TableRow>
            )}
            {reviews.map((review) => (
              <TableRow key={`${review.productId}-${review.uid}`}>
                <TableCell className="whitespace-nowrap text-muted-foreground">
                  {new Date(review.createdAt).toLocaleDateString()}
                  {/* An edited review keeps its original date in the list, so
                    say when it was last changed rather than silently showing
                    a stale one. */}
                  {review.updatedAt !== review.createdAt && (
                    <div className="text-xs">
                      edited {new Date(review.updatedAt).toLocaleDateString()}
                    </div>
                  )}
                </TableCell>
                <TableCell>
                  {review.productName || (
                    <span className="text-muted-foreground">
                      Deleted product
                    </span>
                  )}
                </TableCell>
                <TableCell>
                  <div className="font-medium">{review.userName}</div>
                  {review.verifiedPurchase && (
                    <Badge variant="success" className="mt-1">
                      Verified purchase
                    </Badge>
                  )}
                </TableCell>
                <TableCell>
                  <StarRow rating={review.rating} />
                </TableCell>
                <TableCell className="max-w-md text-sm text-muted-foreground">
                  {review.text || <span className="italic">Rating only</span>}
                </TableCell>
                <TableCell className="text-right">
                  <Button
                    variant="ghost"
                    size="sm"
                    className="text-destructive"
                    onClick={() => setDeleting(review)}
                  >
                    Delete
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      )}

      <AlertDialog
        open={!!deleting}
        onOpenChange={(open) => !open && !removing && setDeleting(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete this review?</AlertDialogTitle>
            <AlertDialogDescription>
              {deleting?.userName}&apos;s {deleting?.rating}-star review of{" "}
              {deleting?.productName || "this product"} will be removed and the
              product&apos;s rating recalculated. This can&apos;t be undone —
              the shopper can post a new review afterwards.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={removing}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              disabled={removing}
              onClick={(e) => {
                e.preventDefault();
                confirmDelete();
              }}
            >
              {removing ? "Deleting…" : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

/// Delivery ratings. No Actions column: this feedback isn't published
/// anywhere, so there is nothing to moderate — deleting it would only
/// destroy the store's own signal. The order id is what ties a row back to
/// the Orders page.
function OrderReviewsTable({
  reviews,
  loading,
  storeCurrency,
}: {
  reviews: StoreOrderReview[];
  loading: boolean;
  storeCurrency: string;
}) {
  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Rated on</TableHead>
          <TableHead>Order</TableHead>
          <TableHead>Customer</TableHead>
          <TableHead className="w-32">Rating</TableHead>
          <TableHead>Feedback</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {loading && reviews.length === 0 && (
          <TableRow>
            <TableCell
              colSpan={ORDER_COLUMN_COUNT}
              className="text-center text-muted-foreground"
            >
              Loading…
            </TableCell>
          </TableRow>
        )}
        {!loading && reviews.length === 0 && (
          <TableRow>
            <TableCell
              colSpan={ORDER_COLUMN_COUNT}
              className="text-center text-muted-foreground"
            >
              No delivery ratings yet.
            </TableCell>
          </TableRow>
        )}
        {reviews.map((review) => (
          <TableRow key={review.orderId}>
            <TableCell className="whitespace-nowrap text-muted-foreground">
              {review.reviewedAt
                ? new Date(review.reviewedAt).toLocaleDateString()
                : "—"}
            </TableCell>
            <TableCell>
              <div className="font-mono text-xs text-muted-foreground">
                {review.orderId.slice(0, 8)}
              </div>
              {/* What the order was, so a row means something without
                  cross-referencing the Orders page for every one. */}
              <div className="text-xs text-muted-foreground">
                {formatMoney(review.total, storeCurrency)} ·{" "}
                {new Date(review.placedAt).toLocaleDateString()}
              </div>
            </TableCell>
            <TableCell>
              {review.customerName || (
                <span className="text-muted-foreground">—</span>
              )}
            </TableCell>
            <TableCell>
              <StarRow rating={review.rating} />
            </TableCell>
            <TableCell className="max-w-md text-sm text-muted-foreground">
              {review.text || <span className="italic">Rating only</span>}
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  );
}

// Filled stars up to the rating, hollow for the rest — the count reads at a
// glance in a table where a bare "4" would not.
function StarRow({ rating }: { rating: number }) {
  return (
    <div className="flex items-center gap-0.5">
      {Array.from({ length: MAX_RATING }, (_, i) => (
        <Star
          key={i}
          className={
            i < rating
              ? "size-4 fill-amber-400 text-amber-400"
              : "size-4 text-muted-foreground/40"
          }
        />
      ))}
    </div>
  );
}
