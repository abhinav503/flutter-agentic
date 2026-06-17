# How to Publish an App to the Play Store / App Store

Store-readiness checklist and step-by-step for shipping an app from this monorepo
(`apps/<app>/`) to the Google Play Store and Apple App Store.

> **Status:** planning doc. Captures everything outstanding for `apps/doc_scanner`
> as of v1.2.0. Nothing here is wired up yet — work through it in order and check
> items off as you go. The intent is to turn this into a repeatable `publish` skill
> once the steps are proven on the first real submission.

> **Per-app, not per-repo.** Versions, signing, icons, and store metadata are all
> per app. All paths below are relative to the target app folder `apps/<app>/`
> (the running example is `apps/doc_scanner`, applicationId
> `com.abhinavsintoo.docscanner`).

---

## Minimal critical path (Play Store)

The fastest valid path to a Play listing:

```
1. Release signing  →  4. App icon  →  3. Versioning  →  2. Build AAB
→  6/7. Privacy policy + Data Safety  →  9. Listing assets  →  8. Reviewer access (demo key)
```

Apple is intentionally deferred — see "App Store note" at the bottom for why.

---

## 🔴 Hard blockers — no valid store build without these

### 1. Android release signing

**Current state:** `apps/doc_scanner/android/app/build.gradle.kts` signs release builds
with the **debug** key:

```kotlin
release {
    signingConfig = signingConfigs.getByName("debug")   // ❌ Play rejects debug-signed builds
}
```

There is **no keystore and no `key.properties`**.

**To do:**
1. Generate an upload keystore (keep the password private — never commit it):
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `apps/doc_scanner/android/key.properties` (**git-ignored**):
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<absolute path to upload-keystore.jks>
   ```
3. Wire a real `release` signing config in `build.gradle.kts` that loads
   `key.properties` and replaces the debug `signingConfig`.
4. Confirm `key.properties` and `*.jks` are in `.gitignore`.
5. Consider enabling **Play App Signing** (Google manages the app signing key; you
   keep only the upload key) — recommended for new apps.

### 2. Build an App Bundle (AAB), not an APK

Play requires an `.aab`, not the `.apk` we attach to GitHub releases:

```bash
cd apps/doc_scanner && flutter build appbundle --release
# output: apps/doc_scanner/build/app/outputs/bundle/release/app-release.aab
```

### 3. Versioning

**Current state:** `apps/doc_scanner/pubspec.yaml` is `version: 1.1.0` with **no build
number**. Play rejects a duplicate `versionCode`, so every upload needs a higher one.

**To do:** use `version: <name>+<code>`, e.g. `1.1.0+1`, and bump the `+code` on every
store upload. This is the app's own version — independent of the template/root version
(`1.2.0`).

### 4. Real app icon

**Current state:** `android/app/src/main/res/mipmap-*/ic_launcher.png` is the **default
Flutter icon** (~544 bytes). iOS has a 15-image `AppIcon.appiconset` — verify it isn't a
placeholder too.

**To do:** add `flutter_launcher_icons` as a dev dependency with a 1024×1024 source
image and generate icons for both platforms.

### 5. Target SDK

**Current state:** `build.gradle.kts` uses `targetSdk = flutter.targetSdkVersion`.

**To do:** Play requires **targetSdk 35** (Android 15) for new apps (since Aug 2025).
Confirm the Flutter toolchain's default meets it, or set `targetSdk = 35` explicitly.
Also cap legacy storage: `READ_EXTERNAL_STORAGE` should carry
`android:maxSdkVersion="32"` in the manifest.

---

## 🟠 Legal / compliance — required for this app

### 6. Privacy policy URL

**Mandatory** on both stores. This app uses the **camera** and sends user images to
**third-party AI providers** (Groq, Google Gemini, Anthropic Claude), which makes a
privacy policy non-negotiable. None exists in the repo today.

**To do:** write a privacy policy and host it at a public URL (GitHub Pages is fine).
It must disclose: camera/photo access, that images are transmitted to third-party AI
services for processing, and that the user supplies their own API key.

### 7. Data disclosure forms

- **Play Data Safety form** — declare that images/photos are collected and **shared with
  third parties** (the AI providers). Cannot be left blank.
- **Apple privacy nutrition labels** — same disclosure, if/when pursuing iOS.

---

## 🟡 BYOK — the biggest review risk

The core AI extraction only works if the user pastes **their own API key**
(`save_api_key_usecase`, `model_api_key_row`, `model_selector_sheet`). Keys are stored
on-device, not embedded — good for security, but a problem at review time:

- **Apple:** high rejection risk under guidelines 4.2 / 2.1 — requires an external
  account and technical setup; reviewers can't exercise the feature without a key.
- **Reviewer access (both stores):** either provide a **demo API key in the review
  notes**, or ensure the **scan → PDF path works fully without AI** so the app has
  standalone value a reviewer can verify.

**Decision needed before submitting:** confirm the non-AI path (pick images → generate
PDF → share) is fully functional on its own, and/or prepare a reviewer demo key.

---

## 🟢 Store listing assets (Play Console)

- App icon 512×512
- Feature graphic 1024×500
- At least 2 phone screenshots (plus tablet if supported)
- Short description + full description
- Category + content rating (IARC questionnaire)
- Contact email (and optional website)

(App Store equivalents: per-device-class screenshots, promotional text, keywords.)

---

## Release tracks (recommended rollout)

1. **Internal testing** — fastest, up to 100 testers, no review wait. Validate the
   signed AAB installs and runs.
2. **Closed testing** — wider tester group; Play now expects new personal developer
   accounts to run closed testing before production.
3. **Production** — full rollout (start with a staged % if desired).

---

## App Store note (deferred)

App Store submission is intentionally **out of scope for now**:
- $99/yr developer program vs Play's one-time $25.
- Apple guideline **4.2 ("minimum functionality")** frequently rejects single-purpose
  utilities, and the **BYOK** requirement (item 8) compounds that risk.
- Play Store gives the same "shipped a real app from this template" credibility with far
  less friction.

The iOS config is already partly in place (`Info.plist` has `CFBundleDisplayName`,
`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`; bundle id
`com.abhinavsintoo.docscanner`), so revisiting iOS later is mostly signing/provisioning
+ assets + the same privacy disclosures.

---

## Outstanding items — quick checklist

- [ ] 1. Upload keystore + `key.properties` + real release signing config
- [ ] 2. Build signed AAB (`flutter build appbundle --release`)
- [ ] 3. `version: x.y.z+N` with build-number bumping
- [ ] 4. Branded app icon via `flutter_launcher_icons`
- [ ] 5. targetSdk 35 + `maxSdkVersion=32` on legacy storage permission
- [ ] 6. Privacy policy written and hosted
- [ ] 7. Play Data Safety form completed
- [ ] 8. BYOK handled for review (demo key and/or working non-AI path)
- [ ] 9. Listing assets (icon, feature graphic, screenshots, descriptions, rating)
- [ ] 10. Roll out via internal → closed → production tracks
