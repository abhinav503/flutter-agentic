import { adminDb } from "./firebase-admin";
import { previewCoupon } from "./coupon-engine";
import { addressDocRef, priceCart, type CreateOrderItemInput } from "./orders";
import {
  DeliveryUnserviceableError,
  deliveryFeeFor,
  isServiceable,
  mapStoreDelivery,
} from "./delivery";

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
  // What to charge, in major units (rupees, euros) — goods net of any
  // coupon, plus deliveryFee.
  total: number;
  // What delivery added, 0 when the store delivers free or the cart cleared
  // its waiver threshold. Broken out because the order transaction records
  // it on the order doc and both storefront and dashboard show it as its own
  // line — a fee folded into `total` could never be displayed.
  deliveryFee: number;
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

// Throws OrderCreationError (bad item, insufficient stock), CouponError (an
// invalid or no-longer-qualifying code) or DeliveryUnserviceableError (the
// address is outside the store's areas) — all three already mapped to
// shopper-facing 4xx bodies by the two routes.
//
// [addressId] is where the order is going. It is optional only because the
// payment-less test path and older app builds don't send one; when it is
// absent the serviceability check cannot run and is skipped, which is the
// same posture as an address with no postal code (see isServiceable).
export async function quoteCart(
  storeId: string,
  uid: string,
  items: CreateOrderItemInput[],
  couponCode: string,
  addressId = "",
): Promise<CartQuote> {
  const [storeSnap, priced, addressSnap] = await Promise.all([
    adminDb.collection("stores").doc(storeId).get(),
    priceCart(storeId, items),
    addressId ? addressDocRef(uid, addressId).get() : Promise.resolve(null),
  ]);

  let goods = priced;
  const code = couponCode.trim();
  if (code) {
    // Same engine as the Apply preview and the order transaction, so the
    // sheet's amount, the preview's discount, and the recorded order agree.
    const coupon = await previewCoupon(storeId, uid, code, items);
    goods = Math.round((goods - coupon.discount) * 100) / 100;
  }

  const store = storeSnap.data();
  const delivery = mapStoreDelivery(store?.delivery);

  // Refused here rather than after the shopper has been charged: this runs
  // before the payment intent exists, so an unserviceable address costs them
  // a message, not a refund. createOrder re-checks against the same policy —
  // the address can be edited between the two calls.
  if (
    addressSnap?.exists &&
    !isServiceable(delivery, (addressSnap.data()?.postalCode as string) ?? "")
  ) {
    throw new DeliveryUnserviceableError();
  }

  const deliveryFee = deliveryFeeFor(delivery, goods);
  const total = Math.round((goods + deliveryFee) * 100) / 100;

  return {
    total,
    deliveryFee,
    totalMinor: Math.round(total * 100),
    currency: ((store?.currency as string | undefined) ?? "INR").toUpperCase(),
    storeName: (store?.name as string | undefined) ?? "",
  };
}
