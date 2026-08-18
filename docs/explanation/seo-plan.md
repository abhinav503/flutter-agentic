# SEO plan — cordeliaapps.com

Working checklist for taking the marketing site from *"a good landing page"* to *"a site that
gets found by store owners who don't know CordeliaApps exists."*

The site is `admin/` (Next.js 16 App Router). `/` and the legal pages are the public surface;
everything under `/dashboard` and `/api` is auth-gated and correctly excluded from crawling.

**How to use this doc:** work top-down. Each tier is ordered by *impact ÷ effort*, not by how
interesting it is. Tick a box when the change is live on production, not when the code is written.

---

## 0. Baseline — what is already correct

An audit of the source (2026-08-18) found the technical foundation is **stronger than an external
crawler-only review can see**, because the head, robots and JSON-LD are emitted server-side by
Next's Metadata API rather than sitting in the static HTML a text extractor samples. Do **not**
redo any of this:

| Already shipped | Where |
|---|---|
| `robots.txt` — allows `/`, disallows `/dashboard/` and `/api/`, declares the sitemap | `admin/src/app/robots.ts` |
| `sitemap.xml` — 7 public URLs, no `lastModified` lies | `admin/src/app/sitemap.ts` |
| `metadataBase` on the root layout, so every route resolves absolute canonicals | `admin/src/app/layout.tsx` |
| Self-canonical on `/`, `/docs`, `/privacy`, `/terms`, `/refunds`, `/app-privacy`, `/delete-account` | each `page.tsx` |
| Unique `<title>` + `<meta description>` per public page | each `page.tsx` |
| JSON-LD: `Organization`, `SoftwareApplication` (with a zero-price `Offer`), `FAQPage` | `admin/src/components/site/structured-data.tsx` |
| Open Graph + Twitter card tags, `locale: en_IN` | `admin/src/app/page.tsx` |
| Self-hosted fonts via `next/font` (no render-blocking Google Fonts request, no CLS) | `admin/src/app/layout.tsx` |
| Lazy, viewport-gated demo videos with posters and a fixed aspect ratio (no CLS, no wasted MB) | `admin/src/components/site/PhoneVideo.tsx` |
| Semantic landmarks, skip-link, one `<h1>`, `aria-labelledby` per section | `admin/src/components/site/LandingPage.tsx` |
| Descriptive alt on the console screenshot | `admin/src/components/site/AdminFeatures.tsx` |
| Legal/trust pages complete and specific (privacy, terms, refunds, app privacy, delete account) | `admin/src/app/*/page.tsx` |

**The real problem is not technical SEO. It is that the site is one page, and one page can only
rank for one search intent.** Everything a prospective store owner might search — pricing,
templates, kirana stores, cost comparisons — is an anchor (`#pricing`, `#templates`) on the
homepage, not a URL Google can rank independently. The documentation site (§0.5) added ~30
indexable URLs after this audit and does **not** change that sentence: every one of them serves
an existing customer's question, not a prospect's.

---

## 0.5 — Shipped since this audit: the documentation site

The largest SEO change on the domain to date, and it landed after the table above was written
(commit `b0d64e3`). It is recorded here rather than as a P1 tick because it was built as a
*product* surface — onboarding for store owners — and only incidentally moves the search work.

| Shipped | Where |
|---|---|
| 24 MDX guides across 7 categories (~14,900 words): getting started, store setup, catalog, payments, orders, growing your store, going live | `admin/src/content/docs/<category>/<slug>.mdx` |
| A file-backed collection — frontmatter (`title` / `description` / `order` / `sidebarTitle`), heading extraction, editorial category order, prev/next neighbours | `admin/src/lib/docs.ts` |
| Three indexable route levels — `/docs`, `/docs/<category>`, `/docs/<category>/<slug>` — statically prerendered, each with its own `<title>`, description and **self-canonical** | `admin/src/app/docs/**` |
| `robots: { index: false }` **removed** — the page is no longer a stub, so the flag that justified it is gone | `admin/src/app/docs/page.tsx` |
| Sitemap enumerates the collection **off disk**, so a guide added as a file appears without anyone remembering a list; categories with no articles are skipped so it never lists a 404 | `admin/src/app/sitemap.ts` |
| JSON-LD extended — `CollectionPage` with `hasPart` on the index, `TechArticle` per guide (`headline`, `description`, `url`, `isPartOf: WebSite`) | `admin/src/app/docs/page.tsx`, `.../[category]/[slug]/page.tsx` |
| ⌘K client-side search over titles, descriptions and headings; sidebar; per-article table of contents; prev/next pager; MDX component set (callout, steps, tabs, cards, accordion, code block) | `admin/src/components/docs/` |
| Linked from `SiteNav` and `SiteFooter`, so every public page points into it | `admin/src/components/site/` |

**What measurably improved:** the sitemap went from **6 URLs to ~38** (home + 5 legal + `/docs` +
7 category pages + 24 articles). The domain now has crawlable *depth* — internal links pointing
at distinct pages instead of homepage anchors — and its first body of genuinely unique long-form
content, which is the thing P3 was going to have to write from scratch.

**What did not improve:** commercial intent. Every new URL answers "how do I connect Razorpay",
not "how much does a grocery app cost in India". A store owner who has never heard of
CordeliaApps still has exactly one page to land on. **P1 is untouched by this work.**

Two follow-on effects to carry forward:

- **P3's blog infrastructure is now mostly built.** `next-mdx-remote/rsc` + `gray-matter` +
  `remark-gfm` + `rehype-highlight`, the typography shell, the frontmatter contract and the
  sitemap-from-disk pattern are all proven in production. A `/blog` is a second collection over
  the same machinery, not new infrastructure — which moves P3 from "6–10 weeks" toward "write
  the articles".
- **`BreadcrumbList` JSON-LD (P2) got *more* valuable, not less.** Articles now sit three levels
  deep; without it a search result prints the raw URL path instead of
  `Docs › Payments › Connect Razorpay`.

---

## P0 — Broken now, fix this week

Small, concrete, and each one is currently costing traffic or clicks.

- [x] **Ship the social share card.** ~~`/og.png` 404s in production~~ — done 2026-08-18, but
      *generated* rather than uploaded: `admin/src/app/opengraph-image.tsx` renders a 1200×630
      card from the brand palette and Manrope via `next/og`, with `twitter-image.tsx` re-exporting
      it. Living at the `app/` root means **every** route inherits it, which closed the second
      item below in the same change. The hand-declared `images` entries were removed from
      `page.tsx` — a literal `images` array overrides the file convention, and that array was what
      pointed at the missing file. Manrope TTFs are vendored at `admin/src/assets/fonts/` so the
      build has no network dependency. Verified: build prerenders both routes statically, and `/`
      and `/delete-account` both emit `og:image` + dimensions + alt.
      **Confirmed live in production** — the card renders correctly in Slack, LinkedIn and
      WhatsApp, and `https://cordeliaapps.com/opengraph-image` returns the PNG. If a specific
      previously-shared link still shows blank, that platform cached the old 404; re-scrape it in
      the LinkedIn Post Inspector or Facebook Sharing Debugger.
- [x] **Give the legal + docs pages their own OG image.** Covered by the root-level route above;
      `/privacy`, `/terms`, `/refunds`, `/app-privacy` and `/delete-account` now all emit a card.
      The last two are the URLs submitted to Google Play, so they get shared in contexts you do
      not control.
- [x] **Resolve the `/docs` contradiction.** Fixed 2026-08-18, then *superseded the same week*.
      The first fix removed `/docs` from `admin/src/app/sitemap.ts`, because the page set
      `robots: { index: false }` on itself — submitting it asked Google to crawl a page we had
      already told it not to keep. The condition the docstring named for adding it back ("the
      commit that gives the page real content and drops the flag") has since happened: `/docs` is
      now a 24-article collection, the `noindex` is gone, and the sitemap enumerates the whole
      tree off disk. See §0.5. Net movement: 7 URLs → 6 → ~38, all indexable.
- [ ] **Verify the property in Google Search Console and Bing Webmaster Tools**, and submit the
      sitemap in both. Without GSC you are optimising blind: no impressions data, no query data,
      no indexing errors, no way to tell whether any of the work below is landing. This is the
      single highest-leverage hour in the whole plan. Prefer DNS verification so it survives
      redeploys.
- [ ] **Rewrite the homepage `<title>` to lead with the category, not the slogan.**
      Current: `CordeliaApps — Your store's own app, zero commission`. The brand is unknown, so
      the brand name is spending the first 14 characters of the most valuable string on the site.
      Proposed: `Grocery & Retail Store App for Your Shop — Zero Commission | CordeliaApps`.
      Keep the slogan exactly as-is in the `<h1>` — it converts well; it just does not describe
      the category to a search engine.
- [ ] **Add category language to the `<h1>` region without weakening it.** Keep
      `Your store. Your own shopping app. Zero commission.` as the `<h1>` and add a keyword-bearing
      eyebrow or sub-headline above/below it, e.g. *"Online ordering app for grocery, kirana and
      retail stores in India."* (`admin/src/components/site/Hero.tsx`)
- [ ] **Fix the "App reviews — None" stat.** It is meant to say *"no App Store review process to
      wait through"*, but it reads to a skeptical visitor as *"nobody has reviewed this product."*
      Relabel to `App store approval` / `Not needed`. (`admin/src/components/site/Hero.tsx`)
- [ ] **Add `WebSite` JSON-LD** alongside the existing three blocks, with `publisher` pointing at
      the `Organization` node. It is the block that lets Google bind the domain to the brand
      entity. (`admin/src/components/site/structured-data.tsx`)

---

## P1 — The structural fix: turn one page into a site

This is the work that actually moves rankings. Today there is exactly one indexable commercial
URL. Each page below targets a **different search intent** — that is the test for whether a page
deserves to exist.

Build each as a real route under `admin/src/app/`, reusing the existing `SiteNav` / `SiteFooter` /
`ui.tsx` section primitives so they are visually identical to the homepage at near-zero design cost.
Add each to `sitemap.ts` in the same commit.

**Wave 1 — promote what already exists (highest ROI, lowest effort).**
The content is already written; it is trapped behind an anchor link.

- [ ] `/pricing` — the `Pricing` section as a standalone page. High commercial intent; "grocery
      app price / cost" is the query a store owner types right before they buy. Keep the section
      on the homepage as a summary that links here.
- [ ] `/templates` — the `Templates` section (gravia / dailymart / grofast) as its own page, with
      a real prose paragraph per template describing *who it suits* (the demo videos are invisible
      to crawlers — the words around them are what ranks). Add descriptive `alt` on each poster
      image and rename the files: `cordeliaapps-grocery-app-template-grofast.jpg`, not
      `grofast_poster.jpg`.
- [ ] `/features` — the `ShopperFeatures` + `AdminFeatures` sections combined.
- [ ] `/how-it-works` — the `HowItWorks` section, expanded into the real onboarding walkthrough.
- [ ] `/faq` — the `Faq` section. Move the `FAQPage` JSON-LD here (or emit it on both), and
      **expand the question set** — see P2.
- [ ] `/security` — the `Trust` section. This is unusually specific content (tenant isolation,
      encrypted payment secrets, server-verified payments) and is exactly what a cautious store
      owner searches before handing over a catalog.

**Wave 2 — new intent pages (write from scratch, ~600–900 words each).**
One page, one intent, genuinely different content. Do **not** ship near-duplicates.

- [ ] `/grocery-store-app` — head term. The product framed entirely for grocery stores.
- [ ] `/kirana-store-app` — the highest-intent India-specific term on this list, and one no
      international competitor is writing for. Speak the vocabulary: kirana, general store,
      provision store, WhatsApp orders, home delivery, khata.
- [ ] `/online-ordering-app` — the catalog → cart → payment → order → delivery flow. Aimed at the
      owner who already takes orders on WhatsApp and wants them to stop being messages.
- [ ] `/white-label-grocery-app` — branding, templates, ownership, what "your own app" does and
      does not mean (see the honesty item in P2).
- [ ] `/supermarket-app` — larger catalogs, brands, categories, coupons, staff use of the console.
- [ ] `/zero-commission-online-store` — your single strongest differentiator as its own page.
      Marketplace commission is a real, quantified pain (15–30% per order); a page that does the
      arithmetic will earn links on its own.

**Wave 3 — only after Wave 2 is indexed and Search Console shows which terms are moving.**

- [ ] `/retail-store-app`
- [ ] `/grocery-delivery-app`
- [ ] Comparison pages (see P3).

---

## P2 — Sharpen the homepage and the words on it

- [ ] **Add a "Who is this for?" section** to the homepage — four cards: Kirana stores / Grocery
      stores / Supermarkets / Local retail. Each one sentence, each linking to its Wave-2 page.
      This does double duty: it gives Google the semantic map of the category *and* it is the
      fastest self-qualification a visitor can do.
- [ ] **Add contextual in-body links.** Every internal link on the site today is in the nav or
      footer. Google weights an in-content link far more than a footer link, and a visitor follows
      one far more often. Wire the new pages into the homepage prose.
- [ ] **Resolve the "your own app" ambiguity.** The hero promises *"Your store. Your own shopping
      app."* while the FAQ explains one CordeliaApps app hosts many stores. A store owner will
      reasonably read the hero as *"I get my own Play Store listing."* Say it plainly once, high
      on the page: **"Your own branded storefront inside the CordeliaApps app — without building,
      submitting or maintaining a separate mobile app."** This is a stronger offer *because* it is
      honest, and it pre-empts the churn of an owner who signs up expecting something else.
- [ ] **Fix the "premium templates" / "free" tension.** "Three premium templates" next to
      "CordeliaApps is free" makes a visitor hunt for the catch. Use *"Three professionally
      designed store templates"* unless a paid tier is actually planned.
- [ ] **Expand the FAQ** with the questions people actually type. Each new answer is also a
      `FAQPage` entry and a potential featured snippet. Add at minimum:
      *Can I create a grocery app without coding? · How much does a grocery app cost in India? ·
      Can a small kirana store use this? · Do I need to publish anything on the Play Store? ·
      How do customers find my store in the app? · Can I take cash on delivery? ·
      What happens to my catalog if I leave? · Which payment providers are supported? ·
      Can I set my own delivery area and delivery fee?*
      (`admin/src/components/site/faq-data.ts`)
- [ ] **Descriptive image filenames and alt text everywhere.** `admin-console.png` →
      `cordeliaapps-grocery-store-admin-dashboard.png`, and every screenshot gets alt text that
      describes the *screen*, not the file. The existing `AdminFeatures` alt is the standard to
      copy. Image search is a real referral channel for "admin dashboard" style screenshots.
- [ ] **Add `BreadcrumbList` JSON-LD** to every non-homepage route once the pages in P1 exist.

---

## P3 — Content engine (the compounding investment)

Ten genuinely useful articles beat a hundred generated ones, and the difference is not subtle —
thin AI-written volume is now an active ranking liability, not a neutral one.

Set this up first:

- [ ] **Add a `/blog` route with MDX**, one file per post. Build it as a second collection over
      the docs pipeline (§0.5) rather than adding `@next/mdx`: `next-mdx-remote/rsc` +
      `gray-matter`, a `src/lib/blog.ts` mirroring `docs.ts`, and the same `docs-prose`
      typography shell. No CMS — a CMS is a decision to make at post #50, not post #1.
- [ ] Add `Article` JSON-LD, an author, and a real published/updated date to the post template.
- [ ] Add posts to `sitemap.ts` automatically by reading the MDX directory.

Then write, in this order (ordered by commercial intent, highest first):

- [ ] **How much does it cost to build a grocery app in India?** — the highest-intent
      informational query in the category. Include a real comparison table: custom development /
      agency / no-code platform / CordeliaApps, across cost, developer needed, app-store
      submission, time to launch, commission. Be fair to the alternatives; a rigged table reads as
      one.
- [ ] **How to create an online grocery store in India (step-by-step)** — catalog, delivery area,
      payments, orders, promotion, repeat customers. Introduce CordeliaApps at step 2, not in the
      first paragraph.
- [ ] **WhatsApp orders vs a shopping app: what a kirana store actually gains** — this is the true
      status quo you are displacing, and nobody is writing about it honestly.
- [ ] **How local grocery stores can sell online without paying marketplace commission** — the
      arithmetic of 20% on ₹5 lakh of monthly orders. This is the piece most likely to get shared
      and linked.
- [ ] **How to take online orders for a kirana store** — vocabulary-matched to how the search is
      actually typed.
- [ ] **Setting delivery areas and delivery fees for a local store** — maps directly to a shipped
      feature (postal-code prefix serviceability, flat fee, free-above threshold).
- [ ] **A grocery product catalog that actually converts** — photos, categories, units, pack
      sizes, stock. Practical, and it improves the catalogs your live stores publish.
- [ ] **Do you need to be on the Play Store to sell online?** — targets a real misconception and
      converts directly into the "your own app" clarification above.
- [ ] **Accepting online payments as a small store in India** — Razorpay vs Stripe, settlement,
      refunds, what you are and are not liable for.
- [ ] **The first 30 days after launching your store app** — retention/ops content that earns the
      email address of an owner who has not signed up yet.

**Comparison pages** (write only once the above exist, and keep them scrupulously factual —
competitor comparisons that misrepresent earn complaints, not rankings):

- [ ] CordeliaApps vs building a custom grocery app
- [ ] CordeliaApps vs Shopify / WooCommerce for a local grocery store
- [ ] CordeliaApps vs listing on a marketplace

---

## P4 — Authority, distribution and proof

On-page work sets the ceiling; these determine whether you reach it. A new domain with perfect
technical SEO and no citations still does not rank for a commercial head term.

**Links and citations** — target ~10–20 genuinely relevant ones, never a bought bundle:

- [ ] SaaS and software directories with real review flows: **G2, Capterra, SaaSworthy, Software
      Suggest, Product Hunt**. These rank for "best grocery app builder" style queries themselves,
      so a listing is both a link *and* a second search result you occupy.
- [ ] Indian startup directories: **StartupIndia, YourStory, Inc42, Tracxn, Crunchbase**.
- [ ] A **LinkedIn company page** and a founder posting the build story. For a bootstrapped Indian
      SaaS this is realistically the top referral source in year one.
- [ ] Razorpay's partner/ecosystem listing, if the integration qualifies.
- [ ] Indian retail-tech and kirana-digitisation publications — pitch data or a point of view, not
      a press release.
- [ ] `r/india`, `r/IndiaBusiness`, IndieHackers, relevant WhatsApp/Telegram retail groups —
      participate, don't drop links.

**Play Store as a search surface** (ASO — currently unexploited, and store owners *do* search the
Play Store):

- [ ] Optimise the Cordelia app's Play listing title, short description and long description for
      "grocery shopping app", "kirana", "online grocery ordering".
- [ ] Link the Play listing from the site and the site from the listing.
- [ ] Ship the iOS app once APNs is sorted — an App Store listing is a second indexable property.

**Proof** (matters for conversion *and* for the links above):

- [ ] First customer story, with a real store name and city, as soon as one store is live and
      willing. `How <Store> in <City> started taking online orders in a week.`
- [ ] Replace demo screenshots with real store screenshots where the store consents.
- [ ] Collect Play Store reviews from real shoppers of live stores.

**Measurement:**

- [ ] Wire GA4 (or keep the existing consent-gated telemetry) to fire a **signup conversion event**,
      so organic traffic can be attributed to store creations rather than pageviews.
- [ ] Run PageSpeed Insights / a Lighthouse CI check on `/` and record the Core Web Vitals
      baseline **before** adding pages. The foundation is good (self-hosted fonts, lazy video,
      fixed aspect ratios) — measure rather than pre-optimise, then hold the line as pages land.
- [ ] Set a monthly review: GSC impressions, clicks, average position, and the query list. Let the
      query list — not this doc — decide Wave 3.

---

## P5 — Strategic bets (evaluate later, do not start now)

- [ ] **Public web storefronts as programmatic SEO.** Every published store could have an
      indexable web page (`/store/<slug>`) with its real name, city, categories and catalog. This
      is the only idea here that scales without writing content: 200 live stores is 200 pages of
      genuinely unique, genuinely useful content, ranking for *"<store name> <city> online"* and
      *"grocery delivery in <area>"*. It also gives every store a shareable web link — a real
      product feature, not just an SEO one. **Gate it on volume**: with fewer than ~20 published
      stores it produces thin pages and does more harm than good. Revisit when the published-store
      count justifies it.
- [ ] **A Hindi landing page** (`/hi`), with `hreflang` pairing. The app already ships Hindi; the
      site does not. `किराना स्टोर ऐप` has real volume and almost no quality competition. Do this
      *after* the English pages prove which intents convert — translating the wrong pages is
      expensive.
- [ ] **City pages** (`/grocery-app-bangalore`) — **only** where real customers, real stores and
      real local detail exist. A hundred templated city pages with a swapped noun is the fastest
      way to earn a spam classification. This is a P5 for a reason.

---

## Explicitly not doing

Recorded so nobody proposes them later:

- ❌ Buying backlinks, or any link package sold by volume.
- ❌ AI-generating a large volume of thin blog posts.
- ❌ Near-duplicate keyword pages (`/grocery-app`, `/grocery-store-app`, `/grocery-mobile-app`)
      with the same body text.
- ❌ Templated city pages before there are customers in those cities.
- ❌ Keyword stuffing, hidden text, or repeating "grocery app" past the point of readability.
- ❌ Changing URLs after they are indexed — decide the slug once, at creation.
- ❌ Chasing a generic audit tool's 0–100 score. The score is not the customer.

---

## Sequencing summary

| Tier | Theme | Effort | When |
|---|---|---|---|
| **P0** | Broken OG image, sitemap/noindex conflict, GSC setup, title rewrite | ~1 day | This week |
| **P1** | One page → a real site architecture (6 promoted + 6 new pages) | 2–3 weeks | Next |
| **P2** | Homepage sharpening, FAQ expansion, internal linking, image SEO | ~3 days | Alongside P1 |
| **P3** | Blog infrastructure + 10 articles | 6–10 weeks | After P1 is indexed |
| **P4** | Directories, ASO, links, proof, measurement | Ongoing | Start P4 links during P3 |
| **P5** | Store directory, Hindi, city pages | — | Gated on volume |

The order matters: **P0 unblocks measurement, P1 creates the things that can rank, P3 and P4 make
them rank.** Doing P3 before P1 writes articles with nowhere to send the reader; doing P4 before
P1 builds links to a single page.
