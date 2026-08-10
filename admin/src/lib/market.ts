// Which country a store operates in, inferred from the two things it already
// declares: its language and its currency.
//
// This lived in `lib/seed/seed-markets.ts`, which is where it is still used
// from — but that module imports all seven catalogs (thousands of lines of
// product data) at its top, so anything that wants only the *inference* had
// to drag the catalogs along with it. Splitting them keeps a settings form
// from bundling a grocery catalog to decide whether to show a PIN code or a
// ZIP code. `seed-markets.ts` re-exports both functions under their original
// names, so every existing caller is unchanged.

export const MARKETS = [
  "india",
  "germany",
  "france",
  "spain",
  "italy",
  "uk",
  "us",
] as const;

export type Market = (typeof MARKETS)[number];

/**
 * Which market to assume for a store charging `currency`.
 *
 * A *default*, not a derivation — for the euro it has to be: EUR cannot tell
 * Germany from France, Spain or Italy. Germany wins that tie arbitrarily,
 * which is the honest answer; guessing from anything else (store name, admin
 * locale) would be wrong more confidently.
 *
 * INR, GBP and USD each map to one market, so those three are exact.
 */
export function defaultMarketForCurrency(currency: string): Market {
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

/**
 * The market whose *language* matches the store, falling back to currency.
 *
 * This resolves the euro ambiguity the function above documents: EUR can't
 * tell Germany from France, Spain or Italy, but `language` can. Five of the
 * six store languages name exactly one market.
 *
 * `en` is the exception and genuinely needs the currency: India, the UK and
 * the US are all English-speaking markets here, and only what the store
 * charges in separates them.
 */
export function marketForStore(language: string, currency: string): Market {
  switch (language.toLowerCase()) {
    case "hi":
      return "india";
    case "de":
      return "germany";
    case "fr":
      return "france";
    case "es":
      return "spain";
    case "it":
      return "italy";
    default:
      return defaultMarketForCurrency(currency);
  }
}
