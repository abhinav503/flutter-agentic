# Cordelia — Product Spec

> What a store owner gets when they bring their store to Cordelia. This is the
> **scope contract** for the platform: every capability below is marked
> ✅ shipped, 🚧 in progress, or 🗓 planned, and new feature work should land
> here first. Internal build history lives in
> `docs/explanation/superapp-ecommerce-plan.md`; this doc describes the
> product, not the code.

## The pitch

**Add your products, pick a look, and your customers shop a premium app that
feels like it was built just for your store — with zero commission.**

- **One app, your storefront.** Cordelia is a single shopper app that hosts
  many stores. Your store opens inside it fully branded by the template you
  choose — your customers never see a generic marketplace skin.
- **Shared shoppers, from day one.** Anyone shopping any Cordelia store can
  shop yours with the same account — same login, saved addresses, and
  payment flow. A standalone app starts at zero downloads; your store starts
  with the platform's whole shopper base, and every store that joins brings
  more shoppers for all.
- **No money cut.** Payments settle **directly into your own Razorpay
  account**. Cordelia never touches shopper money — no per-order commission,
  no settlement delay imposed by us. (The business model is a flat
  subscription for hosting + the admin console, not a revenue share.)
- **Instant publish.** Because Cordelia itself is the app listed on the App
  Store / Play Store, launching your store is a data change, not an app
  review: create the store in the admin console, pick a template, add
  products — your storefront is live the moment you press save. 🗓 *The public
  store listings for Cordelia are pending; today this works in test
  distribution.*
- **Real commerce, not a demo.** Orders, delivery statuses, cancellations,
  and refunds are wired end-to-end against your Razorpay account — including
  server-verified payments and idempotent refunds.

## Templates

A template restyles the entire shopper experience at runtime — theme, layout,
navigation, iconography, motion — over the same store data. Switching
templates is one dropdown in the admin console.

| Template | Personality | Status |
|---|---|---|
| `gravia` | Premium grocery — sheet-and-header layout, soft depth | ✅ |
| `dailymart` | Clean daily-essentials mart — stacked nav, carded rows | ✅ |
| `grofast` | Playful gradient grocery — domed sheets, staggered grid | ✅ |

Every template implements **every** shopper surface below — no store ever
falls back to another template's screen.

## What your customers get (shopper app)

| Surface | What it does | Status |
|---|---|---|
| Store discovery | Find and open any live store; each visit is a clean, isolated session | ✅ |
| Home | Promo banners you curate, category rails, popular products | ✅ |
| Search | Per-store search with recent-search history | ✅ |
| Categories | Grouped category browse + category details with sort & price filtering | ✅ |
| Product details | Images, brand, pricing with strike-through discounts, a size picker where each size has its own price, description, related products | ✅ |
| Cart | Quantity stepping, swipe-to-delete, live totals | ✅ |
| Coupons | Apply a promo code at cart — validated live, discount shown in the totals and charged exactly | ✅ |
| Checkout | Address selection, Razorpay payment (your account), order confirmation | ✅ |
| Orders | Order history with search + status/date filters, and a track-order view per order — dated status timeline, delivery OTP, itemised contents, what was paid | ✅ |
| Cancel & refund | Shopper self-cancel before dispatch with automatic refund to source | ✅ |
| Product reviews | Any signed-in shopper rates a product 1–5 with optional text — one review each, editable. Product pages show the average, the star breakdown, and every review; a reviewer who bought the item is badged **Verified purchase** | ✅ |
| Order rating | Rate a **delivered** order and say how it went — private feedback to you, not shown to other shoppers | ✅ |
| Addresses | Full address book — add, edit, delete, select at checkout | ✅ |
| Wishlist | Per-store favourites | ✅ |
| Notifications | Push notifications and an in-app notification centre — your store's announcements, CordeliaApps announcements, and automatic order updates (placed, on the way, delivered, cancelled) in the shopper's language. Tapping one opens the store that sent it | ✅ (Android; iOS push needs an Apple push key) |
| Profile | Edit profile with avatar upload, change password | ✅ |
| Account | Email/password sign-up with email verification, forgot/reset password, persistent sessions, and in-app account deletion (removes profile, addresses, cart, wishlist and reviews; orders stay with the stores as their sales records) | ✅ |
| Legal | Your privacy policy & terms rendered in-template | ✅ |

## What you get (admin console)

| Capability | What it does | Status |
|---|---|---|
| Store setup | Create your store, become its admin, pick its template | ✅ |
| Catalog — categories | Category CRUD with images and screen groupings | ✅ |
| Catalog — products | Product CRUD: images, price/original-price with auto-computed discount, unit (g/ml/pcs), stock, prep time, category links, package sizes, "popular" curation | ✅ |
| Banners | Promo-carousel banners with copy, artwork, tap-targets (product/category), ordering, stage/retire toggle | ✅ |
| Orders | Live order dashboard: advance statuses, delivery OTP, cancel with restock, refunds with retry | ✅ |
| Payments | Connect your own Razorpay account (secret stored encrypted); webhook-driven refund settlement | ✅ |
| Brands | Brand list for your store; assign a brand per product — shown on the product page once assigned | ✅ (shows only for products you've given a brand) |
| Size variants | Per-size price on a product (250g ≠ 500g price), computed discounts — priced through cart, checkout, and orders | ✅ |
| Coupons | Create codes scoped to the whole store, a category, or a product — % (with cap) or flat, min order, validity window, total and per-customer limits | ✅ |
| Reviews | One page, two lists: **product reviews** across your store (delete any — the product's rating recalculates), and **delivery ratings** your customers gave their orders (read-only: private feedback isn't yours to erase). Each product's rating also shows in the catalog table | ✅ |
| Catalog table tools | Every list sorts by column — products by name, price, stock, rating or date added; coupons by code, times used or expiry — with quick filters (category, brand, in/out of stock, coupon status) and search on every screen | ✅ |
| Sample data | One click fills a fresh store with a realistic grocery catalog — 90+ products with real product photos across 10 categories, 30+ brands, working coupons and promo banners — so you can trial any template before typing a single product of your own | ✅ |
| Notifications | Compose a notification — kind, title, message, optional artwork — and it goes out as a push to your shoppers *and* into their in-app notification centre. Order updates send themselves | ✅ |

## Platform guarantees

- **Tenant isolation.** Every store's catalog, orders, and payments live under
  its own namespace; security rules and token-verified APIs enforce that a
  store admin can only touch their own store, and a shopper only their own
  data.
- **Secrets and user data are protected.** Your payment keys are stored
  encrypted and never leave the server. Customer passwords are never stored
  by Cordelia, and all data is encrypted in transit and at rest. Every
  request is identity-checked: a shopper sees only their own data, a store
  only its own.
- **Your money path.** Every payment is taken through your own account and
  verified on the server before the order is recorded; a refund can never be
  issued twice, even when retried.
- **Honest order state.** Every status change is timestamped and shown to the
  shopper as a dated timeline — no fake pipeline steps.
- **Ratings that can't drift.** A product's average, review count, and star
  breakdown are recalculated in the same atomic write as the review that
  changed them — so the number on a product card, the histogram on its page,
  and the reviews under it can never disagree, and deleting a review from the
  console corrects the rating immediately.

## Roadmap (committed order)

1. **Catalog depth** — brands + per-size pricing. ✅ Done 2026-08-04, admin
   and all three storefront templates.
2. **Coupons** — store/category/product-scoped codes, validated and priced
   server-side. ✅ Done 2026-08-04, admin + all three storefront templates.
3. **Reviews** — product reviews with aggregate ratings and admin
   moderation, plus delivery ratings on orders. ✅ Done 2026-08-04, admin +
   all three storefront templates. Built with the gating split in two, which
   differs from this item as first written: rating an **order** is
   delivery-gated (only its own shopper, only once delivered), while a
   **product** review is open to any signed-in shopper — gating those on
   purchase would silence most of the people willing to write one, and the
   verified-purchase badge carries the credibility instead.
4. **Per-store notifications** — admin-composed, backend-fed, with push.
   ✅ Done 2026-08-08, admin + all three storefront templates. Push and the
   in-app record are one operation server-side, so neither can ship without
   the other; order updates compose themselves in the store's language.
   iOS push still needs an Apple push key uploaded to Firebase.

Deliberately later: post-delivery returns, delivery serviceability/fees,
store-owner subscription billing, cross-store search.
