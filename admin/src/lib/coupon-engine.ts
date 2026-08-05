import { adminDb } from "./firebase-admin";
import { getProducts, resolveLinePricing } from "./products";
import type { Coupon, CouponScope, CouponType } from "./types";

// The one place coupon rules are decided. The validate route (the shopper's
// "Apply" preview), the payment intent, and the order transaction all price
// a code through these functions, so the preview, the charge, and the
// recorded order can never disagree.
//
// Runs on the Admin SDK: coupon docs are owner-only in firestore.rules —
// shoppers reach them exclusively through the token-verified API.

// A client-input problem (unknown code, expired, floor not met…) — routes
// map this to a 400 with the message shown to the shopper as-is.
/**
 * A coupon rejection the shopper is meant to read.
 *
 * `code` and `minOrderValue` exist because one of these messages has to name
 * an amount, and only the storefront knows how to write it: the store's
 * currency plus the shopper's locale (cordelia's `asPrice`). The server can't
 * format it without loading the store doc on a payment-adjacent path, and it
 * couldn't translate it either. So the amount travels as a number and the
 * client renders the sentence.
 *
 * `message` stays a usable English fallback for any caller that ignores the
 * code — currency-neutral, so it is never *wrong*, only plainer.
 */
export class CouponError extends Error {
  readonly code?: CouponErrorCode;
  readonly minOrderValue?: number;

  constructor(
    message: string,
    details?: { code: CouponErrorCode; minOrderValue?: number },
  ) {
    super(message);
    this.code = details?.code;
    this.minOrderValue = details?.minOrderValue;
  }
}

export type CouponErrorCode = "min_order";

/** The 400 body every coupon route returns, so the three can't drift. */
export function couponErrorBody(error: CouponError) {
  return {
    error: error.message,
    ...(error.code ? { code: error.code } : {}),
    ...(error.minOrderValue !== undefined
      ? { minOrderValue: error.minOrderValue }
      : {}),
  };
}

export function couponRedemptionRef(
  storeId: string,
  couponId: string,
  uid: string,
) {
  return adminDb
    .collection("stores")
    .doc(storeId)
    .collection("coupons")
    .doc(couponId)
    .collection("redemptions")
    .doc(uid);
}

export function mapCouponData(
  id: string,
  data: FirebaseFirestore.DocumentData,
): Coupon {
  return {
    id,
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
      (data.createdAt as FirebaseFirestore.Timestamp | null | undefined)
        ?.toMillis() ?? 0,
  };
}

// Codes are stored uppercase; matching is case-insensitive on entry.
export async function findCouponByCode(
  storeId: string,
  code: string,
): Promise<{ ref: FirebaseFirestore.DocumentReference; coupon: Coupon } | null> {
  const snap = await adminDb
    .collection("stores")
    .doc(storeId)
    .collection("coupons")
    .where("code", "==", code.trim().toUpperCase())
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return { ref: doc.ref, coupon: mapCouponData(doc.id, doc.data()) };
}

// What the engine needs to know about one order line to scope a discount.
export type CouponLine = {
  productId: string;
  categoryIds: string[];
  // Selling price × quantity, already size-variant-resolved by the caller.
  lineTotal: number;
};

// The slice of the order the coupon's scope reaches — the discount base.
export function eligibleSubtotal(coupon: Coupon, lines: CouponLine[]): number {
  switch (coupon.scope) {
    case "store":
      return lines.reduce((sum, l) => sum + l.lineTotal, 0);
    case "product":
      return lines
        .filter((l) => coupon.targetIds.includes(l.productId))
        .reduce((sum, l) => sum + l.lineTotal, 0);
    case "category":
      return lines
        .filter((l) => l.categoryIds.some((id) => coupon.targetIds.includes(id)))
        .reduce((sum, l) => sum + l.lineTotal, 0);
  }
}

// Throws CouponError with the message the shopper sees. `usedCount` and
// `userRedemptions` come from the caller's own reads so the order
// transaction can pass transaction-consistent values.
export function assertCouponUsable(
  coupon: Coupon,
  opts: {
    nowIso: string;
    usedCount: number;
    userRedemptions: number;
    orderSubtotal: number;
    eligible: number;
  },
): void {
  if (!coupon.isActive) {
    throw new CouponError("This coupon is no longer active");
  }
  if (coupon.validFrom && opts.nowIso < coupon.validFrom) {
    throw new CouponError("This coupon isn't valid yet");
  }
  if (coupon.validUntil && opts.nowIso > coupon.validUntil) {
    throw new CouponError("This coupon has expired");
  }
  if (coupon.usageLimit > 0 && opts.usedCount >= coupon.usageLimit) {
    throw new CouponError("This coupon has been fully redeemed");
  }
  if (coupon.perUserLimit > 0 && opts.userRedemptions >= coupon.perUserLimit) {
    throw new CouponError("You've already used this coupon");
  }
  if (coupon.minOrderValue > 0 && opts.orderSubtotal < coupon.minOrderValue) {
    // No currency symbol here on purpose — see CouponError. The client
    // formats `minOrderValue` against the store's currency; this text is only
    // the fallback for a caller that doesn't read the code.
    throw new CouponError(
      `Your order is below this coupon's minimum of ${coupon.minOrderValue}`,
      { code: "min_order", minOrderValue: coupon.minOrderValue },
    );
  }
  if (opts.eligible <= 0) {
    throw new CouponError("This coupon doesn't apply to the items in your cart");
  }
}

// Pure discount math over the eligible base, clamped so the payable amount
// stays ≥ 1 unit of the store's currency — the gateway's minimum charge; a
// coupon can make an order
// nearly free, never free.
export function computeDiscount(
  coupon: Coupon,
  eligible: number,
  orderSubtotal: number,
): number {
  let discount = coupon.type === "percent"
    ? (eligible * coupon.value) / 100
    : Math.min(coupon.value, eligible);
  if (coupon.type === "percent" && coupon.maxDiscount > 0) {
    discount = Math.min(discount, coupon.maxDiscount);
  }
  discount = Math.min(discount, Math.max(orderSubtotal - 1, 0));
  return Math.round(discount * 100) / 100;
}

export type PricedCoupon = {
  ref: FirebaseFirestore.DocumentReference;
  coupon: Coupon;
  discount: number;
  eligible: number;
  orderSubtotal: number;
};

// The whole non-transactional pipeline in one call — the validate route's
// preview and the payment intent's amount both run this, so "what Apply
// said" and "what the sheet charges" come from identical code. Throws
// CouponError for every shopper-facing rejection, including an unknown code.
//
// NOT used inside the order transaction: that re-runs the checks itself with
// transaction-consistent coupon/redemption reads (see createOrder), so a
// code racing to its usage limit fails the order rather than over-redeeming.
export async function previewCoupon(
  storeId: string,
  uid: string,
  code: string,
  items: { productId: string; quantity: number; sizeValue?: number }[],
): Promise<PricedCoupon> {
  const found = await findCouponByCode(storeId, code);
  if (!found) throw new CouponError("Invalid coupon code");
  const { ref, coupon } = found;

  // Same line pricing as the cart join and the order transaction — a line
  // whose product has been deleted silently drops out, same as the cart.
  const products = await getProducts(storeId);
  const lines: CouponLine[] = [];
  for (const item of items) {
    const product = products.find((p) => p.id === item.productId);
    if (!product) continue;
    lines.push({
      productId: product.id,
      categoryIds: product.categoryIds,
      lineTotal:
        resolveLinePricing(product, item.sizeValue).price * item.quantity,
    });
  }

  const orderSubtotal = lines.reduce((sum, l) => sum + l.lineTotal, 0);
  const eligible = eligibleSubtotal(coupon, lines);
  const redemptionSnap = await couponRedemptionRef(storeId, ref.id, uid).get();
  const userRedemptions = (redemptionSnap.data()?.count as number) ?? 0;

  assertCouponUsable(coupon, {
    nowIso: new Date().toISOString(),
    usedCount: coupon.usedCount,
    userRedemptions,
    orderSubtotal,
    eligible,
  });

  return {
    ref,
    coupon,
    discount: computeDiscount(coupon, eligible, orderSubtotal),
    eligible,
    orderSubtotal,
  };
}
