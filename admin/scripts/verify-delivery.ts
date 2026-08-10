/**
 * `npm run verify:delivery` — regression checks for the delivery policy
 * (lib/delivery.ts): the fee, its waiver threshold, and serviceability.
 *
 * A script rather than a test suite for the same reason as the others here —
 * `admin/` has no test runner — and it touches no Firestore, because every
 * function under check is pure. It exits non-zero on failure so CI can gate.
 *
 * What makes these worth running: the same two functions are called from two
 * places that must agree to the paisa (the payment intent in
 * checkout-quote.ts, and the order transaction in orders.ts). A drift between
 * them doesn't show up as a wrong number on a screen — it shows up as a
 * *failed payment verification*, because the amount captured no longer
 * matches the amount re-derived. The Dart mirror in cordelia
 * (StoreDeliveryX.feeFor / .serves) is checked against these same cases in
 * apps/ecommerce/cordelia/test/unit/store_delivery_test.dart.
 */
import { postalGuidanceFor } from "@/lib/postal-examples";
import {
  DEFAULT_STORE_DELIVERY,
  deliveryFeeFor,
  isServiceable,
  mapStoreDelivery,
  normalizeDeliveryAreas,
  type StoreDelivery,
} from "@/lib/delivery";

let failures = 0;
function check(label: string, actual: unknown, expected: unknown) {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n        got ${JSON.stringify(actual)} want ${JSON.stringify(expected)}`}`,
  );
}

function policy(over: Partial<StoreDelivery> = {}): StoreDelivery {
  return { ...DEFAULT_STORE_DELIVERY, ...over };
}

// ── 1. The fee and its threshold ───────────────────────────────────────────
check("no fee configured -> free", deliveryFeeFor(policy(), 100), 0);
check("flat fee, no threshold -> always charged", deliveryFeeFor(policy({ fee: 40 }), 5000), 40);
check("under the threshold -> charged", deliveryFeeFor(policy({ fee: 40, freeAbove: 500 }), 499.99), 40);
// Boundary: "free above 500" is inclusive of 500 itself, and a shopper who
// hits the number exactly must not be charged for missing it by nothing.
check("exactly at the threshold -> waived", deliveryFeeFor(policy({ fee: 40, freeAbove: 500 }), 500), 0);
check("over the threshold -> waived", deliveryFeeFor(policy({ fee: 40, freeAbove: 500 }), 500.01), 0);
// The coupon interaction the settings copy warns about: the threshold reads
// the basket *after* the discount, so a coupon can re-introduce the fee.
check("coupon drops basket under threshold -> fee returns", deliveryFeeFor(policy({ fee: 40, freeAbove: 500 }), 520 - 60), 40);
check("empty basket with a fee -> still charged", deliveryFeeFor(policy({ fee: 40, freeAbove: 500 }), 0), 40);

// ── 2. Serviceability ──────────────────────────────────────────────────────
check("no areas -> delivers everywhere", isServiceable(policy(), "560001"), true);
check("exact code matches", isServiceable(policy({ areas: ["560001"] }), "560001"), true);
check("prefix covers the district", isServiceable(policy({ areas: ["560"] }), "560042"), true);
check("outside the prefix is refused", isServiceable(policy({ areas: ["560"] }), "110001"), false);
// A prefix must not match a code *shorter* than itself — "5600" does not
// cover "560", which would silently widen the area an owner drew.
check("shorter code than the prefix is refused", isServiceable(policy({ areas: ["5600"] }), "560"), false);
check("case and spacing are ignored (UK)", isServiceable(policy({ areas: ["SW1A"] }), "sw1a 1aa"), true);
// The lenient case, and the reason for it: postal code is optional in the
// address form, so an address saved without one predates any policy and must
// not be blocked on a field it was never asked for.
check("address with no postal code is not blocked", isServiceable(policy({ areas: ["560"] }), ""), true);
check("any one matching prefix is enough", isServiceable(policy({ areas: ["110", "560"] }), "560001"), true);

// ── 3. Normalization on the way in ─────────────────────────────────────────
check("areas are uppercased and de-spaced", normalizeDeliveryAreas([" sw1a ", "560 001"]), ["SW1A", "560001"]);
check("duplicates collapse", normalizeDeliveryAreas(["560", "560", " 560 "]), ["560"]);
check("blanks and non-strings are dropped", normalizeDeliveryAreas(["", "  ", 560, null, "560"]), ["560"]);
// Truncating would widen the area; dropping is the safe direction.
check("over-long entries are dropped, not truncated", normalizeDeliveryAreas(["1234567890123"]), []);
check("a non-array is empty, not a crash", normalizeDeliveryAreas("560001"), []);

// ── 4. Reading a store doc ─────────────────────────────────────────────────
// Every store predating the feature has no `delivery` map at all, and must
// read back as what it actually did: free delivery, everywhere.
check("missing map -> free everywhere", mapStoreDelivery(undefined), DEFAULT_STORE_DELIVERY);
check("partial map fills the rest", mapStoreDelivery({ fee: 30 }), { fee: 30, freeAbove: 0, areas: [] });
check("negative fee reads as free", mapStoreDelivery({ fee: -50 }).fee, 0);
check("non-finite fee reads as free", mapStoreDelivery({ fee: "abc" }).fee, 0);
check("fee rounds to two decimals", mapStoreDelivery({ fee: 39.999 }).fee, 40);

// ── 5. The form's postal guidance follows the store's market ───────────────
// The field takes prefixes, and a prefix is only obvious once you've seen one
// from your own country. Both inputs are already on the store doc, so a
// Berlin store must never be shown Bengaluru pincodes.
check("hi/INR -> PIN code", postalGuidanceFor("hi", "INR").noun, "PIN code");
check("en/USD -> ZIP code", postalGuidanceFor("en", "USD").noun, "ZIP code");
check("en/GBP -> postcode", postalGuidanceFor("en", "GBP").noun, "postcode");
check("de/EUR -> Berlin examples", postalGuidanceFor("de", "EUR").examples, ["10115", "10117", "101"]);
// The euro ambiguity the market helper exists to resolve: currency alone
// cannot tell these four apart, language can.
check("fr/EUR -> Paris, not Berlin", postalGuidanceFor("fr", "EUR").prefix, "750");
check("es/EUR -> Madrid", postalGuidanceFor("es", "EUR").prefix, "280");
check("it/EUR -> Rome", postalGuidanceFor("it", "EUR").prefix, "001");
// A UK example has to be a real alphanumeric one — it is the only market
// where the codes aren't digits, and where the space has to look harmless.
check("en/GBP -> alphanumeric example", postalGuidanceFor("en", "GBP").examples[0], "SW1A 1AA");
// Every example must survive the normalizer that will actually be applied to
// it — an example an owner copies verbatim and that then gets dropped would
// be worse than no example.
for (const [language, currency] of [["hi", "INR"], ["de", "EUR"], ["fr", "EUR"], ["es", "EUR"], ["it", "EUR"], ["en", "GBP"], ["en", "USD"]] as const) {
  const g = postalGuidanceFor(language, currency);
  check(
    `${language}/${currency}: every example survives normalization`,
    normalizeDeliveryAreas(g.examples).length,
    g.examples.length,
  );
  // And the documented prefix must really cover the documented example.
  check(
    `${language}/${currency}: the help sentence is true`,
    isServiceable(policy({ areas: [g.prefix] }), g.examples[0]),
    true,
  );
}

console.log(failures === 0 ? "\nAll checks passed." : `\n${failures} FAILED`);
process.exit(failures === 0 ? 0 : 1);
