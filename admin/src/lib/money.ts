// Money rendering for the dashboard, in the active store's currency.
//
// The dashboard used to print ₹ everywhere, which was fine while every store
// charged in rupees. Now a store carries a `currency` (see STORE_CURRENCIES),
// the storefront already formats against it, and an admin looking at a euro
// store's orders should see euros too — otherwise the two halves of the same
// product disagree about what a number means.
//
// Read the currency from `useStore().storeCurrency`; these helpers take it as
// an argument rather than reaching for context so they stay usable from
// non-React code (analytics, CSV export) and trivially testable.

import type { StoreCurrency } from "./types";

// Which locale's grouping and symbol placement to render a currency in.
//
// The dashboard's own language is English, but the *numbers* should read the
// way that market writes them: rupees group in lakhs (₹1,23,456), euros use a
// decimal comma with a trailing symbol (1.234,56 €). This mirrors what the
// storefront does — cordelia's AppFormat pairs the store's currency with the
// shopper's locale — with the difference that the admin has one UI language,
// so the currency picks the convention.
const CURRENCY_LOCALES: Record<StoreCurrency, string> = {
  INR: "en-IN",
  EUR: "de-DE",
  GBP: "en-GB",
  USD: "en-US",
};

const FALLBACK: StoreCurrency = "INR";

function localeFor(currency: string): [string, StoreCurrency] {
  const code = currency.toUpperCase() as StoreCurrency;
  return CURRENCY_LOCALES[code]
    ? [CURRENCY_LOCALES[code], code]
    : [CURRENCY_LOCALES[FALLBACK], FALLBACK];
}

/** `1234.5` → "₹1,234.50" / "1.234,50 €" / "£1,234.50" / "$1,234.50". */
export function formatMoney(amount: number, currency: string): string {
  const [locale, code] = localeFor(currency);
  return new Intl.NumberFormat(locale, {
    style: "currency",
    currency: code,
  }).format(amount);
}

/** The bare symbol, for a form label like "Price (₹)". */
export function currencySymbol(currency: string): string {
  const [locale, code] = localeFor(currency);
  // formatToParts is the only way to get the symbol the locale would actually
  // use — hardcoding a map would drift from what formatMoney prints.
  return (
    new Intl.NumberFormat(locale, { style: "currency", currency: code })
      .formatToParts(0)
      .find((part) => part.type === "currency")?.value ?? code
  );
}

/**
 * A stat tile's value on one line: `124500` → "₹1.2L" in rupees, "€124.5K"
 * elsewhere.
 *
 * The scale is currency-specific, not cosmetic. Lakh and crore are how Indian
 * business writes large sums and the old helper was right to use them — but
 * applying that scale to dollars would print "$1.2L", which means nothing to
 * anyone. Every other currency gets the K/M scale its market actually uses.
 */
export function compactMoney(amount: number, currency: string): string {
  const [, code] = localeFor(currency);
  const symbol = currencySymbol(code);
  const abs = Math.abs(amount);

  if (code === "INR") {
    if (abs >= 10_000_000) return `${symbol}${(amount / 10_000_000).toFixed(1)}Cr`;
    if (abs >= 100_000) return `${symbol}${(amount / 100_000).toFixed(1)}L`;
    if (abs >= 1_000) return `${symbol}${(amount / 1_000).toFixed(1)}K`;
    return `${symbol}${Math.round(amount)}`;
  }

  if (abs >= 1_000_000) return `${symbol}${(amount / 1_000_000).toFixed(1)}M`;
  if (abs >= 1_000) return `${symbol}${(amount / 1_000).toFixed(1)}K`;
  return `${symbol}${Math.round(amount)}`;
}
