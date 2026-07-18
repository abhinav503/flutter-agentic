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
