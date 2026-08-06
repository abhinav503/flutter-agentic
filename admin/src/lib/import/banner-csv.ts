import type { GrocerySeed } from "@/lib/seed/seed-types";
import type { Banner, BannerTargetType } from "@/lib/types";
import {
  eachRow,
  matchKey,
  parseBoolean,
  parseNumber,
  readCsv,
  toCsv,
  type ImportColumn,
  type ImportPlan,
  type ImportRowError,
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

const TARGET_TYPES: BannerTargetType[] = ["none", "product", "category"];
const HEX = /^#[0-9a-fA-F]{6}$/;

export function buildBannerPlan(
  csvText: string,
  catalog: StoreCatalog,
  existing: Banner[],
): ImportPlan<BannerInput> {
  const { rows, headerError } = readCsv(csvText, BANNER_COLUMNS);
  if (headerError) return { writes: [], errors: [headerError], rowCount: rows.length };

  const errors: ImportRowError[] = [];
  const byId = new Map(existing.map((b) => [b.id, b]));
  const byTitle = new Map(existing.map((b) => [matchKey(b.title), b]));
  const categoryByName = new Map(catalog.categories.map((c) => [matchKey(c.name), c.id]));
  const productByName = new Map(catalog.products.map((p) => [matchKey(p.name), p.id]));

  const writes = eachRow<BannerInput>(rows, errors, ({ line, get, fail, identify }) => {
    const title = get("title");
    if (!title) {
      fail("title is required.");
      return;
    }
    if (!identify(title, get("id") || title)) return;

    const imageUrl = get("image_url");
    if (!imageUrl) {
      fail("image_url is required — a banner is its artwork.");
      return;
    }

    const targetType = (get("target_type").toLowerCase() || "none") as BannerTargetType;
    if (!TARGET_TYPES.includes(targetType)) {
      fail(`target_type must be one of ${TARGET_TYPES.join(", ")}.`);
      return;
    }

    // The column takes a *name*, not a doc id: an owner filling in a
    // spreadsheet knows "Fresh Fruits", not the 20-character id behind it.
    const target = get("target");
    let targetId = "";
    if (targetType === "none") {
      if (target) {
        fail("target must be blank when target_type is none.");
        return;
      }
    } else {
      if (!target) {
        fail(`target is required when target_type is ${targetType}.`);
        return;
      }
      const resolved =
        targetType === "category"
          ? categoryByName.get(matchKey(target))
          : productByName.get(matchKey(target));
      if (!resolved) {
        fail(`No ${targetType} named "${target}" in this store.`);
        return;
      }
      targetId = resolved;
    }

    const rawSort = get("sort_order");
    const sortOrder = rawSort ? parseNumber(rawSort) : 0;
    if (sortOrder === null || !Number.isInteger(sortOrder)) {
      fail("sort_order must be a whole number (or blank for 0).");
      return;
    }

    const isActive = parseBoolean(get("is_active") || "true");
    if (isActive === null) {
      fail("is_active must be true or false (or blank).");
      return;
    }

    const backgroundColor = get("background_color");
    if (backgroundColor && !HEX.test(backgroundColor)) {
      fail("background_color must look like #RRGGBB, or be blank.");
      return;
    }

    const explicitId = get("id");
    let kind: "create" | "update" = "create";
    let id: string | undefined;
    if (explicitId) {
      if (!byId.has(explicitId)) {
        fail(`No banner with id ${explicitId} in this store.`);
        return;
      }
      kind = "update";
      id = explicitId;
    } else {
      const match = byTitle.get(matchKey(title));
      if (match) {
        kind = "update";
        id = match.id;
      }
    }

    return {
      line,
      kind,
      id,
      name: title,
      data: { title, subtitle: get("subtitle"), imageUrl, targetType, targetId, sortOrder, isActive, backgroundColor },
    };
  });

  return { writes, errors, rowCount: rows.length };
}

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
