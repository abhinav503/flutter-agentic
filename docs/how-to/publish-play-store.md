# How to publish an app to the Google Play Store

The record of what `apps/ecommerce/cordelia` did in Play Console, and the traps
it hit. Cordelia reached **internal testing (2026-08-07)** and **closed testing
with 12 opted-in testers (2026-08-19)**; production access is still gated on
the Data safety form and the 14-day closed-testing window.

**A gap you should know about before relying on this.** Cordelia's Play
submission was worked through interactively and most of the console forms were
never captured. The build/signing half below is recorded well; the **App
content questionnaires — Data safety, content rating, target audience, ads —
were not**, and the store-listing copy was never saved into the repo. Where a
section says *not recovered*, it means exactly that: you will be answering it
fresh. That absence is the reason this doc exists.

> The generic build mechanics (AAB vs APK, targetSdk, launcher icon) are in
> `docs/how-to/publish-to-stores.md`, which was written for `doc_scanner`.
> This doc is cordelia-specific and supersedes it wherever they disagree.

---

## 1. Signing — the blocker that hides until upload

Release builds were signed **`CN=Android Debug`**, which Play rejects outright.
It was found by reading the certificate out of the built bundle, not by
trusting the TODO comment in the Gradle file — worth repeating, because a debug
signing config produces a bundle that builds, installs and runs perfectly.

```bash
# what the bundle is actually signed with
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

- `android/app/build.gradle.kts` reads `android/key.properties` into a real
  release `signingConfig`, **falling back to the debug key when that file is
  absent**, so a fresh clone and CI without secrets still build.
- Generate the upload key interactively, so the password never lands in a shell
  history or an agent transcript. Store `key.properties` and the keystore
  **outside the repo**.
- Play requires validity past 2033. Cordelia's runs to 2053.

Verified for cordelia: signer `CN=Abhinav Kumar, O=Cordelia Apps`, package
`com.cordeliaapps.superapp`, 66.5 MB against Play's 150 MB base limit.

## 2. Versioning

`version: 1.0.0+1` in `pubspec.yaml`. **The number after `+` is the version
code Play keys uploads on, and it must increase on every upload.** Left
implicit it defaults to 1 and silently blocks the second upload. This repo
bumps patch-first with the build number tracking the patch (`1.0.3+3` →
`1.0.4+4`).

## 3. Developer verification and the package name

This needed no work: publishing through Play **auto-registers the package**,
and the console showed it Registered. The upload key is absent from the app
signing key list until the first upload — because Play learns it *from* that
upload. It looks alarming and isn't.

---

## 4. App content — the questionnaires

**Play Console → your app → Policy and programmes → App content.** This is
where Play asks everything Apple splits between App Privacy and Age Ratings.

### Financial features — the declaration that got cordelia rejected

The closed-testing submission was **rejected** because
**`Financial features → Mobile payments and digital wallets`** was declared.
That declaration restricts distribution to **organization accounts**, and
cordelia's is personal.

It was also wrong. A storefront app of this shape:

- sells **physical goods**, delivered to an address;
- takes payment through **third-party licensed gateways** (Razorpay, Stripe),
  in each store's own merchant account;
- **holds no funds**, issues no wallet, moves no money between users.

None of that is a mobile payment or digital wallet feature. Answer **"My app
doesn't provide any financial features"** unless your app genuinely issues a
wallet or holds balances. Cordelia's declaration was cleared and appealed.

> This is the single most expensive wrong answer in the Play flow: it does not
> fail review with an explanation, it silently makes your account type
> ineligible.

### Testing credentials

**App content → App access.** Cordelia declared restricted access and supplied
the same demo account used for App Store review (credentials live in
`docs/how-to/app-store-review-notes.md`, not duplicated here).

Two defects in what is currently in that box, both worth checking before the
next submission:

1. **An unfilled placeholder shipped.** The instructions read
   `open the store "<STORE NAME>"`. Fill it in — a reviewer following that
   literally has nowhere to go.
2. **It says "Sign-in is required; there is no guest mode."** That stopped
   being true on 2026-08-22, when browsing without an account shipped. Sign-in
   is now required only for cart, wishlist, checkout, orders, profile and
   reviews. Telling a reviewer the app is gated when it isn't invites them to
   test the wrong thing.

The rest of that note is good practice and worth keeping in any app from this
repo: state that the account is **already email-verified** (so no mailbox
access is needed), and that there is **no 2FA, biometric, QR or
location-gated** sign-in.

### Data safety — not filled, not recovered

Still open, and the last form standing between cordelia and production access.
The answers are the same facts as the App Store's App Privacy labels, which
*are* written up in `docs/how-to/publish-app-store.md` §3 — start from that
list of 14 data types and translate. Play additionally asks, per type, whether
the data is **encrypted in transit** (yes — everything goes over HTTPS to
Vercel or Firebase) and whether users can **request deletion** (yes — in-app
Delete Account, plus `https://cordeliaapps.com/delete-account`).

### Content rating, target audience, ads, news, COVID — not recovered

Answered during submission; the answers were not captured. For an app from
this repo they follow from the same facts as the Apple age rating (see
`publish-app-store.md` §2): user-generated content **yes**, no alcohol/tobacco
(banned platform-wide and enforced server-side), no ads, not news, target
audience 18+.

---

## 5. Release tracks

Internal → closed → production, and on a **personal account created after
November 2023** the middle step is a hard clock:

- **12 testers who have opted in, for 14 continuous days.** Not shortenable.
  The window runs from the day the twelfth tester opts in, and **dropping below
  12 at any point restarts it**, so the group has to stay intact until Play
  offers the production-access application. Start recruiting early; this is
  wall-clock time no amount of work removes.
- Cordelia: internal track rolled out and tester link confirmed 2026-08-07;
  12 testers met 2026-08-19.

## 6. Minimum functionality — a live store must exist

Discovery lists **only published stores**. A reviewer opening the app to an
empty list is a minimum-functionality rejection. Cordelia met this on
2026-08-11 with one published `grofast` store — and this blocker **returns the
moment that store is unpublished**, which is easy to do by accident from the
console. Treat "at least one published store" as a release invariant, not a
one-time task.

## 7. Android-specific traps already documented elsewhere

- **API key restrictions blocked the closed-testing build** with "Requests from
  this Android client application are blocked". The GCP API-key allow-list is
  (package name + SHA-1) pairs and is a *different list* from Firebase's
  fingerprints. Full write-up, including the curl probe that verifies a key
  without a device: `docs/how-to/android-api-key-restrictions.md`.
- **`@mipmap/ic_launcher` is wrong as a notification icon.** Android keeps only
  a small icon's alpha channel and fills it white, so a round adaptive launcher
  renders as a filled donut. Ship a flat monochrome `ic_notification` drawable
  plus the `default_notification_icon`/`_color` manifest meta-data.

---

## Checklist for the next app from this repo

- [ ] Real release `signingConfig`; verify with `keytool -printcert -jarfile`
- [ ] `version: x.y.z+N`, N increasing on every upload
- [ ] Privacy policy hosted and linked
- [ ] **Financial features: none** (unless you truly hold funds)
- [ ] App access: demo credentials, verified account, no stale placeholders
- [ ] Data safety form
- [ ] Content rating, target audience, ads declarations
- [ ] Store listing: icon, feature graphic, screenshots, descriptions
- [ ] At least one published store, so discovery is not empty
- [ ] Internal → closed (12 testers × 14 days) → production
