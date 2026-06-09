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
| **Base classes** | `BasePage` (DI + Scaffold + MasterBloc), `BaseScreen` (UI only), `BaseRepository` |
| **Design tokens** | `AppSpacing`, `AppRadius` — neutral scale, no brand colours |
| **UI atoms** | `AppButton`, `AppTextField`, `AppBadge`, `AppChip` |
| **UI molecules** | `AppBottomSheet`, `ErrorView`, `LoadingIndicator` |
| **Testing** | Manual fakes pattern; `bloc_test`; widget test conventions |
| **AI rules** | `CLAUDE.md` with layer rules, forbidden patterns, commit format |

---

## Progress

### Foundation
- [x] Clean Architecture folder structure (`feature/{name}/data|domain|presentation`)
- [x] BLoC + Freezed sealed events/states
- [x] `get_it` DI with `initDependencies()` wired in `main()`
- [x] Dio + Retrofit networking
- [x] `BaseRepository` mixin with Dio-to-Failure error mapping
- [x] `Either<Failure, T>` error handling via fpdart
- [x] GoRouter navigation
- [x] `BasePage` / `BaseScreen` / `BasePageWithoutBloc` base classes — body-scoped loader, getter-based bottom nav, `buildLoader()` hook
- [x] `MasterBloc` for body-scoped blocking loader (auth / form submit only)
- [x] `CLAUDE.md` with full architecture, layer rules, and AI coding conventions

### Design System
- [x] `AppSpacing` token scale
- [x] `AppRadius` token scale
- [x] `AppButton` — primary / secondary / text variants, three sizes, loading state
- [x] `AppTextField` — label, hint, error state, focus-aware border
- [x] `AppBadge` — neutral / info / success / warning / error intents
- [x] `AppChip` — selectable, with icon support
- [x] `AppBottomSheet` — pinned header + scrollable body, static `show()` helper, `actions:` row

### Planned
- [x] `AppTheme` builder — light/dark `ThemeData` from a single seed colour, wired to `ThemeMode.system`
- [ ] `AppCheckbox` and `AppRadioGroup` atoms
- [ ] `AppSnackbar` helper (success / error / info variants)
- [ ] `AppDialog` — confirm/alert modal
- [ ] Pagination mixin for list features
- [ ] CI pipeline (GitHub Actions) — format check, analyse, test
- [ ] Example second feature (non-jokes) to prove the pattern generalises
- [ ] Web-specific layout helpers (responsive breakpoints, side-nav shell)
- [ ] README with quickstart and architecture diagram

---

## How to Measure Success

The template is ready when:
1. A developer can scaffold a new feature by copying the jokes feature and changing names — with no layer violations flagged by `flutter analyze`.
2. An AI agent given `CLAUDE.md` and a feature spec can generate a correct feature (data + domain + presentation + tests) in one pass with no manual fixes.
3. The app runs on both Android/iOS and Web from the same codebase with zero platform-specific hacks in `core/`.
