import type { GrocerySeed } from "@/lib/seed/seed-types";
import {
  toCsv,
  type ImportColumn,
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
  { key: "unit_value", required: false, description: "Pack size as a number, e.g. 500. Blank for non-packaged goods." },
  { key: "unit_type", required: false, description: "One of g, ml, pcs. Blank = g." },
  { key: "stock", required: true, description: "Whole number, 0 or more." },
  { key: "description", required: false, description: "Shown on Product Details." },
  { key: "prep_time", required: false, description: "Free text, e.g. \"10 mins\"." },
  { key: "image_url", required: false, description: "Public https URL of the product photo." },
  { key: "categories", required: false, description: "Existing category names, separated by |." },
  { key: "brand", required: false, description: "An existing brand name. Blank = unbranded." },
  { key: "is_popular", required: false, description: "true/false — feeds the storefront's popular rail." },
  { key: "sku", required: false, description: "Your stock-keeping code." },
  { key: "barcode", required: false, description: "EAN/UPC/ISBN." },
  { key: "external_id", required: false, description: "The id your other system (Shopify, ERP) knows this product by." },
  { key: "id", required: false, description: "Existing product id. Present = update that exact product." },
  { key: "option1_name", required: false, description: "For a product with choices: the first option (Size, Colour). One row per variant, sharing the product's name/external_id; price/stock/sku/barcode on each row are that variant's." },
  { key: "option1_value", required: false, description: "This row's value for option 1 (M, Red)." },
  { key: "option2_name", required: false, description: "Second option, if any." },
  { key: "option2_value", required: false, description: "This row's value for option 2." },
  { key: "option3_name", required: false, description: "Third option, if any." },
  { key: "option3_value", required: false, description: "This row's value for option 3." },
  { key: "pack_size", required: false, description: "For a pack-size variant: the size in unit_type units (500), so weight labels keep working." },
  { key: "attributes", required: false, description: "Details shown on the product page: Material=Cotton|Origin=India." },
];


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
      "", // sku
      "", // barcode
      "", // external_id
      "", // id — blank, these are new products
      "", "", "", "", "", "", // option1–3 name/value — simple products
      "", // pack_size
      "", // attributes
    ];
  });

  return toCsv(PRODUCT_COLUMNS, rows);
}
