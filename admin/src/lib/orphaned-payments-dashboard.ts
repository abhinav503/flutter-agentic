import { collection, onSnapshot, orderBy, query } from "firebase/firestore";
import { db } from "./firebase";
import type { OrphanedPayment } from "./types";

// Plain client SDK, gated by firestore.rules' `isStoreOwner(storeId)` on
// `stores/{storeId}/orphanedPayments` — the same mechanism every other
// dashboard list uses (see orders-dashboard.ts). Records are written only by
// the checkout route through the Admin SDK; nothing here writes.
export function watchOrphanedPayments(
  storeId: string,
  onChange: (payments: OrphanedPayment[]) => void,
) {
  const q = query(
    collection(db, "stores", storeId, "orphanedPayments"),
    orderBy("createdAtMs", "desc"),
  );
  return onSnapshot(
    q,
    (snap) => {
      onChange(
        snap.docs.map(
          (d) =>
            ({ id: d.id, ...(d.data() as Omit<OrphanedPayment, "id">) }) as
              OrphanedPayment,
        ),
      );
    },
    // A store whose owner opened the console before this collection existed
    // gets a permission error rather than an empty snapshot on some Firestore
    // versions; an empty list is the right answer either way, and this list is
    // an exception report — never worth breaking the Orders page over.
    () => onChange([]),
  );
}
