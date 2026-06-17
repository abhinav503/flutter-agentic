# rename-app

If the new app name was not passed as an argument, ask:
"What should the new app name be? Provide two forms:
1. Display name (PascalCase or branded, shown to users) e.g. `MyApp`
2. Package name (snake_case, used in Dart imports) e.g. `my_app`"

This is a monorepo — each app lives under `apps/{app}/` (e.g. `apps/jokes`, `apps/doc_scanner`). Ask which app to rename if ambiguous. `core` is never renamed.

Derive the old package name from the `name:` field in `apps/{app}/pubspec.yaml`.
Derive the old display name from the `title:` string in `apps/{app}/lib/app.dart`.

Then follow every step in the guide below exactly, substituting the old and new values throughout.
At the end run `flutter pub get` at the repo root, `flutter analyze --no-pub`, and `cd apps/{NewName} && flutter test` before reporting done.

@docs/how-to/rename-app.md
