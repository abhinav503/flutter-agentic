# change-app-id

If the new application ID was not passed as an argument, ask:
"What is the new application ID? Use reverse-domain notation, e.g. `com.company.appname`"

This is a monorepo — application IDs are per app. Ask which app under `apps/{app}/` to change if ambiguous.
Derive the old application ID from the `applicationId` field in `apps/{app}/android/app/build.gradle.kts`.

Then follow every step in the guide below exactly, substituting the old and new values throughout.
Run `flutter analyze --no-pub` at the repo root at the end before reporting done.

@docs/how-to/change-app-id.md
