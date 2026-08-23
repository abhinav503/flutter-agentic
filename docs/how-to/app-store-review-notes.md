# App Store review — the reply, and the Notes field

Guideline 2.1 "Information Needed" is a **metadata** rejection, not a build one:
the binary was never run and never faulted. It is answered by replying in App
Store Connect (Resolution Center) and pasting the same text into **App Store
Connect → your app → the version → App Review Information → Notes**, so no
future submission asks for it again. **No new build is required.**

One `⟨…⟩` placeholder is left: the devices you tested on (line ~180).

## Before you send — prepare the review account

1. Sign in as the demo account on any device and **save one delivery address**
   inside DailyMart's delivery area. Addresses live on the shopper
   (`/users/addresses`), not on a store or a device, so it will be waiting when
   the reviewer signs in.
2. Check **DailyMart → Settings → Delivery → Areas** in the console. An empty
   list means the store delivers everywhere and any address the reviewer types
   works; a list of prefixes means only those do.
3. Confirm DailyMart is on **Razorpay test keys** and has stock on the products
   the reviewer will reach first.

---

## Paste-ready Notes

```
APP: CordeliaApps (com.cordeliaapps.superapp), version 1.0.4 (6)

--------------------------------------------------------------------
3. WHAT THE APP DOES, AND FOR WHOM
--------------------------------------------------------------------
CordeliaApps is a multi-tenant shopping app: one app that hosts many
independent stores. Store owners create and stock their store in our
web console (https://cordeliaapps.com); shoppers use this app to
discover those stores, open one, browse its catalog, add items to a
cart, and place an order for physical goods delivered to a street
address.

Problem it solves: an independent retailer cannot justify building and
maintaining its own iOS app. CordeliaApps gives each of them a real
storefront — its own branding, catalog, pricing, coupons, delivery
areas and payment account — inside a single shopper app, so shoppers
install one app instead of one per shop.

Target audience: general consumers (17+) buying everyday goods —
groceries, household and personal-care items — from local and
independent retailers.

Each store picks one of three visual templates, so different stores
look different by design. That is the product working, not a bug.

--------------------------------------------------------------------
4. SETTING UP AND REACHING THE MAIN FEATURES
--------------------------------------------------------------------
No account is needed to launch and browse. Onboarding leads to the
store-discovery screen; tapping any store opens its storefront, where
the catalog, categories, search and product details are all fully
usable while signed out.

An account is required only for actions that store something of the
shopper's: cart, wishlist, checkout, orders, profile and reviews.
Tapping any of those pushes the login screen; going back returns you
to where you were.

DEMO ACCOUNT (already email-verified — please use this one rather than
registering, since a newly registered account must confirm its email
before it can proceed):
    Email:    cordeliaappsreview@gmail.com
    Password: <see the password manager / App Store Connect's
               Sign-In Information field - deliberately not stored
               in this repo, which is public>

There is only one account type in this app. (Store owners sign in to
the separate web console, not to this app.)

TO REACH EVERY CORE FEATURE:
 1. Launch → Onboarding → "DailyMart" on the discovery screen.
 2. Browse / Search / Categories → tap a product → Product Details.
 3. Add to cart → Cart tab → Checkout.
 4. Checkout asks for a delivery address. This account already has
    one saved (Bengaluru 560100, India) - select it and continue.
    You are welcome to add your own instead, on the same screen, but
    note that this store delivers within Bengaluru, so an address
    outside its area is refused by design rather than by fault.
 5. PAYMENT — this store settles through Razorpay and is configured
    with Razorpay TEST keys, so no real money moves and no real card
    is needed. In the Razorpay sheet choose "Card" and enter:
        Card number: 4111 1111 1111 1111
        Expiry:      any future date (e.g. 12/30)
        CVV:         any 3 digits (e.g. 123)
        Name:        anything
    Razorpay then shows its test authentication page — tap
    "Success" to approve the payment.
 6. Order appears under Profile → My Orders → tap it for Track Order,
    where the order can also be cancelled (which auto-refunds) and,
    once delivered, rated.
 7. Reviews: Product Details → Reviews → "Write a review". Reporting
    and blocking are on the "…" control of any review that is not
    your own.
 8. Account deletion: Profile → Delete Account (also available at
    https://cordeliaapps.com/delete-account).

--------------------------------------------------------------------
IN-APP PURCHASE — WHY THERE IS NONE
--------------------------------------------------------------------
Everything sold in this app is a physical good delivered to a street
address, plus its delivery fee. Per Guideline 3.1.5(a), goods and
services consumed outside the app must use a payment method other than
in-app purchase, so checkout goes through Razorpay or Stripe (each
store settles into its own merchant account). There is no digital
content, subscription, or unlockable feature anywhere in the app.

--------------------------------------------------------------------
PERMISSION PROMPTS — WHEN THEY APPEAR
--------------------------------------------------------------------
Nothing is requested at launch. Each prompt is triggered by a tap:
 • Location (when-in-use) — tapping the location row in the
   storefront header, or "Use current location" on the address form.
   Used only to prefill a delivery address. Declining is fine; the
   address can be typed.
 • Camera / Photo Library — only from Profile → Edit Profile → the
   avatar, to set a profile photo.
 • Notifications — asked once after sign-in; used for order status
   updates (placed / on the way / delivered / cancelled) and store
   announcements.
There is no App Tracking Transparency prompt: the app does no
tracking and shows no ads.

--------------------------------------------------------------------
5. EXTERNAL SERVICES USED
--------------------------------------------------------------------
 • Our own backend — Next.js API on Vercel with Google Firestore
   (stores, catalogs, carts, orders, reviews).
 • Firebase Authentication — email/password sign-in and verification.
 • Firebase Cloud Storage — shopper profile photos.
 • Firebase Cloud Messaging — order and store push notifications.
 • Firebase Crashlytics — crash reporting.
 • Razorpay and Stripe — payment processing. Card details are entered
   in the provider's own native sheet; the app never sees or stores
   them, and every payment is verified server-side before an order is
   written.
 • Apple Core Location (via the geolocator plugin) and the device's
   own geocoder — address prefill. No third-party maps or places
   service is used.
 • India Post public pincode lookup — city/state from an Indian
   postal code.
 • Google Fonts — typefaces.
 • Product imagery is uploaded by each store owner. Demo catalogs use
   Open Food Facts photography (CC-BY-SA), attributed in our console.
No AI/LLM service, no advertising SDK and no analytics/tracking SDK is
used in this app.

--------------------------------------------------------------------
6. REGIONAL DIFFERENCES
--------------------------------------------------------------------
The app's features are identical in every region — same screens, same
flows, no region-gated or region-hidden functionality.

What varies is per **store**, not per region: a store publishes its own
language (English, Hindi, German, French, Spanish, Italian), its own
currency (INR, EUR, GBP, USD), and the postal codes it delivers to.
A shopper anywhere sees the same app; a store simply reads in its own
language and prices in its own currency.

Alcohol and tobacco are banned platform-wide and blocked server-side,
in every region, which is why the age rating declares no
alcohol/tobacco references.

--------------------------------------------------------------------
7. REGULATED INDUSTRIES / THIRD-PARTY MATERIAL
--------------------------------------------------------------------
The app does not operate in a regulated industry. It sells everyday
consumer goods only — no pharmacy or medicines, no alcohol or tobacco
(banned and enforced server-side), no financial products, no gambling,
no health data.

Payment processing is delegated entirely to Razorpay and Stripe, both
licensed processors; we are their merchant, not a payment institution,
and no card data touches our app or servers.

All catalog content is uploaded by the store owner who sells it, and
our terms (https://cordeliaapps.com/terms, §6) require them to hold
the rights to it. Demo catalog photography is Open Food Facts under
CC-BY-SA, used with attribution.

--------------------------------------------------------------------
2. TESTED ON
--------------------------------------------------------------------
⟨e.g. iPhone 14 Pro (iOS 18.6) — physical device; iPhone 16 Pro
Simulator (iOS 18.6). Pixel 7 (Android 15) for the shared codebase.⟩
```

---

## The screen recording — full shot list

One take, on a **physical iPhone running the latest iOS**, portrait, starting
from the Home screen. Do not cut, speed up, or narrate over gaps; a reviewer is
checking that the app behaves, so dead time is fine. Roughly 5-8 minutes.

Use **two accounts**: the demo account for the shop-and-buy stretch, and a
throwaway you register during the recording and delete at the end. Deleting the
demo account on camera would strand the credentials you gave in the Notes.

**A. Launch and browse — signed out** *(proves the app opens and works without
an account)*
1. Tap the app icon on the Home screen. Let the splash finish.
2. Page through onboarding to the end.
3. Land on store discovery. Scroll the store list.
4. Tap the **location row** in the header → the iOS location prompt appears →
   **Allow While Using App** → the resolved postcode appears in the row.
   *(This is one of the sensitive-data prompts Apple asked to see.)*
5. Open the **DailyMart** store.
6. Scroll home: banners, categories, product grid.
7. Open **Search**, type a query, open a result.
8. Back out, open a **category**, apply a sort/filter from the Filter sheet.
9. Open a **product's details**: photo, price, stock line, quantity stepper,
   reviews section.

**B. Registration and the login wall**
10. Tap **Add to cart** while still signed out → the login screen is pushed.
11. Tap **Sign up**, register the throwaway account with a real mailbox you
    control.
12. Show the **email-verification sheet** appearing, go to Mail, tap the link,
    return — the sheet clears itself. *(Do not cut here; this is the step a
    reviewer would otherwise get stuck on.)*
13. Show the **notification permission prompt** → **Allow**.
14. Profile → **Sign out**.
15. Sign in with the **demo account** from the Notes.

**C. Purchase — the paid flow Apple asked for**
16. Add two or three products to the cart; show the quantity stepper changing
    a line.
17. Open **Cart**: line items, totals, delivery fee.
18. **Checkout** → **Select address**. Show the pre-saved address, then
    **Add address** and fill the form anyway - Apple wants the typical flow,
    and this is where **Use current location** demonstrates the prefill.
    Select whichever address is in the store's delivery area.
19. Continue to payment → the **Razorpay sheet** opens → card
    `4111 1111 1111 1111`, future expiry, any CVV → Razorpay's test
    authentication page → **Success**.
20. Order-placed screen → **My Orders** → open the order → **Track Order**:
    the dated status timeline, the items, the totals, the handoff OTP.
21. On Track Order, tap **Need help with this order?** to show the support
    channel opening a prefilled mail composer. Back out without sending.
22. Tap **Cancel order** and confirm → show the status flipping to cancelled
    and the refund line appearing. *(Optional but worth it — it demonstrates
    the refund path with no real money involved.)*

**D. User-generated content, reporting and blocking** *(Guideline 1.2 — the
part Apple most often re-rejects on)*
23. Open a product you have received → **Reviews** → **Write a review** → pick
    a star rating, type text, submit → your review appears in the list.
24. Scroll to a review written by **someone else** → open its **…** control →
    **Report review** → pick a reason → confirm → show the acknowledgement.
25. From the same sheet, **Block this shopper** → confirm → show that their
    review is now gone from the list.

**E. Profile, media permissions, and account deletion** *(record this last)*
26. Profile → **Edit Profile** → tap the avatar → the picker sheet →
    **Camera** → the iOS **camera prompt** → Allow → take a photo → save.
27. Repeat with **Choose from library** → the iOS **photo library prompt** →
    Allow → pick a photo → **Save Changes**.
28. Profile → **Help & Support** → show the store's published contact.
29. Sign out. Sign in as the **throwaway** account from step 11.
30. Profile → **Delete Account** → read the confirmation sheet → confirm →
    show the app returning to discovery signed out.
31. Try to sign in with the deleted account's credentials → it fails. *(This
    is what proves deletion was real, and it is the single clip Apple most
    often asks for again when it is missing.)*

Upload the file to the Resolution Center reply, or link it — an unlisted,
non-expiring URL that needs no login (Google Drive set to "anyone with the
link", not a Dropbox preview page).

---

## Where the other fields live in App Store Connect

All of these are **app-level**, not per-version — you reach them from
App Store Connect → **Apps** → CordeliaApps, using the left sidebar:

| What | Where |
|---|---|
| **Privacy Policy URL** | Left sidebar → **App Privacy** → the **Privacy Policy** row at the top → **Edit**. Use `https://cordeliaapps.com/privacy`. There is a second, optional Privacy Choices URL — leave it blank. |
| **App Privacy labels** | Same **App Privacy** page → **Data Collection** → **Get Started**. This is the long questionnaire; the answers for this app are below. |
| **Age Rating** | Left sidebar → **App Information** → **Age Rating** → **Edit**. |
| **Category** | Same **App Information** page → Primary/Secondary category. Shopping is the primary one. |
| **Sign-in credentials for review** | The **version** page (e.g. "1.0.4 Prepare for Submission") → scroll to **App Review Information** → tick *Sign-in required* and fill Username/Password, then the **Notes** box below it. |
| **Screenshots** | The same version page, at the top — 6.9" iPhone is the only mandatory size now. |
| **DSA trader status** | **App Information** → **Digital Services Act** section. Still unset, which is what excludes EU storefronts. |

### App Privacy — the answers for this app

Declare data your own code **and your embedded SDKs** collect. For CordeliaApps
that is:

| Data type | Collected? | Linked to identity | Used for tracking | Purpose |
|---|---|---|---|---|
| Name, Email address, Phone number | Yes | Yes | No | App Functionality |
| Physical Address | Yes (delivery addresses) | Yes | No | App Functionality |
| Photos | Yes (profile avatar only) | Yes | No | App Functionality |
| Other User Content (reviews, ratings) | Yes | Yes | No | App Functionality |
| User ID | Yes (Firebase uid) | Yes | No | App Functionality |
| Device ID | Yes (FCM push token) | Yes | No | App Functionality |
| Purchase History | Yes (orders) | Yes | No | App Functionality |
| Payment Info | Yes — declare it | Yes | No | App Functionality |
| Crash Data, Performance Data | Yes (Crashlytics) | No | No | App Functionality |
| **Precise / Coarse Location** | **No** | — | — | — |

Two of those rows are worth understanding rather than copying:

- **Location is "Data Not Collected."** Since Ola Maps was dropped, the fix is
  resolved by the device's own geocoder and used on screen; nothing leaves the
  device and no coordinates are stored. What *is* stored is the postcode and
  street the shopper accepts into a saved address — and that is already
  declared as Physical Address, entered by them. Declaring location as
  collected here would be wrong in the stricter direction and invites
  questions you would then have to answer.
- **Payment Info is declared even though you never see a card.** Apple's
  question covers data collected by third-party SDKs bundled in the app, and
  the Razorpay and Stripe sheets run inside your binary. Declaring it costs
  nothing; omitting it is the kind of mismatch that gets caught later.

Answer **"No"** to tracking across apps for every row — there is no ad SDK,
no analytics SDK, and no ATT prompt in the app, which is also why the App
Tracking Transparency question does not apply.
