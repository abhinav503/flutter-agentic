# FlutterAgentic — Gemini Rules

> Full reference → `docs/` folder

## Monorepo layout

Dart pub-workspace monorepo: one shared `core` package consumed by multiple Flutter apps.

```
packages/core/   shared toolbelt → import 'package:core/core/…'   (no app-specific code)
apps/jokes/      demo app          apps/doc_scanner/  request/response app
apps/ai_chat/    streaming app
```

One `flutter pub get` at the repo root resolves all packages. Run `make` targets from the root; run an app from its folder (`apps/<app>`). Each app owns its `main.dart`, `di/injection_container.dart`, and `constants/` (`ValueConst`/`ApiConstants`); `core` holds only `CoreConst`. The primary feature is always `feature/home/`.

@docs/ai-rules/conventions.md
@docs/reference/architecture.md
@docs/explanation/end-goal.md

Read `docs/how-to/contributing.md` for contributor workflow and git hooks.
Read `docs/how-to/add-feature-template.md` when scaffolding a new feature — it has the full folder tree, empty class skeletons, DI registration order, and a forbidden-pattern checklist.
Read `docs/how-to/add-usecase.md` when adding a use case — create the class and register it in `injection_container.dart`.
Read `docs/how-to/design-screen-state.md` when designing BLoC events and states — covers business-logic naming, state design, retry context, and screen rendering rules with examples from the jokes feature.
Read `docs/how-to/review-code.md` when the user asks to review, audit, or check generated code — run through the full checklist and report ✅/❌ per section.
Read `docs/how-to/change-app-id.md` when the user asks to change the application ID or bundle identifier — covers Android (`build.gradle.kts` + `MainActivity.kt` package path) and iOS (`project.pbxproj`), with Xcode manual steps and provisioning notes.
Read `docs/how-to/rename-app.md` when the user asks to rename the app — covers display name, package name, and all files that reference the old name.
Read `docs/how-to/connect-firebase.md` when connecting an app to Firebase — covers checking/installing the Firebase + FlutterFire CLIs, running `flutterfire configure`, per-app `firebase_core`, `main.dart` init, Android Gradle plugin, iOS deployment target (15.0+), and the Xcode `GoogleService-Info.plist` registration check; it asks which app under `apps/` to connect.
Read `docs/explanation/ai-agents.md` for per-agent install and usage.
Read `docs/tutorials/solid-principles.md` to understand how SOLID principles are applied across all layers — useful context when designing new classes or reviewing layer boundaries.
Read `docs/tutorials/design-patterns-and-concepts.md` for design patterns used in this codebase (Singleton, Repository, DTO, Either, Sealed Classes, Strategy, and more) — explains the why behind structural decisions.
When the user asks to do a release, follow the steps below interactively — ask for confirmation at each step before proceeding.

## Release Workflow

**Prerequisites** — this repo uses **multiple GitHub accounts**, so release auth must be explicit. The token lives in a git-ignored `.env` at the repo root. Load it and verify `gh`:
```bash
which gh
set -a && . ./.env && set +a    # exports GH_TOKEN from the root .env
gh auth status
```
`gh auth status` should report `Logged in … (GH_TOKEN)`. Source `.env` in every shell that runs a `gh` command — non-interactive shells don't inherit it. If `gh` is missing: `brew install gh`. If `.env` has no `GH_TOKEN`, create a fine-grained PAT (Contents: Read and write on this repo) at https://github.com/settings/personal-access-tokens/new and add it as `GH_TOKEN=…` to `.env` (never commit it). Stop if not ready. If `gh auth status` reports the token as invalid, confirm the shell has network access before replacing it — in a sandboxed agent environment, blocked network access can surface as an auth failure; re-run with network permission and `.env` sourced first.

**Step 1 — Identify release branch**
```bash
git branch --show-current
```
If not `main`, ask: "Release from `{branch}`? Confirm or type a different name." Record as `{RELEASE_BRANCH}`.

**Step 2 — Compare to main**
```bash
git log main..{RELEASE_BRANCH} --oneline
git diff main..{RELEASE_BRANCH} --stat
```
Show the commit list for the user to review.

**Step 3 — Version bump** — read current version:
```bash
grep "^version:" pubspec.yaml
```
Format: `MAJOR.MINOR.PATCH`. Rules: Major = breaking change; Minor = any `feat:` commit or new component/skill; Patch = fix/chore/docs/refactor only. Propose bump with one sentence of reasoning. Wait for confirmation.

**Step 4 — Update `pubspec.yaml`** — replace the version line with the confirmed version.

**Step 5 — Write release notes** — create `docs/releases/v{NEW_VERSION}.md` from `docs/releases/_template.md`. Two sections only:
- **Features** — what a developer gains: new components, apps, integrations
- **Agent Context Improvements** — what AI agents gain: new skills, rules, doc refs

Rules: plain language only; one bullet per change; one sentence per bullet; no duplicates across sections; nothing obvious. Show draft and ask "Does this look good?" Wait for confirmation.

**Step 6 — Commit on release branch**
```bash
git add pubspec.yaml docs/releases/v{NEW_VERSION}.md
git commit -m "chore: release v{NEW_VERSION}"
git push
```

**Step 7 — Merge to main**
```bash
git checkout main && git pull origin main
git merge --no-ff {RELEASE_BRANCH} -m "chore: merge {RELEASE_BRANCH} into main for v{NEW_VERSION}"
git push origin main
```
Stop on conflicts — ask user to resolve, then continue.

**Step 8 — Tag and GitHub Release**
```bash
git tag v{NEW_VERSION}
git push origin v{NEW_VERSION}
gh release create v{NEW_VERSION} \
  --title "v{NEW_VERSION} — {SUMMARY_TITLE}" \
  --notes-file docs/releases/v{NEW_VERSION}.md \
  --target main
```
Report the release URL.

**Step 9 — Clean up** — ask: "`{RELEASE_BRANCH}` has been merged. Delete it?" If yes:
```bash
git branch -d {RELEASE_BRANCH}
git push origin --delete {RELEASE_BRANCH}
```

---

## Project Setup

When the user asks about running the project locally, setting up their environment, or troubleshooting missing tools or emulators, follow the instructions in `docs/ai-rules/setup-project.md`.
