# Content i18n Plan — Hindi catalog data + Hindi landing page

> Status: **decided 2026-08-06 — Part 1 deferred, Part 2 discarded.** Written 2026-08-05 as a
> companion to the shipped UI-chrome localization (per-store en/hi via gen-l10n, all three
> templates — see `superapp-ecommerce-plan.md` §2026-08-05). It covered the two things that
> work deliberately left out: **catalog content** and the **marketing landing page**. Neither
> is being built now; the reasoning is below and the design is kept because it is still the
> design we would use.

## Decisions (2026-08-06)

**Catalog content stays single-valued free text — this is the shipped behaviour, not a gap.**
The admin's catalog fields already accept any language, so a German store owner types German
names and the storefront prints them end to end with zero code. The `i18n` override map in
Part 1 buys only a *second* language for the same product, which matters solely because
`StoreLocalePrefs` lets a shopper pick a language the store didn't author in. Deferred
because:

- All seven seeded markets are single-language. The bilingual case (India en/hi, Switzerland,
  Canada) is the only one it bites, and no store is in it.
- Translating chrome but not product names is what real single-market grocery apps do.
- The map is purely additive (`i18n?.[lang]?.[field] ?? field`), so deferring forecloses
  nothing — the migration is non-breaking in both directions.
- **The cost was never the code.** Without machine translation, every owner types every
  product name twice, forever; the form ships and most leave it blank, which is today's
  behaviour with more machinery behind it. So **if Part 1 is ever built, "Translate with AI"
  ships with it, not after it.**

**"BE-only" is not available**, which is worth knowing before someone proposes it again. The
shopper's language override lives on-device, so the server can't resolve a language it wasn't
told. A genuine BE-only variant — resolve from the store doc, ignore the override for catalog
— gives the store exactly one language, leaving the override map nothing to hold. It collapses
back to doing nothing. It is this decision or the full Part 1; there is no middle.

**Part 2 (`/hi` landing page) is discarded**, not deferred — a Hindi marketing page for store
owners isn't wanted.

**Still worth doing, and unrelated to language:** `sitemap.ts` + `robots.ts`, missing entirely
(§Part 2 item 5). Two public routes today (`/` and `/docs`); `/login`, `/signup`,
`/dashboard/*` and `/api/*` should be disallowed so crawl budget doesn't go to pages that can
never rank.

**Already fixed:** the stale `types.ts` (`Store.language`) comment noted below now reads
correctly.

## Where things stand today

- UI chrome is fully bilingual: ~707 ARB keys × en/hi in `apps/ecommerce/cordelia/lib/l10n/`,
  surfaced through the const holders as `static String get x => L10n.current.key`. The store's
  `language` field (admin Settings → validated in `POST/PUT /api/stores`) selects the locale;
  the shopper's per-store on-device override (`StoreLocalePrefs`) wins over it.
- Catalog content is single-valued plain strings in Firestore (camelCase), serialized to the
  frozen snake_case wire in `admin/src/lib/api/serializers.ts`, parsed by cordelia's
  `*Model.fromJson()`. No multilingual fields exist anywhere (audited: no `*_hi`, no
  `translations` maps).
- The landing page (`admin/src/app/page.tsx` → `components/site/LandingPage.tsx`, Next.js 16
  App Router) is hardcoded English JSX with `en_IN` OG metadata and three JSON-LD blocks.
  No `middleware.ts`, no `[locale]` segment, no `sitemap.ts`/`robots.ts`, no i18n library.
- Stale comment to clean up in passing: `admin/src/lib/types.ts` (`Store.language`) still
  claims only the gravia template renders Hindi — the template gate was removed 2026-08-05.

---

## Part 1 — Catalog content (products / categories / banners)

### Decision: optional per-locale override map, resolved server-side via `?lang=`

**Storage.** Keep every existing flat field as the canonical value (the store's default
language, whatever the admin typed) and add one optional map per doc:

```jsonc
// stores/{id}/products/{pid}
{
  "name": "Amul Milk 500ml",          // canonical — unchanged
  "description": "…",
  "i18n": { "hi": { "name": "अमूल दूध 500ml", "description": "…" } }
}
```

- Backward compatible: a doc without `i18n` is simply untranslated.
- Scales to a third language later with zero schema churn.
- Fallback is one expression: `i18n?.[lang]?.[field] ?? field`.

**Field coverage:**

| Doc | Translatable fields | Skipped (why) |
|---|---|---|
| Product | `name`, `description`, `prepTime` | prices/units/stock are data |
| Category | `name`, `groupName` | — |
| Banner | `title`, `subtitle` | `backgroundColor`, targeting |
| Store (optional) | `name`, `description` | — |
| Brand | — | proper nouns; "Amul" isn't translated |
| Coupon | — | codes are identifiers |

**Wire resolution — the key decision.** The serializers are deliberately frozen to match
`*Model.fromJson()`; that's an asset. The API route handlers accept `?lang=hi` and resolve the
override **before** serializing, so the JSON shape does not change — `name` just arrives in
Hindi. Result: **zero changes to any `*Model`, `*Entity`, or template widget.** The rejected
alternative — shipping both languages and picking client-side — would touch every model/entity
across ~7 storefront features and buy nothing except avoiding a refetch on the (rare) language
switch.

### App-side changes (cordelia)

1. **Data sources append the effective language** to catalog requests — the same value
   `StorefrontPage._applyStoreLocale` computes (on-device override else `store.language`).
   Expose it from one source of truth (`ActiveLocaleController` / `StoreLocalePrefs`) rather
   than threading it through use-case params.
2. **Cache key gains a language axis.** `ScopedBlocCache` is keyed to the store so switching
   stores can't flash stale data; language is a second axis of the same problem. Extend the
   scope key to `storeId + lang`. The Profile → Language switch then automatically misses every
   cache, screens refetch through their normal loading skeletons, and English product names can
   never flash on a Hindi screen.
3. **Search.** If matching stays on `name` only, a Devanagari query finds nothing. Minimum
   viable: when `lang=hi`, match against both `name` and `i18n.hi.name` — and keep matching
   English, because Hindi users often type Latin-script queries. Store-level `searchKeywords[]`
   can gain Hindi entries the same way.

### Admin console changes

- **Forms** (products / categories / banners pages): an EN/HI toggle or a second field under
  the primary one, clearly optional — blank falls back to English.
- **"Translate with AI"** (recommended, fits the platform story): per-field or
  whole-catalog translation via an LLM behind a server route, so Hindi adoption is nearly free
  for store owners. The seeder catalog is the test corpus.
- **Seeder:** add Hindi names/titles to `grocery-seed-data.ts` (~93 products, 10 categories,
  4 banners — a one-time translation), so a seeded store demos the bilingual experience out of
  the box.
- Fix the stale `types.ts` comment noted above.

---

## Part 2 — Hindi landing page + SEO

### The constraint that shapes everything

**Never swap `/`'s content to Hindi based on geolocation.** Googlebot crawls almost entirely
from US IPs — a geo-swapped page is invisible to Google as Hindi content (zero SEO benefit),
and Google explicitly discourages locale-based content swapping/redirects on one URL.

### The plan

1. **Separate URL:** keep `/` English, add **`/hi`** fully translated. No `next-intl` — the
   public site is one landing page plus a docs stub, so a lightweight string dictionary
   (`components/site/copy/en.ts` + `hi.ts`) passed into the existing section components, with
   `app/hi/page.tsx` rendering the same `LandingPage`, is proportionate. (If more public pages
   are coming, a `[locale]` segment is the more future-proof restructure — not worth it for one
   page today.)
2. **`hreflang` alternates** on both pages:
   `alternates.languages: { "en-IN": "/", "hi-IN": "/hi", "x-default": "/" }` — this tells
   Google the two URLs are one page in two languages, so they reinforce rather than compete.
3. **Per-page `<html lang>`:** `layout.tsx` hardcodes `lang="en"`; `/hi` must render
   `lang="hi"` (nested/route-group layout).
4. **Translated JSON-LD** on `/hi` — especially `FAQPage` (good Hindi-query surface area, and
   `faq-data.ts` already feeds both the visible FAQ and the markup so they can't drift).
   `Organization.contactPoint.availableLanguage` → `["en", "hi"]`. OG `locale: "hi_IN"` +
   `alternateLocale: "en_IN"` (inverse on `/`).
5. **Add `sitemap.ts` + `robots.ts`** listing both URLs — currently missing entirely; worth
   doing regardless of Hindi.
6. **Location is a *suggestion*, never a redirect:** a dismissible banner
   ("हिंदी में देखें →"). Prefer `Accept-Language` / `navigator.language` over geo-IP — it
   reflects the user's actual language, whereas country=IN includes vast numbers of
   English-preferring users. If geo is wanted too, Vercel provides `x-vercel-ip-country` in
   middleware. Either way the user clicks; the URL never silently changes.

### Does a Hindi page help SEO for Hindi searchers?

**Yes — genuinely, with a bounded ceiling.** Google matches query language to page language,
so today the site can't rank for any Devanagari query; a real `/hi` with hreflang makes it
eligible, and Hindi content in this niche is far less competitive than English. It also
strengthens the India-relevance signal. Caveat: the buyers are store owners, and much Indian
SMB search is English or Latin-script Hinglish (which mostly resolves to English pages) — so
treat `/hi` as a cheap real win (one page, one-time translation), not a traffic
transformation. Pairing it with Part 1 makes a coherent marketing claim: *your store's app, in
your customers' language*.

---

## Suggested order of work — superseded by the decisions at the top

Kept for the day Part 1 is revived. Steps 1–5 move together; step 2's AI button is not
optional (see the decisions). Steps 6–7 are discarded along with Part 2 — except
`sitemap.ts`/`robots.ts`, which is independent of language and still open.

1. Catalog `i18n` map + `?lang=` resolution in the API routes (wire stays frozen)
2. Admin form fields for Hindi (+ "Translate with AI" button)
3. Cordelia data-source `lang` param + `ScopedBlocCache` key extension
4. Search matching across both languages
5. Seeder Hindi data
6. ~~`/hi` landing page + hreflang~~ + `sitemap.ts`/`robots.ts`
7. ~~Language-suggestion banner~~
