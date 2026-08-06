import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Hides the floating dev badge so a screenshot of a page is just the page.
  // Compile and runtime errors are still surfaced — this only removes the
  // indicator. (`buildActivity`/`buildActivityPosition` were removed in
  // v16.0.0; `false` and `position` are the whole API now.)
  // devIndicators: false,

  // firebase-admin/auth's verifyIdToken() reaches jwks-rsa -> jose (an ESM
  // package). Turbopack's production bundler 500s at runtime on any route
  // calling verifyIdToken ("ERR_REQUIRE_ESM") — requireStoreOwner and
  // requireAuthedUser in admin-guard.ts both do — even with firebase-admin
  // marked external (Turbopack's externalImport path still can't require()
  // an ESM module). package.json's build script passes --webpack to opt out
  // of Turbopack for the production build; serverExternalPackages here keeps
  // firebase-admin's native bits out of the webpack bundle too. Not caught
  // by `next dev` — dev mode doesn't run the same production bundling path.
  serverExternalPackages: ["firebase-admin"],

  // `/login` and `/signup` used to render the marketing page with the sign-in
  // dialog already open, which meant arriving at either one put a form over a
  // blurred landing page before the visitor had asked for anything. The dialog
  // now opens only from a click, so the two routes had nothing left to render
  // that `/` doesn't. Kept as redirects for old bookmarks and links.
  //
  // Temporary (307), not permanent: a 308 is cached by browsers indefinitely,
  // which would make reinstating either route as a real page painful.
  async redirects() {
    return [
      { source: "/login", destination: "/", permanent: false },
      { source: "/signup", destination: "/", permanent: false },
    ];
  },
};

export default nextConfig;
