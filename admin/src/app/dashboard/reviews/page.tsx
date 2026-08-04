"use client";

import { useEffect, useState } from "react";
import { Star } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import {
  fetchStoreReviews,
  deleteStoreReview,
  type StoreReview,
} from "@/lib/reviews-dashboard";
import { MAX_RATING } from "@/lib/types";
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

export default function ReviewsPage() {
  const { user } = useAuth();
  const { storeId } = useStore();
  const [reviews, setReviews] = useState<StoreReview[]>([]);
  const [loading, setLoading] = useState(true);
  const [deleting, setDeleting] = useState<StoreReview | null>(null);
  const [removing, setRemoving] = useState(false);

  useEffect(() => {
    if (!storeId || !user) return;
    let active = true;
    user
      .getIdToken()
      .then((token) => fetchStoreReviews(storeId, token))
      .then((fetched) => {
        if (!active) return;
        setReviews(fetched);
        setLoading(false);
      })
      .catch((e: unknown) => {
        if (!active) return;
        setLoading(false);
        toast.error(e instanceof Error ? e.message : "Could not load reviews");
      });
    return () => {
      active = false;
    };
  }, [storeId, user]);

  if (!storeId) return null;

  // The button path, deliberately separate from the mount effect above: it
  // may flip `loading` synchronously, which an effect body may not.
  async function refresh() {
    if (!storeId || !user) return;
    setLoading(true);
    try {
      setReviews(await fetchStoreReviews(storeId, await user.getIdToken()));
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not load reviews");
    } finally {
      setLoading(false);
    }
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
          (r) => !(r.uid === deleting.uid && r.productId === deleting.productId),
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
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-lg font-semibold">Reviews</h1>
          <p className="text-sm text-muted-foreground">
            Product reviews from shoppers, most recent first. Deleting one
            updates that product&apos;s rating.
          </p>
        </div>
        <Button variant="outline" size="sm" onClick={refresh} disabled={loading}>
          {loading ? "Refreshing…" : "Refresh"}
        </Button>
      </div>

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
                  <span className="text-muted-foreground">Deleted product</span>
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
              className="bg-destructive text-white hover:bg-destructive/90"
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
