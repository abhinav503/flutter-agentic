// One-off fixer for stores seeded before the banner/brand image sources
// changed (banners: OFF pack shots → Unsplash photography; brands: "" →
// favicon/monogram URLs). Reads the CURRENT urls straight out of
// every market's *-seed-data.ts — no second copy to drift — and rewrites matching
// docs (banners by title, brands by name) in the given store. Idempotent.
//
// Run (needs the FIREBASE_ADMIN_* env vars from .env.local):
//   node --env-file=.env.local scripts/patch-seed-images.mjs <storeId>

import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { cert, initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

const storeId = process.argv[2];
if (!storeId) {
  console.error("Usage: node scripts/patch-seed-images.mjs <storeId>");
  process.exit(1);
}

// Both markets' catalogs: a store seeded from either one has to be patchable,
// and banner titles / brand names are unique enough across them to key on.
const source = (
  await Promise.all(
    [
      "grocery-seed-data.ts",
      "germany-seed-data.ts",
      "france-seed-data.ts",
      "spain-seed-data.ts",
      "italy-seed-data.ts",
      "uk-seed-data.ts",
      "us-seed-data.ts",
    ].map(
      (name) =>
      readFile(
        join(dirname(fileURLToPath(import.meta.url)), "../src/lib/seed", name),
        "utf8",
      ),
    ),
  )
).join("\n");

const brandLogos = new Map(
  [
    ...source.matchAll(
      /\{ slug: "[^"]+", name: "([^"]+)", logoUrl: "([^"]+)" \}/g,
    ),
  ].map((m) => [m[1], m[2]]),
);
const bannerImages = new Map(
  [
    ...source.matchAll(
      /title: "([^"]+)",\s*subtitle: "[^"]*",\s*imageUrl:\s*"([^"]+)"/g,
    ),
  ].map((m) => [m[1], m[2]]),
);
if (brandLogos.size === 0 || bannerImages.size === 0) {
  console.error(
    `Parsed ${brandLogos.size} brand logos / ${bannerImages.size} banner images — dataset format changed?`,
  );
  process.exit(1);
}

const app = initializeApp({
  credential: cert({
    projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
    clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY,
  }),
});
const db = getFirestore(app);
db.settings({ preferRest: true });

let patched = 0;

const banners = await db.collection(`stores/${storeId}/banners`).get();
for (const doc of banners.docs) {
  const imageUrl = bannerImages.get(doc.data().title);
  if (!imageUrl || doc.data().imageUrl === imageUrl) continue;
  await doc.ref.update({ imageUrl, updatedAt: FieldValue.serverTimestamp() });
  console.log(`✓ banner "${doc.data().title}"`);
  patched += 1;
}

const brands = await db.collection(`stores/${storeId}/brands`).get();
for (const doc of brands.docs) {
  const logoUrl = brandLogos.get(doc.data().name);
  if (!logoUrl || doc.data().logoUrl === logoUrl) continue;
  await doc.ref.update({ logoUrl, updatedAt: FieldValue.serverTimestamp() });
  console.log(`✓ brand "${doc.data().name}"`);
  patched += 1;
}

console.log(`Done — ${patched} docs patched.`);
