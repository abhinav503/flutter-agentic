---
name: add-splash-screen
description: >
  Give one app under apps/{app}/ a native boot splash on Android, iOS, and web
  using flutter_native_splash: themed light/dark background colours with the
  brand logo centered. Asks the user for their logo if not provided, derives
  colours from the app's theme preset, asks the user to choose between
  matching the device's system theme or a fixed single look (the splash
  paints before Dart runs, so it can never follow the app's own in-app theme
  toggle), prepares the 4x-density and Android-12 splash PNGs, adds the
  per-app dev dependency and config, generates, then walks a per-platform
  verification checklist (iOS LaunchImage must be real images, not 1x1
  placeholders). Invoke with $add-splash-screen or ask to add a splash/launch
  screen to an app.
---

Gives one app under `apps/{app}/` a **native boot splash** (the frame before
Flutter's first frame). The optional Flutter splash *route* continues branding
after boot — keep both on the same surface colour so the hand-off is invisible.
Verified working on Android and iOS.

> **Monorepo note:** dependency + config are **per app** (never `core`).
> `flutter pub get` at the **repo root**; the generator runs from the app
> folder.

## Step 1 — Pick the app, get the logo + colours

If the app wasn't passed, list `apps/` and ask. **Ask the user for their logo**
if none exists (an app that ran `$add-app-logo` has one in
`apps/{app}/assets/icons/`). Background colours default to the app theme's
light/dark `surface` — resolve the preset named in
`assets/theme/theme_config.json` from
`packages/core/lib/core/theme/app_theme_presets.dart`.

## Step 2 — Prepare the splash PNGs (PNG only, size rules matter)

- `branding/splash_logo.png` — **512×512**, transparent. The `image:` must
  be **4x pixel density** (512px ⇒ 128pt logo); the tool centers it and
  downscales to iOS @2x/@3x, all Android densities, and web.
- `branding/splash_logo_android12.png` — **1152×1152**, transparent, glyph
  inside the **768px-diameter centre circle** (~560px glyph works). Android
  12+ masks the rest. (With `icon_background_color`: 960×960 / 640 circle.)

Rasterise from SVG with headless Chrome (transparent:
`--default-background-color=00000000`), or `sips` for PNG resizes.

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
  color: "#FFFFFF"          # light surface from the theme preset
  color_dark: "#0C0503"     # dark surface from the theme preset
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

**Android 12+ ignores the top-level `image:`** — only the `android_12:` block
counts there (omitting its image falls back to the launcher icon).

## Step 4 — Generate

```bash
flutter pub get            # repo ROOT
cd apps/{app}
dart run flutter_native_splash:create
```

## Step 5 — Verification checklist (report ✅/❌ per item)

**Android** (`android/app/src/main/res/`):
- [ ] `drawable/launch_background.xml` + `drawable-v21/` — colour + centered
      `@drawable/splash` bitmap
- [ ] `drawable-{mdpi..xxxhdpi}/splash.png` + `drawable-night-*` variants (if
      matching device theme)
- [ ] `values/styles.xml` + `values-night/styles.xml` — LaunchTheme wired
- [ ] `values-v31/styles.xml` + `values-night-v31/styles.xml` —
      `windowSplashScreenBackground` = configured colours,
      `windowSplashScreenAnimatedIcon` = `@drawable/android12splash`
- [ ] `drawable-*/android12splash.png`

**iOS** (`ios/Runner/`):
- [ ] `Assets.xcassets/LaunchImage.imageset/LaunchImage{,@2x,@3x}.png` —
      **real images** (128/256/384 from a 512 source), **not 1×1
      placeholders** — the #1 silent failure when upgrading a colour-only
      splash
- [ ] `Assets.xcassets/LaunchBackground.imageset/background.png` (+ dark)
- [ ] `Base.lproj/LaunchScreen.storyboard` references LaunchImage +
      LaunchBackground
- [ ] `Info.plist` — `UILaunchStoryboardName` = LaunchScreen

**Web** (`web/`):
- [ ] `index.html` gained the splash style/script block
- [ ] `splash/img/` generated light/dark images

## Step 6 — Test (cold launch)

Kill the app fully first — warm resume skips the splash. Android: logo in the
centre (Android 12+ puts it in the system circle); toggle the **device's**
system dark mode (not any in-app toggle) and relaunch if matching device
theme. iOS: simulator or device; splash → first frame should be seamless
when the Flutter splash route shares the surface colour. Web:
`flutter run -d chrome`.

## Gotchas

- PNG only; `image:` **must be 4x density** or it renders tiny/huge.
- Re-run `flutter_native_splash:create` after every asset/colour change;
  never hand-edit the generated files.
- Upgrading colour-only → logo: re-check the iOS LaunchImage PNGs for stale
  1×1 placeholders.
- The splash follows the **device/browser's** system dark/light setting, not
  the app's in-app theme toggle — it paints before Dart runs, so it can't see
  that preference. Ask the user upfront (Step 3) whether they want that, or a
  fixed single look via omitting `color_dark`/`image_dark`/
  `android_12.color_dark`.
