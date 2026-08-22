/**
 * `npm run verify:restricted-products` — regression checks for the alcohol
 * and tobacco ban (lib/restricted-products.ts).
 *
 * A script rather than a test suite for the same reason as the others here —
 * `admin/` has no test runner — and it touches no Firestore, because the
 * matcher is pure. It exits non-zero on failure so CI can gate.
 *
 * What makes these worth running: the matcher is the only thing standing
 * behind an App Store answer. The age-rating questionnaire is answered
 * "None" for "Alcohol, Tobacco, or Drug Use or References", and that is only
 * true while store catalogs stay clean. A term quietly stopping working is
 * invisible until a reviewer opens a store and finds beer in it.
 *
 * The allow cases matter as much as the block ones, and are the reason the
 * list is not simply every word for booze: a grocery catalog legitimately
 * contains root beer, wine vinegar, ginger ale, cigarette lighters and
 * isopropyl alcohol, and a refusal on any of those is a store owner losing
 * an afternoon to a rule that looks broken.
 */
import { findRestrictedTerms } from "@/lib/restricted-products";
import { FRANCE_SEED } from "@/lib/seed/france-seed-data";
import { GERMANY_SEED } from "@/lib/seed/germany-seed-data";
import { INDIA_SEED } from "@/lib/seed/grocery-seed-data";
import { ITALY_SEED } from "@/lib/seed/italy-seed-data";
import { SPAIN_SEED } from "@/lib/seed/spain-seed-data";
import { UK_SEED } from "@/lib/seed/uk-seed-data";
import { US_SEED } from "@/lib/seed/us-seed-data";

let failures = 0;

function blocks(label: string, name: string, description = "") {
  const hits = findRestrictedTerms(name, description);
  const ok = hits.length > 0;
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  blocks  ${label}${ok ? ` (${hits.map((h) => h.term).join(", ")})` : ""}`,
  );
}

function allows(label: string, name: string, description = "") {
  const hits = findRestrictedTerms(name, description);
  const ok = hits.length === 0;
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  allows  ${label}${ok ? "" : ` — matched ${hits.map((h) => h.term).join(", ")}`}`,
  );
}

// ── 1. The products the ban exists for ─────────────────────────────────────
blocks("a beer by brand name", "Kingfisher Premium Lager Beer", "650 ml bottle");
blocks("a spirit", "Old Monk Rum 750ml");
blocks("wine", "Sula Cabernet Shiraz", "Red wine from Nashik");
blocks("a craft beer that never says 'beer'", "Pale Ale 330ml", "Craft brew");
blocks("cigarettes", "Marlboro Gold", "Pack of 20 cigarettes");
blocks("chewing tobacco", "Rajnigandha Gutkha Pouch");
blocks("vaping hardware", "Refillable Vape Pen", "Starter kit");
blocks("something named innocently, described honestly", "Party Pack", "Includes two bottles of whisky");

// ── 2. Every storefront language, since a store names products in its own ──
// A Hindi store types "बीयर", not "beer"; matching only English would leave
// the ban switched off for five of the six languages the app ships.
blocks("Hindi — beer", "बीयर 500ml");
blocks("Hindi — liquor", "शराब की बोतल");
blocks("Hindi — chewing tobacco", "गुटखा पाउच");
blocks("German — cigarettes", "Zigaretten Schachtel");
blocks("German — tobacco", "Tabak Pfeife");
blocks("French — wine", "Vin rouge de Bordeaux");
blocks("Spanish — beer", "Cerveza Corona");
blocks("Italian — beer", "Birra Moretti");

// ── 3. The groceries that must not trip it ─────────────────────────────────
// Each of these contains a restricted term and is an ordinary shelf item.
allows("root beer", "Root Beer 300ml", "Fizzy soft drink");
allows("ginger beer", "Ginger Beer", "Non alcoholic mixer");
allows("ginger ale", "Ginger Ale", "Soft drink");
allows("wine vinegar", "Red Wine Vinegar", "For salads");
allows("glassware", "Wine Glasses Set of 6");
allows("antiseptic", "Isopropyl Alcohol 70%", "First aid");
allows("sanitiser listing its strength", "Hand Sanitizer 200ml", "Contains 70% alcohol");
allows("a lighter", "Cigarette Lighter", "Refillable");
allows("a near-miss on a token boundary", "Ginger Garlic Paste 200g");
allows("another near-miss", "Rumali Roti", "Pack of 5");
allows("ordinary copy that happens to say 'sake'", "Bournvita", "For the sake of strong bones");

// ── 4. Declared-free products are the thing they say they are ──────────────
// The qualifier rarely sits beside the word it qualifies, so it clears the
// whole category rather than one phrase.
allows("alcohol-free beer", "Barbican Non-Alcoholic Beer", "Malt drink");
allows("a 0.0% lager", "Beck's Blue", "Alcohol free lager, 0.0%");
allows("nicotine-free pouches", "Nicotine Free Pouches", "Mint flavour");

// ── 5. The false positives real catalog data actually produced ─────────────
// Every one of these was flagged by an earlier version of the list and is an
// ordinary product. They are here because the shape repeats: a brand that
// borrowed a spirit's name, a soft drink describing its bottle, and a pantry
// staple whose language the exempt list only knew in English.
allows("a biscuit named after a whiskey", "Britannia Bourbon", "Chocolate cream sandwiched in chocolate biscuits.");
allows("a soft drink describing its bottle", "Appy Fizz Sparkling Apple Drink", "Crisp sparkling apple drink in the iconic champagne-style bottle.");
allows("French wine vinegar", "Vinaigre de vin blanc", "Vinaigre de vin blanc doux, pour salades et marinades.");
allows("German wine vinegar", "Weinessig", "Milder Weinessig für Salate.");
allows("Spanish wine vinegar", "Vinagre de vino blanco", "Para ensaladas.");
allows("Italian wine vinegar", "Aceto di vino bianco", "Per insalate.");

// ── 6. Ordinary catalog, untouched ─────────────────────────────────────────
allows("milk", "Amul Fresh Milk", "500 ml pouch");
allows("rice", "India Gate Basmati Rice 5kg", "Long grain");
allows("chocolate", "Cadbury Dairy Milk", "Chocolate bar");
allows("nothing at all", "", "");

// ── 7. Every seeded catalog stays sellable ─────────────────────────────────
// "Generate sample data" writes these into a real store, and a false
// positive in one of them is worse than a missed term: the store owner
// cannot publish, and nothing on the Products page explains why. Scanning
// all seven markets here is what caught the three cases in section 5.
const SEEDS = {
  India: INDIA_SEED,
  UK: UK_SEED,
  US: US_SEED,
  France: FRANCE_SEED,
  Germany: GERMANY_SEED,
  Spain: SPAIN_SEED,
  Italy: ITALY_SEED,
};

for (const [market, seed] of Object.entries(SEEDS)) {
  const flagged = seed.products
    .map((p) => ({ p, matches: findRestrictedTerms(p.name, p.description) }))
    .filter((r) => r.matches.length > 0);
  const ok = flagged.length === 0;
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  allows  the ${market} sample catalog (${seed.products.length} products)` +
      (ok
        ? ""
        : `\n        ${flagged.map((f) => `${f.p.name} → ${f.matches.map((m) => m.term).join(", ")}`).join("\n        ")}`),
  );
}

console.log(failures === 0 ? "\nAll checks passed." : `\n${failures} FAILED`);
process.exit(failures === 0 ? 0 : 1);
