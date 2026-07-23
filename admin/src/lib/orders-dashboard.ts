import {
  collection,
  doc,
  onSnapshot,
  orderBy,
  query,
  updateDoc,
  where,
} from "firebase/firestore";
import { db } from "./firebase";
import type { Order, OrderStatus } from "./types";

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

export async function setOrderStatus(orderId: string, status: OrderStatus) {
  await updateDoc(doc(db, "orders", orderId), { status });
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
