# How to submit an app to the App Store

The record of what `apps/ecommerce/cordelia` actually filled in App Store
Connect, in the order the console asks for it, plus the answers a second
storefront app generated from this repo would give.

**How to read the answers.** Rows marked **observed** were captured from the
console during cordelia's submission (2026-08-22). Rows marked **derived** are
what this repo's code and policies imply — they are what you should enter, but
check them against your app rather than pasting blind. Anything still open is
called out as such.

> The build side — enrolment, signing, the APNs key, the two capabilities push
> needs, and both delivery warnings the first archive hit — is *not* repeated
> here. It is in `docs/explanation/superapp-ecommerce-plan.md` § "iOS —
> signing, push entitlement, and the first TestFlight build". This doc starts
> at the point where a build is in TestFlight and the listing is empty.

---

## 0. Account level, before the app record

These live under **App Store Connect → Business**, not under the app, and two
of them gate distribution rather than review.

| Item | State for cordelia | Notes |
|---|---|---|
| Free Apps Agreement | **Active** (observed) | Enough for a free app with no IAP. |
| Paid Apps Agreement | **New** — not signed (observed) | Only needed to charge through Apple. Cordelia sells physical goods through Razorpay/Stripe, so it stays unsigned. Signing it first requires legal-entity information and banking/tax forms. |
| Name Identification Document | Prompted, not completed (observed) | Business or court documentation confirming your name. Only relevant when changing the displayed developer name. The listing therefore shows the **enrolled individual's legal name**, not "CordeliaApps" — changing that needs an Organization account (D-U-N-S) or an approved d/b/a. |
| **Digital Services Act — trader status** | **Unset** (observed) | A red banner on the Business page. While unset, the app **cannot be distributed in the EU**. Declaring trader status publishes a contact address on the product page — for an individual account, a personal one. For a multi-tenant marketplace it also implies DSA Article 30 merchant traceability (verified identity, address and payment account per selling store), which is unscoped. This is a deliberate hold, not an oversight. |

---

## 1. App record and App Information

App-level, released with the next version. **App Store Connect → your app →
App Information**.

| Field | cordelia's value | Source |
|---|---|---|
| Name | `CordeliaApps: Local Stores` | observed |
| Bundle ID / SKU | `com.cordeliaapps.superapp` | observed |
| Apple ID | `6803333321` | observed |
| Primary language | **English (U.K.)** | observed |
| Subtitle (30 chars) | left empty at capture | observed — worth filling; it shows under the name in search results |
| Category | Shopping (primary) | derived |
| License Agreement | Apple's Standard License Agreement | observed |

### Content Rights

The dialog asks: *"Does your app contain, show, or access third-party
content?"*

Answer **Yes, and I have the necessary rights** (derived). A storefront app
displays catalog content uploaded by the store owners who sell it, and the
platform terms (`/terms` §6) require them to hold the rights. Seeded demo
catalogs additionally carry Open Food Facts photography under CC-BY-SA.
Answering "No" here would be false for any app in this repo that renders a
store's catalog.

### App Encryption

`Info.plist` already carries `ITSAppUsesNonExemptEncryption = false`, so the
**App Encryption Documentation** upload on this page stays empty and no
year-end self-classification report is due. That key is what makes every
upload stop asking about export compliance — keep it in any app derived from
this one.

### App Store Regulations & Permits

Three sections on the same page; two are inapplicable to a storefront app.

- **Digital Services Act** — "Set Up". See §0; unset, and the reason EU
  storefronts are excluded.
- **Vietnam Game License** — N/A, not a game.
- **Regulated Medical Devices** — N/A. It is only triggered by the Medical or
  Health & Fitness categories, or by answering "frequent" to *Medical or
  Treatment Information* in the age-rating questionnaire — which is one more
  reason to answer that questionnaire carefully rather than quickly.

---

## 2. Age Ratings — the seven-step questionnaire

**App Information → Age Ratings → Edit.** Apple replaced the old checkbox list
with a seven-step wizard; steps 1 and 2 are the ones a storefront app has
non-obvious answers for.

### Step 1 — Features (In-App Controls and Capabilities)

| Question | Answer | Why |
|---|---|---|
| Parental Controls | No | derived — none in the app |
| Age Assurance | No | derived |
| Unrestricted Web Access | No | derived — no in-app browser; `url_launcher` opens `mailto:`/`tel:`/a policy page in Safari, which is not "freely browse the web" |
| **User-Generated Content** | **Yes** | derived — product reviews and order ratings are UGC. Answering No here is the mistake that pairs with a Guideline 1.2 rejection: it contradicts the reporting and blocking controls the app ships |
| Social Media | No | derived — reviews attach to a product, there is no feed that amplifies a person's content to many users |

### Step 2 — Mature Themes

| Question | Answer | Why |
|---|---|---|
| Profanity or Crude Humor | None | derived — no app-authored profanity; UGC is moderated in the console, and reportable in-app |
| Horror/Fear Themes | None | derived |
| **Alcohol, Tobacco, or Drug Use or References** | **None** | derived — and only defensible *because* alcohol and tobacco are banned platform-wide and enforced server-side as a store-readiness check (see `superapp-ecommerce-plan.md` § "Alcohol and tobacco banned platform-wide"). A grocery marketplace with no such ban cannot honestly answer None here |

Steps 3–7 (violence, sexual content, gambling, contests, medical) are all
**None** for a storefront app carrying this repo's category bans.

> The alcohol answer is the clearest case in this repo of a store-form answer
> being *earned by code*. It was answerable only after the keyword ban shipped.
> If you fork this app and drop the ban, this answer changes and so does the
> age rating.

---

## 3. App Privacy

**Left sidebar → App Privacy.** App-level, and published separately from the
version — the **Publish** button here is its own action.

- **Privacy Policy URL** — `https://cordeliaapps.com/privacy` (observed). The
  route exists in the admin site (`admin/src/app/privacy`), alongside
  `/terms`, `/refunds`, `/delete-account` and `/app-privacy`.
- **Data Collection** — "Do you or your third-party partners collect data from
  this app?" → **Yes** (observed).

Cordelia declared **14 data types** (observed):

> Search History, Purchase History, Other User Content, Precise Location,
> Phone Number, Name, Device ID, Physical Address, Crash Data, Email Address,
> Payment Info, User ID, Product Interaction, Photos or Videos

Each type then asks three sub-questions: what it is **used for**, whether it is
**linked to the user's identity**, and whether it is **used for tracking**.
For every type in this app: purpose **App Functionality**, linked **Yes**
(except Crash Data), tracking **No**.

### Two traps worth knowing

- **A data type reads as "used for tracking" until you answer its last
  sub-question.** Mid-questionnaire the Name summary listed *"Used for tracking
  purposes"* as a bullet; the final step ("Do you or your third-party partners
  use names for tracking purposes?") was then answered **No** and the bullet
  cleared. Do not stop halfway and assume the summary reflects your intent.
  A tracking declaration you did not mean requires an App Tracking Transparency
  prompt the app does not have, which is its own rejection.
- **Selecting a type is not answering it.** The page shows a ⚠️ against every
  type whose sub-questions are unfinished, and **Publish stays greyed out**
  until all of them are clear. Cordelia's capture shows Email Address, Phone
  Number, Physical Address and Payment Info all still ⚠️.

### Why Payment Info is declared even though no card is ever seen

The card is entered in Razorpay's or Stripe's own native sheet, and no card
data reaches this app's code or servers. Apple's question nevertheless covers
data collected by **third-party SDKs bundled in the app**, and both sheets run
inside the binary. Declaring it costs nothing; omitting it is a mismatch that
surfaces later.

### Precise Location — declared, and arguable

Cordelia declared it. Since Ola Maps was dropped, the fix is resolved by the
device's own geocoder and nothing leaves the device; what persists is the
street and postcode the shopper accepts into a saved address, which is already
covered by Physical Address. Declaring location is the conservative reading and
is safe. If you declare it **not** collected, be able to say why — and re-check
the moment any coordinate is ever sent to a server.

---

## 4. The version page — listing and assets

**The version (e.g. "1.0.0 Prepare for Submission") → Distribution.**

| Field | Limit | cordelia |
|---|---|---|
| Promotional Text | 170 | *"Now live: shop groceries and daily essentials from stores near you. Fill your bag, pay securely, and track every order right to your door."* (observed) |
| Description | 4,000 | Opens with what the app is, then what makes it different: every shop is a real independent business with its own catalogue, prices and delivery area, shopped from one app and one account (observed, ~1,775 chars used) |
| Keywords | 100 | observed as filled; value not captured |
| Support URL | — | required; `https://cordeliaapps.com` |
| Marketing URL | — | optional |
| Copyright | 200 | e.g. `2026 CordeliaApps` |
| Routing App Coverage File | — | N/A (maps apps only) |

### Screenshots — the gotcha that cost a round

Uploading produced: **"Images can't contain alpha channels or transparencies."**
A PNG exported from a simulator screenshot or any tool that preserves an alpha
channel is rejected on upload, silently leaving the slot empty and red.

Flatten before uploading:

```bash
# strip the alpha channel from every PNG in a folder
sips -s format jpeg screenshot.png --out screenshot.jpg
# or, keeping PNG:
magick screenshot.png -background white -alpha remove -alpha off out.png
```

Also remember Guideline **2.3.3**: screenshots must show the app **in use** —
the storefront, a product, the cart — not the splash, the onboarding art, or
the login screen. Cordelia's capture shows 8 of 10 slots on the iPhone 6.5"
display; the 6.9" size is the one that is mandatory now.

---

## 5. App Review Information

The version page again, below the assets.

- Tick **Sign-in required** and fill Username/Password. Do this *as well as*
  putting them in the Notes — reviewers look in the field first.
- **Notes** — the full paste-ready text for cordelia lives in
  `docs/how-to/app-store-review-notes.md`, which also carries the screen
  recording shot list. It exists because cordelia's first submission was
  rejected under **Guideline 2.1 — Information Needed** for leaving this box
  empty: Apple asked for a device recording, a device/OS list, a description of
  the app and audience, setup instructions, an external-services list, a
  regional-differences statement, and any regulated-industry documentation.
  All seven answers are in that doc.

**Fill this box on the first submission.** It is the single cheapest rejection
in this list to avoid, and answering it after the fact costs a full review
cycle.

---

## 6. Order of operations

1. Build in TestFlight (see the plan doc).
2. Business → agreements; decide DSA trader status (§0).
3. App Information: name, category, Content Rights, age rating (§1–2).
4. App Privacy: policy URL, all 14 types, **Publish** (§3).
5. Version page: description, keywords, alpha-free screenshots (§4).
6. App Review Information: credentials **and** notes (§5).
7. Add for Review.

## Still open for cordelia

- DSA trader status → EU excluded.
- Push unverified on real hardware; rich (image) notifications need a
  Notification Service Extension target.
- Firebase App Check unenforced.
- Developer name on the listing is the enrolled individual's legal name.
