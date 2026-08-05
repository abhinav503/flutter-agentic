// Checks that each market's sample catalog actually spreads across the price
// bands the storefront filters by:  npm run verify:seed-bands
//
// Why this is worth a script. The storefront's price filter offers four bands
// per currency. Seeding a euro store from the rupee catalog put ~95% of
// products above the top edge, so every chip except one returned the whole
// catalog or nothing — a filter that filters nothing. The first German draft
// had a quieter version of the same bug: no product over €10, so that chip
// could never match. Neither shows up in a type check or an image check.
//
// The band edges are duplicated from cordelia's ProductPriceFilter
// (apps/ecommerce/cordelia/lib/enums/product_price_filter.dart —
// StoreCurrencyPriceBandsX). If this script starts failing after an edit
// there, reconcile the two rather than loosening the assertion.

import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const BANDS = {
  INR: { low: 100, mid: 250, high: 500 },
  EUR: { low: 2, mid: 5, high: 10 },
  GBP: { low: 2, mid: 5, high: 10 },
  USD: { low: 2, mid: 5, high: 10 },
};

// market → the currency its prices are written in, and its data file.
const MARKETS = [
  { name: "india", currency: "INR", file: "grocery-seed-data.ts" },
  { name: "germany", currency: "EUR", file: "germany-seed-data.ts" },
  { name: "france", currency: "EUR", file: "france-seed-data.ts" },
  { name: "spain", currency: "EUR", file: "spain-seed-data.ts" },
  { name: "italy", currency: "EUR", file: "italy-seed-data.ts" },
  { name: "uk", currency: "GBP", file: "uk-seed-data.ts" },
  { name: "us", currency: "USD", file: "us-seed-data.ts" },
];

const seedDir = join(dirname(fileURLToPath(import.meta.url)), "../src/lib/seed");

// Top-level product prices only — `sizeVariants` carry their own `price:` at a
// deeper indent, and counting those would let one product's variants stand in
// for a band no product actually occupies.
const PRICE = /^ {6}price: ([\d.]+),$/gm;

let failed = false;

for (const { name, currency, file } of MARKETS) {
  const source = await readFile(join(seedDir, file), "utf8");
  const prices = [...source.matchAll(PRICE)].map((m) => Number(m[1]));
  if (prices.length === 0) {
    console.error(`${name}: no prices found — did the file's shape change?`);
    failed = true;
    continue;
  }

  const { low, mid, high } = BANDS[currency];
  // Same edge semantics as matches(): < low, [low, mid], (mid, high], > high.
  const counts = {
    [`under ${low}`]: prices.filter((p) => p < low).length,
    [`${low}–${mid}`]: prices.filter((p) => p >= low && p <= mid).length,
    [`${mid}–${high}`]: prices.filter((p) => p > mid && p <= high).length,
    [`over ${high}`]: prices.filter((p) => p > high).length,
  };

  const empty = Object.entries(counts).filter(([, n]) => n === 0);
  const min = Math.min(...prices).toFixed(2);
  const max = Math.max(...prices).toFixed(2);
  console.log(
    `${name} (${currency}, ${prices.length} products, ${min}–${max}): ` +
      Object.entries(counts)
        .map(([band, n]) => `${band}=${n}`)
        .join("  "),
  );

  if (empty.length > 0) {
    console.error(
      `  FAIL — ${empty.length} band(s) no product can ever match: ` +
        empty.map(([band]) => band).join(", "),
    );
    failed = true;
  }

  // A band holding almost everything is the rupee-catalog failure mode: the
  // filter technically works but tells the shopper nothing.
  const dominant = Object.entries(counts).find(
    ([, n]) => n / prices.length > 0.9,
  );
  if (dominant) {
    console.error(
      `  FAIL — ${Math.round((dominant[1] / prices.length) * 100)}% of products ` +
        `sit in the single "${dominant[0]}" band; the filter cannot separate them.`,
    );
    failed = true;
  }
}

if (failed) process.exit(1);
console.log("\nEvery market's prices span its currency's filter bands.");
