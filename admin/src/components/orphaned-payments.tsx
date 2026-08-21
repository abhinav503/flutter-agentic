"use client";

import { useEffect, useState } from "react";
import { useStore } from "@/lib/store-context";
import { watchOrphanedPayments } from "@/lib/orphaned-payments-dashboard";
import { formatMoney } from "@/lib/money";
import type { OrphanedPayment, OrphanedPaymentReason } from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

// Why the order never got written, in the owner's terms rather than the
// checkout step's. "Sold out" is the only one that is nobody's fault; the
// other three are worth acting on, which is why they name what to look at.
const REASON_LABELS: Record<OrphanedPaymentReason, string> = {
  insufficient_stock: "Sold out while they paid",
  cart_repricing_failed: "Basket changed while they paid",
  payment_verification_failed: "Payment didn't verify — check your keys",
  order_write_failed: "Order couldn't be saved",
};

const REFUND_LABELS: Record<string, string> = {
  PROCESSED: "Refunded",
  PENDING: "Refund processing",
  FAILED: "Refund failed",
  NONE: "Nothing to refund",
};

function formatWhen(ms: number): string {
  return new Date(ms).toLocaleString(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  });
}

/**
 * Payments taken for orders that were never written — an exception report,
 * not a list anyone should be reading daily.
 *
 * It renders nothing at all when there are none, which is the normal state.
 * Deliberately placed under Orders rather than in its own nav item: an owner
 * comes looking for this when an order they expected is missing, and that is
 * the page they are already on.
 */
export function OrphanedPayments() {
  const { storeId, storeCurrency } = useStore();
  const [payments, setPayments] = useState<OrphanedPayment[]>([]);

  useEffect(() => {
    if (!storeId) return;
    return watchOrphanedPayments(storeId, setPayments);
  }, [storeId]);

  if (payments.length === 0) return null;

  const needsAttention = payments.some(
    (payment) => payment.refundStatus === "FAILED",
  );

  return (
    <div className="flex flex-col gap-3">
      <div>
        <h2 className="text-base font-semibold">Payments without orders</h2>
        <p className="text-sm text-muted-foreground">
          A payment was taken and the order couldn&apos;t be written — the last
          item selling while someone paid, or a payment that didn&apos;t
          verify. Each one was refunded automatically, so these need nothing
          from you unless the refund itself failed.
        </p>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>When</TableHead>
            <TableHead>Payment</TableHead>
            <TableHead>Amount</TableHead>
            <TableHead>Why</TableHead>
            <TableHead className="w-44">Refund</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {payments.map((payment) => (
            <TableRow key={payment.id}>
              <TableCell className="whitespace-nowrap">
                {formatWhen(payment.createdAtMs)}
              </TableCell>
              <TableCell>
                {/* Full id, not truncated like an order's: this is the only
                    handle the owner has for finding it in their provider's
                    dashboard. */}
                <code className="text-xs">{payment.paymentId}</code>
              </TableCell>
              <TableCell className="whitespace-nowrap">
                {payment.amountMinor === undefined
                  ? "—"
                  : formatMoney(
                      payment.amountMinor / 100,
                      payment.currency ?? storeCurrency,
                    )}
              </TableCell>
              <TableCell>{REASON_LABELS[payment.reason] ?? payment.reason}</TableCell>
              <TableCell>
                <Badge
                  variant={
                    payment.refundStatus === "FAILED"
                      ? "destructive"
                      : payment.refundStatus === "PROCESSED"
                        ? "secondary"
                        : "outline"
                  }
                >
                  {REFUND_LABELS[payment.refundStatus] ?? payment.refundStatus}
                </Badge>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {needsAttention && (
        <p className="text-sm text-destructive">
          A refund your provider rejected is the one case here that needs you.
          Refund it from their dashboard using the payment id above.
        </p>
      )}
    </div>
  );
}
