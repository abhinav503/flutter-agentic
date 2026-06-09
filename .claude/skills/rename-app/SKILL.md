# rename-app

If the new app name was not passed as an argument, ask:
"What should the new app name be? Provide two forms:
1. Display name (PascalCase or branded, shown to users) e.g. `MyApp`
2. Package name (snake_case, used in Dart imports) e.g. `my_app`"

Derive the old package name from the current `name:` field in `pubspec.yaml`.
Derive the old display name from `ValueConst.appTitle` in `lib/core/constants/value_const.dart`.

Then follow every step in the guide below exactly, substituting the old and new values throughout.
Run `flutter pub get`, `flutter analyze`, and `flutter test` at the end before reporting done.

@docs/how-to/rename-app.md
