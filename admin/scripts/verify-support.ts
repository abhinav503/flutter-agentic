/**
 * `npm run verify:support` — regression checks for the store support contact
 * (lib/support.ts): what a stored doc reads back as, and what a write is
 * allowed to be.
 *
 * A script rather than a test suite for the same reason as the others here —
 * `admin/` has no test runner — and it touches no Firestore, because every
 * function under check is pure. It exits non-zero on failure so CI can gate.
 *
 * What makes these worth running: reading and writing are deliberately
 * asymmetric. `mapStoreSupport` is lenient because it prints docs written
 * long ago and must never throw on one; the PUT route is strict because a
 * typo saved as a support address is a channel that silently swallows every
 * message sent to it. Both halves have to keep their own end of that bargain,
 * and neither has a UI that would show it breaking.
 */
import {
  DEFAULT_STORE_SUPPORT,
  MAX_SUPPORT_EMAIL_LENGTH,
  MAX_SUPPORT_HOURS_LENGTH,
  MAX_SUPPORT_PHONE_LENGTH,
  isSupportEmail,
  isSupportPhone,
  mapStoreSupport,
} from "@/lib/support";

let failures = 0;
function check(label: string, actual: unknown, expected: unknown) {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n        got ${JSON.stringify(actual)} want ${JSON.stringify(expected)}`}`,
  );
}

// ── 1. Reading a doc is lenient, and never throws ──────────────────────────
// Every store predating the field. The app reads this as "no store contact"
// and offers the platform address alone — which is what those stores have
// always actually offered.
check("a doc with no support map", mapStoreSupport(undefined), DEFAULT_STORE_SUPPORT);
check("a null support map", mapStoreSupport(null), DEFAULT_STORE_SUPPORT);
check("a support map of the wrong type", mapStoreSupport("nonsense"), DEFAULT_STORE_SUPPORT);
check(
  "non-string fields degrade to empty rather than to 'undefined'",
  mapStoreSupport({ email: 42, phone: null, hours: {} }),
  DEFAULT_STORE_SUPPORT,
);
check(
  "surrounding whitespace is dropped",
  mapStoreSupport({ email: "  a@b.com \n", phone: " +91 1 ", hours: " 9-5 " }),
  { email: "a@b.com", phone: "+91 1", hours: "9-5" },
);
// Truncated, not rejected: a doc already holding an over-long value must
// still render. The write path below is where length is refused.
check(
  "an over-long stored value is truncated on read",
  mapStoreSupport({ email: "a".repeat(MAX_SUPPORT_EMAIL_LENGTH + 50) }).email.length,
  MAX_SUPPORT_EMAIL_LENGTH,
);
check(
  "an over-long stored hours line is truncated on read",
  mapStoreSupport({ hours: "x".repeat(MAX_SUPPORT_HOURS_LENGTH + 10) }).hours.length,
  MAX_SUPPORT_HOURS_LENGTH,
);

// ── 2. Writing is strict ───────────────────────────────────────────────────
check("an ordinary address", isSupportEmail("orders@freshmart.com"), true);
check("a subdomain and a plus tag", isSupportEmail("a+b@mail.store.co.in"), true);
check("no @", isSupportEmail("orders.freshmart.com"), false);
check("no domain dot", isSupportEmail("orders@freshmart"), false);
check("an embedded space", isSupportEmail("orders @freshmart.com"), false);
check("empty is not a valid address", isSupportEmail(""), false);
check(
  "an over-long address is refused rather than truncated",
  isSupportEmail(`${"a".repeat(MAX_SUPPORT_EMAIL_LENGTH)}@b.com`),
  false,
);

// The owner's own punctuation is theirs to choose — the app strips it when
// building the `tel:` and shows the number exactly as typed.
check("spaced with a country code", isSupportPhone("+91 98765 43210"), true);
check("dashed", isSupportPhone("020-7946-0018"), true);
check("parenthesised US style", isSupportPhone("+1 (415) 555-0132"), true);
check("too few digits to dial", isSupportPhone("12345"), false);
check("letters alone", isSupportPhone("call us"), false);
check("empty is not a valid number", isSupportPhone(""), false);
check(
  "an over-long number is refused",
  isSupportPhone("+1".padEnd(MAX_SUPPORT_PHONE_LENGTH + 1, "5")),
  false,
);

// ── 3. The publish gate uses the same predicate ────────────────────────────
// `getStoreReadiness`'s "Support email" check is `isSupportEmail(support.email)`
// over `mapStoreSupport(doc.support)`, so the two halves above compose into
// the gate. These pin that composition: a stored value that reads back
// invalid must read as "not done" rather than quietly passing, or a store
// goes live with a support address nobody can deliver to.
const readsAsPublishable = (raw: unknown) =>
  isSupportEmail(mapStoreSupport(raw).email);

check("a store that never opened the settings", readsAsPublishable(undefined), false);
check("a store that saved only a phone", readsAsPublishable({ phone: "+91 98765 43210" }), false);
check("a store that saved only opening hours", readsAsPublishable({ hours: "Mon-Sat" }), false);
check("whitespace is not an address", readsAsPublishable({ email: "   " }), false);
check("junk stored by some other writer", readsAsPublishable({ email: "not-an-email" }), false);
check("a real address", readsAsPublishable({ email: "orders@freshmart.com" }), true);
check(
  "an address stored with stray whitespace still passes",
  readsAsPublishable({ email: "  orders@freshmart.com  " }),
  true,
);

console.log(failures === 0 ? "\nAll checks passed." : `\n${failures} FAILED`);
process.exit(failures === 0 ? 0 : 1);
