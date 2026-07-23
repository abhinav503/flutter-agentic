"use client";

import { Fragment, useEffect, useState } from "react";
import { ChevronDown, ChevronRight } from "lucide-react";
import { useStore } from "@/lib/store-context";
import { watchOrdersForStore, setOrderStatus } from "@/lib/orders-dashboard";
import type { Address, Order, OrderStatus } from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
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
  IN_PROCESS: "In process",
  DELIVERED: "Delivered",
  CANCELLED: "Cancelled",
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
  const { storeId } = useStore();
  const [orders, setOrders] = useState<Order[]>([]);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());

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
    try {
      await setOrderStatus(order.id, status);
      toast.success("Order status updated");
    } catch {
      toast.error("Could not update order status");
    }
  }

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h1 className="text-lg font-semibold">Orders</h1>
        <p className="text-sm text-muted-foreground">
          Orders placed by shoppers, most recent first. Click a row for items
          and delivery details.
        </p>
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
          {orders.length === 0 && (
            <TableRow>
              <TableCell
                colSpan={COLUMN_COUNT}
                className="text-center text-muted-foreground"
              >
                No orders yet.
              </TableCell>
            </TableRow>
          )}
          {orders.map((order) => {
            const isOpen = expanded.has(order.id);
            const paid = Boolean(order.razorpayPaymentId);
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
                  <TableCell>₹{order.total.toFixed(2)}</TableCell>
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
                    <Select
                      value={order.status}
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
                  </TableCell>
                </TableRow>
                {isOpen && (
                  <TableRow className="bg-muted/30 hover:bg-muted/30">
                    <TableCell colSpan={COLUMN_COUNT}>
                      <OrderDetail order={order} paid={paid} />
                    </TableCell>
                  </TableRow>
                )}
              </Fragment>
            );
          })}
        </TableBody>
      </Table>
    </div>
  );
}

function OrderDetail({ order, paid }: { order: Order; paid: boolean }) {
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

        <h3 className="mt-2 text-xs font-semibold uppercase text-muted-foreground">
          Payment
        </h3>
        <div className="flex items-center gap-2 text-sm">
          {paid ? (
            <>
              <Badge variant="success">Paid</Badge>
              <span className="font-mono text-xs text-muted-foreground">
                {order.razorpayPaymentId}
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
                  {item.quantity} × ₹{item.price.toFixed(2)}
                </div>
                <div className="text-xs text-muted-foreground">
                  ₹{(item.quantity * item.price).toFixed(2)}
                </div>
              </div>
            </div>
          ))}
        </div>
        <div className="flex justify-between border-t pt-2 text-sm font-semibold">
          <span>Total</span>
          <span>₹{order.total.toFixed(2)}</span>
        </div>
      </div>
    </div>
  );
}
