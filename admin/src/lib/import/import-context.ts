import {
  SEED_MARKET_CATALOGS,
  SEED_MARKET_LABELS,
  seedMarketForStore,
} from "@/lib/seed/seed-markets";
import type { Brand, Category, Product } from "@/lib/types";
import { StoreCatalog } from "./store-catalog";

/**
 * What every import dialog needs from the store: which seed catalog its sample
 * should be drawn from, and the live catalog its rows resolve against.
 *
 * The market comes from the store's *language*, with currency breaking the tie
 * only for English (India / UK / US all speak it) — a French store wants French
 * product names, and EUR alone cannot say that. See `seedMarketForStore`.
 */
export function importContext(
  storeLanguage: string,
  storeCurrency: string,
  contents: { products: Product[]; categories: Category[]; brands: Brand[] },
) {
  const market = seedMarketForStore(storeLanguage, storeCurrency);
  return {
    market,
    seed: SEED_MARKET_CATALOGS[market],
    sampleLabel: SEED_MARKET_LABELS[market],
    sampleSlug: market,
    catalog: new StoreCatalog(contents),
  };
}
