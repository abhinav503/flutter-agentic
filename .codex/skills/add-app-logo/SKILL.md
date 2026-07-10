---
name: add-app-logo
description: >
  Set the launcher icon for one app under apps/{app}/ on Android, iOS, and web
  from a single brand image, using flutter_launcher_icons to generate every
  size. Asks the user for their logo (SVG or PNG >=1024) if not provided,
  prepares the full-bleed + adaptive-foreground source PNGs, adds the per-app
  dev dependency and config, generates, then walks a per-platform verification
  checklist. Invoke with $add-app-logo or ask to set/change an app's icon/logo.
---

Sets the **launcher icon** for one app under `apps/{app}/` from a single brand
image. Verified working on Android and iOS.

> **Monorepo note:** dependency + config are **per app** (never `core`).
> `flutter pub get` runs at the **repo root**; the generator runs from the app
> folder.

## Step 1 — Pick the app and get the brand image

If the app wasn't passed, list `apps/` and ask. If no image was provided,
**ask the user for their logo**: SVG preferred, or PNG ≥1024×1024. Store the
original in `apps/{app}/assets/icons/`.

## Step 2 — Prepare the two 1024×1024 source PNGs

The tool takes PNG only (no SVG):

- `branding/app_icon.png` — full-bleed: background colour + glyph at ~70%.
  **No transparency** (the App Store rejects alpha in the 1024 icon).
- `branding/app_icon_foreground.png` — transparent, glyph inside the
  central **~66% safe zone** (~440px box) so Android launcher masks
  (circle/squircle) never clip it.

Rasterise an SVG with headless Chrome (`--window-size=1024,1024
--force-device-scale-factor=1 --screenshot=…`; add
`--default-background-color=00000000` for the transparent foreground). Resize
big PNGs with `sips --resampleWidth 1024`.

## Step 3 — Dev dependency + config in `apps/{app}/pubspec.yaml`

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.3
```

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  remove_alpha_ios: true
  image_path: branding/app_icon.png
  adaptive_icon_background: "#FFFFFF"    # or the brand colour
  adaptive_icon_foreground: branding/app_icon_foreground.png
  web:
    generate: true
    image_path: branding/app_icon.png
```

## Step 4 — Generate

```bash
flutter pub get            # repo ROOT
cd apps/{app}
dart run flutter_launcher_icons
```

## Step 5 — Verification checklist (report ✅/❌ per item)

**Android** (`android/app/src/main/res/`):
- [ ] `mipmap-{mdpi..xxxhdpi}/ic_launcher.png` regenerated with brand pixels
- [ ] `mipmap-anydpi-v26/ic_launcher.xml` (adaptive: bg colour + foreground)
- [ ] `mipmap-*/ic_launcher_foreground.png` per density
- [ ] `values/colors.xml` has `ic_launcher_background`
- [ ] `AndroidManifest.xml` still `android:icon="@mipmap/ic_launcher"`

**iOS** (`ios/Runner/Assets.xcassets/AppIcon.appiconset/`):
- [ ] `Contents.json` lists every size
- [ ] All `Icon-App-*.png` sizes regenerated (20 → 1024)
- [ ] `Icon-App-1024x1024@1x.png` has **no alpha** (`file` says RGB, not RGBA)

**Web** (`web/`):
- [ ] `icons/Icon-192.png`, `icons/Icon-512.png` + maskable variants
- [ ] `favicon.png`

**Display name (under the icon) — must start uppercase.** `flutter create`
seeds the lowercase package name; fix every one:
- [ ] `AndroidManifest.xml` — `android:label` capitalised (e.g. `"Gravia"`)
- [ ] `ios/Runner/Info.plist` — **both** `CFBundleDisplayName` and
      `CFBundleName`
- [ ] `web/manifest.json` — `name` + `short_name`
- [ ] `web/index.html` — `<title>` + `apple-mobile-web-app-title` meta

## Step 6 — Device check

Uninstall the previous build first (launchers cache icons). Android: check a
non-circle mask (squircle) to confirm the safe zone. iOS: home screen +
Settings icon.

## Gotchas

- PNG only — an SVG `image_path` fails.
- Foreground glyph outside the safe zone gets cropped by round masks.
- Never hand-edit generated mipmaps/appiconset — regenerate instead.
- Light glyph → set `adaptive_icon_background` to the brand colour, not white.
