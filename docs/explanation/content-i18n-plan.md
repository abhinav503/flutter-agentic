# Content i18n Plan — Hindi catalog data + Hindi landing page

> Status: **planned, not started** (written 2026-08-05). Companion to the shipped UI-chrome
> localization (per-store en/hi via gen-l10n, all three templates — see
> `superapp-ecommerce-plan.md` §2026-08-05). This plan covers the two things that work
> deliberately left out: **catalog content** (product/category/banner text stays whatever the
> admin typed) and the **admin console's marketing landing page** (English-only, no locale
> routing).

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

## Suggested order of work

1. Catalog `i18n` map + `?lang=` resolution in the API routes (wire stays frozen)
2. Admin form fields for Hindi (+ "Translate with AI" button)
3. Cordelia data-source `lang` param + `ScopedBlocCache` key extension
4. Search matching across both languages
5. Seeder Hindi data
6. `/hi` landing page + hreflang + `sitemap.ts`/`robots.ts`
7. Language-suggestion banner
