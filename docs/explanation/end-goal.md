# FlutterAgentic — End Goal

## Vision

A Flutter template repository optimised for **Flutter developers working with AI coding agents**. It should be general enough that any mobile or web dev can clone it, drop in their feature, and have a production-grade structure in place from day one — without fighting the boilerplate.

The repo is not opinionated about _what_ you build. It is opinionated about _how_ the code is organised, so that AI agents (Claude Code, Copilot, Cursor, etc.) can navigate, extend, and test it reliably.

---

## Guiding Principles

1. **AI-legible architecture** — every folder, file, and class name signals its role clearly. An agent reading any single file should be able to infer where it fits in the system.
2. **Zero ambiguity at layer boundaries** — domain never knows about Flutter; data never knows about UI. Violations are caught by the linter.
3. **Convention over configuration** — one way to do things, documented in `CLAUDE.md`. Agents follow the rules without needing to ask.
4. **General, not branded** — no app-specific colours, copy, or business logic in core. Everything in `core/` works for any app.
5. **Testable by default** — every layer is independently testable with manual fakes. No real-network tests, no `setState` in test files.

---

## What a Flutter Dev Gets Out of the Box

| Layer | What's provided |
|---|---|
| **Architecture** | Clean Architecture — `domain/` → `data/` → `presentation/` per feature |
| **State management** | BLoC + Freezed sealed events/states |
| **DI** | `get_it` service locator wired in `injection_container.dart` |
| **Networking** | Dio + Retrofit generated clients; `BaseRepository` error mapping |
| **Error handling** | `Either<Failure, T>` — no thrown exceptions across layers |
| **Navigation** | GoRouter with typed routes |
| **Base classes** | `BasePage` (DI + Scaffold), `BaseScreen` (UI only), `BaseRepository` |
| **Design tokens** | `AppSpacing`, `AppRadius` — neutral scale, no brand colours |
| **UI atoms** | `AppButton`, `AppTextField`, `AppBadge`, `AppChip` |
| **UI molecules** | `AppBottomSheet`, `ErrorView`, `LoadingIndicator` |
| **Testing** | Manual fakes pattern; `bloc_test`; widget test conventions |
| **AI rules** | `CLAUDE.md` with layer rules, forbidden patterns, commit format |

---

## Progress

### Phase 1 — Foundation ✅ Complete

**Core architecture**
- [x] Clean Architecture folder structure (`feature/{name}/data|domain|presentation`)
- [x] BLoC + Freezed sealed events/states
- [x] `get_it` DI with `initDependencies()` wired in `main()`
- [x] Dio + Retrofit networking
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

### Phase 2 — Production App + Core Infrastructure

The first public phase is complete. Phase 2 runs two parallel tracks:

**Track A — Receipt/Bill-to-PDF Scanner (publishable app, Feature #2)**

The goal is a real app, published to the App Store and Play Store, that proves the template works for production — not just demos. The app solves a real-world need: consolidate multiple photos of receipts or bills into a single downloadable PDF for expense reimbursement.

- [ ] `feature/doc_scanner/` — multi-image picker (camera + gallery)
- [ ] Image preview and reorder screen
- [ ] On-device PDF generation — `pdf` package, no backend, works offline
- [ ] File share/save via native share sheet — `share_plus` + `path_provider`
- [ ] Runtime permission handling — `permission_handler`
- [ ] Published to App Store and Play Store

**Track B — Core infrastructure modules**

Modules that every Flutter app eventually needs, structured as abstract interfaces with concrete implementations so any developer can swap the backend.

- [ ] `AppCheckbox` and `AppRadioGroup` atoms
- [ ] `AppSnackbar` helper (success / error / info variants)
- [ ] `AppDialog` — confirm/alert modal
- [ ] Pagination mixin for list features
- [ ] Secure storage — `flutter_secure_storage` backed interface in `core/storage/`
- [ ] Push notifications — FCM-backed `NotificationService` abstraction in `core/notifications/`
- [ ] Deep linking — `app_links` backed `DeepLinkService` in `core/deep_link/` (GoRouter wired)
- [ ] Connectivity awareness — `OfflineBanner` molecule + `ConnectivityService`
- [ ] Analytics abstraction — `AnalyticsService` + `NoOpAnalyticsService` default
- [ ] Crash reporting abstraction — `CrashReportingService` + `NoOpCrashReportingService` default
- [ ] Auth scaffold — `feature/auth/` with login → token → protected route pattern
- [ ] CI pipeline (GitHub Actions) — format check, analyse, test
- [ ] Web-specific layout helpers (responsive breakpoints, side-nav shell)
- [ ] README with quickstart and architecture diagram

---

## How to Measure Success

Phase 2 is complete when:
1. The doc scanner app is live on both the App Store and Play Store, built entirely from this template.
2. A developer can clone this repo and add push notifications, deep links, and secure storage without writing any infrastructure code — only wiring up the existing interfaces.
3. An AI agent given `CLAUDE.md` and a feature spec can generate a correct feature (data + domain + presentation + tests) with minimal iterations — running `/review-code` after generation catches any drift before it is merged.
4. The app runs on both Android/iOS and Web from the same codebase with zero platform-specific hacks in `core/`.
