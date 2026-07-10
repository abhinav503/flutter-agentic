# Add a Native Splash Screen to an App

When the user asks to add a splash/launch screen to an app, follow every step
below. Covers Android, iOS, and web via `flutter_native_splash` — themed
light/dark background with the brand logo centered.

> **Two splashes:** the *native* splash covers engine boot (colour + one
> image); a Flutter splash *route* may continue branding after boot. Keep both
> on the same surface colour so the hand-off is invisible.

> **Monorepo note:** dependency + config are **per app** (never `core`).
> `flutter pub get` at the repo root; the generator runs from the app folder.

## Step 1 — Pick the app, get logo + colours

If unspecified, list `apps/` and ask. Ask the user for their logo if none
exists (`apps/{app}/assets/icons/`). Colours default to the app theme's
light/dark `surface` — resolve the preset in `assets/theme/theme_config.json`
from `packages/core/lib/core/theme/app_theme_presets.dart`.

## Step 2 — Prepare splash PNGs (PNG only; sizes matter)

- `branding/splash_logo.png` — **512×512** transparent. `image:` must be
  **4x pixel density** (512px ⇒ 128pt logo); centered and downscaled to iOS
  @2x/@3x, Android densities, web.
- `branding/splash_logo_android12.png` — **1152×1152** transparent, glyph
  inside the **768px centre circle** (~560px glyph). Android 12+ masks the
  rest and **ignores the top-level `image:`**.

## Step 3 — Ask which theme strategy, then add the dev dependency + config

The native splash paints **before the Flutter engine and Dart VM start**, so
it can only follow the **device/browser's** system dark/light setting — it
can never read the app's in-app `ThemeModeController` toggle (that lives in
`SharedPreferences`, only readable once Dart runs). Ask the user to choose
one before writing config:

1. **Match device theme (recommended)** — splash follows the device/browser's
   system dark/light setting. Set `color_dark` / `image_dark` /
   `android_12.color_dark`.
2. **Fixed single look** — splash renders identically regardless of the
   device's theme. Omit `color_dark` (and `image_dark`, and
   `android_12.color_dark`) entirely — the generator then skips all
   night/dark resources. Trade-off: a device in system Dark mode sees the
   fixed (light) splash flash before the Flutter UI takes over.

```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.3
```

Option 1 (match device theme):
```yaml
flutter_native_splash:
  color: "#FFFFFF"          # light surface from theme preset
  color_dark: "#0C0503"     # dark surface from theme preset
  image: branding/splash_logo.png
  web: true
  android_12:
    color: "#FFFFFF"
    color_dark: "#0C0503"
    image: branding/splash_logo_android12.png
```

Option 2 (fixed single look — no `color_dark`/`image_dark` anywhere):
```yaml
flutter_native_splash:
  color: "#FFFFFF"          # the one look, regardless of device theme
  image: branding/splash_logo.png
  web: true
  android_12:
    color: "#FFFFFF"
    image: branding/splash_logo_android12.png
```

## Step 4 — Generate

`flutter pub get` at the repo root, then
`cd apps/{app} && dart run flutter_native_splash:create`.

## Step 5 — Verification checklist (report ✅/❌ per item)

**Android** (`android/app/src/main/res/`): `drawable/launch_background.xml` +
`drawable-v21/` (colour + centered `@drawable/splash`);
`drawable-{mdpi..xxxhdpi}/splash.png` + `drawable-night-*` (if matching
device theme); `values/styles.xml`
+ `values-night/styles.xml`; `values-v31/` + `values-night-v31/styles.xml`
(`windowSplashScreenBackground` = colours, `windowSplashScreenAnimatedIcon` =
`@drawable/android12splash`); `drawable-*/android12splash.png`.

**iOS** (`ios/Runner/`): `LaunchImage.imageset/LaunchImage{,@2x,@3x}.png` are
**real images (not 1×1 placeholders — the #1 silent failure)**;
`LaunchBackground.imageset/background.png` (+ dark);
`Base.lproj/LaunchScreen.storyboard` references both; `Info.plist`
`UILaunchStoryboardName` = LaunchScreen.

**Web** (`web/`): `index.html` splash block; `splash/img/` images.

## Step 6 — Test (cold launch)

Kill the app first — warm resume skips the splash. Android: logo centered
(Android 12+ system circle); toggle the **device's** system dark mode (not
any in-app toggle) and relaunch if matching device theme. iOS: simulator or
device. Web: `flutter run -d chrome`.

## Gotchas

PNG only; 4x-density rule for `image:`. Android 12+ reads only the
`android_12:` block. Re-run `:create` after every change; never hand-edit
generated files. Upgrading colour-only → logo: re-check iOS LaunchImage PNGs
for stale 1×1 placeholders. The splash follows the **device/browser's**
system dark/light setting, not the app's in-app theme toggle — it paints
before Dart runs. Ask the user upfront (Step 3) whether they want that, or a
fixed single look via omitting `color_dark`/`image_dark`/
`android_12.color_dark`.
