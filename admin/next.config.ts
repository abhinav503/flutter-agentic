import type { NextConfig } from "next";

const nextConfig: NextConfig = {
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
};

export default nextConfig;
