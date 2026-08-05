// Checks every market catalog's internal references:
//   npm run verify:seed-refs
//
// The seeder resolves slugs → freshly minted doc ids and `.filter()`s away any
// slug it cannot find (seed-grocery.ts). That is the right behaviour at write
// time — a partial reference shouldn't abort a 200-doc batch — but it means a
// typo'd `categorySlug` silently seeds a product into no aisle at all, and a
// typo'd coupon target silently seeds a coupon that discounts nothing. Neither
// shows up in a type check, an image check or a band check.
//
// Also flags declared-but-unused brands, which are just dead docs in the
// store.

import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const FILES = [
  ["india", "grocery-seed-data.ts"],
  ["germany", "germany-seed-data.ts"],
  ["france", "france-seed-data.ts"],
];

const seedDir = join(dirname(fileURLToPath(import.meta.url)), "../src/lib/seed");

// Slice the source into its five array blocks so a `slug:` can be attributed
// to the right collection. Parsing TS properly would need a toolchain the
// scripts/ directory deliberately does not have.
function block(source, key, next) {
  const start = source.indexOf(`${key}: [`);
  const end = next ? source.indexOf(`${next}: [`) : source.length;
  if (start === -1 || end === -1 || end < start) return "";
  return source.slice(start, end);
}

const slugsIn = (text) => [...text.matchAll(/^ {6}slug: "([^"]+)",$/gm)].map((m) => m[1]);

let failed = false;

for (const [market, file] of FILES) {
  const source = await readFile(join(seedDir, file), "utf8");
  const problems = [];

  const categories = block(source, "categories", "brands");
  const brands = block(source, "brands", "products");
  const products = block(source, "products", "coupons");
  const coupons = block(source, "coupons", "banners");
  const banners = block(source, "banners", null);

  const categorySlugs = new Set(slugsIn(categories));
  // Brands are one-per-line objects, not indented blocks.
  const brandSlugs = new Set(
    [...brands.matchAll(/\{ slug: "([^"]+)", name:/g)].map((m) => m[1]),
  );
  const productSlugList = slugsIn(products);
  const productSlugs = new Set(productSlugList);

  const dup = (list, what) => {
    const seen = new Set();
    for (const slug of list) {
      if (seen.has(slug)) problems.push(`duplicate ${what} slug "${slug}"`);
      seen.add(slug);
    }
  };
  dup(slugsIn(categories), "category");
  dup(productSlugList, "product");

  // Products → categories and brands.
  for (const ref of products.matchAll(/categorySlugs: \[([^\]]*)\]/g)) {
    for (const slug of ref[1].matchAll(/"([^"]+)"/g)) {
      if (!categorySlugs.has(slug[1])) {
        problems.push(`product references unknown category "${slug[1]}"`);
      }
    }
  }
  for (const ref of products.matchAll(/brandSlug: "([^"]+)"/g)) {
    if (!brandSlugs.has(ref[1])) {
      problems.push(`product references unknown brand "${ref[1]}"`);
    }
  }

  // Coupons and banners → categories and products.
  for (const [text, what] of [
    [coupons, "coupon"],
    [banners, "banner"],
  ]) {
    for (const ref of text.matchAll(/targetCategorySlugs?: (?:\[([^\]]*)\]|"([^"]+)")/g)) {
      for (const slug of (ref[1] ?? `"${ref[2]}"`).matchAll(/"([^"]+)"/g)) {
        if (!categorySlugs.has(slug[1])) {
          problems.push(`${what} targets unknown category "${slug[1]}"`);
        }
      }
    }
    for (const ref of text.matchAll(/targetProductSlugs?: (?:\[([^\]]*)\]|"([^"]+)")/g)) {
      for (const slug of (ref[1] ?? `"${ref[2]}"`).matchAll(/"([^"]+)"/g)) {
        if (!productSlugs.has(slug[1])) {
          problems.push(`${what} targets unknown product "${slug[1]}"`);
        }
      }
    }
  }

  // Dead brand docs.
  const usedBrands = new Set(
    [...products.matchAll(/brandSlug: "([^"]+)"/g)].map((m) => m[1]),
  );
  for (const slug of brandSlugs) {
    if (!usedBrands.has(slug)) {
      problems.push(`brand "${slug}" is declared but no product uses it`);
    }
  }

  console.log(
    `${market}: ${categorySlugs.size} categories, ${brandSlugs.size} brands, ` +
      `${productSlugs.size} products`,
  );
  if (problems.length > 0) {
    failed = true;
    for (const problem of problems) console.error(`  FAIL — ${problem}`);
  }
}

if (failed) process.exit(1);
console.log("\nEvery catalog's slug references resolve, and no brand is unused.");
