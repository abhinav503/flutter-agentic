import type { GrocerySeed } from "@/lib/seed/seed-types";
import {
  toCsv,
  type ImportColumn,
} from "./csv-core";
import type { StoreCatalog } from "./store-catalog";

export const COUPON_COLUMNS: ImportColumn[] = [
  { key: "code", required: true, description: "Redemption code. Stored uppercase; the match key when `id` is blank." },
  { key: "type", required: true, description: "percent or flat." },
  { key: "value", required: true, description: "1–100 for percent; an amount in the store's currency for flat." },
  { key: "scope", required: false, description: "store, category or product. Blank = store." },
  { key: "targets", required: false, description: "Category/product names for the scoped kinds, separated by |." },
  { key: "min_order_value", required: false, description: "Order floor. Blank or 0 = no minimum." },
  { key: "max_discount", required: false, description: "Cap on a percent coupon's discount. 0 = uncapped." },
  { key: "valid_from", required: false, description: "ISO date, e.g. 2026-08-01. Blank = immediately." },
  { key: "valid_until", required: false, description: "ISO date. Blank = never expires." },
  { key: "usage_limit", required: false, description: "Total redemptions allowed. 0 = unlimited." },
  { key: "per_user_limit", required: false, description: "Redemptions per shopper. 0 = unlimited." },
  { key: "is_active", required: false, description: "true/false. Blank = active." },
  { key: "id", required: false, description: "Existing coupon id. Present = update that exact coupon." },
];


/**
 * Seed coupons scope to categories and products by slug. A sample may only
 * claim targets the store actually has, so scoped coupons are included **only
 * when every one of their targets resolves** — the alternative, silently
 * rewriting them to whole-order scope, would hand the owner a coupon that
 * discounts far more than the one they thought they were copying.
 *
 * Whole-order coupons always qualify, so the sample is never empty.
 */
export function sampleCouponCsv(
  seed: GrocerySeed,
  catalog: StoreCatalog,
  rowLimit = 6,
): string {
  const categoryNameBySlug = new Map(seed.categories.map((c) => [c.slug, c.name]));
  const productNameBySlug = new Map(seed.products.map((p) => [p.slug, p.name]));

  const rows: string[][] = [];
  for (const coupon of seed.coupons) {
    if (rows.length >= rowLimit) break;

    let targets: string[] = [];
    if (coupon.scope === "category") {
      targets = (coupon.targetCategorySlugs ?? [])
        .map((slug) => categoryNameBySlug.get(slug))
        .filter((name): name is string => Boolean(name) && catalog.hasCategory(name!));
      if (targets.length !== (coupon.targetCategorySlugs ?? []).length) continue;
    } else if (coupon.scope === "product") {
      targets = (coupon.targetProductSlugs ?? [])
        .map((slug) => productNameBySlug.get(slug))
        .filter((name): name is string => Boolean(name) && catalog.hasProduct(name!));
      if (targets.length !== (coupon.targetProductSlugs ?? []).length) continue;
    }
    if (coupon.scope !== "store" && targets.length === 0) continue;

    rows.push([
      coupon.code,
      coupon.type,
      String(coupon.value),
      coupon.scope,
      targets.join("|"),
      String(coupon.minOrderValue),
      String(coupon.maxDiscount),
      "",
      "",
      String(coupon.usageLimit),
      String(coupon.perUserLimit),
      "true",
      "",
    ]);
  }

  return toCsv(COUPON_COLUMNS, rows);
}
