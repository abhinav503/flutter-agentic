import Papa from "papaparse";
import { MAX_UPSERT_ROWS, upsertCatalog, type CatalogEntity, type WriteResult } from "./catalog";

// CSV → the JSON rows the v1 catalog API already validates. The import route
// is deliberately thin: a format adapter turns a file into `items` for
// PUT /{entity}, and everything about what a valid product IS lives in one
// place (catalog.ts). A new source platform is a new adapter — a header
// map and a grouping rule — not a new validator.
//
// Two formats today:
//   cordelia — our own columns (the sample CSVs the console downloads), one
//              row per product, or one row per variant when the option
//              columns are filled
//   shopify  — products_export.csv, either header dialect (the legacy
//              "Variant Price" / "Image Src" one and the 2024+ "Price" /
//              "Product image URL" one)

export const IMPORT_FORMATS = ["cordelia", "shopify"] as const;
export type ImportFormat = (typeof IMPORT_FORMATS)[number];

type Raw = Record<string, unknown>;
type Row = Record<string, string>;

export type ImportOptions = {
  entity: CatalogEntity;
  format: ImportFormat;
  commit: boolean;
  // Create the categories and brands the rows name but the store lacks,
  // before importing the rows. Off by default for our own format (a typo
  // shouldn't mint a category); on by default for Shopify, whose Type /
  // Vendor values are the merchant's own taxonomy.
  createMissing: boolean;
  // Shopify only: also turn each Tag into a category.
  tagsAsCategories: boolean;
};

export type ImportReport = {
  format: ImportFormat;
  entity: CatalogEntity;
  dry_run: boolean;
  rows_read: number;
  // Rows the adapter dropped before validation, with why (a Shopify draft,
  // an image-only row folded into its product) — never silent.
  skipped: { line: number; reason: string }[];
  // What the adapter derived that the file never said outright.
  notes: string[];
  created_categories: string[];
  created_brands: string[];
  results: WriteResult[];
  created: number;
  updated: number;
  failed: number;
  atomic: boolean;
};

export class ImportError extends Error {
  constructor(
    message: string,
    public readonly status: 400 | 413 | 415 = 400,
  ) {
    super(message);
  }
}

function normalizeHeader(h: string): string {
  return h.replace(/^﻿/, "").trim().toLowerCase().replace(/[\s/-]+/g, "_");
}

function parseCsv(text: string): { rows: Row[]; headers: string[] } {
  const parsed = Papa.parse<Row>(text, {
    header: true,
    skipEmptyLines: false,
    transformHeader: normalizeHeader,
  });
  return { rows: parsed.data, headers: parsed.meta.fields ?? [] };
}

const isBlank = (row: Row) => Object.values(row).every((v) => !String(v ?? "").trim());
const get = (row: Row, key: string) => (row[key] ?? "").trim();
const splitList = (s: string) => s.split(/[|,]/).map((x) => x.trim()).filter(Boolean);

// --- cordelia format -------------------------------------------------------

// Product rows. A row's option columns decide whether it is a whole product
// or one variant of the product the rows around it share (same id /
// external_id / name). Price, stock, sku and barcode on a variant row belong
// to that variant.
const CORDELIA_OPTION_COLUMNS = [1, 2, 3] as const;

function cordeliaProducts(rows: Row[]): { items: Raw[]; skipped: ImportReport["skipped"]; notes: string[] } {
  const groups = new Map<string, { first: Row; rows: Row[]; line: number }>();
  const order: string[] = [];
  rows.forEach((row, i) => {
    if (isBlank(row)) return;
    const key = get(row, "id") || get(row, "external_id") || get(row, "name").toLowerCase();
    if (!key) return; // validated as "name is required" below via an empty item
    if (!groups.has(key)) {
      groups.set(key, { first: row, rows: [], line: i + 2 });
      order.push(key);
    }
    groups.get(key)!.rows.push(row);
  });

  const items: Raw[] = [];
  for (const key of order) {
    const { first, rows: group } = groups.get(key)!;
    const optionNames = CORDELIA_OPTION_COLUMNS.map((n) => get(first, `option${n}_name`)).filter(Boolean);
    const base: Raw = {
      id: get(first, "id") || undefined,
      external_id: get(first, "external_id") || undefined,
      name: get(first, "name"),
      description: first.description === undefined ? undefined : get(first, "description"),
      images: first.image_url === undefined && first.images === undefined
        ? undefined
        : splitList(get(first, "images") || get(first, "image_url")),
      unit_value: get(first, "unit_value") || undefined,
      unit_type: get(first, "unit_type") || undefined,
      prep_time: get(first, "prep_time") || undefined,
      categories: first.categories === undefined ? undefined : splitList(get(first, "categories")),
      brand: first.brand === undefined ? undefined : get(first, "brand"),
      is_popular: get(first, "is_popular") || undefined,
      attributes: parseAttributes(get(first, "attributes")),
    };
    if (optionNames.length === 0) {
      items.push({
        ...base,
        price: get(first, "price") || undefined,
        original_price: get(first, "original_price") || undefined,
        stock: get(first, "stock") || undefined,
        sku: get(first, "sku") || undefined,
        barcode: get(first, "barcode") || undefined,
      });
      continue;
    }
    items.push({
      ...base,
      option_names: optionNames,
      variants: group.map((row) => ({
        options: CORDELIA_OPTION_COLUMNS.slice(0, optionNames.length).map((n) => get(row, `option${n}_value`)),
        price: get(row, "price"),
        original_price: get(row, "original_price") || undefined,
        stock: get(row, "stock") || undefined,
        sku: get(row, "sku") || undefined,
        barcode: get(row, "barcode") || undefined,
        external_id: get(row, "variant_external_id") || undefined,
        image: get(row, "variant_image_url") || undefined,
        pack_size: get(row, "pack_size") || undefined,
      })),
    });
  }
  return { items, skipped: [], notes: [] };
}

// "Material=Cotton|Origin=India"
function parseAttributes(raw: string): Raw | undefined {
  if (!raw) return undefined;
  const out: Raw = {};
  for (const pair of raw.split("|")) {
    const [k, ...rest] = pair.split("=");
    if (k?.trim() && rest.length) out[k.trim()] = rest.join("=").trim();
  }
  return out;
}

// The non-product entities are flat: one row, one record, columns = API keys.
function cordeliaFlat(rows: Row[]): Raw[] {
  return rows
    .filter((r) => !isBlank(r))
    .map((r) => {
      const item: Raw = {};
      for (const [k, v] of Object.entries(r)) {
        const value = (v ?? "").trim();
        if (value === "") continue;
        if (k === "image_url") item.image = value;
        else if (k === "targets" || k === "target_ids") item.targets = splitList(value);
        else item[k] = value;
      }
      return item;
    });
}

// --- shopify format --------------------------------------------------------

// Both header dialects, normalised to one vocabulary.
const SHOPIFY_HEADERS: Record<string, string[]> = {
  handle: ["handle", "url_handle"],
  title: ["title"],
  body: ["body_(html)", "body_html", "description"],
  vendor: ["vendor"],
  product_category: ["product_category", "standardized_product_type"],
  type: ["type", "custom_product_type"],
  tags: ["tags"],
  published: ["published", "published_on_online_store"],
  status: ["status"],
  option1_name: ["option1_name"],
  option1_value: ["option1_value"],
  option2_name: ["option2_name"],
  option2_value: ["option2_value"],
  option3_name: ["option3_name"],
  option3_value: ["option3_value"],
  sku: ["variant_sku", "sku"],
  barcode: ["variant_barcode", "barcode"],
  price: ["variant_price", "price"],
  compare_at: ["variant_compare_at_price", "compare_at_price"],
  inventory_qty: ["variant_inventory_qty", "inventory_quantity"],
  inventory_policy: ["variant_inventory_policy", "continue_selling_when_out_of_stock"],
  image_src: ["image_src", "product_image_url"],
  image_position: ["image_position"],
  variant_image: ["variant_image", "variant_image_url"],
  grams: ["variant_grams", "weight_value_(grams)"],
};

function shopifyField(row: Row, key: string): string {
  for (const h of SHOPIFY_HEADERS[key]) {
    if (row[h] !== undefined) return row[h].trim();
  }
  return "";
}

function hasShopifyHeaders(headers: string[]): boolean {
  return SHOPIFY_HEADERS.handle.some((h) => headers.includes(h)) &&
    SHOPIFY_HEADERS.price.some((h) => headers.includes(h));
}

function stripHtml(html: string): string {
  return html
    .replace(/<br\s*\/?>/gi, "\n")
    .replace(/<\/p>/gi, "\n\n")
    .replace(/<[^>]+>/g, "")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

const FALLBACK_CATEGORY = "Imported";

// Shopify's Excel-proofing: a barcode exported as '9009518582030.
const cleanBarcode = (s: string) => s.replace(/^'+/, "");

function shopifyProducts(
  rows: Row[],
  opts: Pick<ImportOptions, "tagsAsCategories">,
): { items: Raw[]; skipped: ImportReport["skipped"]; notes: string[] } {
  const skipped: ImportReport["skipped"] = [];
  const notes = new Set<string>();
  const groups = new Map<string, { rows: { row: Row; line: number }[] }>();
  const order: string[] = [];
  rows.forEach((row, i) => {
    if (isBlank(row)) return;
    const handle = shopifyField(row, "handle");
    if (!handle) {
      skipped.push({ line: i + 2, reason: "No handle — not a Shopify product row." });
      return;
    }
    if (!groups.has(handle)) {
      groups.set(handle, { rows: [] });
      order.push(handle);
    }
    groups.get(handle)!.rows.push({ row, line: i + 2 });
  });

  const items: Raw[] = [];
  for (const handle of order) {
    const group = groups.get(handle)!.rows;
    const first = group[0].row;
    const title = shopifyField(first, "title");
    if (!title) {
      skipped.push({ line: group[0].line, reason: `"${handle}": first row has no Title.` });
      continue;
    }
    const status = shopifyField(first, "status").toLowerCase();
    const published = shopifyField(first, "published").toLowerCase();
    if ((status && status !== "active") || published === "false") {
      skipped.push({
        line: group[0].line,
        reason: `"${title}" is ${status || "unpublished"} in Shopify — only active, published products import.`,
      });
      continue;
    }

    const optionNames = ([1, 2, 3] as const)
      .map((n) => shopifyField(first, `option${n}_name`))
      .filter((n) => n && n.toLowerCase() !== "title");
    const isSimple = optionNames.length === 0;

    // Every row of the group contributes images (gallery rows carry only
    // handle + image), and every row with a price is a variant.
    const images: string[] = [];
    const variantRows: { row: Row; line: number }[] = [];
    for (const entry of group) {
      const src = shopifyField(entry.row, "image_src");
      if (src && !images.includes(src)) images.push(src);
      if (shopifyField(entry.row, "price")) variantRows.push(entry);
    }
    if (images.length > 1) notes.add("Extra image rows were folded into their product's gallery.");

    const categories: string[] = [];
    const type = shopifyField(first, "type");
    const productCategory = shopifyField(first, "product_category");
    // "Apparel & Accessories > Clothing > Shirts" — the leaf is the
    // category; the path above it is recorded as a note, not built (the
    // merchant's own Type is almost always the level they sell by).
    const leaf = productCategory.split(">").map((s) => s.trim()).filter(Boolean).pop();
    const tags = splitList(shopifyField(first, "tags"));
    if (type) categories.push(type);
    else if (leaf) categories.push(leaf);
    if (opts.tagsAsCategories) categories.push(...tags);
    if (categories.length === 0 && tags.length) {
      // No Type and no taxonomy entry: the tags are the only grouping the
      // merchant gave this product.
      categories.push(...tags);
      notes.add("Products with no Type or Product category were filed under their Tags.");
    }
    if (categories.length === 0) {
      categories.push(FALLBACK_CATEGORY);
      notes.add(`Products with no Type, Product category or Tags were filed under "${FALLBACK_CATEGORY}".`);
    }
    if (type && leaf && leaf !== type) {
      notes.add("Product category paths were not built as a tree; each product's Type became its category.");
    }

    const base: Raw = {
      external_id: handle,
      name: title,
      description: stripHtml(shopifyField(first, "body")),
      images,
      categories: [...new Set(categories)],
      brand: shopifyField(first, "vendor") || undefined,
    };
    const grams = Number(shopifyField(first, "grams"));
    if (grams > 0) {
      base.unit_value = grams;
      base.unit_type = "g";
    }

    const toVariantFields = (row: Row) => {
      const policy = shopifyField(row, "inventory_policy").toLowerCase();
      const qty = shopifyField(row, "inventory_qty");
      return {
        price: shopifyField(row, "price"),
        original_price: shopifyField(row, "compare_at") || undefined,
        stock: qty === "" ? undefined : Math.max(0, Number(qty) || 0),
        sku: shopifyField(row, "sku") || undefined,
        barcode: cleanBarcode(shopifyField(row, "barcode")) || undefined,
        sell_when_out_of_stock: policy === "continue" || policy === "true" ? true : undefined,
      };
    };

    if (isSimple) {
      const v = variantRows[0]?.row ?? first;
      items.push({ ...base, ...toVariantFields(v) });
      continue;
    }
    items.push({
      ...base,
      option_names: optionNames,
      variants: variantRows.map(({ row }) => ({
        options: ([1, 2, 3] as const).slice(0, optionNames.length).map((n) => shopifyField(row, `option${n}_value`)),
        external_id: [handle, ...([1, 2, 3] as const).slice(0, optionNames.length).map((n) => shopifyField(row, `option${n}_value`))].join("/"),
        image: shopifyField(row, "variant_image") || undefined,
        ...toVariantFields(row),
      })),
    });
  }
  if (skipped.some((s) => s.reason.includes("draft") || s.reason.includes("archived") || s.reason.includes("unpublished"))) {
    notes.add("Draft, archived and unpublished Shopify products were skipped.");
  }
  return { items, skipped, notes: [...notes] };
}

// --- the import itself ------------------------------------------------------

function referencedNames(items: Raw[], key: "categories" | "brand"): string[] {
  const names = new Set<string>();
  for (const item of items) {
    const v = item[key];
    if (Array.isArray(v)) v.forEach((x) => names.add(String(x)));
    else if (typeof v === "string" && v) names.add(v);
  }
  return [...names];
}

// Pure: the file → the rows the catalog API validates, plus what the
// adapter dropped or derived. Throws ImportError on a file it can't read.
export function adaptCsv(
  csvText: string,
  opts: Pick<ImportOptions, "entity" | "format" | "tagsAsCategories">,
): { items: Raw[]; skipped: ImportReport["skipped"]; notes: string[]; rowCount: number } {
  if (!csvText.trim()) throw new ImportError("The file is empty.");
  const { rows, headers } = parseCsv(csvText);
  if (headers.length === 0) throw new ImportError("No header row found.");
  const rowCount = rows.filter((r) => !isBlank(r)).length;
  if (rowCount > MAX_UPSERT_ROWS) {
    throw new ImportError(`The file holds ${rowCount} rows; at most ${MAX_UPSERT_ROWS} per import.`, 413);
  }
  if (opts.format === "shopify") {
    if (opts.entity !== "products") throw new ImportError("The Shopify format carries products only.");
    if (!hasShopifyHeaders(headers)) {
      throw new ImportError("This doesn't look like a Shopify products export (no Handle / Price columns).");
    }
    return { ...shopifyProducts(rows, opts), rowCount };
  }
  if (opts.entity === "products") return { ...cordeliaProducts(rows), rowCount };
  return { items: cordeliaFlat(rows), skipped: [], notes: [], rowCount };
}

export async function runImport(
  storeId: string,
  csvText: string,
  opts: ImportOptions,
  actorUid: string,
): Promise<ImportReport> {
  const { items, skipped, notes, rowCount } = adaptCsv(csvText, opts);

  const createdCategories: string[] = [];
  const createdBrands: string[] = [];
  if (opts.createMissing && opts.entity === "products") {
    // Categories and brands the rows name: upsert by name, so existing ones
    // are touched only with what the file knows (nothing) and missing ones
    // are created. Runs before the products so the rows can resolve them.
    const cats = referencedNames(items, "categories");
    if (cats.length) {
      const r = await upsertCatalog(storeId, "categories", cats.map((name) => ({ name })), {
        dryRun: !opts.commit,
        actorUid,
      });
      r.results.forEach((res, i) => {
        if (res.action === "created") createdCategories.push(cats[i]);
      });
    }
    const brands = referencedNames(items, "brand");
    if (brands.length) {
      const r = await upsertCatalog(storeId, "brands", brands.map((name) => ({ name })), {
        dryRun: !opts.commit,
        actorUid,
      });
      r.results.forEach((res, i) => {
        if (res.action === "created") createdBrands.push(brands[i]);
      });
    }
    if (!opts.commit && (createdCategories.length || createdBrands.length)) {
      notes.push(
        `Dry run: ${createdCategories.length} categor${createdCategories.length === 1 ? "y" : "ies"} and ${createdBrands.length} brand${createdBrands.length === 1 ? "" : "s"} would be created first; the product rows below were checked as if they existed.`,
      );
    }
  }

  const outcome = await upsertCatalog(storeId, opts.entity, items, {
    dryRun: !opts.commit,
    actorUid,
    assumeExisting: opts.commit
      ? undefined
      : { categories: createdCategories, brands: createdBrands },
  });

  return {
    format: opts.format,
    entity: opts.entity,
    dry_run: !opts.commit,
    rows_read: rowCount,
    skipped,
    notes,
    created_categories: createdCategories,
    created_brands: createdBrands,
    ...outcome,
  };
}
