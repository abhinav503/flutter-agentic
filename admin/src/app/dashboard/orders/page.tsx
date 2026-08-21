"use client";

import { Fragment, useEffect, useState } from "react";
import { ChevronDown, ChevronRight, Star } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import {
  watchOrdersForStore,
  setOrderStatus,
  cancelOrder,
  refundOrder,
} from "@/lib/orders-dashboard";
import type { Address, Order, OrderStatus, RefundStatus } from "@/lib/types";
import { MAX_RATING } from "@/lib/types";
import { matchesSearch } from "@/lib/search";
import { formatMoney } from "@/lib/money";
import { OrphanedPayments } from "@/components/orphaned-payments";
import { SearchField } from "@/components/search-field";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
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

const COLUMN_COUNT = 9;

const STATUS_LABELS: Record<OrderStatus, string> = {
  PENDING: "Pending",
  IN_PROCESS: "On the way",
  DELIVERED: "Delivered",
  CANCELLED: "Cancelled",
};

// The refund badge shown alongside a cancelled order's status. NONE (an
// unpaid/test order) shows nothing — there was never money to return.
const REFUND_LABELS: Record<Exclude<RefundStatus, "NONE">, string> = {
  PENDING: "Refund pending",
  PROCESSED: "Refunded",
  FAILED: "Refund failed",
};

const REFUND_BADGE_VARIANT: Record<
  Exclude<RefundStatus, "NONE">,
  "secondary" | "success" | "destructive"
> = {
  PENDING: "secondary",
  PROCESSED: "success",
  FAILED: "destructive",
};

const STATUS_BADGE_VARIANT: Record<
  OrderStatus,
  "secondary" | "default" | "destructive"
> = {
  PENDING: "secondary",
  IN_PROCESS: "default",
  DELIVERED: "default",
  CANCELLED: "destructive",
};

function itemCount(order: Order): number {
  return order.items.reduce((sum, item) => sum + item.quantity, 0);
}

// What the lines came to before any coupon — `total` is already net of the
// discount, so this is the only figure that shows what was taken off.
function itemsSubtotal(order: Order): number {
  return order.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// Orders placed before coupons existed have no field at all — treat those,
// and any order checked out without a code, as "no coupon".
function couponDiscount(order: Order): number {
  return order.couponDiscount ?? 0;
}

function addressLines(address: Address): string {
  return [
    address.addressLine1,
    address.addressLine2,
    address.landmark,
    [address.city, address.postalCode].filter(Boolean).join(" "),
    address.country,
  ]
    .filter(Boolean)
    .join(", ");
}

export default function OrdersPage() {
  const { user } = useAuth();
  const { storeId, storeCurrency } = useStore();
  const [orders, setOrders] = useState<Order[]>([]);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [cancelTarget, setCancelTarget] = useState<Order | null>(null);
  const [cancelling, setCancelling] = useState(false);
  const [refundTarget, setRefundTarget] = useState<Order | null>(null);
  const [refunding, setRefunding] = useState(false);
  const [search, setSearch] = useState("");

  useEffect(() => {
    if (!storeId) return;
    return watchOrdersForStore(storeId, setOrders);
  }, [storeId]);

  if (!storeId) return null;

  function toggleExpanded(orderId: string) {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(orderId)) next.delete(orderId);
      else next.add(orderId);
      return next;
    });
  }

  async function handleStatusChange(order: Order, status: OrderStatus) {
    // Cancelling isn't a plain status write — it restocks and refunds
    // server-side. Route it through a confirm dialog + the REST cancel path.
    if (status === "CANCELLED") {
      setCancelTarget(order);
      return;
    }
    try {
      await setOrderStatus(order, status);
      toast.success("Order status updated");
    } catch {
      toast.error("Could not update order status");
    }
  }

  async function confirmCancel() {
    if (!cancelTarget || !user || !storeId) return;
    setCancelling(true);
    try {
      const token = await user.getIdToken();
      const { refundStatus } = await cancelOrder(storeId, cancelTarget.id, token);
      toast.success(
        refundStatus === "PROCESSED"
          ? "Order cancelled and customer refunded"
          : refundStatus === "PENDING"
            ? "Order cancelled — refund is processing"
            : refundStatus === "FAILED"
              ? "Order cancelled, but the refund failed — retry from the order"
              : "Order cancelled",
      );
      setCancelTarget(null);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not cancel order");
    } finally {
      setCancelling(false);
    }
  }

  async function confirmRefund() {
    if (!refundTarget || !user || !storeId) return;
    setRefunding(true);
    try {
      const token = await user.getIdToken();
      const { refundStatus } = await refundOrder(
        storeId,
        refundTarget.id,
        token,
      );
      toast.success(
        refundStatus === "PROCESSED"
          ? "Refund completed"
          : refundStatus === "PENDING"
            ? "Refund is processing at Razorpay"
            : "Refund could not be completed — try again",
      );
      setRefundTarget(null);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not issue refund");
    } finally {
      setRefunding(false);
    }
  }

  // The order id is searchable in full even though the row prints only its
  // first 8 characters — a support ticket quotes the whole thing.
  const visible = orders.filter((order) =>
    matchesSearch(
      search,
      order.id,
      order.deliveryAddress?.name,
      order.deliveryAddress?.phone,
      order.deliveryOtp,
      order.couponCode,
      STATUS_LABELS[order.status],
      ...order.items.map((item) => item.productName),
    ),
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Orders</h1>
          <p className="text-sm text-muted-foreground">
            Orders placed by shoppers, most recent first. Click a row for items
            and delivery details.
          </p>
        </div>
        <SearchField
          value={search}
          onChange={setSearch}
          label="Search orders"
          placeholder="Search id, customer, item…"
        />
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-8" />
            <TableHead>Order</TableHead>
            <TableHead>Customer</TableHead>
            <TableHead>Placed at</TableHead>
            <TableHead>Items</TableHead>
            <TableHead>Total</TableHead>
            <TableHead>Payment</TableHead>
            <TableHead>OTP</TableHead>
            <TableHead className="w-44">Status</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell
                colSpan={COLUMN_COUNT}
                className="text-center text-muted-foreground"
              >
                {search ? "No orders match your search." : "No orders yet."}
              </TableCell>
            </TableRow>
          )}
          {visible.map((order) => {
            const isOpen = expanded.has(order.id);
            const paid = Boolean(order.paymentId);
            return (
              <Fragment key={order.id}>
                <TableRow
                  className="cursor-pointer"
                  onClick={() => toggleExpanded(order.id)}
                >
                  <TableCell className="text-muted-foreground">
                    {isOpen ? (
                      <ChevronDown className="size-4" />
                    ) : (
                      <ChevronRight className="size-4" />
                    )}
                  </TableCell>
                  <TableCell className="font-mono text-xs text-muted-foreground">
                    {order.id.slice(0, 8)}
                  </TableCell>
                  <TableCell>
                    <div className="font-medium">
                      {order.deliveryAddress?.name || "—"}
                    </div>
                    {order.deliveryAddress?.phone && (
                      <div className="text-xs text-muted-foreground">
                        {order.deliveryAddress.phone}
                      </div>
                    )}
                  </TableCell>
                  <TableCell>
                    {new Date(order.placedAt).toLocaleString()}
                  </TableCell>
                  <TableCell>{itemCount(order)}</TableCell>
                  <TableCell>
                    <div>{formatMoney(order.total, storeCurrency)}</div>
                    {couponDiscount(order) > 0 && (
                      <div className="text-xs text-muted-foreground">
                        {order.couponCode || "Coupon"} · −
                        {formatMoney(couponDiscount(order), storeCurrency)}
                      </div>
                    )}
                  </TableCell>
                  <TableCell>
                    {paid ? (
                      <Badge variant="success">Paid</Badge>
                    ) : (
                      <Badge variant="outline">No payment</Badge>
                    )}
                  </TableCell>
                  <TableCell className="font-mono">
                    {order.deliveryOtp}
                  </TableCell>
                  <TableCell onClick={(e) => e.stopPropagation()}>
                    <div className="flex flex-col gap-1">
                      <Select
                        value={order.status}
                        // A cancelled order is terminal — no transitions out.
                        disabled={order.status === "CANCELLED"}
                        onValueChange={(value) =>
                          handleStatusChange(order, value as OrderStatus)
                        }
                      >
                        <SelectTrigger size="sm" className="w-full">
                          <SelectValue>
                            <Badge variant={STATUS_BADGE_VARIANT[order.status]}>
                              {STATUS_LABELS[order.status]}
                            </Badge>
                          </SelectValue>
                        </SelectTrigger>
                        <SelectContent>
                          {Object.entries(STATUS_LABELS).map(([value, label]) => (
                            <SelectItem key={value} value={value}>
                              {label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                      {order.status === "CANCELLED" &&
                        order.refundStatus !== "NONE" && (
                          <Badge
                            variant={REFUND_BADGE_VARIANT[order.refundStatus]}
                            className="w-fit"
                          >
                            {REFUND_LABELS[order.refundStatus]}
                          </Badge>
                        )}
                      {/* A refund that isn't settled yet — let the owner push
                          it through (or reconcile a pending one). */}
                      {order.status === "CANCELLED" &&
                        (order.refundStatus === "PENDING" ||
                          order.refundStatus === "FAILED") && (
                          <Button
                            size="sm"
                            variant="outline"
                            className="w-fit"
                            onClick={() => setRefundTarget(order)}
                          >
                            {order.refundStatus === "FAILED"
                              ? "Retry refund"
                              : "Complete refund"}
                          </Button>
                        )}
                    </div>
                  </TableCell>
                </TableRow>
                {isOpen && (
                  <TableRow className="bg-muted/30 hover:bg-muted/30">
                    <TableCell colSpan={COLUMN_COUNT}>
                      <OrderDetail order={order} paid={paid} currency={storeCurrency} />
                    </TableCell>
                  </TableRow>
                )}
              </Fragment>
            );
          })}
        </TableBody>
      </Table>

      {/* Renders nothing unless this store has some — see the component. */}
      <OrphanedPayments />

      <AlertDialog
        open={!!cancelTarget}
        onOpenChange={(open) => !open && !cancelling && setCancelTarget(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Cancel this order?</AlertDialogTitle>
            <AlertDialogDescription>
              {cancelTarget?.paymentId
                ? "The items will be restocked and the customer refunded in full via Razorpay. This can't be undone."
                : "The items will be restocked. This order had no payment to refund. This can't be undone."}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={cancelling}>
              Keep order
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={cancelling}
              onClick={(e) => {
                e.preventDefault();
                confirmCancel();
              }}
            >
              {cancelling ? "Cancelling…" : "Cancel order"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={!!refundTarget}
        onOpenChange={(open) => !open && !refunding && setRefundTarget(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Refund this order?</AlertDialogTitle>
            <AlertDialogDescription>
              {refundTarget?.refundStatus === "FAILED"
                ? "The earlier refund didn't go through. This retries the full refund to the customer via Razorpay."
                : "This issues the full refund to the customer via Razorpay. If a refund is already in progress, it's just re-checked, not duplicated."}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={refunding}>Back</AlertDialogCancel>
            <AlertDialogAction
              disabled={refunding}
              onClick={(e) => {
                e.preventDefault();
                confirmRefund();
              }}
            >
              {refunding ? "Refunding…" : "Refund customer"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

function OrderDetail({
  order,
  paid,
  currency,
}: {
  order: Order;
  paid: boolean;
  currency: string;
}) {
  const discount = couponDiscount(order);
  // 0 on every order placed before delivery fees existed, and on every order
  // a store delivered free — the same line is correct for both.
  const deliveryFee = order.deliveryFee ?? 0;
  return (
    <div className="grid gap-6 p-2 md:grid-cols-[1fr_1.4fr]">
      <div className="flex flex-col gap-2">
        <h3 className="text-xs font-semibold uppercase text-muted-foreground">
          Delivery
        </h3>
        {order.deliveryAddress?.name ? (
          <div className="text-sm">
            <div className="font-medium">
              {order.deliveryAddress.name}
              {order.deliveryAddress.tag && (
                <Badge variant="outline" className="ml-2">
                  {order.deliveryAddress.tag}
                </Badge>
              )}
            </div>
            {order.deliveryAddress.phone && (
              <div className="text-muted-foreground">
                {order.deliveryAddress.phone}
              </div>
            )}
            <div className="text-muted-foreground">
              {addressLines(order.deliveryAddress)}
            </div>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            No delivery address on this order.
          </p>
        )}

        {/* The shopper's verdict on this delivery — distinct from a product
            review, and only ever present on a delivered order. */}
        {order.rating > 0 && (
          <>
            <h3 className="mt-2 text-xs font-semibold uppercase text-muted-foreground">
              Customer rating
            </h3>
            <div className="flex items-center gap-2 text-sm">
              <span className="flex items-center gap-0.5">
                {Array.from({ length: MAX_RATING }, (_, i) => (
                  <Star
                    key={i}
                    className={
                      i < order.rating
                        ? "size-4 fill-amber-400 text-amber-400"
                        : "size-4 text-muted-foreground/40"
                    }
                  />
                ))}
              </span>
              {order.reviewedAt && (
                <span className="text-xs text-muted-foreground">
                  {new Date(order.reviewedAt).toLocaleDateString()}
                </span>
              )}
            </div>
            {order.reviewText && (
              <p className="text-sm text-muted-foreground">
                {order.reviewText}
              </p>
            )}
          </>
        )}

        <h3 className="mt-2 text-xs font-semibold uppercase text-muted-foreground">
          Payment
        </h3>
        <div className="flex items-center gap-2 text-sm">
          {paid ? (
            <>
              <Badge variant="success">Paid</Badge>
              <span className="font-mono text-xs text-muted-foreground">
                {order.paymentId}
                {/* The Razorpay order behind the payment — what a dashboard
                    search there keys on. Absent on orders placed before this
                    was recorded, so it's rendered only when present. */}
                {order.paymentOrderId ? ` · ${order.paymentOrderId}` : ""}
              </span>
            </>
          ) : (
            <span className="text-muted-foreground">
              No payment recorded (test-mode order).
            </span>
          )}
        </div>
      </div>

      <div className="flex flex-col gap-2">
        <h3 className="text-xs font-semibold uppercase text-muted-foreground">
          Items
        </h3>
        <div className="flex flex-col divide-y">
          {order.items.map((item, index) => (
            <div
              key={`${item.productId}-${index}`}
              className="flex items-center justify-between gap-3 py-2 text-sm"
            >
              <div className="flex items-center gap-3">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={item.image}
                  alt={item.productName}
                  className="size-9 rounded-md object-cover"
                />
                <div>
                  <div className="font-medium">{item.productName}</div>
                  <div className="text-xs text-muted-foreground">
                    {item.weight}
                  </div>
                </div>
              </div>
              <div className="text-right">
                <div>
                  {item.quantity} × {formatMoney(item.price, currency)}
                </div>
                <div className="text-xs text-muted-foreground">
                  {formatMoney(item.quantity * item.price, currency)}
                </div>
              </div>
            </div>
          ))}
        </div>
        <div className="flex flex-col gap-1 border-t pt-2 text-sm">
          {/* Subtotal earns its line as soon as anything sits between it and
              the total — a coupon, a delivery fee, or both. Without one of
              those, Total alone already says everything. */}
          {(discount > 0 || deliveryFee > 0) && (
            <div className="flex justify-between text-muted-foreground">
              <span>Subtotal</span>
              <span>{formatMoney(itemsSubtotal(order), currency)}</span>
            </div>
          )}
          {discount > 0 && (
            <div className="flex justify-between text-muted-foreground">
              <span className="flex items-center gap-2">
                Coupon
                {order.couponCode && (
                  <Badge variant="outline" className="font-mono">
                    {order.couponCode}
                  </Badge>
                )}
              </span>
              <span>−{formatMoney(discount, currency)}</span>
            </div>
          )}
          {deliveryFee > 0 && (
            <div className="flex justify-between text-muted-foreground">
              <span>Delivery</span>
              <span>{formatMoney(deliveryFee, currency)}</span>
            </div>
          )}
          <div className="flex justify-between font-semibold">
            <span>Total</span>
            <span>{formatMoney(order.total, currency)}</span>
          </div>
        </div>
      </div>
    </div>
  );
}
