/**
 * `npm run verify:import-csv` — regression checks for CSV import, run against
 * the server's own planner with no Firestore: `adaptCsv` turns a file into
 * rows, `planCatalog` validates them against a catalog snapshot built from
 * plain records. Same code the /import route runs; only the reads and the
 * batch commit are outside it.
 *
 * 1. Every sample CSV the console offers, for every market, imports cleanly
 *    into three shapes of store — including one sharing none of the seed's
 *    names (the bug that motivated this file).
 * 2. The rules, one fixture per entity: required fields, bad numbers, unknown
 *    references, duplicates, ids, case-insensitive matching, variants.
 * 3. The Shopify fixtures under admin/fixtures/shopify: dialect, grouping,
 *    variants, galleries, drafts, categories and brands to create.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { planCatalog, snapshotFrom, type CatalogEntity } from "@/lib/api/v1/catalog";
import { adaptCsv } from "@/lib/api/v1/import";
import { PRODUCT_COLUMNS, sampleProductCsv } from "@/lib/import/product-csv";
import { sampleCategoryCsv } from "@/lib/import/category-csv";
import { sampleBannerCsv } from "@/lib/import/banner-csv";
import { sampleCouponCsv } from "@/lib/import/coupon-csv";
import { StoreCatalog } from "@/lib/import/store-catalog";
import { SEED_MARKETS, SEED_MARKET_CATALOGS } from "@/lib/seed/seed-markets";
import type { Brand, Category, Product } from "@/lib/types";

let failures = 0;
function check(label: string, actual: unknown, expected: unknown) {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n        got ${JSON.stringify(actual)} want ${JSON.stringify(expected)}`}`,
  );
}

const products = [
  { id: "p1", name: "Tata Salt", externalId: "", variants: [], optionNames: [], categoryIds: ["c2"], images: [], attributes: {}, price: 30, originalPrice: 30, stock: 5 },
  { id: "p2", name: "Amul Gold Milk", externalId: "ext-milk", variants: [], optionNames: [], categoryIds: ["c1"], images: [], attributes: {}, price: 60, originalPrice: 60, stock: 5 },
] as unknown as Product[];
const categories = [
  { id: "c1", name: "Dairy & Eggs", parentId: "", externalId: "" },
  { id: "c2", name: "Grocery & Kitchen", parentId: "", externalId: "" },
  { id: "c3", name: "Fruits & Vegetables", parentId: "", externalId: "" },
] as unknown as Category[];
const brands = [
  { id: "b1", name: "Amul", externalId: "" },
  { id: "b2", name: "Tata", externalId: "" },
] as unknown as Brand[];

type Shape = { products: Product[]; categories: Category[]; brands: Brand[] };
// The sample generators take the console's StoreCatalog; the planner takes a
// snapshot. Both built from the same records.
const shapes: Array<[string, Shape]> = [
  ["empty store", { products: [], categories: [], brands: [] }],
  ["unrelated categories", { products: [], categories, brands }],
  ["seeded-looking store", { products, categories, brands }],
];

let ids = 0;
const newId = () => `new${++ids}`;

type Data = Record<string, unknown>;
function run(csv: string, entity: CatalogEntity, shape: Shape, format: "cordelia" | "shopify" = "cordelia") {
  const { items, skipped, notes } = adaptCsv(csv, { entity, format, tagsAsCategories: false });
  const planned = planCatalog(entity, items, snapshotFrom(shape), newId);
  const errors = planned.flatMap((p) => ("errors" in p ? p.errors : []));
  const writes = planned.filter((p): p is { index: number; id: string; data: Data; action: "created" | "updated" } => !("errors" in p));
  return {
    errors,
    created: writes.filter((w) => w.action === "created").length,
    updated: writes.filter((w) => w.action === "updated").length,
    writes,
    skipped,
    notes,
    items,
  };
}

// ── 1. Every sample, every market, every shape of store ────────────────────
for (const market of SEED_MARKETS) {
  const seed = SEED_MARKET_CATALOGS[market];
  for (const [label, shape] of shapes) {
    const catalog = new StoreCatalog(shape);
    for (const [entity, csv] of [
      ["products", sampleProductCsv(seed, catalog)],
      ["categories", sampleCategoryCsv(seed, catalog)],
      ["banners", sampleBannerCsv(seed, catalog)],
      ["coupons", sampleCouponCsv(seed, catalog)],
    ] as const) {
      const r = run(csv, entity, shape);
      check(`${entity} sample[${market}] into ${label}`, [r.errors, r.created + r.updated > 0], [[], true]);
    }
  }
  const r = run(sampleProductCsv(seed, new StoreCatalog(shapes[0][1])), "products", shapes[0][1]);
  const literalHttps = (u: unknown) => typeof u === "string" && /^https:\/\/\S+$/.test(u) && !u.includes("${");
  check(
    `sample[${market}]: product image urls are literal https`,
    r.writes.every((w) => (w.data.images as string[]).every(literalHttps)),
    true,
  );
}

// ── 2. Rules ───────────────────────────────────────────────────────────────
const PH = PRODUCT_COLUMNS.map((c) => c.key).join(",");
const stocked = shapes[2][1];
const bare = shapes[0][1];

const bad = run(
  [
    PH,
    ",10,,1,g,1,,,,Dairy & Eggs,,,,,,",         // no name
    "A,0,,1,g,1,,,,Dairy & Eggs,,,,,,",         // price 0
    "B,10,5,1,g,1,,,,Dairy & Eggs,,,,,,",       // original below price
    "C,10,,abc,g,1,,,,Dairy & Eggs,,,,,,",      // unit_value not a number
    "D,10,,1,kg,1,,,,Dairy & Eggs,,,,,,",       // bad unit_type
    "E,10,,1,g,1.5,,,,Dairy & Eggs,,,,,,",      // fractional stock
    "F,10,,1,g,-1,,,,Dairy & Eggs,,,,,,",       // negative stock
    "G,10,,1,g,1,,,,Beverges,,,,,,",            // unknown category
    "H,10,,1,g,1,,,,Dairy & Eggs,Nestle,,,,,",  // unknown brand
    "I,10,,1,g,1,,,,Dairy & Eggs,,maybe,,,,",   // bad boolean
    "J,10,,1,g,1,,,,Dairy & Eggs,,,,,,nope",    // unknown id
    "K,10,,1,g,1,,,,Dairy & Eggs,,,,,,",
    "Whisky,10,,1,g,1,,,,Dairy & Eggs,,,,,,",   // restricted
  ].join("\n"),
  "products",
  stocked,
);
check("products: every bad row refused, K alone planned", [bad.writes.length, bad.created], [1, 1]);
check("products: unknown category named", bad.errors.some((e) => e.includes("Beverges")), true);
check("products: unknown id refused", bad.errors.some((e) => e.includes("nope")), true);
check("products: restricted term caught", bad.errors.some((e) => e.includes("whisky")), true);

const dup = run(`${PH}\nK,10,,1,g,1,,,,Dairy & Eggs,,,,,,\nk,11,,1,g,1,,,,Dairy & Eggs,,,,,,`, "products", stocked);
check("products: same name twice in one file folds into one record", [dup.created, dup.updated], [1, 0]);

const unpackaged = run(`${PH}\nTee,499,,,,3,,,,Dairy & Eggs,,,TEE-M,8901234567890,shopify-tee,`, "products", stocked);
const tee = unpackaged.writes[0]?.data ?? {};
check(
  "products: blank unit fields accepted, codes carried",
  [unpackaged.errors, tee.unitValue, tee.unitType, tee.sku, tee.barcode, tee.externalId],
  [[], 0, "g", "TEE-M", "8901234567890", "shopify-tee"],
);

const money = run(`${PH}\nY,"₹1,299.00","₹1,499.00",1,pcs,5,,,,Dairy & Eggs,,,,,,`, "products", stocked);
check("products: currency glyph + separators parsed", [money.errors, money.writes[0]?.data.price, money.writes[0]?.data.originalPrice], [[], 1299, 1499]);

const byId = run(`${PH}\nRenamed Salt,30,,1000,g,5,,,,Dairy & Eggs,,,,,,p1`, "products", stocked);
check("products: id column beats name match", [byId.updated, byId.writes[0]?.id], [1, "p1"]);

const byExt = run(`${PH}\nRenamed Milk,70,,,,5,,,,Dairy & Eggs,,,,,ext-milk,`, "products", stocked);
check("products: external_id matches before name", [byExt.updated, byExt.writes[0]?.id], [1, "p2"]);

const casing = run(`${PH}\n  tata SALT ,30,,1000,g,5,,,,  grocery & KITCHEN ,  tata  ,,,,,`, "products", stocked);
check("products: case-insensitive product/category/brand match", [casing.errors, casing.updated, casing.writes[0]?.data.categoryIds, casing.writes[0]?.data.brandId], [[], 1, ["c2"], "b2"]);

const multi = run(`${PH}\nZ,10,,1,g,1,,,,Dairy & Eggs|Fruits & Vegetables,,,,,,`, "products", stocked);
check("products: multi-category split on |", multi.writes[0]?.data.categoryIds, ["c1", "c3"]);

// Variant rows: one row per variant, option columns filled, grouped by name.
const VH = `${PH},option1_name,option1_value,option2_name,option2_value`;
const dupCombo = run(
  [
    VH,
    "Tee,499,599,,,3,Soft,,,Dairy & Eggs,,,TEE-M-RED,,tee,,Size,M,Colour,Red",
    "Tee,449,,,,5,,,,,,,TEE-L-RED,,tee,,,L,,Red",
    "Tee,449,,,,5,,,,,,,TEE-L-RED,,tee,,,L,,Red",
  ].join("\n"),
  "products",
  stocked,
);
check("products: variant rows refused when a combo repeats", dupCombo.errors.some((e) => e.includes("Duplicate variant")), true);
const variants = run(
  [
    VH,
    "Tee,499,599,,,3,Soft,,,Dairy & Eggs,,,TEE-M-RED,,tee,,Size,M,Colour,Red",
    "Tee,449,,,,5,,,,,,,TEE-L-RED,,tee,,,L,,Red",
  ].join("\n"),
  "products",
  stocked,
);
const t = variants.writes[0]?.data ?? {};
check(
  "products: variant rows become one product with derived summary",
  [variants.errors, variants.created, t.optionNames, (t.variants as { options: string[]; stock: number }[] | undefined)?.map((v) => [v.options, v.stock]), t.price, t.stock],
  [[], 1, ["Size", "Colour"], [[["M", "Red"], 3], [["L", "Red"], 5]], 449, 8],
);

// Categories: parent by name, unknown and self refused.
const tree = run(
  ["name,parent,external_id,id", "Milk,Dairy & Eggs,shopify-milk,", "Cheese,Nowhere,,", "Dairy & Eggs,Dairy & Eggs,,c1"].join("\n"),
  "categories",
  stocked,
);
check(
  "categories: parent resolved by name, unknown and self refused",
  [tree.writes.map((w) => [w.data.name, w.data.parentId, w.data.externalId]), tree.errors.length],
  [[["Milk", "c1", "shopify-milk"]], 2],
);
const spaced = run("name,image_url,group_name,id\nGood,,,\n,,,\n,,,badid\n", "categories", bare);
check("categories: blank row skipped, unknown id refused", [spaced.created, spaced.errors.length], [1, 1]);

// Coupons and banners resolve their targets by name.
const coupon = run(
  ["code,type,value,scope,targets", "SAVE10,percent,10,category,Dairy & Eggs", "BIG,percent,120,store,", "FLAT,flat,50,product,Nowhere"].join("\n"),
  "coupons",
  stocked,
);
check("coupons: category target by name; >100% and unknown product refused", [coupon.created, coupon.errors.length, coupon.writes[0]?.data.targetIds], [1, 2, ["c1"]]);
const banner = run(
  ["title,image_url,target_type,target,sort_order", "Hero,https://x/y.png,product,Tata Salt,1", "Broken,,none,,0"].join("\n"),
  "banners",
  stocked,
);
check("banners: product target by name; missing image refused", [banner.created, banner.errors.length, banner.writes[0]?.data.targetId], [1, 1, "p1"]);

// ── 3. Shopify fixtures ────────────────────────────────────────────────────
const fixture = (name: string) => readFileSync(join(__dirname, "..", "fixtures", "shopify", name), "utf8");

const apparel = adaptCsv(fixture("apparel.csv"), { entity: "products", format: "shopify", tagsAsCategories: false });
check("shopify/apparel: 22 rows → 20 products", [apparel.rowCount, apparel.items.length], [22, 20]);
const varsity = apparel.items.find((i) => i.external_id === "classic-varsity-top") ?? {};
check(
  "shopify/apparel: Size variants, tags as categories when no Type, vendor as brand",
  [varsity.option_names, (varsity.variants as { options: string[] }[] | undefined)?.map((v) => v.options[0]), varsity.categories, varsity.brand],
  [["Size"], ["Small", "Medium", "Large"], ["women"], "partners-demo"],
);
check("shopify/apparel: Default Title = simple product", apparel.items.filter((i) => !i.option_names).length, 19);

const snow = adaptCsv(fixture("snowdevil.csv"), { entity: "products", format: "shopify", tagsAsCategories: false });
check("shopify/snowdevil: 636 rows → 277 active products, 1 draft skipped", [snow.rowCount, snow.items.length, snow.skipped.length], [636, 277, 1]);
const glove = snow.items.find((i) => i.external_id === "burton-approach-under-glove-2016") ?? {};
const gloveVariants = (glove.variants as { options: string[]; barcode: string }[] | undefined) ?? [];
check(
  "shopify/snowdevil: two-axis variants, apostrophe stripped from barcodes, Type as category",
  [glove.option_names, gloveVariants[0]?.options, gloveVariants[0]?.barcode, glove.categories],
  [["Size", "Color"], ["Medium", "True Black"], "9009518582030", ["Gloves"]],
);
check("shopify/snowdevil: galleries folded from image rows", snow.items.some((i) => (i.images as string[]).length > 1), true);
const snowShape: Shape = {
  products: [],
  categories: [...new Set(snow.items.flatMap((i) => i.categories as string[]))].map((name, n) => ({ id: `sc${n}`, name, parentId: "", externalId: "" }) as unknown as Category),
  brands: [...new Set(snow.items.map((i) => i.brand as string))].map((name, n) => ({ id: `sb${n}`, name, externalId: "" }) as unknown as Brand),
};
const snowPlan = planCatalog("products", snow.items, snapshotFrom(snowShape), newId);
check(
  "shopify/snowdevil: same Title under two handles stays two products; only the restricted names fail",
  [snowPlan.filter((p) => !("errors" in p) && p.action === "created").length, snowPlan.filter((p) => "errors" in p).length],
  [275, 2],
);

// ── 4. WooCommerce fixture ─────────────────────────────────────────────────
const woo = adaptCsv(readFileSync(join(__dirname, "..", "fixtures", "woocommerce", "sample_products.csv"), "utf8"), { entity: "products", format: "woocommerce", tagsAsCategories: false });
check("woocommerce: 25 rows → 14 products, 4 skipped with reasons", [woo.rowCount, woo.items.length, woo.skipped.length], [25, 14, 4]);
check("woocommerce: category paths become a tree", woo.categoryPaths, [["Clothing", "Hoodies"], ["Clothing", "Tshirts"], ["Clothing", "Accessories"]]);
const hoodie = woo.items.find((i) => i.external_id === "woo-hoodie") ?? {};
const hoodieVariants = (hoodie.variants as { options: string[]; price: string; original_price?: string; sku?: string }[] | undefined) ?? [];
check(
  "woocommerce: variable product → two axes from variations, sale price as price with regular as compare-at",
  [hoodie.option_names, hoodieVariants.map((v) => [v.options, v.price, v.original_price ?? null])],
  [["Color", "Logo"], [[["Red", "No"], "42", "45"], [["Green", "No"], "45", null], [["Blue", "No"], "45", null], [["Blue", "Yes"], "45", null]]],
);
const vneck = woo.items.find((i) => i.external_id === "woo-vneck-tee") ?? {};
check("woocommerce: an axis left blank on every variation is dropped", vneck.option_names, ["Color"]);
const beanie = woo.items.find((i) => i.external_id === "woo-beanie") ?? {};
check("woocommerce: simple product keeps attributes as a spec list; sale price wins", [beanie.attributes, beanie.price, beanie.original_price], [{ Color: "Red" }, "18", "20"]);
check("woocommerce: untracked stock flagged", woo.notes.some((n) => n.includes("no stock count")), true);
const wooPlan = planCatalog("products", woo.items, snapshotFrom({ products: [], categories: ["Clothing", "Hoodies", "Tshirts", "Accessories"].map((name, n) => ({ id: `wc${n}`, name, parentId: n ? "wc0" : "", externalId: "" }) as unknown as Category), brands: [] }), newId);
check("woocommerce: every product validates against the created tree", [wooPlan.filter((p) => "errors" in p).length, wooPlan.length], [0, 14]);

// ── 5. Meta / WhatsApp catalog fixture ─────────────────────────────────────
const meta = adaptCsv(readFileSync(join(__dirname, "..", "fixtures", "meta-catalog", "meta_catalog_feed.csv"), "utf8"), { entity: "products", format: "meta", tagsAsCategories: false });
check("meta: 7 rows → 4 products, archived item skipped", [meta.items.length, meta.skipped.map((s) => s.line)], [4, [7]]);
const shirt = meta.items.find((i) => i.external_id === "FB1234_shirts") ?? {};
check(
  "meta: item_group_id → one product; only fields that differ become axes, constants become details",
  [shirt.option_names, (shirt.variants as { options: string[]; price: string; original_price?: string; stock: number }[] | undefined)?.map((v) => [v.options, v.price, v.original_price ?? null, v.stock]), shirt.attributes, shirt.brand, (shirt.images as string[]).length],
  [["Size", "Color"], [[["small", "blue"], "4.99", "9.99", 200], [["medium", "blue"], "9.99", null, 150], [["small", "red"], "9.99", null, 0]], { Material: "cotton" }, "Facebook", 3],
);
const bottle = meta.items.find((i) => i.external_id === "FB_product_2001") ?? {};
check("meta: \"1,299.00 INR\" parses; sale price charged; gtin → barcode; product_type leaf → category", [bottle.price, bottle.original_price, bottle.barcode, bottle.categories], ["999.00", "1299.00", "8901234567890", ["Bottles"]]);
const tote = meta.items.find((i) => i.external_id === "FB_product_2002") ?? {};
check("meta: available for order → sells past zero", [tote.stock, tote.sell_when_out_of_stock], [0, true]);
check("meta: product_type paths become a tree", meta.categoryPaths, [["Apparel & Accessories", "Clothing", "Shirts"], ["Kitchen", "Bottles"], ["Accessories", "Bags"], ["Drinks"]]);
const metaPlan = planCatalog("products", meta.items, snapshotFrom({ products: [], categories: ["Shirts", "Bottles", "Bags", "Drinks"].map((name, n) => ({ id: `m${n}`, name, parentId: "", externalId: "" }) as unknown as Category), brands: [{ id: "mb0", name: "Facebook", externalId: "" } as unknown as Brand, { id: "mb1", name: "Hydro", externalId: "" } as unknown as Brand] }), newId);
check("meta: everything validates except the beer, refused by the restricted list", [metaPlan.filter((p) => !("errors" in p)).length, metaPlan.flatMap((p) => ("errors" in p ? p.errors : [])).some((e) => e.includes("beer"))], [3, true]);

const modern = adaptCsv(
  ["Title,URL handle,Description,Vendor,Type,Option1 name,Option1 value,Price,Inventory quantity,Product image URL", "Mug,mug,A mug,Acme,Kitchen,Title,Default Title,9.5,4,https://x/mug.png"].join("\n"),
  { entity: "products", format: "shopify", tagsAsCategories: false },
);
check("shopify: 2024+ header dialect parses", [modern.items.length, modern.items[0]?.price, modern.items[0]?.categories, modern.items[0]?.images], [1, "9.5", ["Kitchen"], ["https://x/mug.png"]]);

if (failures > 0) {
  console.error(`\n${failures} check(s) failed`);
  process.exit(1);
}
console.log("\nAll checks passed.");
