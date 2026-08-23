import {
  computeDiscountPercentage,
  finaliseProductInput,
  type ProductInput,
} from "@/lib/products";
import { formatPackSize, packSizeVariantId } from "@/lib/product-model";
import type { Variant } from "@/lib/types";
import { SEED_MARKET_CATALOGS, type SeedMarket } from "./seed-markets";

// Builds one market's bundled grocery catalog as a list of docs for the
// store, with slug references already resolved to the ids `newId` mints —
// pure, so the v1 seed route commits it through the Admin SDK in one
// atomic batch (the largest catalog is ~170 docs, well under Firestore's
// 500-write cap): a mid-way failure leaves zero partial state.
// If the dataset ever nears the cap, split per collection in dependency
// order — and change the dialog's failure copy, which promises all-or-nothing.

export type SeedDoc = {
  collection: "categories" | "brands" | "products" | "coupons" | "banners";
  id: string;
  data: Record<string, unknown>;
};

export type SeedPhase =
  | "categories"
  | "brands"
  | "products"
  | "coupons"
  | "banners"
  | "committing";

export type SeedResult = {
  categories: number;
  brands: number;
  products: number;
  coupons: number;
  banners: number;
  total: number;
};

export function buildSeedDocs(
  market: SeedMarket,
  newId: (collection: SeedDoc["collection"]) => string,
): { docs: SeedDoc[]; result: SeedResult } {
  const seed = SEED_MARKET_CATALOGS[market];
  const docs: SeedDoc[] = [];
  const ref = (coll: SeedDoc["collection"]) => ({ id: newId(coll), coll });
  const set = (r: { id: string; coll: SeedDoc["collection"] }, data: Record<string, unknown>) =>
    docs.push({ collection: r.coll, id: r.id, data });

  // Ids are minted up front, so slug → id maps exist before anything is
  // written and products can reference categories/brands that land in the
  // same commit.
  const categoryIds = new Map<string, string>();
  for (const category of seed.categories) {
    const categoryRef = ref("categories");
    categoryIds.set(category.slug, categoryRef.id);
    set(categoryRef, {
      name: category.name,
      imageUrl: category.imageUrl,
      groupName: category.groupName,
      parentId: "",
      externalId: "",
    });
  }

  const brandIds = new Map<string, string>();
  for (const brand of seed.brands) {
    const brandRef = ref("brands");
    brandIds.set(brand.slug, brandRef.id);
    set(brandRef, {
      name: brand.name,
      externalId: "",
      logoUrl: brand.logoUrl,
    });
  }

  const productIds = new Map<string, string>();
  for (const product of seed.products) {
    const productRef = ref("products");
    productIds.set(product.slug, productRef.id);
    const originalPrice = product.originalPrice ?? product.price;
    // Seed pack sizes become v2 variants on a single "Size" axis. Each pack
    // carries the product's stock count — per-variant stock is real now, and
    // a sample store with every pack in stock is the useful default.
    const variants: Variant[] = (product.sizeVariants ?? []).map((variant) => ({
      id: packSizeVariantId(variant.value),
      externalId: "",
      sku: "",
      barcode: "",
      options: [formatPackSize(variant.value, product.unitType)],
      price: variant.price,
      originalPrice: variant.originalPrice ?? variant.price,
      stock: product.stock,
      sellWhenOutOfStock: false,
      imageUrl: "",
      packSize: variant.value,
    }));
    // Built as a ProductInput and finalised exactly as the product form's
    // writes are, so the seeder can never drift from it (derived summary,
    // sizeOptions from variants, rating aggregates absent).
    const payload: ProductInput = finaliseProductInput({
      name: product.name,
      imageUrl: product.imageUrl,
      images: product.imageUrl ? [product.imageUrl] : [],
      externalId: "",
      sku: "",
      barcode: "",
      price: product.price,
      originalPrice,
      discountPercentage: computeDiscountPercentage(
        product.price,
        originalPrice,
      ),
      unitValue: product.unitValue,
      unitType: product.unitType,
      prepTime: product.prepTime ?? "",
      description: product.description,
      stock: product.stock,
      categoryIds: product.categorySlugs
        .map((slug) => categoryIds.get(slug))
        .filter((id): id is string => !!id),
      brandId: product.brandSlug ? (brandIds.get(product.brandSlug) ?? "") : "",
      optionNames: variants.length > 0 ? ["Size"] : [],
      variants,
      attributes: {},
      sizeOptions: [],
      sizeVariants: [],
      isPopular: product.isPopular ?? false,
    });
    set(productRef, { ...payload });
  }

  for (const coupon of seed.coupons) {
    const targetIds =
      coupon.scope === "category"
        ? (coupon.targetCategorySlugs ?? [])
            .map((slug) => categoryIds.get(slug))
            .filter((id): id is string => !!id)
        : coupon.scope === "product"
          ? (coupon.targetProductSlugs ?? [])
              .map((slug) => productIds.get(slug))
              .filter((id): id is string => !!id)
          : [];
    // Mirrors addCoupon (lib/coupons.ts): usedCount starts at 0, server-owned.
    set(ref("coupons"), {
      code: coupon.code.toUpperCase(),
      type: coupon.type,
      value: coupon.value,
      scope: coupon.scope,
      targetIds,
      minOrderValue: coupon.minOrderValue,
      maxDiscount: coupon.maxDiscount,
      validFrom: "",
      validUntil: "",
      usageLimit: coupon.usageLimit,
      perUserLimit: coupon.perUserLimit,
      usedCount: 0,
      isActive: true,
    });
  }

  for (const banner of seed.banners) {
    const targetId = banner.targetCategorySlug
      ? (categoryIds.get(banner.targetCategorySlug) ?? "")
      : banner.targetProductSlug
        ? (productIds.get(banner.targetProductSlug) ?? "")
        : "";
    set(ref("banners"), {
      imageUrl: banner.imageUrl,
      title: banner.title,
      subtitle: banner.subtitle,
      targetType: targetId
        ? banner.targetCategorySlug
          ? "category"
          : "product"
        : "none",
      targetId,
      sortOrder: banner.sortOrder,
      isActive: true,
      backgroundColor: banner.backgroundColor,
    });
  }

  return {
    docs,
    result: {
      categories: seed.categories.length,
      brands: seed.brands.length,
      products: seed.products.length,
      coupons: seed.coupons.length,
      banners: seed.banners.length,
      total: docs.length,
    },
  };
}

// Sample data is for an empty store: a second run on a stocked one would
// double every category and product. Admin SDK count() — one read per
// collection, whatever the catalog's size.
export async function assertStoreEmptyForSeed(
  store: FirebaseFirestore.DocumentReference,
): Promise<void> {
  const [products, categories] = await Promise.all([
    store.collection("products").count().get(),
    store.collection("categories").count().get(),
  ]);
  const n = products.data().count + categories.data().count;
  if (n > 0) {
    throw new SeedRefusedError(
      `This store already has ${n} product${n === 1 ? "" : "s"}/categories — sample data is for an empty store. Delete them first, or import your own catalog instead.`,
    );
  }
}

export class SeedRefusedError extends Error {}
