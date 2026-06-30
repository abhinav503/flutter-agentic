# FlutterAgentic — Claude Code Plugin

Production-grade **Flutter Clean Architecture** (BLoC + Freezed + `Either<Failure, T>`)
as Claude Code skills. Install it and Claude scaffolds features that follow the same
layer boundaries, naming, and forbidden-pattern rules a human teammate would — in any
Flutter project, no fork required.

This **pilot release** ships one skill and bundles the full FlutterAgentic rulebook
(`docs/`) so the skill generates on-pattern code.

## Install

```text
/plugin marketplace add abhinav503/flutter-agentic
/plugin install flutter-agentic
```

## What you get

| Skill | What it does |
|---|---|
| `/add-feature-template <name>` | Scaffolds a feature's full wiring skeleton — folder tree, repository interface, data source, repository impl, BLoC with sealed states, page, screen, and DI registration — straight from the bundled architecture rules. |

### Bundled rulebook (`docs/`)
The skill reads these at runtime, so generated code stays on-pattern:
- `docs/reference/architecture.md` — layer boundaries, naming, patterns
- `docs/ai-rules/conventions.md` — forbidden patterns, commit/codegen rules
- `docs/how-to/` — step-by-step task guides
- `docs/explanation/`, `docs/tutorials/` — the "why" and SOLID/design-pattern context

## Usage

```text
/add-feature-template products
```

Claude reads the bundled rules, scaffolds the `products` feature across data / domain /
presentation, wires DI, and runs `make gen` + `make analyze`.

## Roadmap

Pilot ships `add-feature-template`. Planned: `setup-project`, `review-code`,
`connect-firebase`, `add-notification-feature`, `rename-app`, `change-app-id`,
`release`.

---

Source & full template: https://github.com/abhinav503/flutter-agentic
