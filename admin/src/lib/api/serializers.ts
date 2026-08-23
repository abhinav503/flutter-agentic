import type {
  Address,
  Banner,
  Brand,
  Category,
  Order,
  Product,
  RatingBuckets,
  Review,
  SizeVariant,
  Store,
  Variant,
} from "@/lib/types";
import type { FeedNotification } from "@/lib/notifications-feed";
import { computeDiscountPercentage } from "@/lib/products";

// Shapes match gravia's existing mock JSON / *Model.fromJson() wire format
// exactly (apps/ecommerce/gravia/lib/feature/*/data/models/) — snake_case,
// `image` not `imageUrl` — so a future gravia data source pointed at this
// API needs zero model changes, only a data-source-impl swap.

export function serializeCategory(c: Category) {
  // parent_id "" = top level. Extra key pre-tree clients ignore.
  return { id: c.id, name: c.name, image: c.imageUrl, parent_id: c.parentId };
}

// Matches AddressModel.fromJson() in gravia (feature/address/data/models/).
export function serializeAddress(a: Address) {
  return {
    id: a.id,
    name: a.name,
    phone: a.phone,
    address_line1: a.addressLine1,
    address_line2: a.addressLine2,
    landmark: a.landmark,
    city: a.city,
    // `?? defaults`: this serializer is also fed order delivery_address
    // snapshots, and docs written before the location feature carry none of
    // these three fields.
    state: a.state ?? "",
    country: a.country,
    postal_code: a.postalCode,
    tag: a.tag,
    is_default: a.isDefault,
    latitude: a.latitude ?? null,
    longitude: a.longitude ?? null,
  };
}

// isFavourite defaults false: it's per-shopper state, not a catalog
// property, and most callers of this serializer (home, categories, search,
// product details) don't resolve it per-uid — gravia cross-references its
// own FavouritesCubit instead of trusting this field there. Only the
// favourites endpoint itself passes a real value, since every item it
// returns is a favourite by definition.
export function serializeProduct(p: Product, isFavourite = false) {
  return {
    id: p.id,
    name: p.name,
    image: p.imageUrl,
    price: p.price,
    original_price: p.originalPrice,
    discount_percentage: p.discountPercentage,
    unit_value: p.unitValue,
    unit_type: p.unitType,
    prep_time: p.prepTime,
    // "" for unbranded. Extra key existing *Model.fromJson readers ignore;
    // a storefront that wants the name resolves it against GET /brands
    // (id-only, same rationale as Banner.targetId).
    brand_id: p.brandId,
    is_favourite: isFavourite,
    // Every card can print a rating without a second call — the aggregates
    // ride on the product doc the grid already read. review_count 0 means
    // "unrated": clients must render that as such, not as 0.0 stars.
    rating_average: p.ratingAverage,
    review_count: p.reviewCount,
    // The same number the order transaction enforces (lib/orders.ts), so the
    // storefront can refuse a sale before the shopper reaches payment
    // instead of after. Sent on every product payload — a card, a grid cell
    // and a cart line all need it, and it rides on the doc they already read.
    stock: p.stock,
    // v2 (general product model). Every key below is additive — a storefront
    // build that predates it keeps reading image/price/stock above, which
    // are derived from the same variants.
    images: p.images,
    sku: p.sku,
    barcode: p.barcode,
    external_id: p.externalId,
    option_names: p.optionNames,
    variants: p.variants.map(serializeVariant),
    attributes: p.attributes,
  };
}

export function serializeVariant(v: Variant) {
  return {
    id: v.id,
    sku: v.sku,
    barcode: v.barcode,
    options: v.options,
    price: v.price,
    original_price: v.originalPrice,
    discount_percentage: computeDiscountPercentage(v.price, v.originalPrice),
    stock: v.stock,
    sell_when_out_of_stock: v.sellWhenOutOfStock,
    image: v.imageUrl,
    pack_size: v.packSize,
  };
}

// One shopper's product review. `uid` travels because it's the review's
// identity (it's also the doc id) — a client needs it to tell its own
// review apart from everyone else's, which is what turns the write CTA into
// "Edit your review". No email or other profile field is exposed.
export function serializeReview(r: Review) {
  return {
    uid: r.uid,
    product_id: r.productId,
    rating: r.rating,
    text: r.text,
    user_name: r.userName,
    user_avatar_url: r.userAvatarUrl,
    verified_purchase: r.verifiedPurchase,
    created_at: r.createdAt,
    updated_at: r.updatedAt,
  };
}

// An order the shopper rated, for the dashboard's order-review list. Not a
// public review: this is private feedback about a delivery, so it carries
// the order's own identifying details (id, date, total) rather than a
// product's, and the customer is named from the delivery address the order
// already snapshotted — no profile lookup per row.
export function serializeOrderReview(o: Order) {
  return {
    order_id: o.id,
    rating: o.rating,
    text: o.reviewText,
    reviewed_at: o.reviewedAt,
    placed_at: o.placedAt,
    total: o.total,
    customer_name: o.deliveryAddress?.name ?? "",
  };
}

// The rating summary a product page renders above its review list — the
// average, the total, and the per-star histogram. Read off the product doc's
// denormalized aggregates, never recounted per request.
export function serializeRatingSummary(p: Product) {
  return {
    average: p.ratingAverage,
    count: p.reviewCount,
    // Fixed 1→5 order so a client reads it positionally without sorting
    // string map keys (Firestore hands them back as strings).
    buckets: [1, 2, 3, 4, 5].map(
      (star) => p.ratingBuckets[star as keyof RatingBuckets] ?? 0,
    ),
  };
}

// Matches serializeCategory's shape (`image` not `logoUrl`) so a future
// BrandModel.fromJson can share the id/name/image convention.
export function serializeBrand(b: Brand) {
  return { id: b.id, name: b.name, image: b.logoUrl };
}

// Per-size pricing for the product page's "Select QTY" row — discount is
// derived through the same function as Product's, never stored.
export function serializeSizeVariant(v: SizeVariant) {
  return {
    value: v.value,
    price: v.price,
    original_price: v.originalPrice,
    discount_percentage: computeDiscountPercentage(v.price, v.originalPrice),
  };
}

// Matches OrderModel.fromJson() in gravia (data/models/order_model.dart)
// exactly — status/placed_at/delivery_otp/items[] with product_name/weight/
// image/price/quantity — so a future OrdersRemoteDataSourceImpl swap needs
// no model changes, same intent as serializeProduct above. `status` is
// already one of gravia's OrderStatusParse wire strings, except PENDING,
// which that parser doesn't recognize yet and falls back to `inProcess`
// for — a safe degrade, not a crash, until gravia's enum grows a case for it.
export function serializeOrder(o: Order) {
  return {
    id: o.id,
    status: o.status,
    // Shopper-facing refund state for a cancelled order. refundId is
    // reconciliation-only (support/dashboard) and isn't sent to the client.
    refund_status: o.refundStatus,
    placed_at: o.placedAt,
    // The order's timeline, oldest first — what a Track Order screen dates
    // its steps from. Already flat and snake-free, so it passes through as-is.
    status_history: o.statusHistory,
    delivery_otp: o.deliveryOtp,
    // The shopper's own payment reference, shown on Track Order as the id
    // they'd quote to support. Empty on the test-mode payment-less path.
    // refundId stays server-side — it identifies a reconciliation record the
    // shopper can't act on, and refund_status already tells them where their
    // money is.
    payment_id: o.paymentId,
    // "" / 0 when the order was placed without one; total is already net of
    // the discount.
    coupon_code: o.couponCode,
    coupon_discount: o.couponDiscount,
    // What delivery cost on this order, already included in `total`. Sent
    // even when 0 so the storefront's totals panel can print a "Free" line
    // it knows to be true, rather than assuming it.
    delivery_fee: o.deliveryFee,
    // The shopper's rating of this delivery — 0 when unrated, which is every
    // order that hasn't been delivered yet. Sent back to the shopper so
    // their own order card can show what they gave and offer to change it.
    rating: o.rating,
    review_text: o.reviewText,
    reviewed_at: o.reviewedAt,
    total: o.total,
    // Reuses serializeAddress so the order's snapshot round-trips through
    // gravia's existing AddressModel.fromJson (feature/address) unchanged.
    delivery_address: serializeAddress(o.deliveryAddress),
    items: o.items.map((item) => ({
      product_name: item.productName,
      weight: item.weight,
      // "" on pre-variant orders and simple products' lines.
      variant_id: item.variantId,
      variant_label: item.variantLabel,
      image: item.image,
      price: item.price,
      quantity: item.quantity,
    })),
  };
}

// Matches StoreModel.fromJson() in cordelia (feature/home/data/models/) —
// snake_case like every other serializer in this file, `image` not
// `imageUrl` for consistency with serializeCategory/serializeProduct.
export function serializeStore(s: Store) {
  return {
    id: s.id,
    name: s.name,
    image: s.logoUrl,
    description: s.description,
    template_id: s.templateId,
    language: s.language,
    currency: s.currency,
    // The store's delivery policy, so a storefront can print the fee in its
    // cart totals before checkout is ever reached. Display only — the server
    // recomputes the fee from the same doc when it charges, so a client that
    // ignores or misreads this can't change what a shopper pays. `areas` is
    // public for the same reason a shop's delivery radius is: it tells a
    // shopper whether ordering is possible at all.
    delivery: {
      fee: s.delivery.fee,
      free_above: s.delivery.freeAbove,
      areas: s.delivery.areas,
    },
    // How a shopper reaches this store when an order goes wrong. Public for
    // the same reason a shop's phone number on its door is: it is the point
    // of publishing it. Any field may be empty — the app falls back to the
    // platform address, so an unfilled contact is a quieter channel, never a
    // dead end.
    support: {
      email: s.support.email,
      phone: s.support.phone,
      hours: s.support.hours,
    },
    // Discovery renders a "Not published yet" marker on the owner's own
    // in-progress stores and filters on it — the route has already decided
    // *whether* the caller may see this store, so this is presentation
    // only, never the access check.
    status: s.status,
  };
}

// Matches BannerModel.fromJson() in cordelia (feature/storefront/home/
// data/models/) — snake_case, `image` not `imageUrl`, same as the
// serializers above. isActive/sortOrder aren't sent: the route already
// filtered and ordered by them, so they're admin-side concerns only.
export function serializeBanner(b: Banner) {
  return {
    id: b.id,
    image: b.imageUrl,
    title: b.title,
    subtitle: b.subtitle,
    target_type: b.targetType,
    target_id: b.targetId,
    background_color: b.backgroundColor,
  };
}

export function groupCategories(categories: Category[]) {
  const groups = new Map<string, Category[]>();
  for (const category of categories) {
    const key = category.groupName || "Uncategorized";
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key)!.push(category);
  }
  return Array.from(groups.entries()).map(([name, categoriesInGroup]) => ({
    name,
    categories: categoriesInGroup.map(serializeCategory),
  }));
}

// Deliberately flat and undated-in-words: no "Today"/"Yesterday" section
// titles are composed here. cordelia groups the feed itself so the headings
// come from its own string table — a server-authored heading would print
// English into a Hindi, German, French, Spanish or Italian storefront, which
// is the exact trap docs/how-to/add-language-pack.md warns about.
export function serializeNotification(n: FeedNotification) {
  return {
    id: n.id,
    kind: n.kind,
    title: n.title,
    message: n.message,
    image_url: n.imageUrl,
    source: n.source,
    created_at_ms: n.createdAtMs,
    is_read: n.isRead,
  };
}
