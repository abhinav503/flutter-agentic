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
  // The OAuth discovery documents live at the RFC-mandated /.well-known
  // paths, which the app router can't serve from a dot-prefixed folder —
  // so they are routes under /api/oauth/metadata, rewritten here.
  async rewrites() {
    return [
      {
        source: "/.well-known/oauth-authorization-server",
        destination: "/api/oauth/metadata/authorization-server",
      },
      {
        source: "/.well-known/oauth-protected-resource",
        destination: "/api/oauth/metadata/protected-resource",
      },
      {
        source: "/.well-known/oauth-protected-resource/api/mcp",
        destination: "/api/oauth/metadata/protected-resource",
      },
    ];
  },

  async redirects() {
    return [
      // The developer entry point people type and agents guess.
      { source: "/developers", destination: "/docs/ai-and-api", permanent: false },
      { source: "/mcp", destination: "/docs/ai-and-api/connect-an-ai-assistant", permanent: false },
      { source: "/login", destination: "/", permanent: false },
      { source: "/signup", destination: "/", permanent: false },

      // Canonical host: www → apex, for every path.
      //
      // Done here rather than in Vercel's Domains UI because that screen only
      // offers a redirect on domains it doesn't consider production-assigned —
      // once both hostnames resolve to the project the control disappears.
      // Doing it in config also puts the rule in version control instead of a
      // dashboard setting nobody can see in a diff.
      //
      // Without it both hosts serve the site independently, which costs twice:
      // Google sees duplicate content whose canonical only names one of them,
      // and GA4 files the same page under two hostnames, splitting every
      // per-page number.
      //
      // permanent (308) here, unlike the two above: the canonical host is a
      // settled decision, and a permanent redirect is precisely the signal
      // that consolidates the duplicate into one. The /login pair stayed
      // temporary because reinstating those routes is plausible.
      {
        source: "/:path*",
        has: [{ type: "host", value: "www.cordeliaapps.com" }],
        destination: "https://cordeliaapps.com/:path*",
        permanent: true,
      },
    ];
  },
};

export default nextConfig;
