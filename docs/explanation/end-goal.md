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
- [x] `core/ui/blocks/` — cross-domain compositions (`section_header`, `quantity_stepper`, `bottom_nav_bar`) and ecommerce-domain compositions (`product_card`, `category_tile`)
- [x] `gravia` app logo, native splash screen, and onboarding flow — the "free pack" skills (`/add-app-logo`, `/add-splash-screen`, onboarding pattern) proven end-to-end on a real generated app, not just in isolation
- [x] Nav shell pattern (`feature/shell/`) for bottom-nav tabbed apps, documented in `docs/reference/architecture.md`
- [x] Product/ecommerce feature screens (home/product grid, categories, cart, product details, orders, address, profile, search) — all wired end-to-end (BLoC → screen → navigation) on `product_card`/`category_tile` and the rest of the `core/ui/blocks/` catalog
- [ ] Real checkout flow — "Proceed to Checkout" on the Cart screen is still a `comingSoon` stub (same pattern as the cart's coupon-apply); no payment/order-confirmation screens exist yet
- [ ] A second style pack proven end-to-end — today only `gravia` has a real app behind it; `rocketWarm`/`oceanBreeze`/`forestWalk`/`dadJokes` are presets in the catalog without an exemplar app

---

### Phase 4 — Core Infrastructure Modules *(the generator's parts bin)*

Modules every real app eventually needs, as abstract interfaces with swappable implementations. These are not just dev conveniences anymore — they're the **building blocks the generator composes** when a prompt implies them ("users log in" → auth scaffold; "send a reminder" → notifications). Each one shipped is one more capability the engine can emit correctly.

- [ ] `AppRadioGroup` and `AppSnackbar` atoms (success / error / info variants)
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
