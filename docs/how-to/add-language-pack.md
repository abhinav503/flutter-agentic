# Add a language pack

How a storefront language gets added end to end, distilled from the four that
shipped (de, fr, es, it on top of en/hi). Each is ~710 ARB keys, so this is a
translation project with a build around it, not a handful of strings.

Read this with `docs/how-to/add-storefront-template.md` if you are also adding a
template — a language is orthogonal to a pack, and every pack renders every
language.

---

## What already works, and what you actually have to do

**Formatting is done.** Core's `AppFormat` (`packages/core/lib/core/formatting/`)
already handles the decimal comma, the trailing `€`, day-first dates and the
24-hour clock. Adding a language changes **no formatting code**. What you owe is
translation, plus a layout pass for the text that got longer.

**Currency is a separate axis.** The store fixes what it charges in; the
shopper's locale fixes how the number reads. A shopper reading a UK store in
German still pays in £. Never infer one from the other.

---

## The steps

### 1. Register the language

Six places, all mechanical:

| Where | What |
|---|---|
| `StoreLanguage` enum | a case — **before `hi`**, which sorts last by decision (see `locale_pack_test.dart`) |
| `StoreLanguageX.wireValue` | the code |
| `StoreLanguageParse` | wire → enum |
| `StoreLanguageLocaleX.asLocale` | enum → `Locale` — deliberately in `l10n/active_locale_controller.dart`, not beside the enum, so `StoreLanguage` stays pure Dart and domain entities can hold it |
| `ValueConst.language<Name>` + an arb key | the self-naming label |
| admin `STORE_LANGUAGES` / `STORE_LANGUAGE_LABELS` | same order as the enum |

`supportedLocales` needs no change — it derives from the generated
`AppLocalizations`, so the arb file alone wires the locale up.

The self-naming label is **never translated**: `languageGerman` is "Deutsch" in
every locale, so a shopper who can't read the current language can still find
their own in the list.

### 2. Write a translation contract before translating anything

The single highest-leverage step. Consistency across ~710 keys is the thing that
fails, and it fails invisibly — "Cart" rendered three ways across three packs
looks fine key by key. Write one document covering:

- **Hard rules** — placeholders preserved exactly; ICU plural branches kept
  (both `one` and `other`, with the nested `{count}`); leading/trailing spaces
  preserved (`"Don't have an account? "`); `\n` preserved; brand names and the
  self-naming language values passed through; `termsAndConditionsBody` is
  lorem-ipsum and copied verbatim.
- **Register** — formal or informal, decided per market, not per house style.
  German and French use the formal *Sie*/*vous*; Spanish and Italian use the
  informal *tú*/*tu*, because that is what retail in those markets does.
- **A mandatory terminology table** — 50–60 rows. This is what stops "Cart"
  drifting between packs.
- **Typography** — Spanish opens questions with `¿` and exclamations with `¡`;
  French puts a no-break space (U+00A0) before `: ; ! ?`; Italian uses neither.
- **A length budget** — see below.

### 3. Pre-decide the capped slots

The German pass discovered nine width problems *after* translating and fixed
them by hand. The French, Spanish and Italian passes put a length-budget table
in the contract with the exact rendering for every narrow slot, and merged with
**zero overrides**. Front-load it.

Cap only what English is genuinely short in — a cap looser than the English is
not a budget. From the shipped packs:

| Slot | Cap | Why |
|---|---|---|
| bottom-nav tab labels | 12 | narrowest slot in the app |
| order-status chips | 12 | English "Order Placed" is 12 |
| refund **failed** pill | 14 | English is 13 |
| paired card actions (Track / Cancel) | 12 | two buttons in one card row |
| date quick-pick chips | 10 | English "All time" is 8 |

Refund **pending** is deliberately absent: English ships "Refund processing"
(17), so there is no tight budget there to enforce.

### 4. Translate, then merge through the gate

Chunk by prefix (app-level, then one per template) so the work parallelises, and
merge with:

```bash
scripts/check-arb-parity.py de --merge-from /path/to/chunks   # assemble + validate
scripts/check-arb-parity.py --all                             # CI-shaped gate
```

It refuses to write an arb unless key parity holds, every placeholder survives,
ICU branch sets are intact, layout-significant whitespace matches, declared
passthrough values are untouched, no long value is still English, and no value
introduces a currency glyph. It also runs per-locale typography checks
(`LOCALE_RULES`) and cross-checks pairs that must stay distinct
(`DISTINCT_PAIRS`).

`gen-l10n` silently falls back to the template's English for a missing key, so
without this gate a half-finished locale ships as a half-English screen rather
than a build failure.

### 5. Run the tests, then look at it

`apps/ecommerce/cordelia/test/unit/l10n/locale_pack_test.dart` loops over
`StoreLanguage.values`, so a new language inherits every check the day its arb
lands: key parity, capped-slot widths, the string-and-format swap landing
together, currency surviving a language-only switch, plural-category
correctness, and cross-locale typography contamination.

Then open a store in the new language. Tests cannot judge whether copy *fits* —
see the widget-test font caveat in `docs/ai-rules/design.md` §3.

---

## Traps, each of which cost a debugging round

**Plural categories are not shared across Romance languages.** CLDR puts **0 in
French's `one`** category and in **Spanish's and Italian's `other`**. Writing
only the plural sense into French's `one` prints "0 unités" on every empty row.
Pin it with a test.

**`String.length` is a width proxy only for Latin script.** Extending the
capped-slot test across all locales failed on Hindi — and the cap was wrong, not
the copy. Devanagari's combining marks and conjuncts count as separate code
units but render in one cluster: `'ऑर्डर ट्रैक करें'` is 16 code units, 14
clusters, and narrower again on screen. Non-Latin scripts are excluded from that
test and judged on a device.

**A capped slot invites collapsing two labels into one word.** French and
Spanish both rendered the order-timeline *step name* ("Order Placed") as
"pending", colliding with the sibling key that means *a step not yet reached*.
`DISTINCT_PAIRS` in the gate now catches it.

**One language's typography bleeds into another's file** when locales are
translated in parallel from a shared contract — Spanish's `¿` or French's
no-break space landing in Italian. `no_foreign_typography` catches it.

**Invisible characters make tests lie.** CLDR joins an English time to AM/PM
with a narrow no-break space (U+202F), and French groups thousands with the same
character while preceding `€` with U+00A0. A plain space typed in an expectation
looks identical in the diff and in the editor; it cost three false debugging
rounds. Build such expectations from named constants (`nbsp`, `nnbsp`), never
literals.

**Copy that carries formatting has to give it up.** A key like
`"Under ₹100"` bakes in a currency; `"{date} at {time}"` bakes in an English
connector. Pass pre-formatted operands in and let the string own only the
words — one key then serves every currency and every locale.

**A server-authored message cannot be localized.** The coupon minimum-order
error named an amount and shipped a hardcoded `₹` to every storefront. The fix
is for the API to send the bare number plus a machine-readable `code`, and the
client to write the sentence — it is the only side that knows the store's
currency *and* the shopper's language. See `CouponError` /
`couponErrorBody` in `admin/src/lib/coupon-engine.ts` and
`CouponRejectedException` in cordelia's cart data source.

---

## What is deliberately *not* translated

Catalog content — product names, categories, brands — is single-valued plain
text (`docs/explanation/content-i18n-plan.md`). Each seed catalog is instead
**written in its market's language**, which is why there are seven of them. A
shopper switching a store's language gets translated chrome around untranslated
product names, and that is the accepted boundary.
