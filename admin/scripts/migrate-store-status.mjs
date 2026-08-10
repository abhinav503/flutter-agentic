// Backfills the store publication lifecycle onto stores that predate it.
//
// Every existing store carries `status: "active"` (or nothing at all), which
// the old discovery query treated as "visible". The lifecycle replaces that
// with draft | pending | published | rejected.
//
//   --to=draft      (default) every store goes back to draft and disappears
//                   from public discovery until it is submitted and approved.
//                   Owners still see their own via the preview tier.
//   --to=published  grandfathers every store as live, preserving exactly
//                   what shoppers see today.
//
// `previewReady` is computed for real either way — logo + at least one
// category + at least one product — because that flag is what decides
// whether an owner can see their own unpublished store in the app, and a
// blanket `true` would put empty storefronts back in front of them.
//
// Dry run by default. Pass --apply to write.
//
//   node --env-file=.env.local scripts/migrate-store-status.mjs
//   node --env-file=.env.local scripts/migrate-store-status.mjs --apply
//   node --env-file=.env.local scripts/migrate-store-status.mjs --to=published --apply

import { cert, initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const flags = process.argv.slice(2);
const apply = flags.includes("--apply");
const target = (flags.find((f) => f.startsWith("--to=")) ?? "--to=draft").slice(
  5,
);

if (!["draft", "published"].includes(target)) {
  console.error(`--to must be "draft" or "published" (got "${target}")`);
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

async function countIn(storeId, sub) {
  const snap = await db
    .collection("stores")
    .doc(storeId)
    .collection(sub)
    .count()
    .get();
  return snap.data().count;
}

const stores = await db.collection("stores").get();
console.log(`Target status: ${target}\n${stores.size} store(s)\n`);

const rows = [];
for (const doc of stores.docs) {
  const data = doc.data();
  const [categories, products] = await Promise.all([
    countIn(doc.id, "categories"),
    countIn(doc.id, "products"),
  ]);
  const previewReady =
    Boolean((data.logoUrl ?? "").trim()) && categories > 0 && products > 0;
  rows.push({
    id: doc.id,
    name: data.name ?? "(unnamed)",
    from: data.status ?? "(none)",
    categories,
    products,
    logo: Boolean((data.logoUrl ?? "").trim()),
    previewReady,
  });
}

for (const r of rows) {
  console.log(
    `  ${r.previewReady ? "✓" : "·"} ${r.name.padEnd(24)} ${r.from.padEnd(10)} -> ${target}` +
      `   logo=${r.logo ? "y" : "n"} cats=${r.categories} products=${r.products}`,
  );
}
console.log(
  `\npreviewReady: ${rows.filter((r) => r.previewReady).length}/${rows.length}` +
    ` (an owner only sees their own unpublished store when this is true)`,
);

if (!apply) {
  console.log("\nDry run — nothing written. Re-run with --apply.");
  process.exit(0);
}

for (let i = 0; i < rows.length; i += 400) {
  const batch = db.batch();
  for (const r of rows.slice(i, i + 400)) {
    batch.set(
      db.collection("stores").doc(r.id),
      { status: target, previewReady: r.previewReady, rejectionReason: "" },
      { merge: true },
    );
  }
  await batch.commit();
}

console.log(`\nDone — ${rows.length} store(s) set to "${target}".`);
process.exit(0);
