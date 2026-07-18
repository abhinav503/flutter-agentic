"use client";

import { useEffect, useState } from "react";
import { useStore } from "@/lib/store-context";
import { watchOrdersForStore, setOrderStatus } from "@/lib/orders-dashboard";
import type { Order, OrderStatus } from "@/lib/types";
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

export default function OrdersPage() {
  const { storeId } = useStore();
  const [orders, setOrders] = useState<Order[]>([]);

  useEffect(() => {
    if (!storeId) return;
    return watchOrdersForStore(storeId, setOrders);
  }, [storeId]);

  if (!storeId) return null;

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
          Orders placed by shoppers, most recent first.
        </p>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Order</TableHead>
            <TableHead>Placed at</TableHead>
            <TableHead>Items</TableHead>
            <TableHead>Total</TableHead>
            <TableHead>OTP</TableHead>
            <TableHead className="w-44">Status</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {orders.length === 0 && (
            <TableRow>
              <TableCell colSpan={6} className="text-center text-muted-foreground">
                No orders yet.
              </TableCell>
            </TableRow>
          )}
          {orders.map((order) => (
            <TableRow key={order.id}>
              <TableCell className="font-mono text-xs text-muted-foreground">
                {order.id.slice(0, 8)}
              </TableCell>
              <TableCell>{new Date(order.placedAt).toLocaleString()}</TableCell>
              <TableCell>
                {order.items.reduce((sum, item) => sum + item.quantity, 0)} items
              </TableCell>
              <TableCell>₹{order.total.toFixed(2)}</TableCell>
              <TableCell className="font-mono">{order.deliveryOtp}</TableCell>
              <TableCell>
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
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
