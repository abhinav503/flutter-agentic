# Add a native splash screen — Android + iOS + web

Gives **one app** under `apps/{app}/` a native boot splash (the frame shown
before Flutter's first frame) using `flutter_native_splash`: themed background
colours (light + dark) with the brand logo centered. Verified working on real
Android and iOS simulators/devices.

> **Two splashes, two jobs.** The *native* splash covers engine boot and is
> static (colour + one image). An optional *Flutter* splash route
> (`feature/splash/`) continues the branding after boot — wordmark, loader,
> then navigate to home. This guide covers the native one; keep the two
> visually continuous (same background colour) so the hand-off is invisible.

> **Monorepo note:** dependency + config are **per app** (never `core`).
> `flutter pub get` at the **repo root**; the generator runs **from the app
> folder**.

---

## Step 1 — Get the logo + colours

- **Logo:** ask the user for their brand image if not provided (an app that
  already ran `/add-app-logo` has one under `apps/{app}/assets/icons/`).
- **Background colours:** default to the app theme's surfaces — read the
  preset named in `assets/theme/theme_config.json` from
  `packages/core/lib/core/theme/app_theme_presets.dart` and use its light
  `surface` and dark `surface` values. Confirm with the user if unsure.

## Step 2 — Prepare the splash PNGs

The tool consumes PNGs only, and each platform has a size rule. Put them in
`branding/` at the app root — build-time generator sources live outside
`assets/` and are never registered (`assets/icons/` = runtime SVGs,
`assets/images/` = runtime raster images):

| File | Size | Rule |
|---|---|---|
| `branding/splash_logo.png` | **512×512**, transparent | The `image:` must be sized for **4x pixel density** — 512px renders as a 128pt logo. The tool centers it and downscales to iOS `@2x`/`@3x`, all Android densities, and web |
| `branding/splash_logo_android12.png` | **1152×1152**, transparent | Android 12+ masks everything outside a **768px-diameter centre circle** — keep the glyph well inside it (~560px works). With `icon_background_color` the spec is 960×960 / 640 circle instead |

Rasterise from SVG with headless Chrome (transparent canvas:
`--default-background-color=00000000`), or resize a PNG with `sips`.

## Step 3 — Add the dev dependency + config (app pubspec)

```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.3
```

```yaml
# Native boot splash (kills the white flash before Flutter's first frame).
# Regenerate: dart run flutter_native_splash:create
flutter_native_splash:
  color: "#FFFFFF"          # light surface from the app's theme preset
  color_dark: "#0C0503"     # dark surface from the app's theme preset
  image: branding/splash_logo.png
  web: true
  android_12:
    color: "#FFFFFF"
    color_dark: "#0C0503"
    image: branding/splash_logo_android12.png
```

Notes:

- **Android 12+ ignores the top-level `image:`** — it only reads the
  `android_12:` block. Omitting `android_12.image` falls back to the launcher
  icon (acceptable; explicit asset preferred).
- `image_dark` exists if the logo needs a different treatment on dark.

## Step 4 — Generate

```bash
flutter pub get                        # repo ROOT
cd apps/{app}
dart run flutter_native_splash:create
```

Expect `✅ Native splash complete.`

## Step 5 — Verification checklist (files to check)

**Android** (`apps/{app}/android/app/src/main/res/`):

- [ ] `drawable/launch_background.xml` + `drawable-v21/launch_background.xml` —
      now layer the colour + a centered `@drawable/splash` bitmap
- [ ] `drawable-{mdpi..xxxhdpi}/splash.png` — the logo at each density
- [ ] `drawable-night-*/` variants — present because `color_dark` is set
- [ ] `values/styles.xml` + `values-night/styles.xml` — `LaunchTheme`
      windowBackground points at `launch_background`
- [ ] `values-v31/styles.xml` + `values-night-v31/styles.xml` —
      `windowSplashScreenBackground` = your colours and
      `windowSplashScreenAnimatedIcon` = `@drawable/android12splash`
- [ ] `drawable-*/android12splash.png` — the 1152 asset per density

**iOS** (`apps/{app}/ios/Runner/`):

- [ ] `Assets.xcassets/LaunchImage.imageset/LaunchImage{,@2x,@3x}.png` — **real
      images** (128/256/384 from a 512 source), **not 1×1 placeholders**. This
      is the #1 silent failure: colour-only configs leave 1×1 stubs and the
      iOS splash shows no logo
- [ ] `Assets.xcassets/LaunchBackground.imageset/background.png` (+ dark
      variant when `color_dark` is set)
- [ ] `Base.lproj/LaunchScreen.storyboard` — references both `LaunchImage`
      and `LaunchBackground`
- [ ] `Info.plist` — `UILaunchStoryboardName` is `LaunchScreen`

**Web** (`apps/{app}/web/`):

- [ ] `index.html` — gained the splash style/script block
- [ ] `splash/img/` — generated light/dark images

## Step 6 — Test (cold launch)

- Kill the app fully first — a warm resume skips the splash.
- **Android:** logo centered on the colour; on Android 12+ the icon sits in
  the system's centre circle. Toggle dark mode and relaunch — background must
  flip to `color_dark`.
- **iOS:** same check on a simulator or device; splash → Flutter first frame
  should be seamless when the Flutter splash route uses the same surface
  colour.
- **Web:** `flutter run -d chrome` — splash shows while the engine loads.

## Gotchas (learned the hard way)

- PNG only; the `image:` **must be 4x density** or it renders tiny/huge.
- Android 12+ requires the `android_12:` block — the top-level image is not
  used there.
- Re-run `flutter_native_splash:create` after **every** asset or colour
  change; never hand-edit the generated files (they're overwritten).
- When upgrading a colour-only splash to include a logo, re-check the iOS
  `LaunchImage` PNGs — stale 1×1 placeholders mean the storyboard renders
  nothing in the middle.
