import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  onSnapshot,
  serverTimestamp,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
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
  };
}

export function watchCoupons(
  storeId: string,
  onChange: (coupons: Coupon[]) => void,
) {
  return onSnapshot(couponsRef(storeId), (snap) => {
    onChange(snap.docs.map(mapCouponDoc));
  });
}

// usedCount is deliberately not accepted here — it belongs to the order
// transaction (Admin SDK), never the dashboard form.
export type CouponInput = Omit<Coupon, "id" | "usedCount">;

export async function addCoupon(storeId: string, data: CouponInput) {
  await addDoc(couponsRef(storeId), {
    ...data,
    usedCount: 0,
    createdAt: serverTimestamp(),
  });
}

export async function updateCoupon(
  storeId: string,
  id: string,
  data: CouponInput,
) {
  await updateDoc(doc(db, "stores", storeId, "coupons", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteCoupon(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "coupons", id));
}
