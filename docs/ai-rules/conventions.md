## Build & Run

This is a **Dart pub-workspace monorepo** (`packages/core` + `apps/*`). A single `flutter pub get` at the repo root resolves every package; run `make` targets from the repo root.

After cloning, run `make setup` once to install git hooks and fetch packages.

```bash
make setup            # first-time setup: git hooks + root flutter pub get
make run-jokes        # run the jokes app        (cd apps/jokes && flutter run)
make run-doc-scanner  # run the doc_scanner app  (cd apps/doc_scanner && flutter run)
make run-ai-chat      # run the ai_chat app      (cd apps/ai_chat && flutter run)
make web-jokes        # run jokes on Chrome
make analyze          # flutter analyze — covers the WHOLE workspace in one pass
make test             # flutter test in each app
make gen              # build_runner in core + each app
make clean            # flutter clean per package, then root pub get
```

Dependencies: always `flutter pub get` **at the repo root** (never inside an app folder). Apps are run **from their own folder** (`apps/<app>`) — the root has no runnable app.

The pre-commit hook formats staged Dart files, runs the two convention checks
below, and runs `flutter analyze` at the root — commits are blocked if any of
them fails. CI runs the same three, so `--no-verify` only defers them.

```bash
make checks                  # everything the hook runs, on demand
make check-core-adoption     # a widget in core/ui/ that nobody calls
make check-test-isolation    # a test that builds the real graph or names a live host
```

Both encode a failure this repo shipped, and both are greppable rules that had
already drifted: six core widgets were extracted and never adopted, and a
widget test ran against a live API for months. Each takes a marker comment
(`// core-adoption: ignore — why`, `// test-isolation: ignore — why`) for a
deliberate exception. Reasoning: `docs/explanation/review-lessons.md`.

> First-time setup and contributor workflow: `docs/how-to/contributing.md`
> For folder structure, naming conventions, layer patterns, DI, and code examples see `docs/reference/architecture.md`.

---

## Forbidden Patterns

- Hardcoded colours, strings, spacing, or radii in widget files
- Business logic in `build()` or widget classes
- Giving an enum methods/fields in its own body (enhanced enum) when an `extension on` it would do — keep enums as bare case lists; put helpers, `switch` mappings, and string ↔ enum conversion in an extension beside the enum. Likewise, put repeated `String`/`num`/`DateTime` logic in an `extension on` that type, not a `*Utils` helper class or inline. Don't add a conversion extension for an enum that never crosses a string boundary; parse wire strings in the `*Model` (data layer), not the UI
- Comments that restate what the code or name already says — with business-logic naming most doc comments are redundant. Write **why** (non-obvious decisions, gotchas, constraints), not **what**. Don't repeat the same note in two places, and reserve longer comments for genuinely complex logic. Examples:
  - ❌ `/// Stops the app.` above `Future<…> stopApp(String name)` — the name says it
  - ❌ `/// Param is the app name.` above `RunAppUseCase` — the signature says it
  - ✅ `// Not const — owns the live WebSocket the other methods act on`
  - ✅ `// Returning a state equal to the current one is a no-op, so per-chunk updates don't rebuild`
- `import 'package:dio/...'` from `domain/`
- `if (state is XState)` — always use exhaustive `switch`
- `context.read<T>()` after an `await` without a `mounted` check
- More than one feature's logic in a single BLoC
- Exposing `*Model` classes outside the `data/` layer
- Calling `AppBottomSheet.show()` directly in a screen — use `showAppBottomSheet()` from `BaseScreenState`
- Extending `StatelessWidget`/`StatefulWidget` directly for full pages or screens
- Manually editing `.freezed.dart` or `.g.dart` files
- Using `setState` in a screen to store values that come from BLoC events — put them in BLoC state instead
- Putting a screen-specific BLoC in `buildBlocProviders` when it is not needed above the body — provide it in `buildBody` wrapping the screen instead
- Calling `add()` from inside a BLoC event handler — factor shared logic into a private method instead
- Using Flutter's built-in button widgets (`ElevatedButton`, `TextButton`, `OutlinedButton`, `FilledButton`) in screens or molecules — use `AppButton` with the appropriate `AppButtonVariant`
- Using a raw `PopupMenuButton` / `DropdownButton` for a menu/select — use `AppDropdownMenu` (themed, with `AppDropdownItem`)
- Inline `CircularProgressIndicator` in screens — use `LoadingIndicator` (spinner) or `LoadingDots` (inline "working…") from `package:core/core/ui/atoms/`
- A raw inline `TextField` in a slot whose surrounding chrome IS the field (a promo pill, a recessed strip, a voucher row) without re-adding what `AppTextField` bakes in: strip **every** border state (`isCollapsed: true` plus `border`/`enabledBorder`/`focusedBorder`/`disabledBorder: InputBorder.none` — the theme's `inputDecorationTheme` injects the pack's input border even into `InputDecoration.collapsed`) and dismiss on outside tap (`onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus()` — Flutter's default keeps focus on mobile)
- Relying on `AppButton.foregroundColor` for the label while also passing a `labelStyle` built from a `textTheme` role — the style's inherited theme ink silently wins over `foregroundColor` (invisible ink-on-ink when the fill is pinned across modes). When a button's fill is pinned to one colour in both themes, pin the label colour on the style too: `labelStyle: packStyle(tt).copyWith(color: cs.onX)`
- A hand-rolled empty/placeholder view — use the `EmptyState` molecule
- Hand-typing `Theme.of(context).extension<AppColorsExtension>()!` — use the `context.appColors` accessor it ships
- Raw `AnimatedSwitcher` for a skeleton/loaded/error content swap — use `AppSwitcher` (or the pack's preset over it), so the standard duration can't drift per screen
- Forking `IconInfoRow`'s row silhouette into a private `_Row` — it takes `subtitle`/`trailing`/`onTap`; if a variant is missing, extend it in core
- Inline `toStringAsFixed` price/percent formatting or `count > 1 ? 's' : ''` pluralization — use core's `num`/`int` extensions (`asPrice`, `asPercent`, `plural`; the `> 1` form renders "0 item" and has shipped as a bug)
- **Hardcoding a currency glyph, a decimal point, or an English month/AM-PM table.** Money and dates render through core's `AppFormat` — `asPrice`/`asPriceParts` for money, `asWeekdayDate`/`asCompactDate`/`asTime`/`asDateTimeLabel` for dates. German, French, Spanish and Italian all use a decimal **comma**, put the currency symbol **after** the amount, order the date day-first, and read the clock in 24 hours, so each of these prints an English number in a localized storefront:
  - `'₹${x.toStringAsFixed(2)}'` — the glyph belongs to the store (`StoreCurrency`), its side to the locale
  - `formatted.indexOf('.')` to split a price for two-size typography — split on `AppFormat.decimalSeparator`, and use `lastIndexOf`, since `'.'` is the *thousands* separator in three of those four languages
  - a private `_months`/`_weekdays` list, or composing `hour12`/`meridiem` into a time — name a CLDR skeleton instead and let the locale order the pieces
  - a connector baked into a format string (`'$date at $time'`) — "at" is copy; it goes in the string table with the operands as placeholders, so a translator can move or replace it
  - a currency amount inside a translated string (`"Under ₹100"`) — pass the amount in already formatted, so one key serves every currency
- **Showing a user text a machine wrote.** An HTTP client's message, an SDK's
  exception, `e.toString()` — these are written for a developer, in one
  language, and every one of them has shipped to a user here. Map a failure to
  copy once, at the presentation boundary, and rewrite only what was never
  written for a person: a server refusal or an app-authored message passes
  through untouched
- Crossing a layer boundary with only a **sentence** when the caller has to
  react to *why*. A failure two callers handle differently carries a
  machine-readable `code` (see `Failure.refused`), parsed once by the layer
  that owns the vocabulary. A screen that can only print the message will
  handle one refusal as though it were another
- A **sheet reporting its own validation through the host screen's
  `showSnackBar`** — a snack bar renders behind the modal barrier, so it is
  invisible exactly while it matters and stale by the time it isn't. A sheet
  shows its own errors inline; if a screen reports the same failure, the state
  carries a flag saying the sheet already has it
- **Closing a surface before the write it started has come back.** Popping on
  dispatch throws away whatever the user typed and then tells them it failed
  over an empty screen. An async submit resolves first; on failure the surface
  stays, holding the input
- A BLoC/Cubit handler that **returns without emitting** on a guard clause,
  when anything awaits it — the awaiting caller hangs forever. Every path
  answers, guards included. Note a value-equal state is dropped by `emit`, so
  "emit the same thing" is not an answer
- A **reset that leaves work in flight**. Clearing state must also invalidate
  what is already on the wire (bump the revision token, clear the scope key),
  or a late response repaints the state you just cleared
- **Denylist guards.** A guard that enumerates what is *blocked* silently
  grants every route added afterwards. Enumerate what is permitted
- **A branch that renders a skeleton (or nothing) behind a comment saying it
  is unreachable.** It is reachable. Every branch renders something a user can
  live with
- **Deriving state from a global fact by waiting to be told.** Anything that
  follows "who is signed in" or "which store is open" subscribes to it. A
  screen that has to notify it will one day sit outside the provider it needs
  and fail silently
- **Reacting to a route's arguments to detect a new navigation.** The same
  destination requested twice looks identical to an ordinary rebuild, so the
  second request is dropped; reacting to every rebuild instead drags the user
  off what they chose. Give the request its own identity (a counter stamped
  per call) and compare that
- Navigating to reach something **already in the widget tree** — change state
  instead. Re-entering a route to select a tab you are inside costs a remount,
  and only the first use looks like a navigation
- **Deduplicating copy by comparing the source-language value.** Two strings
  identical in English are routinely different elsewhere — one may be a
  width-budgeted short form. Compare every locale before merging, and keep a
  test asserting the character budget of any string in a narrow slot
- **A widget in `core/ui/` with no callers.** Extracting and adopting are one
  task, in one commit: a promotion that stops at "the shared version exists"
  leaves the duplication in place *and* adds a second thing to maintain
- Forking a shared widget without first naming **the one parameter that is
  missing** — that is what nearly every fork turns out to be. The converse is
  also a rule: if absorbing a variant needs **three or more** new config
  params, the fork is correct, and the reason belongs in the file so the next
  review doesn't undo it
- **A test that touches the network**, or a **test seam in production code**.
  Fakes are injected at the data-source (or repository) boundary. A static
  override added so a test can express something is a missing dependency
  boundary — add the boundary; global mutable state outlives the test that set
  it
- A **subscription with no error path**, or an empty state and an error state
  that render the same. Permission-denied, offline and genuinely-empty must be
  distinguishable, or a broken listener reads as "nothing here"
- Error states that omit the data needed to retry — every `*Error` state must carry enough context (e.g. `searchTerm`, `page`) for the BLoC to re-dispatch without reading prior state; screens must never inspect preceding states for retry inputs
- Creating a new entity that is structurally identical to an existing one — reuse the existing entity; a single `JokeEntity` works for both single-result and list-result use cases
- Adding constructor parameters to data source impls for infrastructure — data sources are `const` no-arg; they reach infrastructure through static singleton `.instance` calls
- Duplicating UI concerns (snackbars, bottom sheet or dialog presentation) across screens — these belong in `BaseScreenState`, `AppBottomSheet`, or `AppDialog`; if something appears in more than one screen, move it to the appropriate base class
- **Leaving a screen's bottom edge unpadded.** `BasePage`'s `Scaffold` and `BaseScreenState` add **no** `SafeArea` — every screen owns its own bottom inset, or its last control sits under the iOS home indicator and Android's gesture bar. Two shapes, pick one deliberately:
  - Ordinary content → wrap the body in `SafeArea`.
  - A surface that must bleed to the device edge (a bottom fade, a full-bleed canvas, a sheet-cornered docked region) → `SafeArea(bottom: false)`, and then **every** control in that subtree re-adds `MediaQuery.paddingOf(context).bottom` itself
- Adding that inset on only one branch of a screen that swaps bodies. A loading/loaded/empty/error/success swap puts several widgets in the same slot; the inset belongs on **each** of them. Getting it right on the happy path and missing it on the state you rarely look at is how this ships broken — check every branch, not just the one you're building
- Re-adding a bottom inset inside `AppBottomSheet` content, a `DockedBar`, or any wrapper that already applies one — `AppBottomSheet` pads for both the keyboard (`viewInsetsOf`) and the device inset, `DockedBar` wraps itself in `SafeArea`; doubling up leaves a visible dead gap. Add the inset at the boundary that opted out of it, never twice
- Hand-padding for the keyboard on a page — `BasePage` sets `resizeToAvoidBottomInset: true`, so the `Scaffold` already resizes; `viewInsets` handling is only for a surface outside that (a sheet, an overlay)
- Wrapping a screen's body in `AnnotatedRegion<SystemUiOverlayStyle>` — override `BaseScreenState.overlayStyle` instead, returning `BaseScreenState.lightStatusIcons` (coloured header canvas) or `BaseScreenState.themedStatusIcons(context)` (plain surface)
- Creating a `*Model` without a corresponding `*Entity`, or a `*Entity` without a corresponding `*Model` — every DTO in `data/` must map to an entity in `domain/` and vice versa; they are always a pair
- Registering a static-singleton service (`HttpService`, `SharedPreferenceService`, `ImagePickerService`, or any class with a `static final instance`) in GetIt, or calling `sl<T>()` for it — these are never in the GetIt graph; always access them via `ServiceName.instance`
- Writing field-by-field `Model(field: entity.field, ...)` construction inside a repository — use `Model.fromEntity(entity)` and `model.toEntity()` instead; every `*Model` must expose both
- Putting app-specific copy, feature logic, or product API URLs in `core` — `core` is the generic shared toolbelt only. Product strings/URLs go in each app's `lib/constants/` (`ValueConst` / `ApiConstants`); `core` keeps only `CoreConst`
- Listing a package in an app's `pubspec.yaml` that the app's own code does not import directly — each app declares only its direct deps (it gets the rest transitively via `core`). Keep `core` dependency-lean: only packages every app uses
- Naming the primary feature folder/entry after the product — the app's main feature is always `feature/home/` with `HomePage` / `HomeScreen`
- Unguarded native-only initialization or actions — generated apps are **previewed as Flutter Web** in the console, so nothing in the boot path or a tap handler may throw on web. Guard native/platform code behind `kIsWeb`:
  - **Startup must boot on web.** Wrap native init that throws on web — `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`, FCM (`firebase_messaging`), `flutter_local_notifications`, and similar — in `if (!kIsWeb) { … }` (or a `try/catch` that continues); device behaviour is unchanged. Example: `if (!kIsWeb) { await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); }`
  - **Native-only user actions degrade gracefully.** For a capability with no web implementation *or* one that is intentionally mobile-only (camera/gallery capture, native share/save, etc.), `kIsWeb`-guard the handler to no-op **with user feedback** — a snackbar such as `'… only available on mobile'` — never a silent dead button and never a thrown exception
  - Prefer plugins that ship a web implementation; reserve the guard for genuinely native-only paths. Put a shared native wrapper's guard in its `core` service (e.g. `ImagePickerService`) so every app inherits it; keep per-feature copy/snackbars in the app
  - **When a package won't even *compile* for web** (it or a dependency pulls in `dart:io` / `dart:ffi` / `dart:mirrors`), a runtime `kIsWeb` check is **not** enough — the import itself fails to compile. Isolate the platform code behind a **conditional import** with a web stub so the web build never sees the native import: `export 'x_stub.dart' if (dart.library.io) 'x_io.dart' if (dart.library.js_interop) 'x_web.dart';`. Rule of thumb: *compiles but throws at runtime* → `kIsWeb` guard; *won't compile for web* → conditional import. Dart **deferred loading** (`loadLibrary()`) is code-splitting, **not** a platform-compat tool — never reach for it to fix a web build

---

## Code Generation

Run after changing any `@freezed` or `@JsonSerializable` file. From the repo root, regenerate every package at once:

```bash
make gen
```

Or for a single package, run it from that package's folder:

```bash
cd apps/jokes && dart run build_runner build --delete-conflicting-outputs
```

Never manually edit `.freezed.dart` or `.g.dart` files.

---

## Git

```
<type>: <summary under 72 chars>

What changed:
- bullet

Why:
- bullet
```

Types: `feat` `fix` `chore` `refactor` `test` `docs` `ci`

---

## Maintaining agent instructions

This repo serves **7 AI agents** across **6 instruction surfaces** (Codex CLI + Android Studio share `AGENTS.md`). The canonical rule docs are `docs/ai-rules/conventions.md` and `docs/reference/architecture.md`.

When you change a shared rule, update **every** surface in the same commit:

| Surface | Agent(s) | Picks up canonical-doc edits |
|---|---|---|
| `CLAUDE.md` | Claude Code | ✅ auto (`@docs/…` import) |
| `GEMINI.md` | Gemini CLI | ✅ auto (`@docs/…` import) |
| `.amazonq/rules/` | Amazon Q | ⚠️ hybrid — plain rule docs are **symlinks** into `docs/` (auto-sync); per-skill files are **self-contained copies** (hand-sync, drift). Amazon Q reads symlink targets but cannot follow `@docs/…` prose references |
| `.cursor/rules/conventions.mdc` | Cursor | ⚠️ hand-sync — self-contained copy |
| `.github/copilot-instructions.md` | GitHub Copilot | ⚠️ hand-sync — self-contained copy |
| `AGENTS.md` | Codex CLI, Android Studio | ⚠️ hand-sync — self-contained copy |

The three ⚠️ files only **name** the doc path as prose; they carry their own condensed copy that drifts unless edited directly. Full per-agent detail: `docs/explanation/ai-agents.md`.

**Skills live in two parallel trees — keep them in sync.** Both Claude Code (`.claude/skills/`) and Codex CLI (`.codex/skills/`) read per-skill `SKILL.md` folders, but in different formats: Claude skills are thin (body + `@docs/…` import), Codex skills are **self-contained inline** (full content with YAML frontmatter, since Codex can't follow `@docs/…`). When you add, remove, or rename a skill, update **both** trees in the same commit — `.codex/skills/` does not inherit `.claude/skills/` edits — and add the matching self-contained `.amazonq/rules/<skill>.md`. A skill that exists in only one tree is the most common drift; verify with `ls .claude/skills .codex/skills`.
