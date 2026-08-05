// The shape every "Generate sample data" catalog is written in, shared by all
// markets (see seed-markets.ts). Lives apart from any one catalog so a new
// market's data file doesn't have to import another market's.
//
// Slugs are the cross-reference keys within a catalog: real Firestore ids are
// minted at write time by the seeder (seed-grocery.ts), which maps slugs → new
// doc ids so products can reference categories and brands landing in the same
// commit.

import type { CouponScope, CouponType, UnitType } from "@/lib/types";

export type SeedCategory = {
  slug: string;
  name: string;
  imageUrl: string;
  groupName: string;
};

export type SeedBrand = {
  slug: string;
  name: string;
  // Google's favicon endpoint where the brand's site serves a real ≥64px
  // icon, DiceBear monograms otherwise (most brand sites only ship a 16px
  // favicon, which reads as a blur). Consumers placeholder-fall-back on "".
  logoUrl: string;
};

export type SeedSizeVariant = {
  value: number;
  price: number;
  // Absent = no per-size discount (originalPrice equals price).
  originalPrice?: number;
};

export type SeedProduct = {
  slug: string;
  name: string;
  imageUrl: string;
  price: number;
  // Absent = not discounted.
  originalPrice?: number;
  unitValue: number;
  unitType: UnitType;
  description: string;
  stock: number;
  prepTime?: string;
  categorySlugs: string[];
  // Absent = unbranded ("").
  brandSlug?: string;
  sizeVariants?: SeedSizeVariant[];
  isPopular?: boolean;
};

// Always seeded evergreen (validFrom/validUntil "") and active; the target
// slug list used is the one matching `scope`.
export type SeedCoupon = {
  code: string;
  type: CouponType;
  value: number;
  scope: CouponScope;
  targetCategorySlugs?: string[];
  targetProductSlugs?: string[];
  minOrderValue: number;
  maxDiscount: number;
  usageLimit: number;
  perUserLimit: number;
};

export type SeedBanner = {
  title: string;
  subtitle: string;
  imageUrl: string;
  // At most one of these; neither = a display-only banner.
  targetCategorySlug?: string;
  targetProductSlug?: string;
  sortOrder: number;
  backgroundColor: string;
};

export type GrocerySeed = {
  categories: SeedCategory[];
  brands: SeedBrand[];
  products: SeedProduct[];
  coupons: SeedCoupon[];
  banners: SeedBanner[];
};

// Every catalog's product photos are hotlinked from Open Food Facts, so the
// base lives here rather than being repeated per market.
export const OFF_IMAGE_BASE = "https://images.openfoodfacts.org/images/products";
