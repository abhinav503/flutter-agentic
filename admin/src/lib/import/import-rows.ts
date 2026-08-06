import { collection, doc, serverTimestamp, writeBatch } from "firebase/firestore";
import { db } from "@/lib/firebase";
import type { PlannedWrite } from "./csv-core";

// Firestore caps a batch at 500 writes. The seeder gets away with one atomic
// commit because a bundled catalog is ~170 docs; an uploaded file has no such
// ceiling, so this chunks — and a file over 500 rows is therefore NOT atomic.
// The dialog says so before the owner commits, rather than implying an
// all-or-nothing write it can't deliver.
export const BATCH_LIMIT = 500;

export type ImportProgress = {
  written: number;
  total: number;
};

/**
 * Writes a checked plan into `stores/{storeId}/{collectionName}`.
 *
 * One writer for all four entities: what differs between them is which fields
 * a create seeds (`createDefaults` — coupons start at `usedCount: 0`, the way
 * addCoupon does), never how the write itself is shaped.
 */
export async function importRows<T extends object>(
  storeId: string,
  collectionName: string,
  writes: PlannedWrite<T>[],
  options: {
    createDefaults?: Record<string, unknown>;
    onProgress?: (progress: ImportProgress) => void;
  } = {},
): Promise<void> {
  const ref = collection(db, "stores", storeId, collectionName);

  for (let start = 0; start < writes.length; start += BATCH_LIMIT) {
    const chunk = writes.slice(start, start + BATCH_LIMIT);
    const batch = writeBatch(db);

    for (const write of chunk) {
      if (write.kind === "update") {
        // merge, never a plain set: a product's ratingAverage/reviewCount/
        // ratingBuckets belong to the review transaction, a coupon's usedCount
        // to the order transaction, and createdAt to the original write. A
        // full overwrite would silently reset every one of them — the kind of
        // damage an import must not be able to do.
        batch.set(
          doc(ref, write.id),
          { ...write.data, updatedAt: serverTimestamp() },
          { merge: true },
        );
      } else {
        // doc() mints the id locally, so a create can ride in a batch the way
        // addDoc cannot.
        batch.set(doc(ref), {
          ...write.data,
          ...(options.createDefaults ?? {}),
          createdAt: serverTimestamp(),
        });
      }
    }

    await batch.commit();
    options.onProgress?.({
      written: Math.min(start + chunk.length, writes.length),
      total: writes.length,
    });
  }
}
