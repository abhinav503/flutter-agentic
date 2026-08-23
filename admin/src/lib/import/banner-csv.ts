import type { GrocerySeed } from "@/lib/seed/seed-types";
import type { Banner, BannerTargetType } from "@/lib/types";
import {
  toCsv,
  type ImportColumn,
} from "./csv-core";
import type { StoreCatalog } from "./store-catalog";

export type BannerInput = Omit<Banner, "id">;

export const BANNER_COLUMNS: ImportColumn[] = [
  { key: "title", required: true, description: "Headline. Also the match key when `id` is blank." },
  { key: "subtitle", required: false, description: "Supporting line under the title." },
  { key: "image_url", required: true, description: "Public https URL of the banner artwork." },
  { key: "target_type", required: false, description: "none, product or category. Blank = none." },
  { key: "target", required: false, description: "Name of the product/category it opens. Blank when target_type is none." },
  { key: "sort_order", required: false, description: "Carousel position, ascending. Blank = 0." },
  { key: "is_active", required: false, description: "true/false — false stages a banner without showing it." },
  { key: "background_color", required: false, description: "#RRGGBB for the copy panel, or blank." },
  { key: "id", required: false, description: "Existing banner id. Present = update that exact banner." },
];


/**
 * Seed banners point at a category or product by slug. A sample may only claim
 * a target the store actually has, so an unresolvable one is emitted as a
 * display-only banner rather than a row that fails — same principle as the
 * product sample's linking columns.
 */
export function sampleBannerCsv(
  seed: GrocerySeed,
  catalog: StoreCatalog,
  rowLimit = 4,
): string {
  const categoryNameBySlug = new Map(seed.categories.map((c) => [c.slug, c.name]));
  const productNameBySlug = new Map(seed.products.map((p) => [p.slug, p.name]));

  const rows = seed.banners.slice(0, rowLimit).map((banner) => {
    let targetType: BannerTargetType = "none";
    let target = "";

    const categoryName = banner.targetCategorySlug
      ? categoryNameBySlug.get(banner.targetCategorySlug)
      : undefined;
    const productName = banner.targetProductSlug
      ? productNameBySlug.get(banner.targetProductSlug)
      : undefined;

    if (categoryName && catalog.hasCategory(categoryName)) {
      targetType = "category";
      target = categoryName;
    } else if (productName && catalog.hasProduct(productName)) {
      targetType = "product";
      target = productName;
    }

    return [
      banner.title,
      banner.subtitle,
      banner.imageUrl,
      targetType,
      target,
      String(banner.sortOrder),
      "true",
      banner.backgroundColor,
      "",
    ];
  });

  return toCsv(BANNER_COLUMNS, rows);
}
