/**
 * `npm run verify:import-csv` — regression checks for the CSV import planners
 * (lib/import/*-csv.ts), across all four catalog entities.
 *
 * A script rather than a test suite because `admin/` has no test runner; it
 * follows the `verify:seed-*` convention already here and exits non-zero on
 * failure, so CI can gate on it. It touches no Firestore — the planners are
 * pure, and that is the reason they were written that way.
 *
 * The lesson these checks were rebuilt around: **a fixture built to match the
 * thing it checks proves nothing.** The first version fed the planner a fake
 * store containing exactly the names its sample used, so it confirmed the
 * parser and hid the fact that the sample failed on every real store. The
 * sample checks now vary the *store*, not just the file.
 *
 * It needs `.env.local` only because the module graph pulls in lib/firebase;
 * nothing here connects.
 */
import { buildProductPlan, sampleProductCsv, PRODUCT_COLUMNS } from "@/lib/import/product-csv";
import { buildCategoryPlan, sampleCategoryCsv } from "@/lib/import/category-csv";
import { buildBannerPlan, sampleBannerCsv } from "@/lib/import/banner-csv";
import { buildCouponPlan, sampleCouponCsv } from "@/lib/import/coupon-csv";
import { StoreCatalog } from "@/lib/import/store-catalog";
import type { ImportPlan } from "@/lib/import/csv-core";
import {
  SEED_MARKETS,
  SEED_MARKET_CATALOGS,
  seedMarketForStore,
} from "@/lib/seed/seed-markets";
import type { Banner, Brand, Category, Coupon, Product } from "@/lib/types";

let failures = 0;
function check(label: string, actual: unknown, expected: unknown) {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n        got ${JSON.stringify(actual)} want ${JSON.stringify(expected)}`}`,
  );
}
function messages(plan: ImportPlan<object>) {
  return plan.errors.map((e) => e.message);
}

const products = [
  { id: "p1", name: "Tata Salt" },
  { id: "p2", name: "Amul Gold Milk" },
] as unknown as Product[];
const categories = [
  { id: "c1", name: "Dairy & Eggs" },
  { id: "c2", name: "Grocery & Kitchen" },
  { id: "c3", name: "Fruits & Vegetables" },
] as unknown as Category[];
const brands = [
  { id: "b1", name: "Amul" },
  { id: "b2", name: "Tata" },
] as unknown as Brand[];

const stocked = new StoreCatalog({ products, categories, brands });
const bare = new StoreCatalog({ products: [], categories: [], brands: [] });
const noProducts = new StoreCatalog({ products: [], categories, brands });

const shapes: Array<[string, StoreCatalog]> = [
  ["empty store", bare],
  ["unrelated categories", noProducts],
  ["seeded-looking store", stocked],
];

const banners: Banner[] = [];
const coupons: Coupon[] = [];

// ── 1. Every sample, every market, every shape of store ────────────────────
// The one check that would have caught the original bug: a downloaded sample
// must import cleanly into the store that downloaded it, including stores
// sharing none of the seed catalog's names.
for (const market of SEED_MARKETS) {
  const seed = SEED_MARKET_CATALOGS[market];
  for (const [shapeLabel, shape] of shapes) {
    check(
      `product sample[${market}] into ${shapeLabel}`,
      (() => {
        const plan = buildProductPlan(sampleProductCsv(seed, shape), shape);
        return [messages(plan), plan.writes.length > 0];
      })(),
      [[], true],
    );
    check(
      `category sample[${market}] into ${shapeLabel}`,
      (() => {
        const plan = buildCategoryPlan(sampleCategoryCsv(seed, shape), shape);
        return [messages(plan), plan.writes.length > 0];
      })(),
      [[], true],
    );
    check(
      `banner sample[${market}] into ${shapeLabel}`,
      (() => {
        const plan = buildBannerPlan(sampleBannerCsv(seed, shape), shape, banners);
        return [messages(plan), plan.writes.length > 0];
      })(),
      [[], true],
    );
    check(
      `coupon sample[${market}] into ${shapeLabel}`,
      (() => {
        const plan = buildCouponPlan(sampleCouponCsv(seed, shape), shape, coupons);
        return [messages(plan), plan.writes.length > 0];
      })(),
      [[], true],
    );
  }

  // Image URLs survive the round-trip as complete, literal URLs. The seed
  // files build them from a shared `IMG` base with a template literal, which
  // resolves at module load — but a description holding an unescaped comma
  // would shift the column and land a sentence fragment in it, so this reads
  // the value back through the parser rather than trusting the writer.
  const productPlan = buildProductPlan(sampleProductCsv(seed, bare), bare);
  const bannerPlan = buildBannerPlan(sampleBannerCsv(seed, bare), bare, banners);
  const literalHttps = (u: string) => /^https:\/\/\S+$/.test(u) && !u.includes("${");
  check(
    `sample[${market}]: product + banner image_urls are literal https`,
    [
      productPlan.writes.every((w) => literalHttps(w.data.imageUrl)),
      bannerPlan.writes.every((w) => literalHttps(w.data.imageUrl)),
    ],
    [true, true],
  );
}

// ── 2. Samples follow the store, not the seed ──────────────────────────────
const indiaSeed = SEED_MARKET_CATALOGS.india;
check(
  "product sample: no categories in store -> column blank",
  buildProductPlan(sampleProductCsv(indiaSeed, bare), bare).writes.every(
    (w) => w.data.categoryIds.length === 0,
  ),
  true,
);
check(
  "product sample: store's own category borrowed when the seed's don't match",
  buildProductPlan(sampleProductCsv(indiaSeed, noProducts), noProducts).writes.every(
    (w) => w.data.categoryIds.length > 0,
  ),
  true,
);
check(
  "banner sample: unresolvable target degrades to display-only",
  buildBannerPlan(sampleBannerCsv(indiaSeed, bare), bare, banners).writes.every(
    (w) => w.data.targetType === "none" && w.data.targetId === "",
  ),
  true,
);
check(
  "coupon sample: only whole-order coupons survive an empty store",
  buildCouponPlan(sampleCouponCsv(indiaSeed, bare), bare, coupons).writes.every(
    (w) => w.data.scope === "store" && w.data.targetIds.length === 0,
  ),
  true,
);

// ── 3. Products: parsing and validation ────────────────────────────────────
const PH = PRODUCT_COLUMNS.map((c) => c.key).join(",");

const excel = buildProductPlan(
  "﻿Name,Price,Unit_Value,UNIT TYPE,Stock\r\nSugar,55,1000,g,10\r\n",
  stocked,
);
check("products/excel: BOM+CRLF+case+reorder parses", [messages(excel), excel.writes.length, excel.writes[0]?.kind], [[], 1, "create"]);

const badProducts = buildProductPlan(
  [
    PH,
    ",10,,1,g,1,,,,,,,,,,",              // no name
    "A,0,,1,g,1,,,,,,,,,,",              // price 0
    "B,10,5,1,g,1,,,,,,,,,,",            // original below price
    "C,10,,abc,g,1,,,,,,,,,,",           // unit_value not a number
    "D,10,,1,kg,1,,,,,,,,,,",            // bad unit_type
    "E,10,,1,g,1.5,,,,,,,,,,",           // fractional stock
    "F,10,,1,g,-1,,,,,,,,,,",            // negative stock
    "G,10,,1,g,1,,,,Beverges,,,,,,",     // unknown category
    "H,10,,1,g,1,,,,,Nestle,,,,,",       // unknown brand
    "I,10,,1,g,1,,,,,,maybe,,,,",        // bad boolean
    "J,10,,1,g,1,,,,,,,,,,nope",         // unknown id
    "K,10,,1,g,1,,,,,,,,,,",
    "K,11,,1,g,1,,,,,,,,,,",             // duplicate
  ].join("\n"),
  stocked,
);
check("products: 12 rows rejected", badProducts.errors.length, 12);
check("products: only K planned", badProducts.writes.map((w) => w.name), ["K"]);
check("products: line numbers are 1-based incl. header", badProducts.errors[0].line, 2);
check("products: duplicate names the first line", badProducts.errors[11].message.includes("line 13"), true);

// v2: a non-packaged product leaves unit_value/unit_type blank.
const unpackaged = buildProductPlan(`${PH}\nTee,499,,,,3,,,,,,,TEE-M,8901234567890,shopify-tee,`, stocked);
check(
  "products: blank unit fields accepted, codes carried",
  [
    messages(unpackaged),
    unpackaged.writes[0]?.data.unitValue,
    unpackaged.writes[0]?.data.unitType,
    unpackaged.writes[0]?.data.sku,
    unpackaged.writes[0]?.data.barcode,
    unpackaged.writes[0]?.data.externalId,
  ],
  [[], 0, "g", "TEE-M", "8901234567890", "shopify-tee"],
);

const noPrice = buildProductPlan("name,unit_value,unit_type,stock\nX,1,g,1\n", stocked);
check("products: missing column rejected wholesale", [noPrice.writes.length, noPrice.errors.length, noPrice.errors[0].message.includes("price")], [0, 1, true]);

const money = buildProductPlan(`${PH}\nY,"₹1,299.00","₹1,499.00",1,pcs,5,,,,,,,,,,`, stocked);
check("products: currency glyph + separators parsed", [messages(money), money.writes[0]?.data.price, money.writes[0]?.data.originalPrice], [[], 1299, 1499]);

const byId = buildProductPlan(`${PH}\nRenamed Salt,30,,1000,g,5,,,,,,,,,,p1`, stocked);
check("products: id column beats name match", [byId.writes[0]?.kind, byId.writes[0]?.id, byId.writes[0]?.data.name], ["update", "p1", "Renamed Salt"]);

const casing = buildProductPlan(`${PH}\n  tata SALT ,30,,1000,g,5,,,,  grocery & KITCHEN ,  tata  ,,,,,`, stocked);
check("products: case-insensitive product/category/brand match", [messages(casing), casing.writes[0]?.kind, casing.writes[0]?.data.categoryIds, casing.writes[0]?.data.brandId], [[], "update", ["c2"], "b2"]);

const multi = buildProductPlan(`${PH}\nZ,10,,1,g,1,,,,Dairy & Eggs|Fruits & Vegetables,,,,,,`, stocked);
check("products: multi-category split on |", multi.writes[0]?.data.categoryIds, ["c1", "c3"]);

const freshStore = buildProductPlan(`${PH}\nSugar,55,,1000,g,10,,,,,,,,,,\nRice,80,,5000,g,4,,,,Grains,,,,,,`, bare);
check("products: empty store imports the uncategorised row", [freshStore.writes.length, freshStore.writes[0]?.data.categoryIds], [1, []]);
check("products: empty store fails the categorised row actionably", [freshStore.errors.length, freshStore.errors[0]?.message.includes("Categories page")], [1, true]);

// ── 4. Categories ──────────────────────────────────────────────────────────
const cats = buildCategoryPlan(
  [
    "name,image_url,group_name,id",
    "Bakery,https://x/y.png,Grocery & Kitchen,",
    "Dairy & Eggs,,,",                  // matches an existing category by name
    ",,,",                              // no name
    "Bakery,,,",                        // duplicate within the file
    "Ghost,,,badid",                    // unknown id
  ].join("\n"),
  stocked,
);
// v2: parent must already exist in the store; a category can't parent itself.
const tree = buildCategoryPlan(
  [
    "name,parent,external_id,id",
    "Milk,Dairy & Eggs,shopify-milk,",      // under an existing category
    "Cheese,Nowhere,,",                     // unknown parent
    "Dairy & Eggs,Dairy & Eggs,,c1",        // self-parent
  ].join("\n"),
  stocked,
);
check(
  "categories: parent resolved by name, unknown and self refused",
  [tree.writes.map((w) => [w.name, w.data.parentId, w.data.externalId]), tree.errors.map((e) => e.name)],
  [[["Milk", "c1", "shopify-milk"]], ["Cheese", "Dairy & Eggs"]],
);
// The all-blank row is skipped, not rejected — a spacer or trailing newline
// is a spreadsheet artefact, not something the owner meant to import.
check("categories: 2 planned, 2 rejected (blank row skipped)", [cats.writes.length, cats.errors.length], [2, 2]);

// Line numbers must survive blank rows. Papaparse's skipEmptyLines would drop
// them from the data array and shift every later row's index, sending the
// owner to the wrong line for every error after the gap.
const spaced = buildCategoryPlan("name,image_url,group_name,id\nGood,,,\n,,,\n,,,badid\n", bare);
check("blank rows don't shift line numbers", spaced.errors.map((e) => e.line), [4]);
check("blank rows aren't themselves errors", spaced.errors.length, 1);
check("categories: existing name -> update", cats.writes.find((w) => w.name === "Dairy & Eggs")?.kind, "update");
check("categories: new name -> create", cats.writes.find((w) => w.name === "Bakery")?.kind, "create");
check("categories: blank group defaults", cats.writes.find((w) => w.name === "Dairy & Eggs")?.data.groupName, "Uncategorized");

// ── 5. Banners ─────────────────────────────────────────────────────────────
const BH = "title,subtitle,image_url,target_type,target,sort_order,is_active,background_color,id";
const bans = buildBannerPlan(
  [
    BH,
    "Fresh deals,Up to 40% off,https://x/a.png,category,Dairy & Eggs,1,true,#FFAA00,",
    "Salt promo,,https://x/b.png,product,Tata Salt,2,,,",
    "Plain,,https://x/c.png,,,,,,",                       // display-only
    "No art,,,none,,,,,",                                 // missing image_url
    "Bad type,,https://x/d.png,page,X,,,,",                // bad target_type
    "Ghost cat,,https://x/e.png,category,Nope,,,,",        // unknown target
    "Stray,,https://x/f.png,none,Something,,,,",           // target with none
    "Bad hex,,https://x/g.png,none,,,,red,",               // bad colour
    "Bad order,,https://x/h.png,none,,1.5,,,",             // fractional sort_order
  ].join("\n"),
  stocked,
  banners,
);
check("banners: 3 planned, 6 rejected", [bans.writes.length, bans.errors.length], [3, 6]);
check("banners: category target resolved to id", bans.writes[0]?.data.targetId, "c1");
check("banners: product target resolved to id", bans.writes[1]?.data.targetId, "p1");
check("banners: blank target_type -> none", [bans.writes[2]?.data.targetType, bans.writes[2]?.data.targetId], ["none", ""]);
check("banners: blank is_active defaults true", bans.writes[1]?.data.isActive, true);

// ── 6. Coupons ─────────────────────────────────────────────────────────────
const CH = "code,type,value,scope,targets,min_order_value,max_discount,valid_from,valid_until,usage_limit,per_user_limit,is_active,id";
const cous = buildCouponPlan(
  [
    CH,
    "save10,percent,10,store,,200,50,2026-08-01,2026-08-31,100,1,true,",
    "DAIRY5,flat,5,category,Dairy & Eggs,0,0,,,0,0,,",
    ",percent,10,store,,,,,,,,,",                          // no code
    "BADTYPE,half,10,store,,,,,,,,,",                      // bad type
    "OVER,percent,120,store,,,,,,,,,",                     // percent > 100
    "ZERO,flat,0,store,,,,,,,,,",                          // value 0
    "BADSCOPE,flat,5,shop,,,,,,,,,",                       // bad scope
    "STRAY,flat,5,store,Dairy & Eggs,,,,,,,,",             // targets with store scope
    "NOTARGET,flat,5,category,,,,,,,,,",                   // scoped, no targets
    "GHOST,flat,5,category,Nope,,,,,,,,",                  // unknown target
    "BADDATE,flat,5,store,,,,not-a-date,,,,,",             // bad valid_from
    "BACKWARDS,flat,5,store,,,,2026-08-31,2026-08-01,,,,", // until before from
    "NEG,flat,5,store,,-1,,,,,,,",                         // negative minimum
  ].join("\n"),
  stocked,
  coupons,
);
check("coupons: 2 planned, 11 rejected", [cous.writes.length, cous.errors.length], [2, 11]);
check("coupons: code uppercased", cous.writes[0]?.data.code, "SAVE10");
check("coupons: category target resolved to id", cous.writes[1]?.data.targetIds, ["c1"]);
check("coupons: blank scope defaults to store", buildCouponPlan(`${CH}\nX,flat,5,,,,,,,,,,`, stocked, coupons).writes[0]?.data.scope, "store");
check("coupons: blank numerics default to 0", [cous.writes[1]?.data.minOrderValue, cous.writes[1]?.data.usageLimit], [0, 0]);
check(
  "coupons: existing code -> update (case-insensitively)",
  buildCouponPlan(`${CH}\nsave10,percent,20,store,,,,,,,,,`, stocked, [
    { id: "cp1", code: "SAVE10" } as unknown as Coupon,
  ]).writes[0],
  { line: 2, kind: "update", id: "cp1", name: "SAVE10", data: { code: "SAVE10", type: "percent", value: 20, scope: "store", targetIds: [], minOrderValue: 0, maxDiscount: 0, validFrom: "", validUntil: "", usageLimit: 0, perUserLimit: 0, isActive: true } },
);

// ── 7. Market resolution ───────────────────────────────────────────────────
check("market: fr store on EUR -> france (not germany)", seedMarketForStore("fr", "EUR"), "france");
check("market: it store on EUR -> italy", seedMarketForStore("it", "EUR"), "italy");
check("market: hi store -> india", seedMarketForStore("hi", "INR"), "india");
check("market: en falls through to currency", [seedMarketForStore("en", "GBP"), seedMarketForStore("en", "USD"), seedMarketForStore("en", "INR")], ["uk", "us", "india"]);

console.log(failures === 0 ? "\nAll checks passed." : `\n${failures} FAILED`);
process.exit(failures === 0 ? 0 : 1);
