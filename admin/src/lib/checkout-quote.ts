import { adminDb } from "./firebase-admin";
import { previewCoupon } from "./coupon-engine";
import { priceCart, type CreateOrderItemInput } from "./orders";

// The one place the amount a shopper is charged is computed, shared by both
// halves of checkout:
//
//   POST /payments  — creates the provider intent for this amount
//   POST /orders    — verifies the completed payment was for this amount
//
// Those two used to price the cart with their own copy of the same three
// steps, which was survivable while Razorpay's HMAC signature was the only
// proof of payment (the signature binds an order id, so the amount never had
// to be re-derived). Stripe has no client signature — verification is a
// re-fetch that asserts the captured amount — so the second half now needs to
// arrive at exactly the same number as the first, and "exactly the same" is
// only guaranteed if it's the same code.
//
// The client never supplies an amount; it is always derived here from live
// catalog prices and the coupon engine.
export type CartQuote = {
  // What to charge, in major units (rupees, euros) — net of any coupon.
  total: number;
  // The same figure in the smallest currency unit, which is what both
  // providers' APIs take. Every StoreCurrency is a two-decimal currency.
  totalMinor: number;
  // ISO-4217, from the store doc. Was hardcoded "INR" before Stripe landed,
  // which is why a EUR/GBP/USD store could never actually take a payment.
  currency: string;
  // The merchant name the checkout sheet shows. It has to be the store's, not
  // the app's: each store settles into its own provider account, so billing
  // the shopper under the app's name would name a party that never receives
  // the money. Empty if the store doc somehow has no name — the client falls
  // back to the app name rather than opening a nameless sheet.
  storeName: string;
};

// Throws OrderCreationError (bad item, insufficient stock) or CouponError (an
// invalid or no-longer-qualifying code) — both already mapped to shopper-facing
// 4xx bodies by the two routes.
export async function quoteCart(
  storeId: string,
  uid: string,
  items: CreateOrderItemInput[],
  couponCode: string,
): Promise<CartQuote> {
  const [storeSnap, priced] = await Promise.all([
    adminDb.collection("stores").doc(storeId).get(),
    priceCart(storeId, items),
  ]);

  let total = priced;
  const code = couponCode.trim();
  if (code) {
    // Same engine as the Apply preview and the order transaction, so the
    // sheet's amount, the preview's discount, and the recorded order agree.
    const coupon = await previewCoupon(storeId, uid, code, items);
    total = Math.round((total - coupon.discount) * 100) / 100;
  }

  const store = storeSnap.data();
  return {
    total,
    totalMinor: Math.round(total * 100),
    currency: ((store?.currency as string | undefined) ?? "INR").toUpperCase(),
    storeName: (store?.name as string | undefined) ?? "",
  };
}
