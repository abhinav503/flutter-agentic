# Contributing to FlutterAgentic

Thanks for your interest in contributing.

## Quick start

```bash
git clone <repo>
cd flutter-agentic
make setup   # wires git hooks + flutter pub get
```

Full contributor workflow, git hooks, Makefile targets, and AI agent config guide:
**[docs/how-to/contributing.md](docs/how-to/contributing.md)**

## Before you code

Read the architecture and conventions — agents and humans are held to the same rules:

- [docs/reference/architecture.md](docs/reference/architecture.md) — folder structure, layer patterns, naming, DI
- [docs/ai-rules/conventions.md](docs/ai-rules/conventions.md) — forbidden patterns, commit format, code generation

## Scaffolding a new feature

Follow [docs/how-to/add-feature-template.md](docs/how-to/add-feature-template.md) exactly.
Run `/review-code` (Claude Code) or the checklist in [docs/how-to/review-code.md](docs/how-to/review-code.md) before opening a PR.

## Commit format

```
<type>: <summary under 72 chars>

What changed:
- bullet

Why:
- bullet
```

Types: `feat` `fix` `chore` `refactor` `test` `docs` `ci`

## Pre-commit hook

The hook runs `dart format` on staged files and blocks the commit if `flutter analyze` finds issues. Fix analysis errors and re-commit.
