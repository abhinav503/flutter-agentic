// Field names mirror ProductEntity/CategoryEntity in
// apps/ecommerce/gravia/lib/feature/home/domain/entities/ — this schema is
// what the gravia Firestore data source will read from in a later milestone.
// unitType uses gravia's wire values ('g' | 'ml' | 'pcs'), not the Dart enum
// names, so ProductUnitTypeParse.toProductUnitType() can parse it directly.

import type { StoreStatus } from "./store-status";
import type { PaymentProvider } from "./payment-providers/types";
import type { StoreDelivery } from "./delivery";

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
  // Millis from the doc's createdAt serverTimestamp — what the dashboard's
  // "newest first" sort orders by. 0 = the doc predates the field, or the
  // snapshot is latency-compensated and the pending serverTimestamp is still
  // null. Mapper-derived (never written as a field), so the *Input types all
  // omit it.
  createdAtMs: number;
};

// A product manufacturer/label ("Amul", "Tata") — an entity rather than a
// free-text field on Product so a storefront can browse/filter by it and a
// rename edits one doc. Products reference it by id only (see Banner's
// targetId note: display data resolves at read time, so a rename can't
// leave stale copies behind).
export type Brand = {
  id: string;
  name: string;
  logoUrl: string;
  // See Category.createdAtMs.
  createdAtMs: number;
};

// One selectable package size on the product page's "Select QTY" row, with
// its own price — 500g is not just 2× the 250g chip visually, it has a real
// price the cart will charge. originalPrice ≥ price; discount is derived per
// variant (computeDiscountPercentage), never stored. Stock deliberately stays
// product-level until order lines carry a variant — per-variant stock with
// nothing decrementing it would be fiction.
export type SizeVariant = {
  value: number;
  price: number;
  originalPrice: number;
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
  // The product's brand doc id, or "" for unbranded. Id-only — name/logo
  // resolve from the brands collection at read time (see Brand above).
  brandId: string;
  // Selectable package sizes shown on gravia's Product Details "Select QTY"
  // row, in unitType's base unit (e.g. [250, 500, 1000] for grams). Empty =
  // the product has no size picker. Kept in sync with sizeVariants (it's
  // always the variants' values) so storefronts reading the old field keep
  // working until they adopt per-variant pricing.
  sizeOptions: number[];
  // sizeOptions with real per-size pricing — the source of truth the form
  // edits; sizeOptions is derived from it on every save.
  sizeVariants: SizeVariant[];
  // Real curation flag for the storefront's "popular products" rail —
  // without this, that endpoint would have to fake it by returning
  // everything.
  isPopular: boolean;
  // Rolled up from the reviews subcollection (see Review below) inside the
  // same transaction as every review write, so the two can never drift.
  // Denormalized onto the product deliberately: product docs are
  // world-readable and already loaded by every grid, so a card can print a
  // rating with zero extra reads — counting a subcollection per card
  // couldn't. Not admin-editable (see ProductInput in products.ts).
  ratingAverage: number;
  reviewCount: number;
  ratingBuckets: RatingBuckets;
  // See Category.createdAtMs.
  createdAtMs: number;
};

// Per-star review counts — the histogram dailymart's Reviews frame draws.
// A plain average can't produce those five bars, which is why the buckets
// are stored rather than derived.
export type RatingBuckets = {
  1: number;
  2: number;
  3: number;
  4: number;
  5: number;
};

export const EMPTY_RATING_BUCKETS: RatingBuckets = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };

// The lowest and highest star a review may carry — one range, used by the
// write route's validation and by the buckets above.
export const MIN_RATING = 1;
export const MAX_RATING = 5;

// One shopper's review of one product —
// stores/{storeId}/products/{productId}/reviews/{uid}. The doc id IS the
// reviewer's uid, so a shopper has at most one review per product: posting
// again edits theirs instead of stacking duplicates, and "have I reviewed
// this?" is a single get rather than a query.
//
// Any signed-in shopper may review, bought or not — rating a *delivered
// order* is the separate, purchase-gated feature. Reviews are written only
// through the token-verified API (never the client SDK) because each write
// must move the product's aggregates in the same transaction.
export type Review = {
  uid: string;
  // Denormalized so the dashboard's store-wide listing can be one
  // collection-group query instead of one read per product.
  storeId: string;
  productId: string;
  // MIN_RATING..MAX_RATING, whole stars.
  rating: number;
  text: string;
  // Snapshotted from users/{uid} at write time rather than resolved per
  // read — rendering N reviews would otherwise cost N profile reads. A
  // later profile rename leaves past reviews reading as they were posted,
  // the usual trade for this (same reasoning as OrderLineItem's snapshots).
  userName: string;
  userAvatarUrl: string;
  // Derived server-side from the reviewer's delivered orders; never taken
  // from the request body. Purely a badge — it gates nothing.
  verifiedPurchase: boolean;
  createdAt: string;
  updatedAt: string;
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
  // "#RRGGBB" for the copy panel beside the artwork, or "" to let the
  // storefront's own surface colour stand in. Only templates that lay the
  // copy out *next to* the image read it — one that prints the copy over the
  // photo ignores it.
  backgroundColor: string;
};

export type CartItem = {
  productId: string;
  quantity: number;
  // The selected package size (a sizeVariants value), absent for the
  // product's base pack — line identity in a cart is (productId, sizeValue).
  sizeValue?: number;
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
  status: StoreStatus;
  /// Set when a superadmin rejects a submission — shown back to the store
  /// owner so they know what to fix. Cleared on the next submit.
  rejectionReason: string;
  /// Cached result of the preview tier of `getStoreReadiness` (logo +
  /// categories + products), refreshed whenever the owner opens the publish
  /// card or submits. Discovery reads this instead of counting
  /// subcollections per store on every load; a stale `true` at worst shows
  /// the owner their own store, which is the point of the tier.
  previewReady: boolean;
  searchKeywords: string[];
  // Which cordelia presentation/templates/<id>/ this store's storefront
  // renders as — defaults to 'gravia' (see mapStoreDoc) since it's the only
  // template with a real UI behind it today; see templates/{id} in Firestore
  // (world-readable, `getTemplates()`) for the set the create-store dialog
  // offers.
  templateId: string;
  // The storefront's UI language (see STORE_LANGUAGES) — defaults to 'en' (see
  // mapStoreDoc). Every template is localized (its pack constants read the
  // active string table), so this applies whichever one the store renders.
  language: string;
  // ISO-4217 code the store charges in ('INR' | 'EUR' | 'GBP' | 'USD') —
  // defaults to 'INR' (see mapStoreDoc), which is what stores predating the
  // field were already charging.
  currency: string;
  // What this store charges to deliver, and where it delivers at all (see
  // StoreDelivery). Stores predating the field read back as free delivery
  // everywhere — what every storefront's totals panel used to hardcode.
  delivery: StoreDelivery;
  // See Category.createdAtMs. Both store lists order by this, in opposite
  // directions, because they are different jobs: discovery is a feed and runs
  // newest first, while the superadmin review queue runs oldest first so the
  // submission that has waited longest surfaces to be worked next.
  createdAtMs: number;
};

// Array order is the order the language pickers render (Settings, and the
// create-store dialog): English first as the default, then the European packs,
// **Hindi last**. A new language goes before "hi", not after it. This is a UI
// decision living in a constant — nothing keys off the position, and stores
// persist the code string, so the order is free to change and therefore easy
// to change back by accident.
export const STORE_LANGUAGES = ["en", "de", "fr", "es", "it", "hi"] as const;
export type StoreLanguage = (typeof STORE_LANGUAGES)[number];

export const STORE_LANGUAGE_LABELS: Record<StoreLanguage, string> = {
  en: "English",
  de: "Deutsch (German)",
  fr: "Français (French)",
  es: "Español (Spanish)",
  it: "Italiano (Italian)",
  hi: "हिन्दी (Hindi)",
};

// What the store charges in — independent of `language`, since a shopper
// reading a UK store in German still pays in £. Matches cordelia's
// StoreCurrency enum; the app formats the glyph and separators itself from
// this code plus the shopper's locale, so nothing here is a symbol.
export const STORE_CURRENCIES = ["INR", "EUR", "GBP", "USD"] as const;
export type StoreCurrency = (typeof STORE_CURRENCIES)[number];

export const STORE_CURRENCY_LABELS: Record<StoreCurrency, string> = {
  INR: "₹ Indian Rupee (INR)",
  EUR: "€ Euro (EUR)",
  GBP: "£ Pound Sterling (GBP)",
  USD: "$ US Dollar (USD)",
};

// One doc per storefront template the create-store dialog can offer —
// seeded via scripts/seed-templates.mjs, never client-written (see
// firestore.rules). `id` matches cordelia's StorefrontTemplate wire value.
export type Template = {
  id: string;
  name: string;
};

export type CouponType = "percent" | "flat";

// A function rather than a constant because the flat label names the store's
// currency (see lib/money.ts) — "Flat amount off (₹)" was wrong the moment a
// store could charge in euros.
export function couponTypeLabels(
  currencySign: string,
): Record<CouponType, string> {
  return {
    percent: "Percentage off",
    flat: `Flat amount off (${currencySign})`,
  };
}

// What the discount applies to: the whole order, or only the lines whose
// product matches targetIds (directly, or through a category) — the
// banner-target pattern, but multi-select.
export type CouponScope = "store" | "category" | "product";

export const COUPON_SCOPE_LABELS: Record<CouponScope, string> = {
  store: "Whole order",
  category: "Selected categories",
  product: "Selected products",
};

// A discount code (stores/{id}/coupons). The code is stored uppercase and
// unique per store; shoppers never read these docs — validation and pricing
// go through the token-verified API, which is also the only writer of
// usedCount (and the per-user redemptions/{uid} subcollection) inside the
// order transaction.
export type Coupon = {
  id: string;
  code: string;
  type: CouponType;
  // Percent (1–100) or a flat amount in the store's currency, per type.
  value: number;
  scope: CouponScope;
  // Category/product doc ids for the scoped kinds; empty for "store".
  targetIds: string[];
  // 0 = no floor. Checked against the order's eligible-items subtotal.
  minOrderValue: number;
  // Cap for a percent coupon's computed discount; 0 = uncapped.
  maxDiscount: number;
  // ISO timestamps; "" = immediately / never.
  validFrom: string;
  validUntil: string;
  // Total redemptions allowed (0 = unlimited) and how many have happened.
  usageLimit: number;
  perUserLimit: number;
  usedCount: number;
  isActive: boolean;
  // See Category.createdAtMs.
  createdAtMs: number;
};

// Mirrors NotificationKind in cordelia's lib/enums — what a notification is
// *about*, never how it's drawn. Each storefront template maps a kind to its
// own pack glyph, so an icon/asset path must never reach this data.
export const NOTIFICATION_KINDS = [
  "discount",
  "orderPlaced",
  "orderDelivered",
  "payment",
  "account",
  "security",
] as const;

export type NotificationKind = (typeof NOTIFICATION_KINDS)[number];

export const NOTIFICATION_KIND_LABELS: Record<NotificationKind, string> = {
  discount: "Offer or discount",
  orderPlaced: "Order placed",
  orderDelivered: "Order delivered",
  payment: "Payment",
  account: "Account",
  security: "Security",
};

// Who authored a notification, which is also who can delete it. A shopper's
// feed merges both sources; the app labels a platform one so a store isn't
// blamed for a message it didn't write.
//
// Not stored on the platform docs themselves — it's derived from which
// collection a notification came out of (`notifications` vs
// `stores/{id}/notifications`), so the two can never disagree.
export type NotificationSource = "store" | "platform";

/**
 * FCM silently drops a push image over ~300 KB — no error, just a push with
 * no picture — so this is enforced rather than left to fail invisibly on the
 * device. Lives here because both ends check it: the upload field rejects the
 * file before it is stored, and the send route re-checks the URL, since the
 * browser's check is advice a scripted caller can skip.
 */
export const NOTIFICATION_IMAGE_MAX_BYTES = 300 * 1024;

export type StoreNotification = {
  id: string;
  kind: NotificationKind;
  title: string;
  message: string;
  /**
   * Optional artwork. Shown by the OS on a backgrounded push and rendered as
   * a BigPicture in the foreground; empty string when there is none. Capped
   * at {@link NOTIFICATION_IMAGE_MAX_BYTES}.
   */
  imageUrl: string;
  source: NotificationSource;
  // See Category.createdAtMs. Also what the storefront groups the feed by —
  // the "Today"/"Yesterday" section titles are derived from this server-side,
  // so the app keeps taking sections as opaque data.
  createdAtMs: number;
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
  // Empty on addresses saved before the location feature (and optional in
  // the form) — same back-compat posture as latitude/longitude below.
  state: string;
  country: string;
  postalCode: string;
  tag: string;
  isDefault: boolean;
  // Set when the address came from GPS/autocomplete; null for hand-typed
  // ones and for every address (and order delivery_address snapshot) saved
  // before the location feature.
  latitude: number | null;
  longitude: number | null;
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

// A payment that was taken and never became an order.
//
// Checkout takes the money first and writes the order second; if the basket
// stops being valid in between (the last unit sold, a coupon hit its limit,
// the address left the delivery areas), there is a captured payment with
// nothing to attach it to. The refund is automatic — this is the record of it,
// and the only place a store owner can see why their provider's dashboard
// shows a refund with no order beside it.
//
// Doc id is the payment id, which is what makes a retried checkout update one
// record rather than stacking duplicates.
export type OrphanedPayment = {
  id: string;
  uid: string;
  paymentId: string;
  paymentOrderId: string;
  provider: PaymentProvider;
  reason: OrphanedPaymentReason;
  refundId: string;
  refundStatus: RefundStatus;
  // Read off the refund the provider created; absent when no refund was
  // issued at all (the provider was unreachable, or the payment was an
  // uncaptured hold with nothing to return).
  amountMinor?: number;
  currency?: string;
  createdAtMs: number;
};

export type OrphanedPaymentReason =
  | "insufficient_stock"
  | "cart_repricing_failed"
  | "payment_verification_failed"
  | "order_write_failed";

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
  // Which provider took the money. Informational — refunds authenticate with
  // the store's *current* config, not this — but it's what tells support which
  // dashboard to open, and orders predating the Stripe split are all Razorpay.
  paymentProvider: PaymentProvider;
  // The verified payment this order was placed against: a Razorpay payment
  // (`pay_...`) or a Stripe PaymentIntent (`pi_...`). Empty for orders placed
  // through the test-mode payment-less path (the web preview, which can't run
  // a native checkout SDK) — never empty for a live store.
  //
  // Stored in Firestore under the legacy key `razorpayPaymentId`: renaming the
  // field would strand every existing order, and the value is only ever read
  // back through toOrder(), which maps it. Same for paymentOrderId below.
  paymentId: string;
  // The intent the payment was made against — a Razorpay order (`order_...`)
  // or the same Stripe PaymentIntent id as paymentId (Stripe has no separate
  // charge reference the client is trusted with). Created by POST /payments
  // one step before this order doc existed, so a provider-side record can be
  // traced back here directly. Empty on the payment-less path, and on orders
  // placed before this field was added.
  paymentOrderId: string;
  // The coupon this order was placed with — "" / 0 when none. `total` is
  // already net of couponDiscount; the pair is kept for the records
  // (dashboard, support), not for re-deriving the charge.
  couponCode: string;
  couponDiscount: number;
  // What delivery cost on this order, snapshotted at placement — the store's
  // policy can change afterwards, and an old order must keep showing what it
  // actually charged. Included in `total`, which is therefore
  // items − couponDiscount + deliveryFee. 0 on every order placed before the
  // field existed, which is correct: they were all charged free delivery.
  deliveryFee: number;
  // The shopper's rating of this *delivery* — how the order went, which is a
  // different question from what they thought of a product (that's a Review,
  // above). 0 = not rated. Lives on the order doc rather than its own
  // collection because it is strictly 1:1 with the order, and the dashboard
  // reads that doc already. Only a DELIVERED order can be rated: there is
  // nothing to judge until it arrives.
  rating: number;
  reviewText: string;
  // ISO, "" when unrated. Distinguishes "rated 0 stars" — impossible, the
  // range starts at 1 — from "never rated".
  reviewedAt: string;
  // The refund axis (see RefundStatus). NONE on every freshly-placed order;
  // set only when the order is cancelled and a refund is attempted.
  refundStatus: RefundStatus;
  // Razorpay's refund id (`rfnd_...`), set once a refund is issued — empty
  // otherwise. Kept for reconciliation/support lookups.
  refundId: string;
};
