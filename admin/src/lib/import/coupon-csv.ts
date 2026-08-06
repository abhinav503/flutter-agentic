import type { CouponInput } from "@/lib/coupons";
import type { GrocerySeed } from "@/lib/seed/seed-types";
import type { Coupon, CouponScope, CouponType } from "@/lib/types";
import {
  eachRow,
  matchKey,
  parseBoolean,
  parseIsoDate,
  parseNumber,
  readCsv,
  toCsv,
  type ImportColumn,
  type ImportPlan,
  type ImportRowError,
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

const TYPES: CouponType[] = ["percent", "flat"];
const SCOPES: CouponScope[] = ["store", "category", "product"];

export function buildCouponPlan(
  csvText: string,
  catalog: StoreCatalog,
  existing: Coupon[],
): ImportPlan<CouponInput> {
  const { rows, headerError } = readCsv(csvText, COUPON_COLUMNS);
  if (headerError) return { writes: [], errors: [headerError], rowCount: rows.length };

  const errors: ImportRowError[] = [];
  const byId = new Map(existing.map((c) => [c.id, c]));
  const byCode = new Map(existing.map((c) => [c.code.toUpperCase(), c]));
  const categoryByName = new Map(catalog.categories.map((c) => [matchKey(c.name), c.id]));
  const productByName = new Map(catalog.products.map((p) => [matchKey(p.name), p.id]));

  const writes = eachRow<CouponInput>(rows, errors, ({ line, get, fail, identify }) => {
    // Stored uppercase because that is what coupon-engine.ts looks up
    // (`code.trim().toUpperCase()`) — a lowercase import would create a
    // coupon no shopper could ever redeem.
    const code = get("code").toUpperCase();
    if (!code) {
      fail("code is required.");
      return;
    }
    if (!identify(code, get("id") || code)) return;

    const type = get("type").toLowerCase() as CouponType;
    if (!TYPES.includes(type)) {
      fail(`type must be one of ${TYPES.join(", ")}.`);
      return;
    }

    const value = parseNumber(get("value"));
    if (value === null || value <= 0) {
      fail("value must be a number greater than 0.");
      return;
    }
    if (type === "percent" && value > 100) {
      fail("a percent coupon cannot be over 100.");
      return;
    }

    const scope = (get("scope").toLowerCase() || "store") as CouponScope;
    if (!SCOPES.includes(scope)) {
      fail(`scope must be one of ${SCOPES.join(", ")}.`);
      return;
    }

    const targetNames = get("targets").split("|").map((t) => t.trim()).filter(Boolean);
    const targetIds: string[] = [];
    if (scope === "store") {
      if (targetNames.length > 0) {
        fail("targets must be blank when scope is store — it applies to the whole order.");
        return;
      }
    } else {
      if (targetNames.length === 0) {
        fail(`targets is required when scope is ${scope}.`);
        return;
      }
      const unknown: string[] = [];
      for (const targetName of targetNames) {
        const id =
          scope === "category"
            ? categoryByName.get(matchKey(targetName))
            : productByName.get(matchKey(targetName));
        if (id) targetIds.push(id);
        else unknown.push(targetName);
      }
      if (unknown.length > 0) {
        fail(`Unknown ${scope}${unknown.length > 1 ? "s" : ""}: ${unknown.join(", ")}.`);
        return;
      }
    }

    const numeric: Record<string, number> = {};
    for (const key of ["min_order_value", "max_discount", "usage_limit", "per_user_limit"]) {
      const raw = get(key);
      const parsed = raw ? parseNumber(raw) : 0;
      if (parsed === null || parsed < 0) {
        fail(`${key} must be a number of 0 or more (or blank).`);
        return;
      }
      numeric[key] = parsed;
    }

    const validFrom = parseIsoDate(get("valid_from"));
    if (validFrom === null) {
      fail("valid_from must be a date like 2026-08-01, or blank.");
      return;
    }
    const validUntil = parseIsoDate(get("valid_until"));
    if (validUntil === null) {
      fail("valid_until must be a date like 2026-08-31, or blank.");
      return;
    }
    if (validFrom && validUntil && Date.parse(validUntil) < Date.parse(validFrom)) {
      fail("valid_until is before valid_from.");
      return;
    }

    const isActive = parseBoolean(get("is_active") || "true");
    if (isActive === null) {
      fail("is_active must be true or false (or blank).");
      return;
    }

    const explicitId = get("id");
    let kind: "create" | "update" = "create";
    let id: string | undefined;
    if (explicitId) {
      if (!byId.has(explicitId)) {
        fail(`No coupon with id ${explicitId} in this store.`);
        return;
      }
      kind = "update";
      id = explicitId;
    } else {
      const match = byCode.get(code);
      if (match) {
        kind = "update";
        id = match.id;
      }
    }

    return {
      line,
      kind,
      id,
      name: code,
      data: {
        code,
        type,
        value,
        scope,
        targetIds,
        minOrderValue: numeric.min_order_value,
        maxDiscount: numeric.max_discount,
        validFrom,
        validUntil,
        usageLimit: numeric.usage_limit,
        perUserLimit: numeric.per_user_limit,
        isActive,
      },
    };
  });

  return { writes, errors, rowCount: rows.length };
}

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
