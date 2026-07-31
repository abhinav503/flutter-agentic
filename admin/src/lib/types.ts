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

// A merchandising banner for a storefront template's promo carousel (today
// dailymart's DailyMartHomePromoCarousel). Unlike Category/Product this has
// no catalog counterpart — title/subtitle are marketing copy the admin
// writes, which is exactly why it exists: before it, that carousel had to
// borrow top-selling products and derive its copy from their discounts.
export type BannerTargetType = "none" | "product" | "category";

export const BANNER_TARGET_TYPE_LABELS: Record<BannerTargetType, string> = {
  none: "Nothing (display only)",
  product: "A product",
  category: "A category",
};

export type Banner = {
  id: string;
  imageUrl: string;
  title: string;
  subtitle: string;
  // What tapping the banner opens; targetId is that product/category doc's
  // id, empty when targetType is "none". Only the id travels — the
  // storefront resolves display data (e.g. a category's name, needed for
  // its details route) from the catalog it has already loaded, so a rename
  // can't leave a stale copy behind here.
  targetType: BannerTargetType;
  targetId: string;
  // Carousel position, ascending. Sorted in JS rather than with a Firestore
  // orderBy so combining it with the active-only filter needs no composite
  // index — the collection is a handful of docs per store.
  sortOrder: number;
  // Lets a store stage a seasonal banner, or retire one, without deleting
  // the doc and re-uploading its image.
  isActive: boolean;
};

export type CartItem = {
  productId: string;
  quantity: number;
};

// Mirrors the real stores/{storeId} doc written by POST /api/stores
// (store-creation route) — only name/ownerUid/status/createdAt are
// actually written today. logoUrl/description/searchKeywords are part of
// the schema documented in docs/explanation/superapp-ecommerce-plan.md but
// aren't populated by any code yet, so they default to empty in
// mapStoreDoc rather than being treated as always-present.
export type Store = {
  id: string;
  name: string;
  logoUrl: string;
  description: string;
  ownerUid: string;
  status: string;
  searchKeywords: string[];
  // Which cordelia presentation/templates/<id>/ this store's storefront
  // renders as — defaults to 'gravia' (see mapStoreDoc) since it's the only
  // template with a real UI behind it today; see templates/{id} in Firestore
  // (world-readable, `getTemplates()`) for the set the create-store dialog
  // offers.
  templateId: string;
};

// One doc per storefront template the create-store dialog can offer —
// seeded via scripts/seed-templates.mjs, never client-written (see
// firestore.rules). `id` matches cordelia's StorefrontTemplate wire value.
export type Template = {
  id: string;
  name: string;
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

// One dated entry per status transition — the order's timeline, which is the
// only place a "moved to On the way at 11:04" is recorded: `status` holds the
// current value and overwrites the previous one on every update.
//
// Append-only, including corrections: an admin who marks DELIVERED by mistake
// and walks it back leaves [.., DELIVERED, IN_PROCESS, DELIVERED] behind.
// That's deliberate — this is the audit trail, and collapsing it at write
// time destroys information no later read can recover. A timeline UI takes
// the *last* entry per status.
export type OrderStatusChange = { status: OrderStatus; at: string };

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
  // Every status this order has been through, oldest first (see
  // OrderStatusChange). Orders placed before this field existed read back as
  // a single PENDING entry dated `placedAt` — the only transition time we
  // can honestly reconstruct, so their later steps are undated.
  statusHistory: OrderStatusChange[];
  // The verified Razorpay payment this order was placed against. Empty for
  // orders placed through the test-mode payment-less path (the web preview,
  // which can't run the native checkout SDK) — never empty for a live store.
  razorpayPaymentId: string;
  // The Razorpay *order* (`order_...`) the payment was made against — created
  // by POST /payments one step before this order doc existed. Stored so a
  // Razorpay-side record can be traced back here directly; without it the only
  // route in is via razorpayPaymentId. Empty on the payment-less path, and on
  // orders placed before this field was added.
  razorpayOrderId: string;
  // The refund axis (see RefundStatus). NONE on every freshly-placed order;
  // set only when the order is cancelled and a refund is attempted.
  refundStatus: RefundStatus;
  // Razorpay's refund id (`rfnd_...`), set once a refund is issued — empty
  // otherwise. Kept for reconciliation/support lookups.
  refundId: string;
};
