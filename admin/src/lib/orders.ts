import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import { cartDocRef } from "./cart";
import {
  assertCouponUsable,
  computeDiscount,
  CouponError,
  couponRedemptionRef,
  eligibleSubtotal,
  findCouponByCode,
  mapCouponData,
  type CouponLine,
} from "./coupon-engine";
import { resolveLinePricing } from "./products";
import {
  MAX_RATING,
  MIN_RATING,
  type Address,
  type Order,
  type OrderLineItem,
  type OrderStatus,
  type OrderStatusChange,
  type RefundStatus,
  type SizeVariant,
  type UnitType,
} from "./types";

// Same cap a product review's body takes — one runaway paragraph shouldn't
// bloat every order payload the dashboard and the app load.
const MAX_REVIEW_TEXT_LENGTH = 2000;

// sizeValue selects one of the product's sizeVariants (absent = base pack) —
// only the size travels; the server resolves its price, never the client.
export type CreateOrderItemInput = {
  productId: string;
  quantity: number;
  sizeValue?: number;
};

// The pricing fields resolveLinePricing needs, off a raw product doc —
// orders run on the Admin SDK, so there's no mapProductDoc here.
function pricingFields(data: FirebaseFirestore.DocumentData) {
  return {
    price: (data.price as number) ?? 0,
    originalPrice: (data.originalPrice as number) ?? 0,
    unitValue: (data.unitValue as number) ?? 0,
    sizeVariants: (data.sizeVariants as SizeVariant[]) ?? [],
  };
}

// Stock is product-level while variants share it, and a cart can now hold
// several lines of one product (different sizes) — check and decrement the
// summed quantity per product, not per line, or the second line's write
// would clobber the first's.
function quantityByProduct(items: { productId: string; quantity: number }[]) {
  const totals = new Map<string, number>();
  for (const item of items) {
    totals.set(item.productId, (totals.get(item.productId) ?? 0) + item.quantity);
  }
  return totals;
}

// Thrown for any client-input problem (unknown product, insufficient
// stock) — routes catch this and map it to a 400/409, distinct from an
// unexpected server error.
export class OrderCreationError extends Error {
  constructor(
    message: string,
    public readonly productId?: string,
  ) {
    super(message);
  }
}

function ordersRef() {
  return adminDb.collection("orders");
}

function productDocRef(storeId: string, productId: string) {
  return adminDb.collection("stores").doc(storeId).collection("products").doc(productId);
}

// Addresses live per-user (see addresses.ts) — the order snapshots one of
// them by id at placement time.
function addressDocRef(uid: string, addressId: string) {
  return adminDb.collection("users").doc(uid).collection("addresses").doc(addressId);
}

function generateOtp(): string {
  return String(Math.floor(1000 + Math.random() * 9000));
}

// Mirrors ProductUnitTypeX.format in gravia (lib/enums/product_unit_type.dart)
// — rolls up to kg/L past 1000, pieces never roll up — so an order's
// snapshotted `weight` copy reads the same as the product page did.
function formatWeight(unitValue: number, unitType: UnitType): string {
  if (unitType === "pcs") return `${unitValue.toFixed(0)} pcs`;
  const large = unitType === "g" ? "kg" : "L";
  if (unitValue < 1000) return `${unitValue.toFixed(0)} ${unitType}`;
  const rolled = unitValue / 1000;
  const isWhole = rolled === Math.round(rolled);
  return `${isWhole ? rolled.toFixed(0) : rolled.toFixed(1)} ${large}`;
}

function toOrder(id: string, data: FirebaseFirestore.DocumentData): Order {
  const placedAt = (data.placedAt as string) ?? "";
  return {
    id,
    uid: data.uid as string,
    storeId: data.storeId as string,
    items: (data.items as OrderLineItem[]) ?? [],
    // Orders placed before delivery addresses existed have no snapshot —
    // fall back to an empty address so serializeOrder/older docs don't throw.
    deliveryAddress: (data.deliveryAddress as Address) ?? EMPTY_ADDRESS,
    status: (data.status as OrderStatus) ?? "PENDING",
    total: (data.total as number) ?? 0,
    deliveryOtp: (data.deliveryOtp as string) ?? "",
    placedAt,
    // Orders placed before the timeline existed have no history — synthesize
    // the one entry we can date honestly. Their later transitions went
    // unrecorded and can't be reconstructed, so the timeline shows those
    // steps reached but undated.
    statusHistory: (data.statusHistory as OrderStatusChange[]) ?? [
      { status: "PENDING", at: placedAt },
    ],
    razorpayPaymentId: (data.razorpayPaymentId as string) ?? "",
    razorpayOrderId: (data.razorpayOrderId as string) ?? "",
    couponCode: (data.couponCode as string) ?? "",
    couponDiscount: (data.couponDiscount as number) ?? 0,
    // Absent on every order placed before order rating shipped, and on every
    // order nobody has rated — both are "unrated", which is what 0 means.
    rating: (data.rating as number) ?? 0,
    reviewText: (data.reviewText as string) ?? "",
    reviewedAt: (data.reviewedAt as string) ?? "",
    // Orders placed before the refund axis existed have no field — default to
    // NONE so an un-refunded past order reads correctly.
    refundStatus: (data.refundStatus as RefundStatus) ?? "NONE",
    refundId: (data.refundId as string) ?? "",
  };
}

const EMPTY_ADDRESS: Address = {
  id: "",
  name: "",
  phone: "",
  addressLine1: "",
  addressLine2: "",
  landmark: "",
  city: "",
  country: "",
  postalCode: "",
  tag: "",
  isDefault: false,
};

// Server-side price/stock authority — the client only supplies
// productId+quantity; name/image/price/stock all come from the live
// Firestore product doc inside one transaction, so a stale client price or
// a race between two shoppers checking out the same low-stock item can't
// corrupt an order or oversell. Also clears the shopper's cart for this
// store in the same transaction — standard "checkout empties the cart"
// behavior, and atomic with the order write.
// Reads live product docs and sums price*quantity without touching stock —
// the authoritative amount for a payment intent, computed the same way (and
// from the same source) as the final transaction below, so the shopper is
// charged exactly what the confirmed order totals. Validates existence and
// stock up front so a doomed cart fails before the shopper is charged,
// rather than after (which would need a refund).
export async function priceCart(
  storeId: string,
  requestedItems: CreateOrderItemInput[],
): Promise<number> {
  if (requestedItems.length === 0) {
    throw new OrderCreationError("Order must contain at least one item");
  }

  const snaps = await Promise.all(
    requestedItems.map((item) => productDocRef(storeId, item.productId).get()),
  );

  const requiredStock = quantityByProduct(requestedItems);
  let total = 0;
  for (let i = 0; i < requestedItems.length; i++) {
    const { productId, quantity, sizeValue } = requestedItems[i];
    const snap = snaps[i];
    if (!snap.exists) {
      throw new OrderCreationError(`Product not found: ${productId}`, productId);
    }
    const data = snap.data()!;
    const stock = (data.stock as number) ?? 0;
    if (stock < requiredStock.get(productId)!) {
      throw new OrderCreationError(
        `Insufficient stock for ${(data.name as string) ?? productId}`,
        productId,
      );
    }
    total += resolveLinePricing(pricingFields(data), sizeValue).price * quantity;
  }
  return total;
}

export async function createOrder(
  uid: string,
  storeId: string,
  requestedItems: CreateOrderItemInput[],
  addressId: string,
  razorpayPaymentId = "",
  razorpayOrderId = "",
  couponCode = "",
): Promise<Order> {
  if (requestedItems.length === 0) {
    throw new OrderCreationError("Order must contain at least one item");
  }

  // Resolved outside the transaction (a where-query can't run inside one);
  // the doc itself is re-read transactionally below, so the limit checks
  // still see transaction-consistent counts.
  const foundCoupon = couponCode
    ? await findCouponByCode(storeId, couponCode)
    : null;
  if (couponCode && !foundCoupon) {
    throw new CouponError("Invalid coupon code");
  }

  const orderRef = ordersRef().doc();

  return adminDb.runTransaction(async (tx) => {
    // All reads must happen before any write in a Firestore transaction, so
    // the address and product docs are read up front, before the stock
    // decrements below.
    const addressSnap = await tx.get(addressDocRef(uid, addressId));
    if (!addressSnap.exists) {
      throw new OrderCreationError("Delivery address not found");
    }
    // Snapshot the whole address onto the order — a later edit/delete of the
    // shopper's address must not change where this order was sent.
    const deliveryAddress: Address = {
      id: addressSnap.id,
      ...(addressSnap.data() as Omit<Address, "id">),
    };

    const productRefs = requestedItems.map((item) =>
      productDocRef(storeId, item.productId),
    );
    const productSnaps = await Promise.all(productRefs.map((ref) => tx.get(ref)));

    // Coupon reads join the read phase (Firestore forbids reads after the
    // stock writes below) — these transaction-consistent counts are what
    // makes the limit checks race-proof where previewCoupon's aren't.
    const couponSnap = foundCoupon ? await tx.get(foundCoupon.ref) : null;
    const redemptionSnap = foundCoupon
      ? await tx.get(couponRedemptionRef(storeId, foundCoupon.ref.id, uid))
      : null;

    const requiredStock = quantityByProduct(requestedItems);
    const lineItems: OrderLineItem[] = [];
    const couponLines: CouponLine[] = [];
    let total = 0;
    // Decrement each product once, by its summed quantity — a second
    // tx.update on the same doc would overwrite the first, silently
    // restoring the earlier line's stock.
    const decremented = new Set<string>();

    for (let i = 0; i < requestedItems.length; i++) {
      const { productId, quantity, sizeValue } = requestedItems[i];
      const snap = productSnaps[i];
      if (!snap.exists) {
        throw new OrderCreationError(`Product not found: ${productId}`, productId);
      }

      const data = snap.data()!;
      const stock = (data.stock as number) ?? 0;
      const required = requiredStock.get(productId)!;
      if (stock < required) {
        throw new OrderCreationError(
          `Insufficient stock for ${(data.name as string) ?? productId}`,
          productId,
        );
      }

      const pricing = resolveLinePricing(pricingFields(data), sizeValue);
      const unitType = (data.unitType as UnitType) ?? "g";

      lineItems.push({
        productId,
        productName: (data.name as string) ?? "",
        image: (data.imageUrl as string) ?? "",
        price: pricing.price,
        quantity,
        // The pack actually sold — the selected size's label when the line
        // carried one, the product's own otherwise.
        weight: formatWeight(pricing.packSize, unitType),
      });
      total += pricing.price * quantity;
      couponLines.push({
        productId,
        categoryIds: (data.categoryIds as string[]) ?? [],
        lineTotal: pricing.price * quantity,
      });

      if (!decremented.has(productId)) {
        decremented.add(productId);
        tx.update(productRefs[i], { stock: stock - required });
      }
    }

    // Re-run the full coupon check on this transaction's own reads, then
    // count the redemption atomically with the order write — Apply's preview
    // reserved nothing, so this is where a limit actually binds.
    let couponDiscount = 0;
    let appliedCouponCode = "";
    if (foundCoupon) {
      if (!couponSnap!.exists) throw new CouponError("Invalid coupon code");
      const coupon = mapCouponData(couponSnap!.id, couponSnap!.data()!);
      const eligible = eligibleSubtotal(coupon, couponLines);
      assertCouponUsable(coupon, {
        nowIso: new Date().toISOString(),
        usedCount: coupon.usedCount,
        userRedemptions: (redemptionSnap!.data()?.count as number) ?? 0,
        orderSubtotal: total,
        eligible,
      });
      couponDiscount = computeDiscount(coupon, eligible, total);
      appliedCouponCode = coupon.code;
      tx.update(foundCoupon.ref, { usedCount: FieldValue.increment(1) });
      tx.set(
        couponRedemptionRef(storeId, foundCoupon.ref.id, uid),
        {
          count: FieldValue.increment(1),
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
    }

    const placedAt = new Date().toISOString();

    const newOrder: Omit<Order, "id"> = {
      uid,
      storeId,
      items: lineItems,
      deliveryAddress,
      status: "PENDING",
      // Net of the coupon — the same figure the payment intent charged.
      total: Math.round((total - couponDiscount) * 100) / 100,
      deliveryOtp: generateOtp(),
      placedAt,
      // Placement is the timeline's first entry, sharing placedAt's exact
      // value so the two can never disagree.
      statusHistory: [{ status: "PENDING", at: placedAt }],
      razorpayPaymentId,
      razorpayOrderId,
      couponCode: appliedCouponCode,
      couponDiscount,
      // Unrated until the order is delivered and the shopper says so.
      rating: 0,
      reviewText: "",
      reviewedAt: "",
      refundStatus: "NONE",
      refundId: "",
    };

    tx.set(orderRef, newOrder);
    tx.set(cartDocRef(uid, storeId), {
      items: [],
      updatedAt: FieldValue.serverTimestamp(),
    });

    return { id: orderRef.id, ...newOrder };
  });
}

export async function getOrdersForUser(
  uid: string,
  storeId: string,
): Promise<Order[]> {
  const snap = await ordersRef()
    .where("storeId", "==", storeId)
    .where("uid", "==", uid)
    .orderBy("placedAt", "desc")
    .get();
  return snap.docs.map((d) => toOrder(d.id, d.data()));
}

export async function getOrdersForStore(storeId: string): Promise<Order[]> {
  const snap = await ordersRef()
    .where("storeId", "==", storeId)
    .orderBy("placedAt", "desc")
    .get();
  return snap.docs.map((d) => toOrder(d.id, d.data()));
}

// Returns null if the order doesn't exist OR belongs to a different store —
// callers 404 either way, so a store owner probing another store's order
// IDs can't tell the two cases apart.
export async function getOrderForStore(
  orderId: string,
  storeId: string,
): Promise<Order | null> {
  const snap = await ordersRef().doc(orderId).get();
  if (!snap.exists) return null;
  const order = toOrder(snap.id, snap.data()!);
  return order.storeId === storeId ? order : null;
}

// Moves an order to [status] and appends the transition to its timeline,
// returning the updated order so the caller serializes what was actually
// written rather than patching its own pre-read copy.
//
// Transactional for the no-op guard, not for the write: re-picking the
// current status must not append a second dated entry, and `arrayUnion`
// can't dedupe that for us — the two entries differ by their timestamp, so
// both would land and the timeline would show a step the order never took.
export async function updateOrderStatus(
  orderId: string,
  status: OrderStatus,
): Promise<Order> {
  const orderRef = ordersRef().doc(orderId);

  return adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(orderRef);
    // Callers 404 on a missing order before reaching here, so this only
    // fires if the doc was deleted mid-request.
    if (!snap.exists) throw new Error(`Order not found: ${orderId}`);
    const order = toOrder(snap.id, snap.data()!);
    if (order.status === status) return order;

    const change: OrderStatusChange = {
      status,
      at: new Date().toISOString(),
    };
    tx.update(orderRef, {
      status,
      statusHistory: FieldValue.arrayUnion(change),
    });
    return {
      ...order,
      status,
      statusHistory: [...order.statusHistory, change],
    };
  });
}

export async function getOrderById(orderId: string): Promise<Order | null> {
  const snap = await ordersRef().doc(orderId).get();
  if (!snap.exists) return null;
  return toOrder(snap.id, snap.data()!);
}

// Finds the order a Razorpay payment belongs to, scoped to the store the
// webhook is for. A full-order refund is 1:1 with a payment, so this uniquely
// identifies the order to reconcile. Two equality filters are served by
// single-field indexes (no composite index needed).
export async function getOrderByPaymentId(
  storeId: string,
  paymentId: string,
): Promise<Order | null> {
  const snap = await ordersRef()
    .where("storeId", "==", storeId)
    .where("razorpayPaymentId", "==", paymentId)
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return toOrder(doc.id, doc.data());
}

// A cancel that isn't allowed by the order's current lifecycle — a delivered
// order is done, an already-cancelled one is a no-op. Routes map this to 409.
export class CancelNotAllowedError extends Error {}

// Cancels an order and reverses its stock, atomically. Deliberately does NOT
// touch Razorpay — issuing the refund needs the store secret and an external
// HTTP call, which can't run inside a Firestore transaction; the caller does
// that next and records the outcome via setOrderRefund. This split means the
// order is always left in a recoverable state: CANCELLED + restocked, with
// refundStatus PENDING (a refund is owed) when it was paid, so a failed
// refund call can be retried without re-cancelling. Returns the updated order.
export async function cancelOrder(orderId: string): Promise<Order> {
  const orderRef = ordersRef().doc(orderId);

  return adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(orderRef);
    if (!snap.exists) {
      throw new CancelNotAllowedError("Order not found");
    }
    const order = toOrder(snap.id, snap.data()!);

    if (order.status === "CANCELLED") {
      throw new CancelNotAllowedError("Order is already cancelled");
    }
    if (order.status === "DELIVERED") {
      throw new CancelNotAllowedError("A delivered order can't be cancelled");
    }

    // Restock every line item — read all product docs first (Firestore
    // transactions require reads before writes), then increment. Summed per
    // product: an order can hold several lines of one product (different
    // sizes), and a second update on the same doc would overwrite the first.
    const restockByProduct = quantityByProduct(order.items);
    const productIds = [...restockByProduct.keys()];
    const productRefs = productIds.map((productId) =>
      productDocRef(order.storeId, productId),
    );
    const productSnaps = await Promise.all(productRefs.map((ref) => tx.get(ref)));

    const paid = order.razorpayPaymentId !== "";
    const refundStatus: RefundStatus = paid ? "PENDING" : "NONE";
    const change: OrderStatusChange = {
      status: "CANCELLED",
      at: new Date().toISOString(),
    };

    tx.update(orderRef, {
      status: "CANCELLED",
      refundStatus,
      statusHistory: FieldValue.arrayUnion(change),
    });
    for (let i = 0; i < productIds.length; i++) {
      const productSnap = productSnaps[i];
      // A product deleted since the order was placed simply isn't restocked —
      // there's no doc to increment, and re-creating it would be wrong.
      if (!productSnap.exists) continue;
      const stock = (productSnap.data()!.stock as number) ?? 0;
      tx.update(productRefs[i], {
        stock: stock + restockByProduct.get(productIds[i])!,
      });
    }

    return {
      ...order,
      status: "CANCELLED",
      refundStatus,
      statusHistory: [...order.statusHistory, change],
    };
  });
}

// The shopper rated their own delivery, or is changing that rating. Distinct
// from a product review (lib/reviews.ts): this judges how the *order* went,
// so it is gated where a product review deliberately isn't — you can only
// rate a delivery you actually received.
// Carries its own HTTP status rather than making the route infer one from
// the message: the three refusals are genuinely different (bad input, wrong
// owner, wrong lifecycle state) and a caller acts on each differently.
export class OrderRatingError extends Error {
  constructor(
    message: string,
    readonly status: number,
  ) {
    super(message);
  }
}

// Rates an order. Re-rating overwrites, the same "one per subject, posting
// again edits it" rule product reviews follow — an order has exactly one
// shopper, so no per-user keying is needed here.
//
// Transactional for the two gates: the order must belong to the caller and
// must be DELIVERED when the write lands. Read-then-write without one would
// let a cancel racing in leave a rating on an order that never arrived.
export async function rateOrder(
  orderId: string,
  uid: string,
  rating: number,
  text: string,
): Promise<Order> {
  if (!Number.isInteger(rating) || rating < MIN_RATING || rating > MAX_RATING) {
    throw new OrderRatingError(
      `rating must be a whole number from ${MIN_RATING} to ${MAX_RATING}`,
      400,
    );
  }

  const orderRef = ordersRef().doc(orderId);

  return adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(orderRef);
    if (!snap.exists) {
      throw new OrderRatingError("Order not found", 404);
    }
    const order = toOrder(snap.id, snap.data()!);

    // Someone else's order answers exactly as a missing one does — the same
    // policy getOrderForStore follows, so probing ids reveals nothing.
    if (order.uid !== uid) {
      throw new OrderRatingError("Order not found", 404);
    }
    if (order.status !== "DELIVERED") {
      throw new OrderRatingError("Only a delivered order can be rated", 409);
    }

    const reviewedAt = new Date().toISOString();
    const reviewText = text.trim().slice(0, MAX_REVIEW_TEXT_LENGTH);
    tx.update(orderRef, { rating, reviewText, reviewedAt });
    return { ...order, rating, reviewText, reviewedAt };
  });
}

export async function setOrderRefund(
  orderId: string,
  refundStatus: RefundStatus,
  refundId: string,
): Promise<void> {
  await ordersRef().doc(orderId).update({ refundStatus, refundId });
}
