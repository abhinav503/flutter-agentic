# add-splash-screen

Gives one app under `apps/{app}/` a **native boot splash** on **Android, iOS,
and web** using `flutter_native_splash` — themed light/dark background with the
brand logo centered. (The native splash covers engine boot; an optional Flutter
splash *route* continues branding after it — keep both on the same surface
colour so the hand-off is invisible.)

How to run this skill:

1. **Pick the app** — if not passed as an argument, list `apps/` and ask.
2. **Ask the user for their logo image** if none was provided (an app that ran
   `/add-app-logo` already has one in `apps/{app}/assets/icons/`). Background
   colours default to the app theme's light/dark `surface` values — resolve
   the preset in `assets/theme/theme_config.json` via
   `app_theme_presets.dart`.
3. **Prepare the splash PNGs:** `splash_logo.png` at **512×512** transparent
   (the `image:` must be **4x pixel density** — renders as a 128pt logo,
   downscaled to iOS @2x/@3x + Android densities + web) and
   `splash_logo_android12.png` at **1152×1152** with the glyph inside the
   **768px centre circle** (Android 12+ masks the rest and ignores the
   top-level `image:` entirely).
4. **Ask which theme strategy, via `AskUserQuestion`, before writing config.**
   The native splash paints before Dart runs, so it can only follow the
   **device/browser's** system dark/light setting — it can never read the
   app's in-app theme toggle (see the guide below for why). Present two
   options and let the user pick:
   - **Match device theme (recommended)** — set `color_dark`/`image_dark`/
     `android_12.color_dark` so the splash follows the device's system theme.
   - **Fixed single look** — omit `color_dark`/`image_dark`/
     `android_12.color_dark` entirely so the splash renders the same
     regardless of device theme.
5. **Add `flutter_native_splash` to the app's `dev_dependencies`** (never
   `core`) plus the config block matching the chosen option: `color`
   (+`color_dark` if matching device theme), `image`, `web: true`, and the
   `android_12:` block with its own image + colours.
6. **Generate:** `flutter pub get` at the repo **root**, then from the app
   folder `dart run flutter_native_splash:create`.
7. **Walk the verification checklist in the guide below** — Android
   `launch_background.xml` + per-density `splash.png` + night variants (if
   matching device theme) + `values-v31`/`values-night-v31` styles +
   `android12splash.png`; iOS `LaunchImage` PNGs must be **real images, not
   1×1 placeholders** (the #1 silent failure), plus `LaunchBackground` +
   storyboard references; web `index.html` splash block. Report ✅/❌ per item.
8. **Test with a cold launch** on both platforms (kill the app first), toggling
   the **device's** system dark mode (not the in-app toggle) if matching
   device theme.

@docs/how-to/add-splash-screen.md
