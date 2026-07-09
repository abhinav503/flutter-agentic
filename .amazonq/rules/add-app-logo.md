# Add an App Logo (Launcher Icon) to an App

When the user asks to set or change an app's icon/logo, follow every step below.
Covers Android, iOS, and web from one brand image via `flutter_launcher_icons`.

> **Monorepo note:** dependency + config are **per app** (never `core`).
> `flutter pub get` runs at the **repo root**; the generator runs from the app
> folder.

## Step 1 — Pick the app and get the brand image

If unspecified, list `apps/` and ask which app. If no image was provided, ask
the user for their logo: SVG preferred, or PNG ≥1024×1024. Store it in
`apps/{app}/assets/icons/`.

## Step 2 — Prepare two 1024×1024 source PNGs (tool takes PNG only)

- `branding/app_icon.png` — full-bleed, opaque: background colour + glyph
  at ~70% (App Store rejects alpha in the 1024 icon).
- `branding/app_icon_foreground.png` — transparent, glyph inside the
  central ~66% safe zone (~440px box) so launcher masks never clip it.

Rasterise SVGs with headless Chrome (`--window-size=1024,1024
--force-device-scale-factor=1 --screenshot=…`; transparent canvas via
`--default-background-color=00000000`). Resize PNGs with `sips`.

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

`flutter pub get` at the repo root, then
`cd apps/{app} && dart run flutter_launcher_icons`.

## Step 5 — Verification checklist (report ✅/❌ per item)

**Android** (`android/app/src/main/res/`): `mipmap-{mdpi..xxxhdpi}/
ic_launcher.png` regenerated; `mipmap-anydpi-v26/ic_launcher.xml`;
`mipmap-*/ic_launcher_foreground.png`; `values/colors.xml` has
`ic_launcher_background`; manifest still `android:icon="@mipmap/ic_launcher"`.

**iOS** (`ios/Runner/Assets.xcassets/AppIcon.appiconset/`): `Contents.json`
lists every size; all `Icon-App-*.png` regenerated;
`Icon-App-1024x1024@1x.png` has **no alpha** (`file` says RGB).

**Web** (`web/`): `icons/Icon-192.png`, `icons/Icon-512.png` + maskable
variants; `favicon.png`.

**Display name (under the icon) — must start uppercase.** `flutter create`
seeds the lowercase package name; fix: `android:label` in
`AndroidManifest.xml`; **both** `CFBundleDisplayName` and `CFBundleName` in
`ios/Runner/Info.plist`; `name` + `short_name` in `web/manifest.json`;
`<title>` + `apple-mobile-web-app-title` in `web/index.html`.

## Step 6 — Device check

Uninstall the previous build first (launchers cache icons). Android: check a
squircle mask. iOS: home screen + Settings icon.

## Gotchas

PNG only (no SVG path). Foreground outside the safe zone gets cropped. Never
hand-edit generated files — regenerate. Light glyph → brand-coloured adaptive
background, not white.
