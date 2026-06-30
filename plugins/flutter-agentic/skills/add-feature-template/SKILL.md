---
name: add-feature-template
description: >
  Scaffold the wiring skeleton for a new Flutter feature in a Clean Architecture
  (BLoC + Freezed + Either) codebase: folder tree, empty repository interface, data
  source, repository impl, BLoC with sealed states, page, screen, and DI registration.
  Invoke with /add-feature-template <feature_name>.
---

Scaffold a new feature following the FlutterAgentic Clean Architecture conventions.

## First — load the bundled rulebook

This plugin ships the full FlutterAgentic docs. **Read these before scaffolding**
(use the Read tool; `${CLAUDE_PLUGIN_ROOT}` is this plugin's install path):

1. `${CLAUDE_PLUGIN_ROOT}/docs/how-to/add-feature-template.md` — the complete
   scaffolding guide: folder tree, empty class skeletons, DI registration order, and
   the forbidden-pattern checklist. **Follow it step by step.**
2. `${CLAUDE_PLUGIN_ROOT}/docs/reference/architecture.md` — layer boundaries, naming
   conventions, and the layer-by-layer patterns.
3. `${CLAUDE_PLUGIN_ROOT}/docs/ai-rules/conventions.md` — forbidden patterns and
   commit/codegen rules.

If `${CLAUDE_PLUGIN_ROOT}` doesn't resolve in your environment, locate the plugin's
`docs/` folder and read the same three files.

## Then — scaffold

If the feature name was not passed as an argument, ask:
"What is the feature name? (e.g. `products`, `auth`, `settings`)"

- `{Feature}` = PascalCase · `{feature}` = snake_case
- `{Action}` = PascalCase verb · `{action}` = snake_case verb (`GetProducts` / `get_products`)

Key rules (the bundled guide has the full detail):
- Scaffold **only** the wiring skeleton — do NOT create entity, model, or use case files.
- BLoCs are **never** registered in GetIt.
- Imports: core types → `package:core/core/...`; app-level di/constants →
  `package:{app}/...`; same-feature files → relative.
- The primary feature folder/entry is always `home` / `HomePage` / `HomeScreen`.

Run `make gen` and `make analyze` at the end before reporting done.
