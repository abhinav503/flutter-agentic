import {
  collection,
  type QueryDocumentSnapshot,
  type Timestamp,
  type FirestoreError,
} from "firebase/firestore";

import { watchQuery } from "./watch";
import { db } from "./firebase";
import type { Coupon, CouponScope, CouponType } from "./types";

function couponsRef(storeId: string) {
  return collection(db, "stores", storeId, "coupons");
}

function mapCouponDoc(d: QueryDocumentSnapshot): Coupon {
  const data = d.data();
  return {
    id: d.id,
    code: (data.code as string) ?? "",
    type: (data.type as CouponType) ?? "percent",
    value: (data.value as number) ?? 0,
    scope: (data.scope as CouponScope) ?? "store",
    targetIds: (data.targetIds as string[]) ?? [],
    minOrderValue: (data.minOrderValue as number) ?? 0,
    maxDiscount: (data.maxDiscount as number) ?? 0,
    validFrom: (data.validFrom as string) ?? "",
    validUntil: (data.validUntil as string) ?? "",
    usageLimit: (data.usageLimit as number) ?? 0,
    perUserLimit: (data.perUserLimit as number) ?? 0,
    usedCount: (data.usedCount as number) ?? 0,
    isActive: (data.isActive as boolean) ?? true,
    createdAtMs:
      (data.createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
  };
}

export function watchCoupons(
  storeId: string,
  onChange: (coupons: Coupon[]) => void,
  onError?: (error: FirestoreError) => void,
) {
  return watchQuery(couponsRef(storeId), (snap) => snap.docs.map(mapCouponDoc), onChange, onError);
}

// usedCount is deliberately not accepted here — it belongs to the order
// transaction (Admin SDK), never the dashboard form.
export type CouponInput = Omit<Coupon, "id" | "usedCount" | "createdAtMs">;



