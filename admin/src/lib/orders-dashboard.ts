import {
  arrayUnion,
  collection,
  doc,
  onSnapshot,
  orderBy,
  query,
  updateDoc,
  where,
} from "firebase/firestore";
import { db } from "./firebase";
import type { Order, OrderStatus, OrderStatusChange } from "./types";

// Plain client SDK, not firebase-admin (server-only, can't run in the
// browser) — gated by firestore.rules' `isStoreOwner(storeId)` check on
// `orders/{orderId}`, the same mechanism Categories/Products already rely
// on for their dashboard CRUD, using the admin's already-signed-in session.
// This is a separate path from the REST API in `src/app/api/.../orders/`,
// which serves callers that aren't an authenticated browser session
// (gravia, curl, etc.) and verifies ownership itself via requireStoreOwner.
function ordersRef() {
  return collection(db, "orders");
}

export function watchOrdersForStore(
  storeId: string,
  onChange: (orders: Order[]) => void,
) {
  const q = query(
    ordersRef(),
    where("storeId", "==", storeId),
    orderBy("placedAt", "desc"),
  );
  return onSnapshot(q, (snap) => {
    onChange(
      snap.docs.map(
        (d) => ({ id: d.id, ...(d.data() as Omit<Order, "id">) }) as Order,
      ),
    );
  });
}

// Writes the transition's date alongside the status. This is the path the
// dashboard's status dropdown actually takes — updateOrderStatus() in
// orders.ts appends the same entry, but only for callers coming through the
// REST route, so a status changed here would otherwise land dated nowhere
// and the shopper's Track Order timeline shows "Time not recorded" forever.
// The two must stay in step: same field, same ISO `at`.
export async function setOrderStatus(order: Order, status: OrderStatus) {
  const change: OrderStatusChange = { status, at: new Date().toISOString() };
  await updateDoc(doc(db, "orders", order.id), {
    status,
    // An order placed before the timeline existed has no history to append
    // to — seed the one entry that can be dated honestly (placement) so
    // arrayUnion doesn't leave the array holding this transition alone.
    statusHistory: order.statusHistory?.length
      ? arrayUnion(change)
      : [{ status: "PENDING", at: order.placedAt }, change],
  });
}

// Cancelling can't go through the client SDK like the other status changes:
// it restocks items and issues a Razorpay refund, both of which need the
// store secret and run server-side only. So this hits the REST cancel route
// (admin SDK, requireStoreOwner via the token) instead of updateDoc. Returns
// the updated order's refund status so the caller can toast the outcome.
export async function cancelOrder(
  storeId: string,
  orderId: string,
  token: string,
): Promise<{ refundStatus: string }> {
  const res = await fetch(
    `/api/stores/${storeId}/orders/${orderId}/cancel`,
    { method: "POST", headers: { Authorization: `Bearer ${token}` } },
  );
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? "Cancel failed");
  }
  const body = (await res.json()) as { order: { refund_status: string } };
  return { refundStatus: body.order.refund_status };
}

// Issue or complete the refund on an already-cancelled order — the admin's
// recourse when the auto-refund at cancel time didn't settle. Server-side and
// idempotent (see the refund route); returns the resulting refund status.
export async function refundOrder(
  storeId: string,
  orderId: string,
  token: string,
): Promise<{ refundStatus: string }> {
  const res = await fetch(
    `/api/stores/${storeId}/orders/${orderId}/refund`,
    { method: "POST", headers: { Authorization: `Bearer ${token}` } },
  );
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? "Refund failed");
  }
  const body = (await res.json()) as { order: { refund_status: string } };
  return { refundStatus: body.order.refund_status };
}
