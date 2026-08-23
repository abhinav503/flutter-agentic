// The pure half of the product schema — read-time upgrade of older docs,
// the summary fields derived from variants, and the pack-size label — with
// no Firestore import, so the client SDK mapper (products.ts), the Admin
// SDK routes (orders.ts, the v1 catalog API) and a tsx verifier all share
// one definition of what a product doc means.

import {
  EMPTY_RATING_BUCKETS,
  type Product,
  type ProductAttributes,
  type RatingBuckets,
  type SizeVariant,
  type UnitType,
  type Variant,
} from "./types";

export const UNIT_TYPES: readonly UnitType[] = ["g", "ml", "pcs"];

// Derived, not admin-entered — keeps price/originalPrice/discountPercentage
// from ever disagreeing with each other in Firestore.
export function computeDiscountPercentage(
  price: number,
  originalPrice: number,
): number {
  if (originalPrice <= 0 || price >= originalPrice) return 0;
  return Math.round(((originalPrice - price) / originalPrice) * 100);
}

// The price a pack size implies when it has no admin-entered one: the base
// price scaled linearly by size (₹100 per 500g → ₹200 for 1000g). Only
// used to upgrade docs that predate per-size pricing (sizeOptions without
// sizeVariants) — an explicit price is always preferred.
export function scalePriceToSize(
  basePrice: number,
  unitValue: number,
  sizeValue: number,
): number {
  if (unitValue <= 0 || sizeValue <= 0) return basePrice;
  return Math.round(((basePrice * sizeValue) / unitValue) * 100) / 100;
}

// "500 g", "1.5 kg", "750 ml", "2 L", "6 pcs" — the label an order line's
// weight and a pack-size variant's option value both print.
export function formatPackSize(value: number, unitType: UnitType): string {
  if (unitType === "pcs") return `${value.toFixed(0)} pcs`;
  const large = unitType === "g" ? "kg" : "L";
  if (value < 1000) return `${value.toFixed(0)} ${unitType}`;
  const rolled = value / 1000;
  return `${Number.isInteger(rolled) ? rolled.toFixed(0) : rolled.toFixed(1)} ${large}`;
}

// A variant's human label: its option values joined, or the product's own
// name for the implicit single unit.
export function variantLabel(variant: Pick<Variant, "options">): string {
  return variant.options.filter((o) => o.trim() !== "").join(" / ");
}

// Deterministic ids for variants upgraded from pack sizes, so a cart line
// that names one survives a re-read (a random id would change per load).
export function packSizeVariantId(value: number): string {
  return `size-${String(value).replace(/[^0-9a-zA-Z]/g, "_")}`;
}

function sizeVariantsToVariants(
  sizeVariants: SizeVariant[],
  unitType: UnitType,
  stock: number,
): Variant[] {
  return sizeVariants.map((v) => ({
    id: packSizeVariantId(v.value),
    externalId: "",
    sku: "",
    barcode: "",
    options: [formatPackSize(v.value, unitType)],
    price: v.price,
    originalPrice: v.originalPrice,
    // Pre-v2 stock is product-level; every pack shares it until a save
    // through the v2 form gives each its own count.
    stock,
    sellWhenOutOfStock: false,
    imageUrl: "",
    packSize: v.value,
  }));
}

export type ProductSummary = Pick<
  Product,
  | "price"
  | "originalPrice"
  | "discountPercentage"
  | "stock"
  | "sizeOptions"
  | "sizeVariants"
>;

// What a product's own price/stock mean once it has variants: the cheapest
// unit's price (what a card prints as "from") and the total stock. A simple
// product keeps what was entered. sizeOptions/sizeVariants are re-derived
// from the variants that still carry a packSize, so pre-v2 storefront
// builds keep their "Select QTY" row with the prices the cart charges.
export function deriveProductSummary(
  base: { price: number; originalPrice: number; stock: number },
  variants: Variant[],
): ProductSummary {
  const sized = variants
    .filter((v) => v.packSize > 0)
    .sort((a, b) => a.packSize - b.packSize);
  const sizeVariants: SizeVariant[] = sized.map((v) => ({
    value: v.packSize,
    price: v.price,
    originalPrice: v.originalPrice,
  }));
  if (variants.length === 0) {
    const originalPrice = base.originalPrice || base.price;
    return {
      price: base.price,
      originalPrice,
      discountPercentage: computeDiscountPercentage(base.price, originalPrice),
      stock: base.stock,
      sizeOptions: [],
      sizeVariants: [],
    };
  }
  const cheapest = variants.reduce((a, b) => (b.price < a.price ? b : a));
  const originalPrice = cheapest.originalPrice || cheapest.price;
  return {
    price: cheapest.price,
    originalPrice,
    discountPercentage: computeDiscountPercentage(cheapest.price, originalPrice),
    stock: variants.reduce((sum, v) => sum + Math.max(0, v.stock), 0),
    sizeOptions: sizeVariants.map((v) => v.value),
    sizeVariants,
  };
}

export function normaliseAttributes(raw: unknown): ProductAttributes {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) return {};
  const out: ProductAttributes = {};
  for (const [key, value] of Object.entries(raw as Record<string, unknown>)) {
    const k = key.trim();
    if (k === "" || value === null || value === undefined) continue;
    out[k] = String(value);
  }
  return out;
}

function normaliseVariant(raw: unknown, index: number): Variant | null {
  if (!raw || typeof raw !== "object") return null;
  const v = raw as Record<string, unknown>;
  const price = Number(v.price);
  if (!Number.isFinite(price) || price < 0) return null;
  const originalPrice = Number(v.originalPrice) || price;
  return {
    id: typeof v.id === "string" && v.id !== "" ? v.id : `v${index + 1}`,
    externalId: typeof v.externalId === "string" ? v.externalId : "",
    sku: typeof v.sku === "string" ? v.sku : "",
    barcode: typeof v.barcode === "string" ? v.barcode : "",
    options: Array.isArray(v.options) ? v.options.map(String) : [],
    price,
    originalPrice,
    stock: Math.max(0, Math.trunc(Number(v.stock) || 0)),
    sellWhenOutOfStock: v.sellWhenOutOfStock === true,
    imageUrl: typeof v.imageUrl === "string" ? v.imageUrl : "",
    packSize: Math.max(0, Number(v.packSize) || 0),
  };
}

export type ProductDocFields = Omit<Product, "id" | "createdAtMs">;

// The read-time upgrade. Three generations of product doc exist —
// sizeOptions-only, sizeVariants, and v2 `variants` — and every reader sees
// the v2 shape regardless; the doc itself is rewritten on its next save. A
// doc with no variants of any kind is a simple product.
export function upgradeProductData(
  data: Record<string, unknown>,
): ProductDocFields {
  const price = (data.price as number) ?? 0;
  const originalPrice = (data.originalPrice as number) ?? 0;
  const unitValue = (data.unitValue as number) ?? 0;
  const unitType = UNIT_TYPES.includes(data.unitType as UnitType)
    ? (data.unitType as UnitType)
    : "g";
  const stock = (data.stock as number) ?? 0;
  const imageUrl = (data.imageUrl as string) ?? "";
  const storedImages = Array.isArray(data.images)
    ? (data.images as unknown[]).map(String).filter((u) => u !== "")
    : [];
  const images =
    storedImages.length > 0
      ? storedImages
      : imageUrl
        ? [imageUrl]
        : [];

  const sizeOptions = (data.sizeOptions as number[]) ?? [];
  const legacySizeVariants: SizeVariant[] =
    (data.sizeVariants as SizeVariant[]) ??
    sizeOptions.map((value) => ({
      value,
      price: scalePriceToSize(price, unitValue, value),
      originalPrice: scalePriceToSize(originalPrice, unitValue, value),
    }));

  const hasV2 = Array.isArray(data.variants);
  const variants: Variant[] = hasV2
    ? (data.variants as unknown[])
        .map(normaliseVariant)
        .filter((v): v is Variant => v !== null)
    : sizeVariantsToVariants(legacySizeVariants, unitType, stock);
  const optionNames: string[] = hasV2
    ? Array.isArray(data.optionNames)
      ? (data.optionNames as unknown[]).map(String)
      : []
    : variants.length > 0
      ? ["Size"]
      : [];

  const attributes = normaliseAttributes(data.attributes);
  const prepTime = (data.prepTime as string) ?? "";

  // A v2 doc's summary was derived at write time, but re-deriving here costs
  // nothing and means a hand-edited doc can never show a price its variants
  // don't have. A legacy doc keeps its own stock (the packs share it).
  const summary = hasV2
    ? deriveProductSummary({ price, originalPrice, stock }, variants)
    : {
        price,
        originalPrice,
        discountPercentage: (data.discountPercentage as number) ?? 0,
        stock,
        sizeOptions: legacySizeVariants.map((v) => v.value),
        sizeVariants: legacySizeVariants,
      };

  return {
    name: (data.name as string) ?? "",
    imageUrl: images[0] ?? "",
    images,
    externalId: (data.externalId as string) ?? "",
    sku: (data.sku as string) ?? "",
    barcode: (data.barcode as string) ?? "",
    ...summary,
    unitValue,
    unitType,
    prepTime,
    description: (data.description as string) ?? "",
    categoryIds: (data.categoryIds as string[]) ?? [],
    brandId: (data.brandId as string) ?? "",
    optionNames,
    variants,
    attributes,
    stockPerVariant: hasV2 && variants.length > 0,
    isPopular: (data.isPopular as boolean) ?? false,
    // A product with no reviews yet (or one created before reviews existed)
    // carries no aggregate fields — zeros here, and every surface renders
    // "no ratings" from count 0 rather than a misleading 0.0 stars.
    ratingAverage: (data.ratingAverage as number) ?? 0,
    reviewCount: (data.reviewCount as number) ?? 0,
    ratingBuckets: (data.ratingBuckets as RatingBuckets) ?? EMPTY_RATING_BUCKETS,
  };
}

export type ResolvedLinePricing = {
  price: number;
  originalPrice: number;
  // The pack size actually sold — the variant's packSize when it has one,
  // the product's own unitValue otherwise. What an order line's weight
  // label formats.
  packSize: number;
  // The variant the line resolved to; null for a simple product's own unit.
  variant: Variant | null;
};

export type LineSelection = {
  variantId?: string;
  // Pre-v2 selector: a pack size in the product's unitType. Resolves to the
  // variant carrying that packSize.
  sizeValue?: number;
};

// The single price authority for a cart/order line — the cart join, the
// payment intent and the order transaction all resolve a (product,
// selection) through here, so what the shopper sees, is charged and is
// recorded can never disagree. No selection = the product's own unit, or on
// a v2 product the cheapest variant (what the card advertised). A selection that names nothing (the admin removed the
// variant after it was carted) returns null — the caller refuses the line
// rather than guessing a price.
export function resolveLine(
  product: Pick<
    Product,
    "price" | "originalPrice" | "unitValue" | "variants" | "stockPerVariant"
  >,
  selection: LineSelection = {},
): ResolvedLinePricing | null {
  const { variantId, sizeValue } = selection;
  if (variantId) {
    const variant = product.variants.find((v) => v.id === variantId);
    return variant ? fromVariant(variant, product.unitValue) : null;
  }
  if (sizeValue && sizeValue > 0) {
    const variant = product.variants.find((v) => v.packSize === sizeValue);
    return variant ? fromVariant(variant, product.unitValue) : null;
  }
  // No selection: on a v2 product the cheapest variant (the price the card
  // showed); on a legacy one the product's own pack, which its size chips
  // need not include.
  if (product.stockPerVariant && product.variants.length > 0) {
    const cheapest = product.variants.reduce((a, b) =>
      b.price < a.price ? b : a,
    );
    return fromVariant(cheapest, product.unitValue);
  }
  return {
    price: product.price,
    originalPrice: product.originalPrice,
    packSize: product.unitValue,
    variant: null,
  };
}

function fromVariant(variant: Variant, unitValue: number): ResolvedLinePricing {
  return {
    price: variant.price,
    originalPrice: variant.originalPrice,
    packSize: variant.packSize > 0 ? variant.packSize : unitValue,
    variant,
  };
}

// --- stock -----------------------------------------------------------------

export type StockRequest = {
  // null = the product's own unit (a simple product, or a legacy doc whose
  // packs share one count).
  variantId: string | null;
  quantity: number;
};

export type StockRefusal = {
  variantId: string | null;
  available: number;
};

// The fields a transaction writes to move stock by `direction` (-1 to sell,
// +1 to restock) for one product doc, or the first line it can't honour.
// Per-variant on a v2 doc (with the product's own stock re-summed, so grids
// stay right), product-level on a legacy one — whose packs were always a
// view over one count. Callers group requests per product first: a second
// update on the same doc inside a transaction overwrites the first.
export function applyStock(
  data: Record<string, unknown>,
  requests: StockRequest[],
  direction: -1 | 1,
): { update: Record<string, unknown> } | { refusal: StockRefusal } {
  const isV2 = Array.isArray(data.variants);
  if (!isV2) {
    const stock = (data.stock as number) ?? 0;
    const total = requests.reduce((sum, r) => sum + r.quantity, 0);
    if (direction < 0 && stock < total) {
      return { refusal: { variantId: null, available: stock } };
    }
    return { update: { stock: stock + direction * total } };
  }

  const upgraded = upgradeProductData(data);
  const variants = upgraded.variants.map((v) => ({ ...v }));
  if (variants.length === 0) {
    // A v2 doc with no variants is a simple product; its stock is its own.
    const stock = (data.stock as number) ?? 0;
    const total = requests.reduce((sum, r) => sum + r.quantity, 0);
    if (direction < 0 && stock < total) {
      return { refusal: { variantId: null, available: stock } };
    }
    return { update: { stock: stock + direction * total } };
  }

  const byVariant = new Map<string, number>();
  for (const r of requests) {
    if (!r.variantId) return { refusal: { variantId: null, available: 0 } };
    byVariant.set(r.variantId, (byVariant.get(r.variantId) ?? 0) + r.quantity);
  }
  for (const [variantId, quantity] of byVariant) {
    const variant = variants.find((v) => v.id === variantId);
    if (!variant) return { refusal: { variantId, available: 0 } };
    if (direction < 0 && !variant.sellWhenOutOfStock && variant.stock < quantity) {
      return { refusal: { variantId, available: variant.stock } };
    }
    variant.stock = Math.max(0, variant.stock + direction * quantity);
  }
  const summary = deriveProductSummary(
    { price: upgraded.price, originalPrice: upgraded.originalPrice, stock: 0 },
    variants,
  );
  return { update: { variants, stock: summary.stock } };
}

// What a line can still buy: the variant's own count on a v2 product, the
// product's otherwise. null = unlimited (sellWhenOutOfStock).
export function availableFor(
  product: Pick<Product, "stock" | "stockPerVariant">,
  variant: Variant | null,
): number | null {
  if (!variant || !product.stockPerVariant) return product.stock;
  return variant.sellWhenOutOfStock ? null : variant.stock;
}
