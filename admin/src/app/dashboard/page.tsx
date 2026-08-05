"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { watchProducts } from "@/lib/products";
import { watchOrdersForStore } from "@/lib/orders-dashboard";
import { fetchStoreReviews, type StoreReview } from "@/lib/reviews-dashboard";
import type { Order, OrderStatus, Product } from "@/lib/types";
import { compactMoney } from "@/lib/money";
import {
  dailyCounts,
  withinLastDays,
} from "@/lib/analytics";
import { StatTile } from "@/components/stat-tile";
import { DailyBarChart } from "@/components/charts/daily-bar-chart";
import { ShareBar, type ShareSegment } from "@/components/charts/share-bar";
import { RankedBars, type RankedItem } from "@/components/charts/ranked-bars";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

const WINDOW_DAYS = 30;
const TOP_PRODUCTS = 5;

// Pipeline stages take steps of one ramp so the order reads in the colour;
// CANCELLED is off-pipeline and wears the destructive token, because it means
// something bad rather than "stage four". Every count is also written out in
// the legend, so the colour is never carrying the meaning alone.
const STATUS_SEGMENTS: { status: OrderStatus; label: string; color: string }[] =
  [
    { status: "PENDING", label: "Pending", color: "var(--stage-early)" },
    { status: "IN_PROCESS", label: "On the way", color: "var(--stage-mid)" },
    { status: "DELIVERED", label: "Delivered", color: "var(--stage-done)" },
    { status: "CANCELLED", label: "Cancelled", color: "var(--destructive)" },
  ];

export default function DashboardOverviewPage() {
  const { user } = useAuth();
  const { storeId, storeName, storeCurrency } = useStore();
  // null = the first snapshot hasn't landed yet; [] = genuinely nothing.
  const [orders, setOrders] = useState<Order[] | null>(null);
  const [products, setProducts] = useState<Product[] | null>(null);
  const [reviews, setReviews] = useState<StoreReview[] | null>(null);

  useEffect(() => {
    if (!storeId) return;
    const unsubOrders = watchOrdersForStore(storeId, setOrders);
    const unsubProducts = watchProducts(storeId, setProducts);
    return () => {
      unsubOrders();
      unsubProducts();
    };
  }, [storeId]);

  // Reviews are a collection-group query behind the owner-gated REST route,
  // so unlike orders/products they are fetched once rather than streamed.
  useEffect(() => {
    if (!storeId || !user) return;
    let active = true;
    user
      .getIdToken()
      .then((token) => fetchStoreReviews(storeId, token))
      .then((fetched) => {
        if (active) setReviews(fetched);
      })
      .catch(() => {
        if (active) setReviews([]);
      });
    return () => {
      active = false;
    };
  }, [storeId, user]);

  if (!storeId) return null;

  const loading = orders === null || products === null;
  const allOrders = orders ?? [];
  const allProducts = products ?? [];

  const recentOrders = allOrders.filter((order) =>
    withinLastDays(order.placedAt, WINDOW_DAYS),
  );
  // A cancelled order's money went back to the shopper — counting it as
  // revenue would overstate every figure derived from it.
  const earningOrders = recentOrders.filter(
    (order) => order.status !== "CANCELLED",
  );
  const revenue = earningOrders.reduce((sum, order) => sum + order.total, 0);
  const averageOrderValue = earningOrders.length
    ? revenue / earningOrders.length
    : 0;

  const ordersToday = allOrders.filter((order) =>
    withinLastDays(order.placedAt, 1),
  ).length;

  // "Customers" can only mean shoppers who have ordered here: the users
  // collection is owner-read-only in firestore.rules, and a store's own
  // orders are the only place its shoppers are visible.
  const ordersPerCustomer = new Map<string, number>();
  for (const order of allOrders) {
    ordersPerCustomer.set(order.uid, (ordersPerCustomer.get(order.uid) ?? 0) + 1);
  }
  const returning = [...ordersPerCustomer.values()].filter((n) => n > 1).length;

  const outOfStock = allProducts.filter((product) => product.stock <= 0).length;

  // Weighted by review count, straight off the aggregates already on each
  // product doc — averaging the per-product averages would let a product with
  // one review outweigh one with fifty.
  const ratedProducts = allProducts.filter((product) => product.reviewCount > 0);
  const totalReviews = ratedProducts.reduce((n, p) => n + p.reviewCount, 0);
  const averageRating = totalReviews
    ? ratedProducts.reduce((n, p) => n + p.ratingAverage * p.reviewCount, 0) /
      totalReviews
    : 0;

  const orderPoints = dailyCounts(
    allOrders.map((order) => order.placedAt),
    WINDOW_DAYS,
  );
  const reviewPoints = dailyCounts(
    (reviews ?? []).map((review) => review.createdAt),
    WINDOW_DAYS,
  );

  const statusSegments: ShareSegment[] = STATUS_SEGMENTS.map((segment) => ({
    key: segment.status,
    label: segment.label,
    color: segment.color,
    value: allOrders.filter((order) => order.status === segment.status).length,
  }));

  const unitsByProduct = new Map<string, { name: string; units: number }>();
  for (const order of earningOrders) {
    for (const item of order.items) {
      const entry = unitsByProduct.get(item.productId) ?? {
        name: item.productName,
        units: 0,
      };
      entry.units += item.quantity;
      unitsByProduct.set(item.productId, entry);
    }
  }
  const topProducts: RankedItem[] = [...unitsByProduct.entries()]
    .sort((a, b) => b[1].units - a[1].units)
    .slice(0, TOP_PRODUCTS)
    .map(([productId, entry]) => ({
      key: productId,
      label: entry.name,
      value: entry.units,
    }));

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h1 className="text-lg font-semibold">{storeName ?? "Overview"}</h1>
        <p className="text-sm text-muted-foreground">
          Last {WINDOW_DAYS} days unless a card says otherwise. Cancelled orders
          are left out of revenue.
        </p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <StatTile
          loading={loading}
          label="Revenue"
          value={compactMoney(revenue, storeCurrency)}
          detail={`from ${earningOrders.length} ${earningOrders.length === 1 ? "order" : "orders"}`}
        />
        <StatTile
          loading={loading}
          label="Orders"
          value={String(recentOrders.length)}
          detail={`${ordersToday} today`}
        />
        <StatTile
          loading={loading}
          label="Customers"
          value={String(ordersPerCustomer.size)}
          detail={`${returning} ordered more than once`}
        />
        <StatTile
          loading={loading}
          label="Average order"
          value={compactMoney(averageOrderValue, storeCurrency)}
          detail="per order placed"
        />
        <StatTile
          loading={loading}
          label="Products"
          value={String(allProducts.length)}
          detail={
            outOfStock > 0 ? (
              <span className="font-medium text-destructive">
                {outOfStock} out of stock
              </span>
            ) : (
              "all in stock"
            )
          }
        />
        <StatTile
          loading={loading}
          label="Average rating"
          value={totalReviews ? averageRating.toFixed(1) : "—"}
          detail={`${totalReviews} product ${totalReviews === 1 ? "review" : "reviews"}`}
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Orders per day</CardTitle>
            <CardDescription>
              {recentOrders.length} in the last {WINDOW_DAYS} days
            </CardDescription>
          </CardHeader>
          <CardContent>
            {loading ? (
              <ChartSkeleton />
            ) : (
              <DailyBarChart points={orderPoints} unit="order" />
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Reviews per day</CardTitle>
            <CardDescription>
              {reviews === null
                ? "Loading…"
                : `${reviews.filter((r) => withinLastDays(r.createdAt, WINDOW_DAYS)).length} in the last ${WINDOW_DAYS} days`}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {reviews === null ? (
              <ChartSkeleton />
            ) : (
              <DailyBarChart points={reviewPoints} unit="review" />
            )}
          </CardContent>
        </Card>
      </div>

      {/* items-start: the status card is naturally shorter than the ranked
          list, and stretching it just leaves a pane of empty card. */}
      <div className="grid items-start gap-4 xl:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Order status</CardTitle>
            <CardDescription>
              Every order this store has taken, by where it stands now
            </CardDescription>
          </CardHeader>
          <CardContent>
            {loading ? (
              <ChartSkeleton />
            ) : (
              <ShareBar segments={statusSegments} />
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Top products</CardTitle>
            <CardDescription>
              By units sold in the last {WINDOW_DAYS} days
            </CardDescription>
          </CardHeader>
          <CardContent>
            {loading ? (
              <ChartSkeleton />
            ) : topProducts.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                Nothing sold yet in this window.
              </p>
            ) : (
              <RankedBars
                items={topProducts}
                formatValue={(units) => `${units} sold`}
              />
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

function ChartSkeleton() {
  return <div className="h-36 animate-pulse rounded-lg bg-muted" />;
}
