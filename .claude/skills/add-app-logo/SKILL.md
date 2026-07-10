# add-app-logo

Sets the **launcher icon** for one app under `apps/{app}/` on **Android, iOS,
and web** from a single brand image, using `flutter_launcher_icons`.

How to run this skill:

1. **Pick the app** — if not passed as an argument, list `apps/` and ask.
2. **Ask the user for their logo image** if none was provided — SVG preferred,
   or PNG ≥1024×1024. Put the original in `apps/{app}/assets/icons/`.
3. **Prepare the two 1024×1024 source PNGs** (the tool takes PNG only):
   `app_icon.png` (full-bleed, opaque — glyph at ~70%) and
   `app_icon_foreground.png` (transparent, glyph inside the ~66% adaptive safe
   zone). Rasterise SVGs with headless Chrome; resize PNGs with `sips`.
4. **Add `flutter_launcher_icons` to the app's `dev_dependencies`** (never
   `core`) plus the config block — include `remove_alpha_ios: true` (the App
   Store rejects alpha in the 1024 icon) and the adaptive background/foreground
   pair.
5. **Generate:** `flutter pub get` at the repo **root**, then from the app
   folder `dart run flutter_launcher_icons`.
6. **Walk the verification checklist in the guide below** — Android mipmaps +
   `mipmap-anydpi-v26/ic_launcher.xml` + `values/colors.xml`; every iOS
   `AppIcon.appiconset` size with the 1024 icon alpha-free (`file` says RGB);
   web icons + favicon. Report ✅/❌ per item.
   Also check the **display name under the icon starts uppercase** — flutter
   create seeds the lowercase package name into `android:label`, iOS
   `CFBundleName` (DisplayName too), `web/manifest.json` name/short_name, and
   `web/index.html` title + `apple-mobile-web-app-title`. Fix all of them.
7. **Device check:** uninstall the old build first (launchers cache icons),
   then confirm on both platforms.

@docs/how-to/add-app-logo.md
