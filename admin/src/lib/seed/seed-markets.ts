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
import { ITALY_SEED } from "./italy-seed-data";
import { SPAIN_SEED } from "./spain-seed-data";
import { UK_SEED } from "./uk-seed-data";
import { US_SEED } from "./us-seed-data";
import type { GrocerySeed } from "./seed-types";

export const SEED_MARKETS = [
  "india",
  "germany",
  "france",
  "spain",
  "italy",
  "uk",
  "us",
] as const;
export type SeedMarket = (typeof SEED_MARKETS)[number];

export const SEED_MARKET_CATALOGS: Record<SeedMarket, GrocerySeed> = {
  india: INDIA_SEED,
  germany: GERMANY_SEED,
  france: FRANCE_SEED,
  spain: SPAIN_SEED,
  italy: ITALY_SEED,
  uk: UK_SEED,
  us: US_SEED,
};

export const SEED_MARKET_LABELS: Record<SeedMarket, string> = {
  india: "India — ₹, Indian brands",
  germany: "Germany — €, German brands",
  france: "France — €, French brands",
  spain: "Spain — €, Spanish brands",
  italy: "Italy — €, Italian brands",
  uk: "United Kingdom — £, British brands",
  us: "United States — $, American brands",
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
  spain:
    "Supermarket aisles in Spanish with brands like Central Lechera Asturiana, Carbonell, Gullón, Font Vella and ColaCao, priced in euros.",
  italy:
    "Supermarket aisles in Italian with brands like Barilla, Mulino Bianco, Galbani, Lavazza and Perugina, priced in euros.",
  uk:
    "Supermarket aisles with brands like Warburtons, Heinz, Cathedral City, Yorkshire Tea and Cadbury, priced in pounds.",
  us:
    "Supermarket aisles with brands like Cheerios, Kraft, Chobani, DiGiorno and Folgers, priced in dollars.",
};

/**
 * Which catalog to pre-select for a store charging `currency`.
 *
 * A *default*, not a derivation — the owner can pick any market, and for the
 * euro they have to: EUR cannot tell Germany from France, Spain or Italy, and
 * all four have catalogs. Germany wins that tie arbitrarily, which is the
 * honest answer; guessing from anything else (store name, admin locale) would
 * be wrong more confidently.
 *
 * INR, GBP and USD each map to their own market, so those three are exact
 * rather than a compromise.
 */
export function defaultSeedMarketForCurrency(currency: string): SeedMarket {
  switch (currency.toUpperCase()) {
    case "INR":
      return "india";
    case "GBP":
      return "uk";
    case "USD":
      return "us";
    default:
      return "germany";
  }
}
