# Contributing

## First-time setup

```bash
make setup   # wires git hooks + root flutter pub get
```

This is a **Dart pub-workspace monorepo** (`packages/core` + `apps/*`). `make setup` runs two things:
- `git config core.hooksPath .githooks` — activates the pre-commit hook
- `flutter pub get` at the repo root — resolves every package in the workspace in one pass

Run `make` targets from the repo root; run an app from its own folder (`apps/<app>`).

---

## Pre-commit hook (`.githooks/pre-commit`)

The hook runs automatically on every `git commit` and does two things:

### 1. Dart formatting
Formats any staged `.dart` files with `dart format` and re-stages them.
The commit is never blocked by formatting — it's fixed automatically.

### 2. Static analysis
Runs `flutter analyze --no-pub --fatal-infos`.
The commit is **blocked** if any issue is found. Fix the issues and re-commit.

---

## AI agent rule files

All agents load context from explicit pointers — no generated files, no sync scripts.
When a new doc is added to `docs/`, add a named pointer to each agent config so agents
know it exists and when to read it.

| Agent file | Agent | How context loads |
|---|---|---|
| `CLAUDE.md` | Claude Code | `@` eagerly loads conventions, architecture, end-goal |
| `.claude/skills/setup-project/SKILL.md` | Claude Code | `/setup-project` command |
| `GEMINI.md` | Gemini CLI | `@` eagerly loads conventions, architecture, end-goal, setup |
| `AGENTS.md` | Android Studio · Codex CLI | Inline conventions; named pointers to architecture, end-goal |
| `.cursor/rules/conventions.mdc` | Cursor | Inline conventions + named doc pointers, `alwaysApply: true` |
| `.cursor/rules/setup-project.mdc` | Cursor | `alwaysApply: false` — auto on setup questions |
| `.codex/skills/setup-project/SKILL.md` | Codex CLI | `$setup-project` command |
| `.amazonq/rules/conventions.md` | Amazon Q | Symlink → `docs/ai-rules/conventions.md` |
| `.amazonq/rules/architecture.md` | Amazon Q | Symlink → `docs/reference/architecture.md` |
| `.amazonq/rules/end-goal.md` | Amazon Q | Symlink → `docs/explanation/end-goal.md` |
| `.amazonq/rules/setup-project.md` | Amazon Q | Symlink → `docs/ai-rules/setup-project.md` |

**To update conventions:** edit `docs/ai-rules/conventions.md`.
**To update setup checklist:** edit `docs/ai-rules/setup-project.md`.
**To add a doc all agents see:** add it under `docs/`, add a named pointer in each agent config file listed above, and create a symlink in `.amazonq/rules/` pointing to it.

See `docs/explanation/ai-agents.md` for per-agent install and usage instructions.

---

## Makefile targets

Run all targets from the repo root.

| Target | What it does |
|---|---|
| `make setup` | First-time setup: git hooks + root `flutter pub get` |
| `make run-jokes` | Run the jokes app (`cd apps/jokes && flutter run`) |
| `make run-doc-scanner` | Run the doc_scanner app |
| `make web-jokes` / `make web-doc-scanner` | Run an app on Chrome |
| `make test` | `flutter test` in each app |
| `make analyze` | `flutter analyze` — covers the whole workspace |
| `make gen` | `build_runner` in core + each app |
| `make clean` | `flutter clean` per package, then root `flutter pub get` |
