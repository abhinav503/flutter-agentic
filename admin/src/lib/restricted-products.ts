// Products no store on CordeliaApps may list: alcohol, tobacco and the
// nicotine/betel products that sit beside them.
//
// This is a **store policy** first (see /terms §6) and a keyword guard
// second. The guard is deliberately shallow — it reads names and
// descriptions, not photos — because its job is to stop the honest mistake
// and to keep the catalog defensible, not to defeat a determined seller.
//
// Why it exists at all: the App Store age-rating questionnaire asks whether
// the app shows alcohol/tobacco references, and we answer "None". That
// answer is only true while the catalogs behind the app are, so the same
// list that backs the policy also gates a store going live
// (see store-readiness.ts).
//
// Matching is intentionally conservative. A false positive costs a store
// owner a confusing refusal on a legitimate product, so every term here is
// one that essentially only appears on the real thing, and EXEMPT_PHRASES
// carves out the handful of legitimate uses that would otherwise trip
// ("non-alcoholic", "root beer", "isopropyl alcohol", "cigarette lighter").

export type RestrictedCategory = "alcohol" | "tobacco";

export type RestrictedMatch = {
  /// The term as it appears in RESTRICTED_TERMS, for the message.
  term: string;
  category: RestrictedCategory;
};

// Terms are matched whole-word against normalised text, so "gin" cannot hit
// "ginger" and "rum" cannot hit "rumali". Multi-word entries match as a
// phrase. Non-Latin scripts are listed alongside the English because a
// store sets its own language — a Hindi store types "बीयर", not "beer".
//
// The bare word "alcohol" is NOT here on purpose: it is the honest
// ingredient of hand sanitiser, antiseptic and mouthwash. "alcoholic"
// carries the intent instead.
const RESTRICTED_TERMS: { term: string; category: RestrictedCategory }[] = [
  // Alcohol — English
  { term: "alcoholic", category: "alcohol" },
  { term: "beer", category: "alcohol" },
  { term: "lager", category: "alcohol" },
  { term: "pale ale", category: "alcohol" },
  { term: "india pale ale", category: "alcohol" },
  { term: "stout", category: "alcohol" },
  { term: "cider", category: "alcohol" },
  { term: "wine", category: "alcohol" },
  { term: "wines", category: "alcohol" },
  { term: "champagne", category: "alcohol" },
  { term: "prosecco", category: "alcohol" },
  { term: "whisky", category: "alcohol" },
  { term: "whiskey", category: "alcohol" },
  { term: "vodka", category: "alcohol" },
  { term: "rum", category: "alcohol" },
  { term: "gin", category: "alcohol" },
  { term: "brandy", category: "alcohol" },
  { term: "tequila", category: "alcohol" },
  { term: "liqueur", category: "alcohol" },
  { term: "liquor", category: "alcohol" },
  { term: "spirits", category: "alcohol" },
  { term: "absinthe", category: "alcohol" },
  { term: "mead", category: "alcohol" },
  { term: "toddy", category: "alcohol" },
  { term: "feni", category: "alcohol" },
  // Alcohol — the storefront languages
  { term: "bier", category: "alcohol" },
  { term: "wein", category: "alcohol" },
  { term: "schnaps", category: "alcohol" },
  { term: "vin", category: "alcohol" },
  { term: "biere", category: "alcohol" },
  { term: "cerveza", category: "alcohol" },
  { term: "vino", category: "alcohol" },
  { term: "birra", category: "alcohol" },
  { term: "licor", category: "alcohol" },
  { term: "बीयर", category: "alcohol" },
  { term: "शराब", category: "alcohol" },
  { term: "व्हिस्की", category: "alcohol" },
  { term: "वाइन", category: "alcohol" },

  // Tobacco, nicotine and betel — English
  { term: "tobacco", category: "tobacco" },
  { term: "cigarette", category: "tobacco" },
  { term: "cigarettes", category: "tobacco" },
  { term: "cigar", category: "tobacco" },
  { term: "cigars", category: "tobacco" },
  { term: "cigarillo", category: "tobacco" },
  { term: "bidi", category: "tobacco" },
  { term: "beedi", category: "tobacco" },
  { term: "hookah", category: "tobacco" },
  { term: "shisha", category: "tobacco" },
  { term: "nicotine", category: "tobacco" },
  { term: "vape", category: "tobacco" },
  { term: "vaping", category: "tobacco" },
  { term: "e cigarette", category: "tobacco" },
  { term: "ecigarette", category: "tobacco" },
  { term: "gutka", category: "tobacco" },
  { term: "gutkha", category: "tobacco" },
  { term: "khaini", category: "tobacco" },
  { term: "zarda", category: "tobacco" },
  { term: "snus", category: "tobacco" },
  { term: "chewing tobacco", category: "tobacco" },
  { term: "rolling papers", category: "tobacco" },
  // Tobacco — the storefront languages
  { term: "tabak", category: "tobacco" },
  { term: "zigaretten", category: "tobacco" },
  { term: "tabac", category: "tobacco" },
  { term: "tabaco", category: "tobacco" },
  { term: "tabacco", category: "tobacco" },
  { term: "sigarette", category: "tobacco" },
  { term: "cigarrillos", category: "tobacco" },
  { term: "तंबाकू", category: "tobacco" },
  { term: "सिगरेट", category: "tobacco" },
  { term: "गुटखा", category: "tobacco" },
];

// Legitimate groceries that contain a restricted term. Removed from the text
// BEFORE matching, so "Kingfisher Beer" is caught while "Root Beer" is not.
//
// Vinegars are here and cooking wine is not, on purpose: wine vinegar has no
// alcohol left in it, cooking wine does.
const EXEMPT_PHRASES = [
  "root beer",
  "ginger beer",
  "birch beer",
  "beer glass",
  "beer mug",
  "wine glass",
  "wine glasses",
  "wine vinegar",
  "wine opener",
  "wine rack",
  "rice wine vinegar",
  // Wine vinegar in the other storefront languages — all shelf staples.
  "vinaigre de vin",
  "weinessig",
  "vinagre de vino",
  "aceto di vino",
  // A bottle shape, not a drink: sparkling soft drinks describe themselves
  // this way constantly.
  "champagne style",
  "champagne flavour",
  "champagne flavor",
  "rum flavour",
  "rum flavoured",
  "rum flavor",
  "rum flavored",
  "rum essence",
  "isopropyl alcohol",
  "rubbing alcohol",
  "surgical spirits",
  "cigarette lighter",
  "cigarette lighters",
  "cigarette case",
];

// A product that declares itself free of the thing is not the thing —
// "Barbican Non-Alcoholic Beer" is a malt drink, and "nicotine free" pouches
// are sweets. Finding one of these clears every match in that category
// rather than just the phrase it sits in, because the qualifier usually
// lands somewhere other than beside the word it qualifies ("Beer, 0%
// alcohol"). A seller could abuse it; the policy and the publish review are
// what answer that, not a longer regex.
const NEGATORS: Record<RestrictedCategory, string[]> = {
  alcohol: [
    "non alcoholic",
    "nonalcoholic",
    "alcohol free",
    "alcoholfree",
    "de alcoholised",
    "de alcoholized",
    "zero alcohol",
    "0 alcohol",
    "0 abv",
    "alkoholfrei",
    "sans alcool",
    "sin alcohol",
    "analcolico",
  ],
  tobacco: ["tobacco free", "nicotine free", "nikotinfrei"],
};

// Lowercase, strip accents, and reduce every run of punctuation to a single
// space, so the text becomes space-separated tokens. Padding the result with
// spaces then lets a plain `includes(" term ")` do whole-word matching in
// any script — JavaScript's \b is ASCII-only and would never fire on
// "सिगरेट".
function normalise(text: string): string {
  const folded = text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\p{M}]+/gu, " ")
    .trim();
  return ` ${folded} `;
}

/// Every restricted term found across the given texts (name, description,
/// …), deduplicated, in list order. Empty means the product is fine.
export function findRestrictedTerms(
  ...texts: (string | null | undefined)[]
): RestrictedMatch[] {
  const text = texts
    .filter((t): t is string => Boolean(t && t.trim()))
    .map(normalise)
    .join("");
  if (!text.trim()) return [];

  // Negators are read off the untouched text — EXEMPT_PHRASES removal below
  // would delete the very phrases this looks for.
  const cleared = new Set<RestrictedCategory>();
  for (const [category, phrases] of Object.entries(NEGATORS)) {
    if (phrases.some((phrase) => text.includes(` ${phrase} `))) {
      cleared.add(category as RestrictedCategory);
    }
  }

  let haystack = text;
  for (const phrase of EXEMPT_PHRASES) {
    haystack = haystack.split(` ${phrase} `).join("  ");
  }

  const found: RestrictedMatch[] = [];
  for (const { term, category } of RESTRICTED_TERMS) {
    if (cleared.has(category)) continue;
    const normalisedTerm = normalise(term).trim();
    if (haystack.includes(` ${normalisedTerm} `)) found.push({ term, category });
  }
  return found;
}

/// The refusal a store owner reads. Names what tripped, so a false positive
/// is obvious rather than mysterious, and says where the rule comes from.
export function restrictedProductMessage(matches: RestrictedMatch[]): string {
  const terms = matches.map((m) => `"${m.term}"`).join(", ");
  return `Alcohol and tobacco products cannot be listed on CordeliaApps (see the Acceptable use section of our terms). This product matched ${terms}. If that's wrong, rename it or email support@cordeliaapps.com.`;
}
