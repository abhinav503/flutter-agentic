import { computeDiscountPercentage, type ProductInput } from "@/lib/products";
import type { GrocerySeed } from "@/lib/seed/seed-types";
import {
  findRestrictedTerms,
  restrictedProductMessage,
} from "@/lib/restricted-products";
import type { UnitType } from "@/lib/types";
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

/**
 * Product rows. See csv-core.ts for the shared machinery and store-catalog.ts
 * for what "the store's current catalog" means to every importer.
 */

export const PRODUCT_COLUMNS: ImportColumn[] = [
  { key: "name", required: true, description: "Product name. Also the match key when `id` is blank." },
  { key: "price", required: true, description: "What the shopper pays, in the store's currency." },
  { key: "original_price", required: false, description: "Pre-discount price. Blank = not discounted." },
  { key: "unit_value", required: true, description: "Pack size as a number, e.g. 500." },
  { key: "unit_type", required: true, description: "One of g, ml, pcs." },
  { key: "stock", required: true, description: "Whole number, 0 or more." },
  { key: "description", required: false, description: "Shown on Product Details." },
  { key: "prep_time", required: false, description: "Free text, e.g. \"10 mins\"." },
  { key: "image_url", required: false, description: "Public https URL of the product photo." },
  { key: "categories", required: false, description: "Existing category names, separated by |." },
  { key: "brand", required: false, description: "An existing brand name. Blank = unbranded." },
  { key: "is_popular", required: false, description: "true/false — feeds the storefront's popular rail." },
  { key: "id", required: false, description: "Existing product id. Present = update that exact product." },
];

const UNIT_TYPES: UnitType[] = ["g", "ml", "pcs"];

export function buildProductPlan(
  csvText: string,
  catalog: StoreCatalog,
): ImportPlan<ProductInput> {
  const { rows, headerError } = readCsv(csvText, PRODUCT_COLUMNS);
  if (headerError) return { writes: [], errors: [headerError], rowCount: rows.length };

  const errors: ImportRowError[] = [];
  const categoryByName = new Map(catalog.categories.map((c) => [matchKey(c.name), c.id]));
  const brandByName = new Map(catalog.brands.map((b) => [matchKey(b.name), b.id]));
  const productById = new Map(catalog.products.map((p) => [p.id, p]));
  const productByName = new Map(catalog.products.map((p) => [matchKey(p.name), p]));

  const writes = eachRow<ProductInput>(rows, errors, ({ line, get, fail, identify }) => {
    const name = get("name");
    if (!name) {
      fail("name is required.");
      return;
    }
    if (!identify(name, get("id") || name)) return;

    // Same rule as the product form — a CSV is the other way a catalog gets
    // filled, and the ban is worth nothing if one path enforces it.
    const restricted = findRestrictedTerms(name, get("description"));
    if (restricted.length > 0) {
      fail(restrictedProductMessage(restricted));
      return;
    }

    const price = parseNumber(get("price"));
    if (price === null || price <= 0) {
      fail("price must be a number greater than 0.");
      return;
    }

    const rawOriginal = get("original_price");
    const originalPrice = rawOriginal ? parseNumber(rawOriginal) : price;
    if (originalPrice === null) {
      fail("original_price must be a number, or blank for no discount.");
      return;
    }
    if (originalPrice < price) {
      fail("original_price is below price — a discount cannot be negative.");
      return;
    }

    const unitValue = parseNumber(get("unit_value"));
    if (unitValue === null || unitValue <= 0) {
      fail("unit_value must be a number greater than 0.");
      return;
    }

    const unitType = get("unit_type").toLowerCase() as UnitType;
    if (!UNIT_TYPES.includes(unitType)) {
      fail(`unit_type must be one of ${UNIT_TYPES.join(", ")}.`);
      return;
    }

    const stock = parseNumber(get("stock"));
    if (stock === null || stock < 0 || !Number.isInteger(stock)) {
      fail("stock must be a whole number, 0 or more.");
      return;
    }

    const isPopular = parseBoolean(get("is_popular"));
    if (isPopular === null) {
      fail("is_popular must be true or false (or blank).");
      return;
    }

    // Unknown categories and brands are errors, not silent creations: a typo
    // would otherwise quietly mint "Beverges" and split the catalog in two.
    const categoryIds: string[] = [];
    const unknownCategories: string[] = [];
    for (const categoryName of get("categories").split("|").map((n) => n.trim()).filter(Boolean)) {
      const id = categoryByName.get(matchKey(categoryName));
      if (id) categoryIds.push(id);
      else unknownCategories.push(categoryName);
    }
    if (unknownCategories.length > 0) {
      fail(
        `Unknown categor${unknownCategories.length > 1 ? "ies" : "y"}: ${unknownCategories.join(", ")}. Add ${unknownCategories.length > 1 ? "them" : "it"} on the Categories page first.`,
      );
      return;
    }

    const brandName = get("brand");
    let brandId = "";
    if (brandName) {
      const id = brandByName.get(matchKey(brandName));
      if (!id) {
        fail(`Unknown brand: ${brandName}. Add it on the Brands page first.`);
        return;
      }
      brandId = id;
    }

    const explicitId = get("id");
    let kind: "create" | "update" = "create";
    let id: string | undefined;
    if (explicitId) {
      if (!productById.has(explicitId)) {
        fail(`No product with id ${explicitId} in this store.`);
        return;
      }
      kind = "update";
      id = explicitId;
    } else {
      const existing = productByName.get(matchKey(name));
      if (existing) {
        kind = "update";
        id = existing.id;
      }
    }

    return {
      line,
      kind,
      id,
      name,
      data: {
        name,
        imageUrl: get("image_url"),
        price,
        originalPrice,
        discountPercentage: computeDiscountPercentage(price, originalPrice),
        unitValue,
        unitType,
        prepTime: get("prep_time"),
        description: get("description"),
        stock,
        categoryIds,
        brandId,
        // Per-size pricing has no sensible flat-file shape and no v1 column.
        // Updates merge (see importRows), so a product that already has
        // variants keeps them — these only apply to rows creating a product.
        sizeOptions: [],
        sizeVariants: [],
        isPopular,
      },
    };
  });

  return { writes, errors, rowCount: rows.length };
}

/**
 * The downloadable template, built from the store's own market seed catalog so
 * the rows are real products in the store's language and currency.
 *
 * **It must import cleanly into the store that downloaded it** — see
 * store-catalog.ts's `linkableCategories`/`linkableBrand` for how the linking
 * columns are resolved against the live catalog rather than copied from the
 * seed, and why.
 */
export function sampleProductCsv(
  seed: GrocerySeed,
  catalog: StoreCatalog,
  rowLimit = 8,
): string {
  const seedCategoryBySlug = new Map(seed.categories.map((c) => [c.slug, c.name]));
  const seedBrandBySlug = new Map(seed.brands.map((b) => [b.slug, b.name]));

  // Between 2 and 30 products per market carry no imageUrl (a gap in the seed
  // catalogs themselves — "Generate sample data" writes those imageless too).
  // A template whose rows land photo-less products teaches the wrong thing, so
  // the sample draws only from products that have one; every market has far
  // more than rowLimit of those. The seed data is left exactly as it is — this
  // is a selection, not an edit.
  const withImages = seed.products.filter((p) => p.imageUrl);
  const pool = withImages.length >= rowLimit ? withImages : seed.products;

  const rows = pool.slice(0, rowLimit).map((product) => {
    const seedCategories = (product.categorySlugs ?? [])
      .map((slug) => seedCategoryBySlug.get(slug))
      .filter((name): name is string => Boolean(name));
    const seedBrand = product.brandSlug ? seedBrandBySlug.get(product.brandSlug) : undefined;

    return [
      product.name,
      String(product.price),
      product.originalPrice === undefined ? "" : String(product.originalPrice),
      String(product.unitValue),
      product.unitType,
      String(product.stock),
      product.description,
      product.prepTime ?? "",
      product.imageUrl,
      catalog.linkableCategories(seedCategories).join("|"),
      catalog.linkableBrand(seedBrand),
      product.isPopular ? "true" : "false",
      "", // id — blank, these are new products
    ];
  });

  return toCsv(PRODUCT_COLUMNS, rows);
}
