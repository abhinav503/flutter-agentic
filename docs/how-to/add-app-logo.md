# Add an app logo (launcher icon) — Android + iOS + web

Sets the launcher icon for **one app** under `apps/{app}/` from a single brand
image, using `flutter_launcher_icons` to generate every required size. Verified
working on real Android and iOS simulators/devices.

> **Monorepo note:** the dependency and config are **per app** (never `core`).
> `flutter pub get` runs at the **repo root**; the generator runs **from the
> app folder**.

---

## Step 1 — Get the brand image from the user

If no image was provided, **ask the user for their logo** before doing anything
else. Accept either:

- **SVG** (preferred — scales losslessly), or
- **PNG at 1024×1024 or larger**.

Place the original under `apps/{app}/assets/icons/`.

> **Asset segregation (three tiers):** `assets/icons/` = runtime SVGs
> (registered under `flutter > assets`); `assets/images/` = runtime raster
> images (registered when the app has some); `branding/` at the app root =
> the raster PNGs only the generators consume — outside `assets/` on purpose
> and **never registered**, so build-time sources never ship in the bundle.

## Step 2 — Prepare the two source PNGs (1024×1024)

The tool consumes PNGs only (no SVG). Two sources are needed:

| File | Contents | Rule |
|---|---|---|
| `branding/app_icon.png` | Full-bleed: background colour + glyph at ~70% of the canvas | No transparency — the App Store rejects alpha in the 1024 marketing icon |
| `branding/app_icon_foreground.png` | Transparent background, glyph only | Glyph must fit the central **~66% safe zone** (~440px box on 1024) — Android launchers mask up to a third of the edges (circle/squircle) |

If the source is an SVG, rasterise it with headless Chrome (no extra tooling
needed on a dev Mac) — write a small HTML wrapper that sizes the image, then:

```bash
# full-bleed (background colour set in the HTML wrapper)
"…/Google Chrome" --headless --disable-gpu --allow-file-access-from-files \
  --window-size=1024,1024 --force-device-scale-factor=1 \
  --screenshot=app_icon.png wrapper.html

# foreground: transparent canvas
"…/Google Chrome" --headless … --default-background-color=00000000 \
  --screenshot=app_icon_foreground.png wrapper_fg.html
```

If the source is a large PNG, resize with `sips --resampleWidth 1024`.

## Step 3 — Add the dev dependency + config (app pubspec)

In `apps/{app}/pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.3
```

```yaml
# One source mark → every launcher-icon size.
# Regenerate: dart run flutter_launcher_icons
flutter_launcher_icons:
  android: true
  ios: true
  remove_alpha_ios: true                 # App Store: 1024 icon must be opaque
  image_path: branding/app_icon.png
  adaptive_icon_background: "#FFFFFF"    # or the brand colour
  adaptive_icon_foreground: branding/app_icon_foreground.png
  web:
    generate: true
    image_path: branding/app_icon.png
```

## Step 4 — Generate

```bash
flutter pub get                 # at the repo ROOT (workspace resolve)
cd apps/{app}
dart run flutter_launcher_icons
```

Expect `✓ Successfully generated launcher icons`.

## Step 5 — Verification checklist (files to check)

Go through this list after generation — every box must pass.

**Android** (`apps/{app}/android/app/src/main/res/`):

- [ ] `mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png` — regenerated
      with the brand pixels (not the Flutter default "F")
- [ ] `mipmap-anydpi-v26/ic_launcher.xml` — adaptive icon XML referencing the
      background colour + foreground image
- [ ] `mipmap-*/ic_launcher_foreground.png` — per-density foreground images
- [ ] `values/colors.xml` — contains the `ic_launcher_background` colour
- [ ] `AndroidManifest.xml` — still `android:icon="@mipmap/ic_launcher"`
      (unchanged; just confirm nothing broke it)

**iOS** (`apps/{app}/ios/Runner/Assets.xcassets/AppIcon.appiconset/`):

- [ ] `Contents.json` — lists every size entry
- [ ] `Icon-App-20x20@{1x,2x,3x}.png` … `Icon-App-83.5x83.5@2x.png` — all
      regenerated
- [ ] `Icon-App-1024x1024@1x.png` — brand image **without an alpha channel**
      (`file Icon-App-1024x1024@1x.png` must say `RGB`, not `RGBA`)

**Web** (`apps/{app}/web/`):

- [ ] `icons/Icon-192.png`, `icons/Icon-512.png` + maskable variants
- [ ] `favicon.png`

**Display name (shown under the icon) — must start with an uppercase letter.**
`flutter create` seeds most of these with the lowercase package name (e.g.
`gravia` instead of `Gravia`); fix every one:

- [ ] `android/app/src/main/AndroidManifest.xml` — `android:label="Gravia"`
- [ ] `ios/Runner/Info.plist` — **both** `CFBundleDisplayName` and
      `CFBundleName` (flutter create capitalises only the first)
- [ ] `web/manifest.json` — `name` and `short_name`
- [ ] `web/index.html` — `<title>` and the `apple-mobile-web-app-title` meta

Quick spot-check: `file` the 1024 iOS icon and open one Android mipmap to eyeball
the pixels.

## Step 6 — Verify on device

- **Uninstall the previous build first** — launchers cache icons aggressively;
  a stale icon after reinstall is almost always cache, not a generation failure.
- **Android:** check the icon under at least one non-circle mask (Pixel launcher
  squircle) — confirms the foreground safe zone.
- **iOS:** home screen + Settings list icon.

## Gotchas (learned the hard way)

- The tool accepts **PNG only** — an SVG path in `image_path` fails.
- A foreground glyph outside the safe zone gets visibly cropped by round masks.
- Regenerate any time the brand image changes — never hand-edit the generated
  mipmaps/appiconset.
- With a light glyph, set `adaptive_icon_background` to the brand colour (not
  white) or the Android icon reads as an empty circle.
