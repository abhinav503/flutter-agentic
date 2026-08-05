// The set of sample catalogs "Generate sample data" can write, and how a
// store's currency picks a default among them.
//
// One catalog per market rather than one catalog rescaled: a market's brands,
// aisle names and shelf prices are all local, and a euro store seeded from the
// rupee catalog is wrong on all three at once — including in a way that breaks
// the storefront's price filter, whose bands are per currency (see cordelia's
// ProductPriceFilter).

import { FRANCE_SEED } from "./france-seed-data";
import { GERMANY_SEED } from "./germany-seed-data";
import { INDIA_SEED } from "./grocery-seed-data";
import type { GrocerySeed } from "./seed-types";

export const SEED_MARKETS = ["india", "germany", "france"] as const;
export type SeedMarket = (typeof SEED_MARKETS)[number];

export const SEED_MARKET_CATALOGS: Record<SeedMarket, GrocerySeed> = {
  india: INDIA_SEED,
  germany: GERMANY_SEED,
  france: FRANCE_SEED,
};

export const SEED_MARKET_LABELS: Record<SeedMarket, string> = {
  india: "India — ₹, Indian brands",
  germany: "Germany — €, German brands",
  france: "France — €, French brands",
};

// One line per market, shown under the picker so an owner can tell them apart
// before writing ~150 docs into their store.
export const SEED_MARKET_DESCRIPTIONS: Record<SeedMarket, string> = {
  india:
    "Quick-commerce aisles with brands like Amul, Britannia, Tata and Maggi, priced in rupees.",
  germany:
    "Supermarket aisles in German with brands like Kerrygold, Dr. Oetker, Ritter Sport and Haribo, priced in euros.",
  france:
    "Supermarket aisles in French with brands like Président, Bonne Maman, LU, Evian and Carte Noire, priced in euros.",
};

/**
 * Which catalog to pre-select for a store charging `currency`.
 *
 * A *default*, not a derivation — the owner can pick any market, and they have
 * to be able to: EUR alone doesn't say whether a store is German, French,
 * Spanish or Italian, and two of those four now have catalogs.
 *
 * Everything non-rupee defaults to Germany, which is arbitrary among the euro
 * catalogs and deliberately so: EUR cannot tell Germany from France, and
 * guessing from anything else (store name, admin locale) would be a worse kind
 * of wrong — silently confident. GBP and USD land there too because German
 * shelf prices sit in the same 2/5/10 band scale the filter uses for those
 * currencies, so the numbers are at least plausible; the brands and language
 * will not be. A starting point, not an answer.
 */
export function defaultSeedMarketForCurrency(currency: string): SeedMarket {
  return currency.toUpperCase() === "INR" ? "india" : "germany";
}
