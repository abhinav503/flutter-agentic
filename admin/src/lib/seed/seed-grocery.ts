import {
  collection,
  doc,
  serverTimestamp,
  writeBatch,
} from "firebase/firestore";
import { db } from "@/lib/firebase";
import { computeDiscountPercentage, type ProductInput } from "@/lib/products";
import { GROCERY_SEED } from "./grocery-seed-data";

// Writes the bundled grocery catalog into a store through the client SDK —
// the same path (and firestore.rules gate) as the dashboard's own forms.
// Deliberately NOT an API route: catalog writes have no server route, and the
// browser session already holds the owner credential.
//
// One atomic writeBatch (~140 docs, well under Firestore's 500-write cap):
// a mid-way failure leaves zero partial state, so retrying is always safe.
// If the dataset ever nears the cap, split per collection in dependency
// order — and change the dialog's failure copy, which promises all-or-nothing.

export type SeedPhase =
  | "categories"
  | "brands"
  | "products"
  | "coupons"
  | "banners"
  | "committing";

export type SeedProgress = { phase: SeedPhase; done: number; total: number };

export type SeedResult = {
  categories: number;
  brands: number;
  products: number;
  coupons: number;
  banners: number;
  total: number;
};

export async function seedGroceryData(
  storeId: string,
  onProgress: (progress: SeedProgress) => void,
): Promise<SeedResult> {
  const seed = GROCERY_SEED;
  const total =
    seed.categories.length +
    seed.brands.length +
    seed.products.length +
    seed.coupons.length +
    seed.banners.length;

  const batch = writeBatch(db);
  const ref = (coll: string) =>
    doc(collection(db, "stores", storeId, coll));

  let done = 0;
  const step = (phase: SeedPhase) => onProgress({ phase, done: ++done, total });

  // doc() mints ids locally (no network), so slug → id maps exist before
  // anything is written and products can reference categories/brands that
  // land in the same commit.
  const categoryIds = new Map<string, string>();
  for (const category of seed.categories) {
    const categoryRef = ref("categories");
    categoryIds.set(category.slug, categoryRef.id);
    batch.set(categoryRef, {
      name: category.name,
      imageUrl: category.imageUrl,
      groupName: category.groupName,
      createdAt: serverTimestamp(),
    });
    step("categories");
  }

  const brandIds = new Map<string, string>();
  for (const brand of seed.brands) {
    const brandRef = ref("brands");
    brandIds.set(brand.slug, brandRef.id);
    batch.set(brandRef, {
      name: brand.name,
      logoUrl: brand.logoUrl,
      createdAt: serverTimestamp(),
    });
    step("brands");
  }

  const productIds = new Map<string, string>();
  for (const product of seed.products) {
    const productRef = ref("products");
    productIds.set(product.slug, productRef.id);
    const originalPrice = product.originalPrice ?? product.price;
    const sizeVariants = (product.sizeVariants ?? []).map((variant) => ({
      value: variant.value,
      price: variant.price,
      originalPrice: variant.originalPrice ?? variant.price,
    }));
    // Built as a ProductInput so the seeder can never drift from what the
    // product form writes (derived discount, sizeOptions from variants,
    // rating aggregates absent).
    const payload: ProductInput = {
      name: product.name,
      imageUrl: product.imageUrl,
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
      sizeOptions: sizeVariants.map((variant) => variant.value),
      sizeVariants,
      isPopular: product.isPopular ?? false,
    };
    batch.set(productRef, { ...payload, createdAt: serverTimestamp() });
    step("products");
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
    batch.set(ref("coupons"), {
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
      createdAt: serverTimestamp(),
    });
    step("coupons");
  }

  for (const banner of seed.banners) {
    const targetId = banner.targetCategorySlug
      ? (categoryIds.get(banner.targetCategorySlug) ?? "")
      : banner.targetProductSlug
        ? (productIds.get(banner.targetProductSlug) ?? "")
        : "";
    batch.set(ref("banners"), {
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
      createdAt: serverTimestamp(),
    });
    step("banners");
  }

  onProgress({ phase: "committing", done: total, total });
  await batch.commit();

  return {
    categories: seed.categories.length,
    brands: seed.brands.length,
    products: seed.products.length,
    coupons: seed.coupons.length,
    banners: seed.banners.length,
    total,
  };
}
