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

The pre-commit hook formats staged Dart files and runs `flutter analyze` at the root — commits are blocked if analysis fails.

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
- A hand-rolled empty/placeholder view — use the `EmptyState` molecule
- Error states that omit the data needed to retry — every `*Error` state must carry enough context (e.g. `searchTerm`, `page`) for the BLoC to re-dispatch without reading prior state; screens must never inspect preceding states for retry inputs
- Creating a new entity that is structurally identical to an existing one — reuse the existing entity; a single `JokeEntity` works for both single-result and list-result use cases
- Adding constructor parameters to data source impls for infrastructure — data sources are `const` no-arg; they reach infrastructure through static singleton `.instance` calls
- Duplicating UI concerns (safe-area padding, snackbars, bottom sheet or dialog presentation) across screens — these belong in `BaseScreenState`, `AppBottomSheet`, or `AppDialog`; if something appears in more than one screen, move it to the appropriate base class
- Creating a `*Model` without a corresponding `*Entity`, or a `*Entity` without a corresponding `*Model` — every DTO in `data/` must map to an entity in `domain/` and vice versa; they are always a pair
- Registering a static-singleton service (`HttpService`, `SharedPreferenceService`, `ImagePickerService`, or any class with a `static final instance`) in GetIt, or calling `sl<T>()` for it — these are never in the GetIt graph; always access them via `ServiceName.instance`
- Writing field-by-field `Model(field: entity.field, ...)` construction inside a repository — use `Model.fromEntity(entity)` and `model.toEntity()` instead; every `*Model` must expose both
- Putting app-specific copy, feature logic, or product API URLs in `core` — `core` is the generic shared toolbelt only. Product strings/URLs go in each app's `lib/constants/` (`ValueConst` / `ApiConstants`); `core` keeps only `CoreConst`
- Listing a package in an app's `pubspec.yaml` that the app's own code does not import directly — each app declares only its direct deps (it gets the rest transitively via `core`). Keep `core` dependency-lean: only packages every app uses
- Naming the primary feature folder/entry after the product — the app's main feature is always `feature/home/` with `HomePage` / `HomeScreen`

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
