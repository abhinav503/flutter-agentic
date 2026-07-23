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
  // Selectable package sizes shown on gravia's Product Details "Select QTY"
  // row, in unitType's base unit (e.g. [250, 500, 1000] for grams). Empty =
  // the product has no size picker.
  sizeOptions: number[];
  // Real curation flag for the storefront's "popular products" rail —
  // without this, that endpoint would have to fake it by returning
  // everything.
  isPopular: boolean;
};

export type CartItem = {
  productId: string;
  quantity: number;
};

// Field names mirror AddressEntity in gravia's feature/address. Structured
// fields, not one text blob — gravia composes its display line client-side
// (AddressEntityX.displayLine) so edits can't drift from the parts.
export type Address = {
  id: string;
  name: string;
  phone: string;
  addressLine1: string;
  addressLine2: string;
  landmark: string;
  city: string;
  country: string;
  postalCode: string;
  tag: string;
  isDefault: boolean;
};

// A recent search is the catalog item the shopper tapped from search
// results — not the raw query string — so gravia can deep-link straight
// back to the product/category details page. `name` is snapshotted at tap
// time (display-only), same reasoning as OrderLineItem's snapshot fields.
export type RecentSearchType = "product" | "category";

export type RecentSearch = {
  id: string;
  name: string;
  type: RecentSearchType;
};

// Mirrors OrderStatus in gravia's lib/enums/order_status.dart, plus PENDING
// (order placed, not yet accepted by the store) — a state gravia doesn't
// have a dedicated enum case for yet. OrderStatusParse's string->enum
// fallback treats any unrecognized value as `inProcess`, so a client still
// on the old 3-state enum degrades safely instead of crashing. IN_PROCESS is
// labelled "On the way" in both UIs; the wire value stays IN_PROCESS so no
// existing order doc needs migrating.
export type OrderStatus = "PENDING" | "IN_PROCESS" | "DELIVERED" | "CANCELLED";

// The refund lifecycle — an axis orthogonal to OrderStatus, so a cancelled
// order records separately whether its money has been returned. NONE for an
// order that was never paid (test-mode/web) or isn't cancelled; PENDING once
// Razorpay has accepted the refund but not yet settled it; PROCESSED once
// settled; FAILED when the refund call itself errored (the order is still
// cancelled — the refund can be retried). Razorpay's own refund `status`
// ("pending"/"processed") maps onto PENDING/PROCESSED.
export type RefundStatus = "NONE" | "PENDING" | "PROCESSED" | "FAILED";

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

// The delivery address is snapshotted onto the order at placement time (same
// reasoning as OrderLineItem's snapshot fields) — the shopper editing or
// deleting that address later must not retroactively change where a past
// order was sent. Structurally an Address, so it serializes through the same
// serializeAddress() shape the /users/addresses routes use.
export type Order = {
  id: string;
  uid: string;
  storeId: string;
  items: OrderLineItem[];
  deliveryAddress: Address;
  status: OrderStatus;
  total: number;
  deliveryOtp: string;
  placedAt: string;
  // The verified Razorpay payment this order was placed against. Empty for
  // orders placed through the test-mode payment-less path (the web preview,
  // which can't run the native checkout SDK) — never empty for a live store.
  razorpayPaymentId: string;
  // The refund axis (see RefundStatus). NONE on every freshly-placed order;
  // set only when the order is cancelled and a refund is attempted.
  refundStatus: RefundStatus;
  // Razorpay's refund id (`rfnd_...`), set once a refund is issued — empty
  // otherwise. Kept for reconciliation/support lookups.
  refundId: string;
};
