import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import { cartDocRef } from "./cart";
import type {
  Address,
  Order,
  OrderLineItem,
  OrderStatus,
  UnitType,
} from "./types";

export type CreateOrderItemInput = { productId: string; quantity: number };

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
    placedAt: (data.placedAt as string) ?? "",
    razorpayPaymentId: (data.razorpayPaymentId as string) ?? "",
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

  let total = 0;
  for (let i = 0; i < requestedItems.length; i++) {
    const { productId, quantity } = requestedItems[i];
    const snap = snaps[i];
    if (!snap.exists) {
      throw new OrderCreationError(`Product not found: ${productId}`, productId);
    }
    const data = snap.data()!;
    const stock = (data.stock as number) ?? 0;
    if (stock < quantity) {
      throw new OrderCreationError(
        `Insufficient stock for ${(data.name as string) ?? productId}`,
        productId,
      );
    }
    total += ((data.price as number) ?? 0) * quantity;
  }
  return total;
}

export async function createOrder(
  uid: string,
  storeId: string,
  requestedItems: CreateOrderItemInput[],
  addressId: string,
  razorpayPaymentId = "",
): Promise<Order> {
  if (requestedItems.length === 0) {
    throw new OrderCreationError("Order must contain at least one item");
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

    const lineItems: OrderLineItem[] = [];
    let total = 0;

    for (let i = 0; i < requestedItems.length; i++) {
      const { productId, quantity } = requestedItems[i];
      const snap = productSnaps[i];
      if (!snap.exists) {
        throw new OrderCreationError(`Product not found: ${productId}`, productId);
      }

      const data = snap.data()!;
      const stock = (data.stock as number) ?? 0;
      if (stock < quantity) {
        throw new OrderCreationError(
          `Insufficient stock for ${(data.name as string) ?? productId}`,
          productId,
        );
      }

      const price = (data.price as number) ?? 0;
      const unitValue = (data.unitValue as number) ?? 0;
      const unitType = (data.unitType as UnitType) ?? "g";

      lineItems.push({
        productId,
        productName: (data.name as string) ?? "",
        image: (data.imageUrl as string) ?? "",
        price,
        quantity,
        weight: formatWeight(unitValue, unitType),
      });
      total += price * quantity;

      tx.update(productRefs[i], { stock: stock - quantity });
    }

    const newOrder: Omit<Order, "id"> = {
      uid,
      storeId,
      items: lineItems,
      deliveryAddress,
      status: "PENDING",
      total,
      deliveryOtp: generateOtp(),
      placedAt: new Date().toISOString(),
      razorpayPaymentId,
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

export async function updateOrderStatus(
  orderId: string,
  status: OrderStatus,
): Promise<void> {
  await ordersRef().doc(orderId).update({ status });
}
