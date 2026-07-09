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

## Step 3 — Dev dependency + config in `apps/{app}/pubspec.yaml`

```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.3
```

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

## Step 4 — Generate

`flutter pub get` at the repo root, then
`cd apps/{app} && dart run flutter_native_splash:create`.

## Step 5 — Verification checklist (report ✅/❌ per item)

**Android** (`android/app/src/main/res/`): `drawable/launch_background.xml` +
`drawable-v21/` (colour + centered `@drawable/splash`);
`drawable-{mdpi..xxxhdpi}/splash.png` + `drawable-night-*`; `values/styles.xml`
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
(Android 12+ system circle); toggle dark mode and relaunch. iOS: simulator or
device. Web: `flutter run -d chrome`.

## Gotchas

PNG only; 4x-density rule for `image:`. Android 12+ reads only the
`android_12:` block. Re-run `:create` after every change; never hand-edit
generated files. Upgrading colour-only → logo: re-check iOS LaunchImage PNGs
for stale 1×1 placeholders.
