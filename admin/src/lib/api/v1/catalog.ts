import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";
import {
  deriveProductSummary,
  normaliseAttributes,
  UNIT_TYPES,
  upgradeProductData,
} from "@/lib/product-model";
import { findRestrictedTerms, restrictedProductMessage } from "@/lib/restricted-products";
import {
  MAX_OPTION_AXES,
  type Banner,
  type BannerTargetType,
  type Brand,
  type Category,
  type Coupon,
  type CouponScope,
  type CouponType,
  type Product,
  type UnitType,
  type Variant,
} from "@/lib/types";

// The v1 catalog write API — what the console, the CLI, the MCP server and
// any merchant script all go through. One validator per entity, the same
// for a single POST and a 2,000-row PUT, and the same rules the console's
// forms enforce (restricted terms, variant shape, targets that exist), so
// no caller can store what the form would refuse.
//
// Wire shape is the snake_case the read routes already serialize, so a
// client can GET a record, edit it, and PUT it back. Every write is an
// upsert resolved by `id`, else `external_id`, else the record's name/code
// — the key an import from another system can hold without ever having
// seen ours. Updates merge field-by-field over the stored doc (a body that
// omits `stock` leaves stock alone), and never touch the fields the server
// owns: rating aggregates, usedCount, createdAt.

export const CATALOG_ENTITIES = [
  "products",
  "categories",
  "brands",
  "coupons",
  "banners",
] as const;
export type CatalogEntity = (typeof CATALOG_ENTITIES)[number];

export const MAX_UPSERT_ROWS = 2000;
const BATCH_LIMIT = 500;
const MAX_IMAGES = 10;
const MAX_VARIANTS = 100;
const MAX_ATTRIBUTES = 50;
const MAX_TEXT = 2000;
const MAX_NAME = 200;

export type WriteResult =
  | { index: number; id: string; action: "created" | "updated" }
  | { index: number; id: string | null; action: "error"; errors: string[] };

type Raw = Record<string, unknown>;

// --- small parsers ----------------------------------------------------------

function str(v: unknown, max = MAX_TEXT): string | null {
  if (v === undefined || v === null) return "";
  if (typeof v !== "string") return null;
  return v.trim().slice(0, max);
}
function num(v: unknown): number | null | undefined {
  if (v === undefined || v === null || v === "") return undefined;
  const n = typeof v === "number" ? v : Number(String(v).replace(/[^0-9.-]/g, ""));
  return Number.isFinite(n) ? n : null;
}
function bool(v: unknown): boolean | null | undefined {
  if (v === undefined || v === null || v === "") return undefined;
  if (typeof v === "boolean") return v;
  const s = String(v).trim().toLowerCase();
  if (["true", "yes", "y", "1"].includes(s)) return true;
  if (["false", "no", "n", "0"].includes(s)) return false;
  return null;
}
function strList(v: unknown): string[] | null | undefined {
  if (v === undefined || v === null) return undefined;
  if (typeof v === "string") return v.split("|").map((s) => s.trim()).filter(Boolean);
  if (!Array.isArray(v)) return null;
  return v.map((s) => String(s).trim()).filter(Boolean);
}
function isHttpsUrl(u: string): boolean {
  return /^https:\/\/\S+$/.test(u);
}
function isoDate(v: unknown): string | null | undefined {
  if (v === undefined || v === null || v === "") return undefined;
  const t = Date.parse(String(v));
  return Number.isNaN(t) ? null : new Date(t).toISOString();
}

// --- the store's current catalog, read once per request ---------------------

export type CatalogSnapshot = {
  products: Map<string, Product>;
  categories: Map<string, Category>;
  brands: Map<string, Brand>;
  coupons: Map<string, Coupon>;
  banners: Map<string, Banner>;
};

function col(storeId: string, entity: CatalogEntity) {
  return adminDb.collection("stores").doc(storeId).collection(entity);
}

export async function loadCatalog(storeId: string): Promise<CatalogSnapshot> {
  const [p, c, b, k, n] = await Promise.all(
    CATALOG_ENTITIES.map((e) => col(storeId, e).get()),
  );
  const products = new Map<string, Product>();
  for (const d of p.docs) {
    products.set(d.id, { id: d.id, ...upgradeProductData(d.data()), createdAtMs: 0 });
  }
  const categories = new Map<string, Category>();
  for (const d of c.docs) {
    const x = d.data();
    categories.set(d.id, {
      id: d.id,
      name: (x.name as string) ?? "",
      imageUrl: (x.imageUrl as string) ?? "",
      groupName: (x.groupName as string) ?? "Uncategorized",
      parentId: (x.parentId as string) ?? "",
      externalId: (x.externalId as string) ?? "",
      createdAtMs: 0,
    });
  }
  const brands = new Map<string, Brand>();
  for (const d of b.docs) {
    const x = d.data();
    brands.set(d.id, {
      id: d.id,
      name: (x.name as string) ?? "",
      logoUrl: (x.logoUrl as string) ?? "",
      externalId: (x.externalId as string) ?? "",
      createdAtMs: 0,
    });
  }
  const coupons = new Map<string, Coupon>();
  for (const d of k.docs) {
    const x = d.data();
    coupons.set(d.id, {
      id: d.id,
      code: (x.code as string) ?? "",
      type: (x.type as CouponType) ?? "percent",
      value: (x.value as number) ?? 0,
      scope: (x.scope as CouponScope) ?? "store",
      targetIds: (x.targetIds as string[]) ?? [],
      minOrderValue: (x.minOrderValue as number) ?? 0,
      maxDiscount: (x.maxDiscount as number) ?? 0,
      validFrom: (x.validFrom as string) ?? "",
      validUntil: (x.validUntil as string) ?? "",
      usageLimit: (x.usageLimit as number) ?? 0,
      perUserLimit: (x.perUserLimit as number) ?? 0,
      usedCount: (x.usedCount as number) ?? 0,
      isActive: (x.isActive as boolean) ?? true,
      createdAtMs: 0,
    });
  }
  const banners = new Map<string, Banner>();
  for (const d of n.docs) {
    const x = d.data();
    banners.set(d.id, {
      id: d.id,
      imageUrl: (x.imageUrl as string) ?? "",
      title: (x.title as string) ?? "",
      subtitle: (x.subtitle as string) ?? "",
      targetType: (x.targetType as BannerTargetType) ?? "none",
      targetId: (x.targetId as string) ?? "",
      sortOrder: (x.sortOrder as number) ?? 0,
      isActive: (x.isActive as boolean) ?? true,
      backgroundColor: (x.backgroundColor as string) ?? "",
    });
  }
  return { products, categories, brands, coupons, banners };
}

const norm = (s: string) => s.trim().toLowerCase();

// id → external_id → name/code. A row that names an id that doesn't exist
// is an error, never a create with a chosen id.
function resolveExisting<T extends { id: string }>(
  raw: Raw,
  existing: Map<string, T>,
  nameOf: (t: T) => string,
  externalIdOf: (t: T) => string,
  nameKey: string,
): { found: T | null } | { error: string } {
  const id = str(raw.id);
  if (id) {
    const found = existing.get(id);
    return found ? { found } : { error: `No record with id ${id} in this store.` };
  }
  const externalId = str(raw.external_id);
  if (externalId) {
    for (const t of existing.values()) {
      if (externalIdOf(t) === externalId) return { found: t };
    }
  }
  const name = str(raw[nameKey]);
  if (name) {
    for (const t of existing.values()) {
      if (norm(nameOf(t)) === norm(name)) return { found: t };
    }
  }
  return { found: null };
}

// Resolves a list of category references — ids or names — against the
// store. Unknown ones are errors, not silent creations: a typo would
// otherwise quietly mint "Beverges" and split the catalog in two.
function resolveCategoryRefs(
  refs: string[],
  catalog: CatalogSnapshot,
): { ids: string[] } | { error: string } {
  const ids: string[] = [];
  const unknown: string[] = [];
  for (const ref of refs) {
    if (catalog.categories.has(ref)) {
      ids.push(ref);
      continue;
    }
    const byName = [...catalog.categories.values()].find((c) => norm(c.name) === norm(ref));
    if (byName) ids.push(byName.id);
    else unknown.push(ref);
  }
  if (unknown.length) {
    return {
      error: `Unknown categor${unknown.length > 1 ? "ies" : "y"}: ${unknown.join(", ")}. Create ${unknown.length > 1 ? "them" : "it"} first.`,
    };
  }
  return { ids: [...new Set(ids)] };
}

// --- products -----------------------------------------------------------------

function parseVariant(raw: unknown, index: number, optionNames: string[]): Variant | string {
  if (!raw || typeof raw !== "object") return `variants[${index}] must be an object.`;
  const v = raw as Raw;
  const price = num(v.price);
  if (price === undefined || price === null || price <= 0) {
    return `variants[${index}].price must be a number greater than 0.`;
  }
  const originalPrice = num(v.original_price);
  if (originalPrice === null) return `variants[${index}].original_price must be a number.`;
  const stock = num(v.stock);
  if (stock === null || (stock !== undefined && (stock < 0 || !Number.isInteger(stock)))) {
    return `variants[${index}].stock must be a whole number, 0 or more.`;
  }
  const options = strList(v.options);
  if (options === null || options === undefined || options.length !== optionNames.length) {
    return `variants[${index}].options must list one value per option (${optionNames.join(", ")}).`;
  }
  const sell = bool(v.sell_when_out_of_stock);
  if (sell === null) return `variants[${index}].sell_when_out_of_stock must be true or false.`;
  const image = str(v.image);
  if (image === null || (image && !isHttpsUrl(image))) {
    return `variants[${index}].image must be a public https URL.`;
  }
  const packSize = num(v.pack_size);
  if (packSize === null || (packSize !== undefined && packSize < 0)) {
    return `variants[${index}].pack_size must be a number, 0 or more.`;
  }
  const id = str(v.id) || `v${index + 1}`;
  return {
    id: id!,
    externalId: str(v.external_id) ?? "",
    sku: str(v.sku) ?? "",
    barcode: str(v.barcode) ?? "",
    options,
    price,
    originalPrice: originalPrice && originalPrice >= price ? originalPrice : price,
    stock: stock ?? 0,
    sellWhenOutOfStock: sell ?? false,
    imageUrl: image,
    packSize: packSize ?? 0,
  };
}

export function parseProduct(
  raw: Raw,
  existing: Product | null,
  catalog: CatalogSnapshot,
): { data: Raw } | { errors: string[] } {
  const errors: string[] = [];
  const e = existing;

  const name = str(raw.name, MAX_NAME);
  if (name === null) errors.push("name must be a string.");
  const finalName = name || e?.name || "";
  if (!finalName) errors.push("name is required.");

  const description = str(raw.description);
  if (description === null) errors.push("description must be a string.");
  const finalDescription = description || (raw.description === undefined ? (e?.description ?? "") : "");

  const restricted = findRestrictedTerms(finalName, finalDescription);
  if (restricted.length) errors.push(restrictedProductMessage(restricted));

  let images = strList(raw.images);
  if (images === null) errors.push("images must be an array of https URLs.");
  if (images === undefined) {
    const single = str(raw.image);
    if (single) images = [single];
  }
  const finalImages = images ?? e?.images ?? [];
  if (finalImages.length > MAX_IMAGES) errors.push(`At most ${MAX_IMAGES} images.`);
  if (finalImages.some((u) => !isHttpsUrl(u))) errors.push("Every image must be a public https URL.");

  const optionNames = strList(raw.option_names);
  if (optionNames === null) errors.push("option_names must be an array of strings.");
  const finalOptionNames = optionNames ?? e?.optionNames ?? [];
  if (finalOptionNames.length > MAX_OPTION_AXES) {
    errors.push(`At most ${MAX_OPTION_AXES} options (got ${finalOptionNames.length}).`);
  }

  let finalVariants: Variant[] = e?.variants ?? [];
  if (raw.variants !== undefined) {
    if (!Array.isArray(raw.variants)) errors.push("variants must be an array.");
    else if (raw.variants.length > MAX_VARIANTS) errors.push(`At most ${MAX_VARIANTS} variants.`);
    else {
      finalVariants = [];
      raw.variants.forEach((v, i) => {
        const parsed = parseVariant(v, i, finalOptionNames);
        if (typeof parsed === "string") errors.push(parsed);
        else finalVariants.push(parsed);
      });
    }
  }
  if (finalOptionNames.length > 0) {
    if (finalOptionNames.some((n) => n === "")) errors.push("Every option needs a name.");
    if (finalVariants.length === 0) errors.push("A product with options needs at least one variant.");
    const labels = new Set<string>();
    for (const v of finalVariants) {
      if (v.options.some((o) => o === "")) errors.push("Every variant needs a value for each option.");
      const label = v.options.map(norm).join(" ");
      if (labels.has(label)) errors.push(`Duplicate variant: ${v.options.join(" / ")}.`);
      labels.add(label);
    }
    const ids = new Set<string>();
    for (const v of finalVariants) {
      if (ids.has(v.id)) errors.push(`Duplicate variant id: ${v.id}.`);
      ids.add(v.id);
    }
  } else if (finalVariants.length > 0) {
    errors.push("variants given without option_names — name the option(s) they vary by.");
  }

  const price = num(raw.price);
  if (price === null) errors.push("price must be a number.");
  const finalPrice = price ?? e?.price ?? 0;
  if (finalOptionNames.length === 0 && finalPrice <= 0) errors.push("price must be greater than 0.");

  const originalPrice = num(raw.original_price);
  if (originalPrice === null) errors.push("original_price must be a number.");
  let finalOriginal = originalPrice ?? (price !== undefined ? finalPrice : (e?.originalPrice ?? finalPrice));
  if (finalOriginal < finalPrice) {
    if (originalPrice !== undefined) errors.push("original_price is below price — a discount cannot be negative.");
    finalOriginal = finalPrice;
  }

  const stock = num(raw.stock);
  if (stock === null || (stock !== undefined && (stock < 0 || !Number.isInteger(stock)))) {
    errors.push("stock must be a whole number, 0 or more.");
  }
  const finalStock = stock ?? e?.stock ?? 0;

  const unitValue = num(raw.unit_value);
  if (unitValue === null || (unitValue !== undefined && unitValue < 0)) {
    errors.push("unit_value must be a number, 0 or more.");
  }
  const rawUnitType = str(raw.unit_type);
  const unitType = rawUnitType ? (rawUnitType.toLowerCase() as UnitType) : undefined;
  if (unitType && !UNIT_TYPES.includes(unitType)) {
    errors.push(`unit_type must be one of ${UNIT_TYPES.join(", ")}.`);
  }

  let categoryIds = e?.categoryIds ?? [];
  const categoryRefs = strList(raw.category_ids) ?? strList(raw.categories);
  if (categoryRefs === null) errors.push("categories must be an array of ids or names.");
  else if (categoryRefs !== undefined) {
    const resolved = resolveCategoryRefs(categoryRefs, catalog);
    if ("error" in resolved) errors.push(resolved.error);
    else categoryIds = resolved.ids;
  }
  if (categoryIds.length === 0) errors.push("At least one category is required.");

  let brandId = e?.brandId ?? "";
  const brandRef = str(raw.brand_id) || str(raw.brand);
  if (raw.brand_id !== undefined || raw.brand !== undefined) {
    if (!brandRef) brandId = "";
    else if (catalog.brands.has(brandRef)) brandId = brandRef;
    else {
      const byName = [...catalog.brands.values()].find((b) => norm(b.name) === norm(brandRef));
      if (byName) brandId = byName.id;
      else errors.push(`Unknown brand: ${brandRef}. Create it first.`);
    }
  }

  const isPopular = bool(raw.is_popular);
  if (isPopular === null) errors.push("is_popular must be true or false.");

  let attributes = e?.attributes ?? {};
  if (raw.attributes !== undefined) {
    if (!raw.attributes || typeof raw.attributes !== "object" || Array.isArray(raw.attributes)) {
      errors.push("attributes must be an object of string values.");
    } else {
      attributes = normaliseAttributes(raw.attributes);
      if (Object.keys(attributes).length > MAX_ATTRIBUTES) errors.push(`At most ${MAX_ATTRIBUTES} attributes.`);
    }
  }

  if (errors.length) return { errors };

  const hasVariants = finalOptionNames.length > 0;
  const summary = deriveProductSummary(
    { price: finalPrice, originalPrice: finalOriginal, stock: finalStock },
    hasVariants ? finalVariants : [],
  );
  return {
    data: {
      name: finalName,
      description: finalDescription,
      images: finalImages,
      imageUrl: finalImages[0] ?? "",
      externalId: str(raw.external_id) || e?.externalId || "",
      sku: hasVariants ? "" : (str(raw.sku) ?? e?.sku ?? ""),
      barcode: hasVariants ? "" : (str(raw.barcode) ?? e?.barcode ?? ""),
      ...summary,
      unitValue: unitValue ?? e?.unitValue ?? 0,
      unitType: unitType ?? e?.unitType ?? "g",
      prepTime: str(raw.prep_time) || e?.prepTime || "",
      categoryIds,
      brandId,
      optionNames: finalOptionNames,
      variants: hasVariants ? finalVariants : [],
      attributes,
      isPopular: isPopular ?? e?.isPopular ?? false,
    },
  };
}

// --- categories -----------------------------------------------------------------

export function parseCategory(
  raw: Raw,
  existing: Category | null,
  catalog: CatalogSnapshot,
): { data: Raw } | { errors: string[] } {
  const errors: string[] = [];
  const name = str(raw.name, MAX_NAME);
  if (name === null) errors.push("name must be a string.");
  const finalName = name || existing?.name || "";
  if (!finalName) errors.push("name is required.");
  const image = str(raw.image);
  if (image === null || (image && !isHttpsUrl(image))) errors.push("image must be a public https URL.");

  let parentId = existing?.parentId ?? "";
  const parentRef = str(raw.parent_id) || str(raw.parent);
  if (raw.parent_id !== undefined || raw.parent !== undefined) {
    if (!parentRef) parentId = "";
    else {
      const parent =
        catalog.categories.get(parentRef) ??
        [...catalog.categories.values()].find((c) => norm(c.name) === norm(parentRef));
      if (!parent) errors.push(`Unknown parent category: ${parentRef}.`);
      else {
        // No cycles: walk up from the proposed parent; meeting ourselves is
        // a loop the storefront would never finish rendering.
        let cursor: Category | undefined = parent;
        const seen = new Set<string>();
        while (cursor && !seen.has(cursor.id)) {
          if (existing && cursor.id === existing.id) {
            errors.push("A category can't sit under itself or one of its own descendants.");
            break;
          }
          seen.add(cursor.id);
          cursor = cursor.parentId ? catalog.categories.get(cursor.parentId) : undefined;
        }
        parentId = parent.id;
      }
    }
  }
  if (errors.length) return { errors };
  return {
    data: {
      name: finalName,
      imageUrl: image || existing?.imageUrl || "",
      groupName: str(raw.group_name) || existing?.groupName || "Uncategorized",
      parentId,
      externalId: str(raw.external_id) || existing?.externalId || "",
    },
  };
}

// --- brands -----------------------------------------------------------------------

export function parseBrand(
  raw: Raw,
  existing: Brand | null,
): { data: Raw } | { errors: string[] } {
  const errors: string[] = [];
  const name = str(raw.name, MAX_NAME);
  if (name === null) errors.push("name must be a string.");
  const finalName = name || existing?.name || "";
  if (!finalName) errors.push("name is required.");
  const image = str(raw.image);
  if (image === null || (image && !isHttpsUrl(image))) errors.push("image must be a public https URL.");
  if (errors.length) return { errors };
  return {
    data: {
      name: finalName,
      logoUrl: image || existing?.logoUrl || "",
      externalId: str(raw.external_id) || existing?.externalId || "",
    },
  };
}

// --- coupons ------------------------------------------------------------------------

const COUPON_TYPES: CouponType[] = ["percent", "flat"];
const COUPON_SCOPES: CouponScope[] = ["store", "category", "product"];

export function parseCoupon(
  raw: Raw,
  existing: Coupon | null,
  catalog: CatalogSnapshot,
): { data: Raw } | { errors: string[] } {
  const errors: string[] = [];
  const code = str(raw.code, 40)?.toUpperCase();
  if (code === null || code === undefined) errors.push("code must be a string.");
  const finalCode = code || existing?.code || "";
  if (!finalCode) errors.push("code is required.");

  const type = (str(raw.type) || existing?.type || "") as CouponType;
  if (!COUPON_TYPES.includes(type)) errors.push(`type must be one of ${COUPON_TYPES.join(", ")}.`);
  const value = num(raw.value) ?? existing?.value;
  if (value === null || value === undefined || value <= 0) errors.push("value must be a number greater than 0.");
  else if (type === "percent" && value > 100) errors.push("a percent coupon cannot be over 100.");

  const scope = (str(raw.scope) || existing?.scope || "store") as CouponScope;
  if (!COUPON_SCOPES.includes(scope)) errors.push(`scope must be one of ${COUPON_SCOPES.join(", ")}.`);
  let targetIds = existing?.targetIds ?? [];
  const targets = strList(raw.target_ids) ?? strList(raw.targets);
  if (targets === null) errors.push("targets must be an array of ids or names.");
  else if (targets !== undefined) {
    const pool = scope === "category" ? catalog.categories : catalog.products;
    const ids: string[] = [];
    const unknown: string[] = [];
    for (const t of targets) {
      if (pool.has(t)) ids.push(t);
      else {
        const byName = [...pool.values()].find((x) => norm(x.name) === norm(t));
        if (byName) ids.push(byName.id);
        else unknown.push(t);
      }
    }
    if (unknown.length) errors.push(`Unknown ${scope}${unknown.length > 1 ? "s" : ""}: ${unknown.join(", ")}.`);
    targetIds = ids;
  }
  if (scope === "store") targetIds = [];
  else if (targetIds.length === 0) errors.push(`targets is required when scope is ${scope}.`);

  const nonNeg = (key: string, fallback: number) => {
    const n = num(raw[key]);
    if (n === null || (n !== undefined && n < 0)) errors.push(`${key} must be a number of 0 or more.`);
    return n ?? fallback;
  };
  const minOrderValue = nonNeg("min_order_value", existing?.minOrderValue ?? 0);
  const maxDiscount = nonNeg("max_discount", existing?.maxDiscount ?? 0);
  const usageLimit = nonNeg("usage_limit", existing?.usageLimit ?? 0);
  const perUserLimit = nonNeg("per_user_limit", existing?.perUserLimit ?? 0);

  const validFrom = isoDate(raw.valid_from);
  if (validFrom === null) errors.push("valid_from must be a date.");
  const validUntil = isoDate(raw.valid_until);
  if (validUntil === null) errors.push("valid_until must be a date.");
  const finalFrom = validFrom ?? existing?.validFrom ?? "";
  const finalUntil = validUntil ?? existing?.validUntil ?? "";
  if (finalFrom && finalUntil && Date.parse(finalUntil) < Date.parse(finalFrom)) {
    errors.push("valid_until is before valid_from.");
  }
  const isActive = bool(raw.is_active);
  if (isActive === null) errors.push("is_active must be true or false.");

  if (errors.length) return { errors };
  return {
    data: {
      code: finalCode,
      type,
      value,
      scope,
      targetIds,
      minOrderValue,
      maxDiscount,
      validFrom: finalFrom,
      validUntil: finalUntil,
      usageLimit,
      perUserLimit,
      isActive: isActive ?? existing?.isActive ?? true,
    },
  };
}

// --- banners ---------------------------------------------------------------------------

const TARGET_TYPES: BannerTargetType[] = ["none", "product", "category"];

export function parseBanner(
  raw: Raw,
  existing: Banner | null,
  catalog: CatalogSnapshot,
): { data: Raw } | { errors: string[] } {
  const errors: string[] = [];
  const title = str(raw.title, MAX_NAME);
  if (title === null) errors.push("title must be a string.");
  const finalTitle = title || existing?.title || "";
  if (!finalTitle) errors.push("title is required.");
  const image = str(raw.image);
  if (image === null || (image && !isHttpsUrl(image))) errors.push("image must be a public https URL.");
  const finalImage = image || existing?.imageUrl || "";
  if (!finalImage) errors.push("image is required — a banner is its artwork.");

  const targetType = (str(raw.target_type) || existing?.targetType || "none") as BannerTargetType;
  if (!TARGET_TYPES.includes(targetType)) errors.push(`target_type must be one of ${TARGET_TYPES.join(", ")}.`);
  let targetId = existing?.targetId ?? "";
  const targetRef = str(raw.target_id) || str(raw.target);
  if (targetType === "none") targetId = "";
  else if (raw.target_id !== undefined || raw.target !== undefined) {
    const pool = targetType === "category" ? catalog.categories : catalog.products;
    const hit = targetRef
      ? (pool.get(targetRef) ?? [...pool.values()].find((x) => norm(x.name) === norm(targetRef)))
      : undefined;
    if (!hit) errors.push(`Unknown ${targetType}: ${targetRef ?? ""}.`);
    else targetId = hit.id;
  }
  if (targetType !== "none" && !targetId) errors.push(`target is required when target_type is ${targetType}.`);

  const sortOrder = num(raw.sort_order);
  if (sortOrder === null || (sortOrder !== undefined && !Number.isInteger(sortOrder))) {
    errors.push("sort_order must be a whole number.");
  }
  const isActive = bool(raw.is_active);
  if (isActive === null) errors.push("is_active must be true or false.");
  const bg = str(raw.background_color);
  if (bg === null || (bg && !/^#[0-9a-fA-F]{6}$/.test(bg))) errors.push("background_color must look like #RRGGBB.");

  if (errors.length) return { errors };
  return {
    data: {
      title: finalTitle,
      subtitle: str(raw.subtitle) || existing?.subtitle || "",
      imageUrl: finalImage,
      targetType,
      targetId,
      sortOrder: sortOrder ?? existing?.sortOrder ?? 0,
      isActive: isActive ?? existing?.isActive ?? true,
      backgroundColor: bg || existing?.backgroundColor || "",
    },
  };
}

// --- upsert ----------------------------------------------------------------------------

type Planned =
  | { index: number; ref: FirebaseFirestore.DocumentReference; data: Raw; action: "created" | "updated" }
  | { index: number; id: string | null; errors: string[] };

function plan(
  storeId: string,
  entity: CatalogEntity,
  rows: Raw[],
  catalog: CatalogSnapshot,
): Planned[] {
  const planned: Planned[] = [];
  // Names claimed earlier in the same body resolve to the doc that row is
  // about to create, so a file can't mint two "Tees" — and a category can
  // be referenced by a product three rows later.
  const claimed = new Map<string, FirebaseFirestore.DocumentReference>();
  rows.forEach((raw, index) => {
    if (!raw || typeof raw !== "object" || Array.isArray(raw)) {
      planned.push({ index, id: null, errors: ["Each item must be an object."] });
      return;
    }
    let result: { data: Raw } | { errors: string[] };
    let found: { id: string } | null;
    let keyName: string;
    switch (entity) {
      case "products": {
        const r = resolveExisting(raw, catalog.products, (p) => p.name, (p) => p.externalId, "name");
        if ("error" in r) { planned.push({ index, id: null, errors: [r.error] }); return; }
        found = r.found;
        result = parseProduct(raw, r.found, catalog);
        keyName = "name";
        break;
      }
      case "categories": {
        const r = resolveExisting(raw, catalog.categories, (c) => c.name, (c) => c.externalId, "name");
        if ("error" in r) { planned.push({ index, id: null, errors: [r.error] }); return; }
        found = r.found;
        result = parseCategory(raw, r.found, catalog);
        keyName = "name";
        break;
      }
      case "brands": {
        const r = resolveExisting(raw, catalog.brands, (b) => b.name, (b) => b.externalId, "name");
        if ("error" in r) { planned.push({ index, id: null, errors: [r.error] }); return; }
        found = r.found;
        result = parseBrand(raw, r.found);
        keyName = "name";
        break;
      }
      case "coupons": {
        const r = resolveExisting(raw, catalog.coupons, (c) => c.code, () => "", "code");
        if ("error" in r) { planned.push({ index, id: null, errors: [r.error] }); return; }
        found = r.found;
        result = parseCoupon(raw, r.found, catalog);
        keyName = "code";
        break;
      }
      case "banners": {
        const r = resolveExisting(raw, catalog.banners, (b) => b.title, () => "", "title");
        if ("error" in r) { planned.push({ index, id: null, errors: [r.error] }); return; }
        found = r.found;
        result = parseBanner(raw, r.found, catalog);
        keyName = "title";
        break;
      }
    }
    if ("errors" in result) {
      planned.push({ index, id: found?.id ?? null, errors: result.errors });
      return;
    }
    // Two rows are the same record when they share an external id, or —
    // lacking one — a name. Two Shopify handles with one Title are two
    // products, and must not fold into each other here.
    const externalId = str(raw.external_id);
    const key = externalId
      ? `${entity}:ext:${externalId}`
      : `${entity}:name:${norm(String(result.data[keyName] ?? ""))}`;
    if (found) {
      planned.push({ index, ref: col(storeId, entity).doc(found.id), data: result.data, action: "updated" });
      return;
    }
    if (claimed.has(key)) {
      planned.push({ index, ref: claimed.get(key)!, data: result.data, action: "updated" });
      return;
    }
    const ref = col(storeId, entity).doc();
    claimed.set(key, ref);
    // A category created in this body is referenceable by the rows after it.
    if (entity === "categories") {
      catalog.categories.set(ref.id, {
        id: ref.id,
        name: String(result.data.name),
        imageUrl: String(result.data.imageUrl),
        groupName: String(result.data.groupName),
        parentId: String(result.data.parentId),
        externalId: String(result.data.externalId),
        createdAtMs: 0,
      });
    }
    if (entity === "brands") {
      catalog.brands.set(ref.id, {
        id: ref.id,
        name: String(result.data.name),
        logoUrl: String(result.data.logoUrl),
        externalId: String(result.data.externalId),
        createdAtMs: 0,
      });
    }
    planned.push({ index, ref, data: result.data, action: "created" });
  });
  return planned;
}

// Validates every row, then writes the valid ones in 500-doc batches. Rows
// that failed validation are reported by index and skipped; the rest still
// land — a 2,000-row import shouldn't be held hostage by one bad line. Not
// atomic past one batch, and says so in the response.
export async function upsertCatalog(
  storeId: string,
  entity: CatalogEntity,
  rows: Raw[],
  opts: {
    dryRun: boolean;
    actorUid: string;
    // Dry-run only: names an earlier step of the same import would have
    // created, so rows referencing them validate as they will on commit.
    assumeExisting?: { categories: string[]; brands: string[] };
  },
): Promise<{ results: WriteResult[]; created: number; updated: number; failed: number; atomic: boolean }> {
  const catalog = await loadCatalog(storeId);
  for (const name of opts.assumeExisting?.categories ?? []) {
    if (![...catalog.categories.values()].some((c) => norm(c.name) === norm(name))) {
      const id = `pending:${name}`;
      catalog.categories.set(id, { id, name, imageUrl: "", groupName: "Uncategorized", parentId: "", externalId: "", createdAtMs: 0 });
    }
  }
  for (const name of opts.assumeExisting?.brands ?? []) {
    if (![...catalog.brands.values()].some((b) => norm(b.name) === norm(name))) {
      const id = `pending:${name}`;
      catalog.brands.set(id, { id, name, logoUrl: "", externalId: "", createdAtMs: 0 });
    }
  }
  const planned = plan(storeId, entity, rows, catalog);
  const results: WriteResult[] = planned.map((p) =>
    "errors" in p
      ? { index: p.index, id: p.id, action: "error", errors: p.errors }
      : { index: p.index, id: p.ref.id, action: p.action },
  );
  const writes = planned.filter((p): p is Exclude<Planned, { errors: string[] }> => !("errors" in p));
  if (!opts.dryRun) {
    for (let i = 0; i < writes.length; i += BATCH_LIMIT) {
      const batch = adminDb.batch();
      for (const w of writes.slice(i, i + BATCH_LIMIT)) {
        const serverOwned =
          entity === "coupons" && w.action === "created" ? { usedCount: 0 } : {};
        batch.set(
          w.ref,
          {
            ...w.data,
            ...serverOwned,
            ...(w.action === "created" ? { createdAt: FieldValue.serverTimestamp() } : {}),
            updatedAt: FieldValue.serverTimestamp(),
            updatedBy: opts.actorUid,
          },
          // Merge, so the server-owned fields (rating aggregates, usedCount,
          // createdAt) on an existing doc survive an update.
          { merge: true },
        );
      }
      await batch.commit();
    }
  }
  return {
    results,
    created: results.filter((r) => r.action === "created").length,
    updated: results.filter((r) => r.action === "updated").length,
    failed: results.filter((r) => r.action === "error").length,
    atomic: writes.length <= BATCH_LIMIT,
  };
}

export async function deleteCatalogDoc(
  storeId: string,
  entity: CatalogEntity,
  id: string,
): Promise<boolean> {
  const ref = col(storeId, entity).doc(id);
  const snap = await ref.get();
  if (!snap.exists) return false;
  await ref.delete();
  return true;
}
