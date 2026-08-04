# FlutterAgentic — End Goal

## Vision

A **vibe-coding platform for Flutter**: a user describes an app in plain language and gets back a **production-grade Flutter app** — running, deployable, and store-ready. Prompt in, real app out.

The differentiator is **what we generate into**. Most vibe-coding tools emit a flat pile of widgets that works in the demo and rots on contact with a second feature. FlutterAgentic generates into a **proven, AI-legible Clean Architecture** — the same conventions documented in `CLAUDE.md` and proven by the `doc_scanner` and `ai_chat` reference apps. Every generated app is structured so that the *next* change — by a human or an agent — lands cleanly. We don't sell speed-to-demo; we sell **speed-to-maintainable**.

> **Closest market analog: [Rocket.new](https://www.rocket.new/)** — a $15M-funded "vibe solutioning" platform (idea → live web + Flutter mobile app in one browser tab; Figma/URL import; Provider/Riverpod/Bloc; Firebase/Supabase auth + backend; compiled APK/iOS builds; OpenAI/Anthropic/Gemini integrations; 25k+ templates — all **web/landing-page**, see Market Research; one-click deploy). Rocket is general-purpose and breadth-first across stacks. **Our wedge is depth in one stack:** opinionated, convention-locked Flutter output that stays editable and reviewable after generation — the architecture *is* the product, not an afterthought.

The platform is not opinionated about _what_ you build. It is ruthlessly opinionated about _how_ the generated code is organised — because that opinion is what makes the output survive past the first prompt.

---

## Market Research — Rocket.new teardown

Findings from studying Rocket.new (our closest analog), and what each means for us.

### 0. End-to-end pipeline — and where each step runs

```
USER (browser, thin client — installs nothing)
  1. Prompt  →  2. Generate  →  3. Compile + auto-fix  →  4. Preview  →  5. See / edit / export
                └──────────── 2–4 run on ROCKET'S SERVERS, never the user's machine ────────────┘
```

1. **Prompt** (browser) — idea / Figma import / URL. Browser just sends text.
2. **Generate** (*server-side, cloud*) — backend calls the LLM (agentic, multi-step) to emit a full project: Flutter for mobile, Next.js for web, plus backend routes / auth / DB schema. Token usage metered as plan credits. Code is written into a **cloud workspace/container**, not locally.
3. **Compile + auto-fix** (*server-side, Linux container*) — toolchain preinstalled; runs `flutter pub get` / analyze / build, catches Dart errors, and the agent re-prompts itself to fix them before showing anything. ("Fix issues in this code" triggers another pass.)
4. **Preview** — generated app compiled to **Flutter Web**, served in the container, shown in an iframe + device frame. Hot-reloads on each edit.
5. **See code / edit / export** — in-browser code view, prompt+code version history, one-click web deploy, **export full source to GitHub / IDE**.

**Is the generated code tested on an iOS / Mac system? No — not in the inner loop.**

| Stage | Runs on | Mac? |
|---|---|---|
| Generate → compile → fix → preview → iterate | Linux cloud container, Flutter Web | ❌ No |
| Android APK build | Linux cloud container | ❌ No |
| iOS IPA / App Store submission (final, optional) | macOS (CI / cloud Mac) | ✅ Only here |

The running preview you iterate on is **Flutter Web — never compiled or run on iOS/Mac**. Real iOS compilation/signing happens only at an optional final store-build step, because Apple's toolchain requires macOS.

> **For us:** generate + compile-fix + preview = **one Linux container** (the `web-terminal/server` bridge lifted into a managed sandbox); no Mac in the loop. iOS = a separate pay-per-build CI call (~$1–2 on GitHub Actions/Codemagic), only on demand. The server-side **compile-and-auto-fix gate** (step 3) is table stakes — it's our Phase 5 self-review gate (`flutter analyze`/build + `/review-code` → agent repairs before preview). **Container compute is cheap (~$0.03–0.25 per active session-hour on GCP spot/serverless — see plan); the LLM tokens dominate unit economics**, which is why Rocket meters credits by tokens, not container-minutes.

### 1. How they preview a "mobile app running on a device"

Rocket does **not** stream a real emulator for the live preview. The generated app is compiled to **Flutter Web**, served on a port, embedded in an `<iframe>`, and that iframe is sized to a phone viewport with a CSS **device bezel** around it. The "device" is a styled viewport, not an emulator — the same Dart code as mobile, just the web render at phone dimensions (the approach the `device_preview` package and Chrome DevTools device mode use). It's cheap, instant, hot-reloadable, and needs **no emulator, GPU, or Mac**. Real emulator/IPA execution is reserved for the final build step. Rocket's own language gives it away: "web and mobile **preview modes**," "test on different **screen sizes**," mobile apps get "a mobile-optimized **web link**."

> **For us:** the live "on a device" preview is a solved, cheap problem — Flutter Web in an iframe + a phone frame, no native infra. `apps/web_terminal` already renders the iframe preview; adding a device frame is client-only work. Native-fidelity preview (streamed emulator, Appetize-style) is an opt-in upgrade, not a prerequisite.

### 2. Their "25,000+ templates" are web-only — a mobile gap

Rocket's headline **25,000+ templates are entirely website / landing-page templates — zero mobile/Flutter app templates.** Their template gallery (`rocket.new/templates`, titled *"25K+ Ready-to-use website & landing page templates"*) is organized into ~37 **web verticals** (Technology 3,969, Professional Services 2,088, Health & Medical 1,067, Blog 1,044, Food & Beverage 1,040, …) with **no "Mobile App," "Flutter," "iOS," or "Android" category or filter** at all. In Rocket, mobile apps start from a blank **prompt or Figma import**, not a template — so the "25k templates" headline and the "Flutter app builder" are two separate parts of the product, and the template count does **not** represent mobile starting points.

> **For us (competitive gap):** the template moat we'd compete against is web-only. On mobile/Flutter, Rocket offers essentially nothing pre-built. A curated set of **Flutter app templates generated into our Clean-Architecture conventions** (the `doc_scanner` / `ai_chat` style) is a differentiator Rocket *lacks* — not a feature we'd be catching up on. This is the strategic backing for the Phase 6 "template gallery generated into our conventions" item.

---

## Decision — Platform console stack: React/Next.js (not Flutter web)

**The builder console is a React/Next.js web app. Flutter is reserved for what Flutter is for: the generated apps and the in-iframe live preview.**

Two distinct surfaces, only one of which is React:
- **Generated apps + live preview** — Flutter, always. The preview is the generated app compiled to Flutter Web and shown in an iframe + device frame (see Market Research). Unaffected by this decision.
- **Console chrome** (chat/prompt panel, code view, code diff, file tree, terminal, connectors, APIs, version history, deploy) — **React/Next.js**.

**Why React for the console:**
- **Code view + diff is the decider** — these need Monaco (VS Code's editor) or CodeMirror, JavaScript libraries with no real Flutter-web equivalent. Drop-in in React; an `HtmlElementView`/iframe bridge fight in Flutter.
- The rest of the chrome is DOM/text-heavy (markdown chat, split panes, file tree, diff viewer, command palette) — mature in React (shadcn/Radix, react-markdown), hand-rolled in Flutter web.
- **Terminal:** we already use xterm.js *through* the Flutter `xterm` wrapper — in React we use xterm.js directly, one less layer.
- Surrounding SaaS (landing, docs, auth, billing) needs SEO + fast first paint; Flutter web ships a heavy CanvasKit/WASM bundle with poor SEO.
- Category fit: v0 (Next.js), Bolt (React), Lovable (React).

**Identity is intact:** the product still *builds Flutter*. The console's stack is SaaS tooling, not the mission. The moat is the generated architecture, not the dashboard's language.

**Migration note:** `apps/web_terminal` (Flutter) was the prototype of this console. It is **superseded by the React console** — its small surface (terminal + preview iframe + app-runner) ports cleanly, and the **Node PTY bridge (`web-terminal/server`) is already JS and is reused as-is**. Switch before building the expensive parts (Monaco code/diff, connectors, version UI) on Flutter web, not after.

### v1 console surface (trim Rocket's mature UI to this)

- ✅ Chat / prompt panel with streaming responses
- ✅ Live preview (iframe + device frame, selectable viewport)
- ✅ Terminal / build logs
- ✅ File list + **read-only** code view (Monaco)
- ✅ Launch / deploy button

Deferred past v1: Connectors, APIs panel, Visual Edit, version/rollback UI, "suggested next step" chips, screenshot/share.

---

## Guiding Principles

1. **Generate into structure, not into a blob** — every generated app is full Clean Architecture (`domain/` → `data/` → `presentation/`), not a single-file widget dump. The structure is non-negotiable; it's the moat.
2. **AI-legible by construction** — every folder, file, and class name signals its role. An agent (or human) reading any single generated file can infer where it fits and extend it without a tour.
3. **Zero ambiguity at layer boundaries** — domain never knows about Flutter; data never knows about UI. The generator enforces this; the linter catches drift.
4. **Convention over configuration** — one way to do things, encoded in `CLAUDE.md` and the skills. The generator follows the rules without asking; output is predictable prompt-to-prompt.
5. **Editable after generation** — users own the code. They can clone, open in their IDE, run `/review-code`, and keep building. No lock-in, no black box.
6. **Testable by default** — every generated layer ships with manual-fake test scaffolding. No real-network tests, no `setState` for BLoC-derived state.

---

## The Generation Target (our "golden output")

The platform's quality bar is the codebase in this repo. Everything below already exists and is what the generator emits into — it's the spec, not a wishlist.

| Layer | What every generated app gets |
|---|---|
| **Architecture** | Clean Architecture — `domain/` → `data/` → `presentation/` per feature |
| **State management** | BLoC + Freezed sealed events/states |
| **DI** | `get_it` service locator wired in `injection_container.dart` |
| **Networking** | Dio via `HttpService` (static singleton); `BaseRepository` error mapping |
| **Error handling** | `Either<Failure, T>` — no thrown exceptions across layers |
| **Navigation** | GoRouter (declarative routes) |
| **Base classes** | `BasePage` (DI + Scaffold), `BaseScreen` (UI only), `BaseRepository` |
| **Design tokens** | `AppSpacing`, `AppRadius` — themable scale, no hardcoded brand colours |
| **UI atoms** | `AppButton`, `AppTextField`, `AppBadge`, `AppChip`, `AppCheckbox`, `AppDropdownMenu`, `LoadingIndicator`, `LoadingDots` |
| **UI molecules** | `AppBottomSheet`, `AppDialog`, `EmptyState`, `ErrorView` |
| **Testing** | Manual fakes pattern; `bloc_test`; widget test conventions |
| **AI rules** | `CLAUDE.md` with layer rules, forbidden patterns, commit format — shipped *in the generated repo* so the user's own agents stay on-rails |

---

## Progress

> **Phases 1–3 are the generation target — the foundation, now shipped.** They built and proved the conventions, the design system, the agent rules, and two production reference apps (`doc_scanner`, `ai_chat`). That work is no longer the end in itself; it's the **golden output the platform generates into**. Phases 4+ are the pivot: turning that hand-written foundation into a *prompt → app* engine.

---

### Phase 1 — Foundation ✅ Complete *(now: the architecture spec)*

**Core architecture**
- [x] Clean Architecture folder structure (`feature/{name}/data|domain|presentation`)
- [x] BLoC + Freezed sealed events/states
- [x] `get_it` DI with `initDependencies()` wired in `main()`
- [x] Dio networking via `HttpService` (`get` / `post` / `postStream`)
- [x] `BaseRepository` mixin with Dio-to-Failure error mapping
- [x] `Either<Failure, T>` error handling via fpdart
- [x] GoRouter navigation
- [x] `BasePage` / `BaseScreen` base classes — getter-based bottom nav, `buildBody` / `buildBlocProviders` hooks
- [x] `CLAUDE.md` with full architecture, layer rules, and AI coding conventions

**Design system**
- [x] `AppSpacing` token scale
- [x] `AppRadius` token scale
- [x] `AppButton` — primary / secondary / text variants, three sizes, loading state
- [x] `AppTextField` — label, hint, error state, focus-aware border
- [x] `AppBadge` — neutral / info / success / warning / error intents
- [x] `AppChip` — selectable, with icon support
- [x] `AppBottomSheet` — pinned header + scrollable body, static `show()` helper, `actions:` row
- [x] `AppTheme` builder — light/dark `ThemeData` from a single seed colour, wired to `ThemeMode.system`

**AI agent support**
- [x] Multi-agent rules: Claude Code, Cursor, Copilot, Gemini, Codex, Android Studio, Amazon Q
- [x] Skills: `setup-project`, `add-feature-template`, `rename-app`, `review-code`, `change-app-id`
- [x] Published to GitHub as open-source template

---

### Phase 2 — Production App: request/response reference (`doc_scanner`) ✅ Complete (v1.1.0) *(now: a generation exemplar)*

A real, production-grade app built entirely on the template — proof the conventions hold for more than demos, and the **request/response** exemplar the generator learns from (one call → one result). `apps/doc_scanner` solves a concrete need: consolidate multiple photos of receipts or bills into a single downloadable PDF for expense reimbursement.

- [x] `apps/doc_scanner/lib/feature/home/` — multi-image picker (camera + gallery) via `image_picker`
- [x] AI receipt extraction — Groq / Gemini / Claude backends behind a dispatcher
- [x] On-device PDF generation — `pdf` package, no backend, works offline
- [x] File share/save via native share sheet — `share_plus` + `path_provider`
- [x] Design-system additions used by the app: `AppDialog` molecule, `AppCheckbox` atom

---

### Phase 3 — Monorepo + streaming reference (`ai_chat`) *(now: a generation exemplar)*

Two themes: complete the monorepo migration (done, shipped in v1.2.0), and add the template's **streaming** reference app + the reusable `StreamUseCase` pattern — the counterpart to `doc_scanner`'s request/response.

- [x] Monorepo migration — pub-workspace (`packages/core` + `apps/*`); one root `flutter pub get` resolves all
- [x] All agent rules + skills updated for the monorepo (Claude, Codex, Cursor, Copilot, Gemini, Android Studio, Amazon Q)
- [x] CI pipeline (GitHub Actions) — `build_runner`, `flutter analyze`, `flutter test` (`.github/workflows/validate.yml`)
- [x] README with quickstart and architecture diagram
- [x] `StreamUseCase` base + `BaseRepository.handleStream` in `core`, documented in `docs/how-to/stream-usecase.md`
- [x] `apps/ai_chat` — AI chat with a real Groq backend (OpenAI-compatible) **and** a zero-setup local mock; in-app Groq API key entry (BYOK, stored on-device) with a dispatcher that routes to Groq once a key is set; user-toggleable streaming (token-by-token SSE) vs one-shot replies; markdown via `gpt_markdown`; Stop/cancel mid-stream; retry.

> **Store publishing — deferred / optional.** Shipping `doc_scanner` to the App Store / Play Store is no longer a phase goal: high friction, low payoff for the template's goal, and BYOK review risk. The full readiness checklist is preserved in `docs/how-to/publish-to-stores.md` for anyone who wants to do it (per-app version handling in the `release` skill is the first prerequisite there).

---

### Phase 3.5 — Style-pack system + ecommerce exemplar (`gravia`) 🚧 In progress *(now: a generation exemplar)*

`doc_scanner`/`ai_chat` proved the architecture is reusable; `gravia` proves the **visual identity** is too — a style-pack selection system (`docs/ai-rules/design.md`) plus a real ecommerce app generated from it, and the first app to exercise the "free pack" (logo, splash, onboarding) as reusable skills rather than one-off code.

- [x] Style-pack catalog + selection procedure (`docs/ai-rules/design.md`) — category/mood matching; `gravia` (ecommerce) profile with palette/shape/typography sampled from a real UI8 kit, not invented
- [x] `core/ui/blocks/` — cross-domain compositions (`section_header`, `quantity_stepper`, `bottom_nav_bar`, `collapsing_header_sheet`, `docked_bar_overlap`, `chunked_grid`) and ecommerce-domain compositions (`product_card`, `category_tile`, `product_meta_row`)
- [x] `apps/design_gallery` — Widgetbook showcase rendering every core atom/molecule/block against every theme preset; a new `core/ui/` component ships with its gallery entry in the same commit (sole documented exception: `AppFileThumbnail`, which imports `dart:io`)
- [x] `gravia` app logo, native splash screen, and onboarding flow — the "free pack" skills (`/add-app-logo`, `/add-splash-screen`, onboarding pattern) proven end-to-end on a real generated app, not just in isolation
- [x] Nav shell pattern (`feature/shell/`) for bottom-nav tabbed apps, documented in `docs/reference/architecture.md`
- [x] Product/ecommerce feature screens (home/product grid, categories + category details, cart, product details, orders, address CRUD + selection, profile + edit/change-password, search + recent searches, favourites, notifications, legal) — all wired end-to-end (BLoC → screen → navigation) on the `core/ui/blocks/` catalog and the gravia preset roster (`lib/widgets/`), with warm-start `BlocCache` on frequently-revisited screens
- [x] Full Firebase auth flow (`/connect-firebase` + `/add-firebase-auth` skills) — email/password signup/login, persistent email-verification sheet with 3s poll + resume-on-relaunch, forgot/reset password, Firestore profile dual-write behind a token-verifying API, local profile cache
- [x] Checkout + per-store Razorpay payments — `CheckoutBloc` runs create-intent → native checkout → server-verified order write; each store settles into its **own** Razorpay account (encrypted secret in `stores/{id}/private/payment`); provider-agnostic (orders feature has `OrdersRepository` + `PaymentGatewayRepository`, "Razorpay" in one file); test-mode payment-less path keeps checkout exercisable on web
- [x] Cancel + refund — shopper self-cancel pre-dispatch (optimistic, restock, auto-refund) and admin cancel, both via one dual-role server route; refund is a separate axis (`RefundStatus`); idempotent `settleRefund` + an admin "Complete/Retry refund" action; `IN_PROCESS` relabelled "On the way"
- [x] Refund hardening — Razorpay `refund.processed`/`refund.failed` webhook (per-store, signature-verified; auto `PENDING→PROCESSED`) and refund idempotency (pre-create lookup of a payment's existing refunds, so a retry can't double-refund)
- [ ] Post-delivery return/refund flow — refund is wired only to cancel today
- [ ] Remaining `comingSoon` stubs — gravia Orders' Track Order / View Details / Write A Review (the last is *order* rating, a separate feature from product reviews); Login's social buttons
- [x] A second style pack proven end-to-end — `dailyMart` ships every storefront surface as `cordelia`'s second template, with no screen falling through to `gravia` (see Phase 3.6); `grofast` followed as a third, generated by the skill. `rocketWarm`/`oceanBreeze`/`forestWalk`/`dadJokes` remain presets in the catalog without an exemplar app

---

### Phase 3.6 — Multi-tenant storefront platform (`cordelia`) 🚧 In progress *(the "super app": one shopper app, many stores)*

`gravia` proved one branded store end-to-end; `cordelia` proves the **platform** version of the same architecture — a single shopper app that discovers admin-created stores and opens any of them, restyled per store at runtime. Every storefront feature keeps ONE shared `domain`/`data` layer (store-scoped via `storeId` call params, backed by the admin backend's API) while each template ships only its own `presentation/templates/<id>/` UI; a store's `template_id` selects the template and its theme config at runtime (`StorefrontPage` swaps the app theme per visit, `StorefrontTemplateSwitch` dispatches routes pushed over the shell).

- [x] Store discovery → storefront session — `ActiveStoreCubit` seeded per visit and torn down via a session token, so replacing one storefront with another (tab jumps: "Track Your Order", "My Orders") can't clear the successor's state
- [x] `gravia` template ported end-to-end on the shared storefront layers — shell + home, categories + details, product details, cart, checkout with per-store Razorpay, orders + cancel, address CRUD/selection, profile + edit/change-password, search (per-store-scoped Hero flight), favourites, notifications, legal, full Firebase auth
- [x] `dailymart` — second template underway from its own UI8 kit spec sheet: nav shell (stacked bottom nav), Home (centred peeking promo carousel, category rail, product grid with static rating row), Notifications; pack-scoped icons, mock data (`assets/data/templates/<id>/`) and theme config
- [x] Template-agnostic notification model — `NotificationKind` in shared data; each template maps kinds to its own pack glyphs
- [x] Cross-template extractions promoted to `core` as they repeated — `IconInfoRow` (since extended with `onTap`/`trailing`/optional subtitle), `ShimmerListRow`/`ShimmerSectionHeader`/`ShimmerCircleTile`, `BaseScreenState.overlayStyle`, `SectionRail`, `PriceBreakdown` (ecommerce block), `AppIconCircle`, `AppSwitcher`, `num` extensions (`asPrice`/`asPercent`/`plural`), `context.appColors`
- [x] `dailymart` Search, Product Details and Cart — Search (recent searches + product grid idle state; categories-and-products vertical result list — the kit's floating Filter pill was later removed from Search, reserved for Category Details), Product Details (hero well, bare kit stepper, Descriptions/Reviews underline tabs with the kit's static Reviews frame, related grid, floating cart-disc + Add To Cart row), Cart (shell tab *and* routed page: swipe-to-delete rows, coupon stub, totals panel, checkout through the shared `CheckoutBloc`), plus the pack's sheet chrome (`showDailyMartSheet` on `AppBottomSheet`'s new `leading`/`centerTitle`/`handleSize`/`headerHeight` params) and a floating cart status pill on outside-shell screens
- [x] Template reusability sweep (2026-07-30) — both templates audited and deduplicated with zero visual change: shared shell base (`StorefrontShellPage`/`StorefrontShellState`), `QuantitySelection` mixin, `HeroSearchFieldFlight`, per-pack product grids + `DailyMartPill`, gravia's `Cordelia*` widgets relocated as `Gravia*`, `GraviaDimenConst` header-height tiers, and the core promotions listed above (details: `superapp-ecommerce-plan.md` §2026-07-30)
- [x] `dailymart` Profile slice — Profile tab (identity row + gravia's row set in the kit's bordered-strip rows), Edit Profile (140px avatar + pencil badge, floating Save Changes), Privacy & Policy / Terms (per-pack render of the shared `LegalDocumentContent`, kit-style always-visible scroll rail), and Select Address (tinted cards where selecting *is* committing — the kit gives the screen no confirm button), plus the pack wrappers they needed (`DailyMartMenuTile`, `DailyMartFormField`, `DailyMartOutlineButton`, `DailyMartActionPair`, `showDailyMartConfirmSheet`)
- [x] `dailymart` Checkout — the kit's `29 Checkout` frame as its own `feature/storefront/checkout/` presentation slice (the `CheckoutBloc` moved out of `cart/`, domain/data stay in `orders/`): address card → Select Address, read-only Order List, floating "Continue to Payment", and the `34 Order Successfully` body swapped in on success under an unchanged header. The kit's Shipping Type block + its picker sheet (`31`) are deliberately not built — one flat delivery perk, no courier tiers. `gravia` has no checkout frame and keeps running the flow inline from its Cart
- [x] Shopper avatar upload — Edit Profile (both templates) uploads the picked photo to Firebase Storage `users/{uid}/avatar.jpg` (owner-gated in `storage.rules`) and sends the download URL to `POST /api/users`, which persists it as `avatarUrl` on the Firestore profile doc and returns it as `avatar_url`; before this the picked bytes were screen-local and died on restart
- [x] `dailymart` Add/Edit Address — the pack's own form (header row → fields → floating CTA over the fade, the Edit Profile skeleton) with `DailyMartDropdownField` for the City/Country picklists, plus per-row **edit** (pencil disc) and **delete** (swipe-to-reveal behind the pack's confirm sheet, non-optimistic so a failed delete keeps the row) on Select Address. The kit draws none of these three affordances — each is composed from a recipe the pack already owned
- [x] Order status history — every transition is now dated in Firestore (`Order.statusHistory`, appended by `updateOrderStatus`/`cancelOrder` and seeded at placement), surfaced to the app as `OrderEntity.statusHistory` + `statusReachedAt`. Before this only `placedAt` and the *current* status existed, so no timeline could be dated; orders predating the field read back as a single dated "Placed" step with undated later ones
- [x] `dailymart` My Orders + Track Order — the kit's `35`/`36` frames: search + status chips over the order cards (each carrying its placed date), the kit's floating Filter pill brought over from Search for a **date-only** filter sheet (quick picks + range picker + Reset/Apply; status stays on the screen's chip row), and a dated status timeline. Track Order itemises the order rather than repeating the kit's single-product card, which stood for a whole basket by its first line item. Deviations recorded in the spec sheet, all where the kit shows data the backend doesn't have (six pipeline steps → the three real statuses, no ETA, tracking id → order id)
- [x] `dailymart` Category Details — the kit's gridded `20` frame (back disc + tap-to-navigate search bar, category name + "N founds", the pack's 2-column grid) with the kit's floating Filter pill over it, opening frame `21`'s sheet for Sort by / Price (gravia's two axes on the shared `CategoryDetailsBloc`; the kit's third Category field is navigation, not a filter, so it isn't reproduced). The route now dispatches through `StorefrontTemplateSwitch` instead of always opening gravia's screen
- [x] `dailymart` Wishlist tab — the pack's back-less header row over its standard product grid, composed from recipes the pack already owned since the kit ships no wishlist frame; renders `FavouritesCubit` directly (no bloc), every heart filled so tapping one removes. With it the template has **no** surface left falling through to a `gravia` screen, and Checkout's success CTA now opens dailymart's own My Orders instead of a coming-soon snackbar
- [x] Template audit + violation/promotion sweep (2026-07-31) — with both templates complete, a four-track audit (duplication, forbidden patterns, shared-layer template-agnosticism, dispatch coverage) ran and everything it found was fixed: shared enums/auth de-templated (auth keeps the gravia look on app-level `Cordelia*` widgets the gravia pack aliases), theme-swap race session-guarded, cross-template screen state promoted to shared mixins (`EditProfileForm`/`ChangePasswordForm`/`AddressFormFields`/`signOutAndReturnToLogin`), `DailyMartScreenBody` replacing 7 `_Page` copies + 8 floating-CTA stacks, core gains (`context.appShapes`, `AppBottomSheet` chromeless mode, `HeroSearchFieldFlight` + `AppRadioRow` gallery entries), and every `state is`/bottom-inset/spinner-loading violation closed (details: `superapp-ecommerce-plan.md` §2026-07-31)
- [x] `/add-storefront-template` skill (2026-08-01) — the dailymart-proven port as a repeatable recipe (`docs/how-to/add-storefront-template.md`): Figma-MCP kit sampling → theme/constants/spec-sheet contracts, frame inventory against the implemented storefront surfaces (discard-and-record deviations), full end-to-end implementation over the unchanged shared layers, review + cross-pack promotion sweep, docs/progress update
- [x] `grofast` — **third** template, and the first built *by* the `/add-storefront-template` skill rather than by hand (2026-08-03). The UI8 GROFAST grocery kit ported end-to-end over unchanged shared layers: every storefront surface, four kit-exact signature shapes (domed sheets with a floating handle, a domed nav whose top edge lifts around the active tab's gradient disc, the product card's welded corner **+**, and a staggered grid produced by a single short first card), a two-family type pairing (Raleway + Montserrat numerics), and 18 recorded deviations where the kit draws data this backend doesn't have. Core gained `AppButton.gradient` and `AppBottomSheet.shape` (details: `superapp-ecommerce-plan.md` §2026-08-03)
- [x] Three-template utils/reuse sweep (2026-08-04) — the review that follows a third pack landing, and everything it found closed. Defects: grofast Product Details rebuilt on the pack's switcher with a structure-mirroring skeleton (it was the one screen that jumped on load and left the dock's device inset unpaid); the nav Bag dot now reads `CartCubit` instead of being hardcoded lit; gravia's `ProfileBloc` hoisted to `buildBlocProviders` so the Profile tab stops re-shimmering per visit. De-templating: Notifications' `domain`/`data` now key on `storeId` + the store's `template_id` wire string, so no feature holds a `StorefrontTemplate`, and `HomeBloc` keeps its own `storeId` like every sibling. Consolidation: 12 `*_bloc_provider.dart` factories adopted at every call site, `ChromelessStorefrontPage` across 28 pages, a shared `OrdersDateFilterState` mixin, per-pack `GraviaSwitcher`/`DailyMartSwitcher`, grofast's 5 inline skeletons moved to `widgets/`, both `formattedPrice` wrappers deleted for `.asPrice`, and `IconInfoRow`/`AppButton` reclaiming two grofast forks. The recurring lessons went back into `/add-storefront-template` (all three copies) as its new "structural conventions" shelf
- [x] Product reviews end-to-end — any signed-in shopper rates a product 1–5 with optional text (one review per shopper per product, re-posting edits it); `verifiedPurchase` is derived server-side from delivered orders as a badge, never a gate. Aggregates (`ratingAverage`/`reviewCount`/`ratingBuckets`) ride on the product doc and move in the same transaction as every write, so a grid prints a rating with zero extra reads; all three templates render a reviews section + write sheet, and the admin console gains a moderation list. Rating a *delivered order* remains a separate, unbuilt feature
- [ ] Per-store notifications from the backend — today a bundled per-template mock

---

### Phase 4 — Core Infrastructure Modules *(the generator's parts bin)*

Modules every real app eventually needs, as abstract interfaces with swappable implementations. These are not just dev conveniences anymore — they're the **building blocks the generator composes** when a prompt implies them ("users log in" → auth scaffold; "send a reminder" → notifications). Each one shipped is one more capability the engine can emit correctly.

- [x] `AppRadioGroup` — shipped as a core molecule (`AppRadioGroup<T>` + `AppRadioRow`), promoted from gravia's `RadioOptionsSheetContent`
- [ ] `AppSnackbar` atom (success / error / info variants)
- [ ] Pagination mixin for list features
- [ ] Secure storage — `flutter_secure_storage` backed interface in `core/storage/`
- [ ] Push notifications — FCM-backed `NotificationService` abstraction in `core/notifications/` *(capability shipped app-side in `doc_scanner` + as the repeatable `add-notification-feature` skill; the `core` abstraction itself is still open)*
- [ ] Deep linking — `app_links` backed `DeepLinkService` in `core/deep_link/` (GoRouter wired)
- [ ] Connectivity awareness — `OfflineBanner` molecule + `ConnectivityService`
- [ ] Analytics abstraction — `AnalyticsService` + `NoOpAnalyticsService` default
- [ ] Crash reporting abstraction — `CrashReportingService` + `NoOpCrashReportingService` default
- [ ] Auth scaffold — `feature/auth/` with login → token → protected route pattern
- [ ] Web-specific layout helpers (responsive breakpoints, side-nav shell)

---

### Phase 5 — Generation Engine (the core pivot)

Turn the hand-written conventions into a deterministic *prompt → feature* engine. The agent already follows `CLAUDE.md`; this phase productizes that into a repeatable, validated pipeline.

- [ ] **Spec extraction** — parse a natural-language app/feature description into a structured spec (entities, screens, data sources, use cases, navigation).
- [ ] **Feature generator** — emit a complete Clean-Architecture feature (data + domain + presentation + DI registration + tests) from the spec, reusing the existing `add-feature-template`, `add-usecase`, and `stream-usecase` skills as the generation grammar.
- [ ] **Self-review gate** — run `/review-code` (and `flutter analyze` + `flutter test`) on generated output automatically; auto-repair findings before returning, so output is on-rails by construction, not by luck.
- [ ] **App scaffolder** — generate a whole new `apps/<app>` from a one-line idea: native folders, theme config, constants, `home/` feature, DI, README.
- [ ] **Determinism harness** — golden tests proving the same spec yields the same structure across runs; measure drift.

---

### Phase 6 — Multi-Input & Product Surface

Match the table-stakes input methods the category (Rocket.new, Lovable, etc.) has set, on top of our structured-output advantage.

- [ ] **Idea → app** from a single plain-language prompt (Phase 5 engine behind a UI).
- [ ] **Figma → app** — import a design and map frames to screens/atoms in the design system.
- [ ] **URL → app** — recreate/reimagine a referenced site's layout into Flutter web.
- [x] **Live preview** — shipped for the web target: `flutter run -d web-server` rendered in an iframe with selectable phone device frames and a visual-edit overlay (click a widget → jump to source or edit text inline → hot restart), in `web-terminal/console` (React) + `web-terminal/server` (bridge). Native emulator/device preview remains local-macOS only.
- [ ] **Conversational refine loop** — describe → build → refine → ship, with full context retained between turns.
- [ ] **Template gallery** — curated starting points generated *into our conventions* (vs. a flat template dump).

---

### Phase 7 — Backend, Build & Deploy

Close the loop from generated code to a thing users can actually ship.

- [x] **Cloud workspace (the Rocket-model infrastructure)** — console + bridge + Flutter SDK + `claude`/`codex` packaged as one Docker image, deployed as one isolated GCE spot VM per user (URL + token, TLS via Caddy, persistent `/workspace` and agent login). Scripted create/delete flow; see `docs/how-to/deploy-workspace-gcp.md` and `docs/explanation/cloud-workspace-plan.md`. Follow-ups: idle reaping, auto-restart after spot preemption, self-serve provisioning.
- [ ] **Backend automation** — Firebase/Supabase wiring (auth, database, storage) generated from the spec, behind the existing `core` service abstractions.
- [ ] **LLM integration panel** — connect Anthropic / OpenAI / Gemini in plain language, reusing the BYOK + dispatcher pattern proven in `ai_chat` and `doc_scanner`.
- [ ] **One-click web deploy** — generated Flutter web hosted at a URL.
- [ ] **Mobile build pipeline** — APK / iOS build artifacts, store-submission-ready (revives the `publish-to-stores` checklist as an automated step).
- [ ] **Code export / ownership** — user downloads the full repo, opens it in their IDE, and keeps building. No lock-in is a feature, not a fallback.

---

## How to Measure Success

The end goal is reached when:
1. A non-developer describes an app in plain language and gets back a **running Flutter app** — full Clean Architecture, tests passing, `flutter analyze` clean — without touching code.
2. The generated repo is **indistinguishable in structure** from the hand-written `doc_scanner` / `ai_chat` reference apps: same layer boundaries, same naming, same forbidden-pattern compliance — verified by `/review-code` passing on first generation.
3. A developer can **export the generated code, open it in their IDE, and add a feature** (their own or via an agent) that lands cleanly — proving the output is maintainable, not disposable.
4. The same spec generates an app that runs on **Android/iOS and Web** from one codebase, with zero platform-specific hacks in `core/`.
5. On the dimensions that matter to us — *maintainability and editability of generated code* — output beats general-purpose vibe-coding platforms (Rocket.new, Lovable) because we generate into a proven architecture instead of a blob.
