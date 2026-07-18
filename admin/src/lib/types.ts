// Field names mirror ProductEntity/CategoryEntity in
// apps/ecommerce/gravia/lib/feature/home/domain/entities/ — this schema is
// what the gravia Firestore data source will read from in a later milestone.
// unitType uses gravia's wire values ('g' | 'ml' | 'pcs'), not the Dart enum
// names, so ProductUnitTypeParse.toProductUnitType() can parse it directly.

export type UnitType = "g" | "ml" | "pcs";

export const UNIT_TYPE_LABELS: Record<UnitType, string> = {
  g: "Grams (g)",
  ml: "Millilitres (ml)",
  pcs: "Pieces (pcs)",
};

export type Category = {
  id: string;
  name: string;
  imageUrl: string;
  // Section a category appears under on gravia's Categories screen (e.g.
  // "Snacks & Drinks", "Grocery & Kitchen") — CategoryGroupEntity in gravia.
  // Free text so an admin can introduce a new group without a schema change.
  groupName: string;
};

export type Product = {
  id: string;
  name: string;
  imageUrl: string;
  price: number;
  originalPrice: number;
  discountPercentage: number;
  unitValue: number;
  unitType: UnitType;
  prepTime: string;
  description: string;
  stock: number;
  categoryIds: string[];
  // Real curation flag for the storefront's "popular products" rail —
  // without this, that endpoint would have to fake it by returning
  // everything.
  isPopular: boolean;
};

export type CartItem = {
  productId: string;
  quantity: number;
};

// Mirrors OrderStatus in gravia's lib/enums/order_status.dart, plus PENDING
// (order placed, not yet accepted by the store) — a state gravia doesn't
// have a dedicated enum case for yet. OrderStatusParse's string->enum
// fallback treats any unrecognized value as `inProcess`, so a client still
// on the old 3-state enum degrades safely instead of crashing.
export type OrderStatus = "PENDING" | "IN_PROCESS" | "DELIVERED" | "CANCELLED";

// A line item's product fields are snapshotted at order time (name, image,
// price, formatted weight) — never re-read live from the catalog, so a
// later price change or product deletion can't retroactively alter a past
// order's contents.
export type OrderLineItem = {
  productId: string;
  productName: string;
  image: string;
  price: number;
  quantity: number;
  weight: string;
};

export type Order = {
  id: string;
  uid: string;
  storeId: string;
  items: OrderLineItem[];
  status: OrderStatus;
  total: number;
  deliveryOtp: string;
  placedAt: string;
};
