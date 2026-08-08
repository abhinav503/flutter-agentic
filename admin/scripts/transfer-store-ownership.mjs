// Moves every store owned by one admin to another.
//
// Ownership is expressed in THREE places and a partial move breaks both
// accounts in different ways, which is why this is one script rather than a
// console action or a hand-edit in the Firebase UI:
//
//   1. stores/{id}.ownerUid   — what firestore.rules and storage.rules trust
//                               for direct client writes (catalog, banners,
//                               product images).
//   2. the `storeIds` custom claim on the Auth user — what every REST route
//                               trusts via requireStoreOwner (orders, cancel,
//                               refunds, notifications, payments).
//   3. admins/{uid}.storeIds  — the mirror the console reads to render the
//                               store switcher.
//
// Change only (1) and the new owner can write the catalog but the console
// shows them no stores and every API route 403s; change only (2) and the
// reverse. So all three move together, or nothing does.
//
// Dry run by default — prints the affected stores and exits without writing.
// Pass --apply to perform the transfer.
//
//   node --env-file=.env.local scripts/transfer-store-ownership.mjs <fromUid> <toUid>
//   node --env-file=.env.local scripts/transfer-store-ownership.mjs <fromUid> <toUid> --apply
//
// The new owner must sign out and back in (or wait up to an hour) before the
// claim is in their ID token — claims are baked in at token mint time.

import { cert, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

const [fromUid, toUid, ...flags] = process.argv.slice(2);
const apply = flags.includes("--apply");

if (!fromUid || !toUid) {
  console.error(
    "Usage: node --env-file=.env.local scripts/transfer-store-ownership.mjs <fromUid> <toUid> [--apply]",
  );
  process.exit(1);
}
if (fromUid === toUid) {
  console.error("Source and target uid are the same — nothing to transfer.");
  process.exit(1);
}

const app = initializeApp({
  credential: cert({
    projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
    clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY,
  }),
});
const auth = getAuth(app);
const db = getFirestore(app);
db.settings({ preferRest: true });

// The target must be a real Auth user — claims are set on the user record,
// and there is nothing to stamp otherwise. The source may legitimately be
// gone (a deleted account is a common reason to transfer in the first
// place), so it is only reported, never required.
const toUser = await auth.getUser(toUid).catch(() => null);
if (!toUser) {
  console.error(`No Firebase Auth user with uid ${toUid}. Aborting.`);
  process.exit(1);
}
const fromUser = await auth.getUser(fromUid).catch(() => null);

const snap = await db.collection("stores").where("ownerUid", "==", fromUid).get();
const stores = snap.docs.map((doc) => ({ id: doc.id, name: doc.data().name ?? "(unnamed)" }));

console.log(`From: ${fromUid}${fromUser ? ` (${fromUser.email})` : " — no Auth user, deleted?"}`);
console.log(`To:   ${toUid} (${toUser.email})`);
console.log(`\nStores with ownerUid == ${fromUid}: ${stores.length}`);
for (const store of stores) console.log(`  - ${store.id}  ${store.name}`);

if (stores.length === 0) {
  console.log("\nNothing to transfer.");
  process.exit(0);
}

if (!apply) {
  console.log("\nDry run — nothing written. Re-run with --apply to transfer.");
  process.exit(0);
}

const storeIds = stores.map((s) => s.id);

// 1. The docs themselves. Chunked at 400 to stay clear of the 500-write
//    batch cap even once the admins-doc writes below are counted.
for (let i = 0; i < storeIds.length; i += 400) {
  const batch = db.batch();
  for (const id of storeIds.slice(i, i + 400)) {
    batch.update(db.collection("stores").doc(id), { ownerUid: toUid });
  }
  await batch.commit();
}
console.log(`\nUpdated ownerUid on ${storeIds.length} store doc(s).`);

// 2. The console's mirror. `role` is seeded only when the target has no
//    admins doc yet: store-context treats a missing role as a broken record
//    and re-fires its repair route forever, but overwriting an existing role
//    would silently demote a superadmin.
const toAdminRef = db.collection("admins").doc(toUid);
const toAdminSnap = await toAdminRef.get();
await toAdminRef.set(
  {
    storeIds: FieldValue.arrayUnion(...storeIds),
    ...(toAdminSnap.exists ? {} : { role: "storeAdmin", email: toUser.email ?? "" }),
  },
  { merge: true },
);
if (fromUser) {
  await db
    .collection("admins")
    .doc(fromUid)
    .set({ storeIds: FieldValue.arrayRemove(...storeIds) }, { merge: true });
}
console.log("Updated admins/{uid}.storeIds on both sides.");

// 3. The claims the REST API actually trusts. Merged rather than replaced —
//    setCustomUserClaims overwrites the whole object, so a bare
//    { storeIds } would strip a superAdmin `role`.
const toClaims = toUser.customClaims ?? {};
const nextToStoreIds = [...new Set([...(toClaims.storeIds ?? []), ...storeIds])];
await auth.setCustomUserClaims(toUid, { ...toClaims, storeIds: nextToStoreIds });

if (fromUser) {
  const fromClaims = fromUser.customClaims ?? {};
  const nextFromStoreIds = (fromClaims.storeIds ?? []).filter(
    (id) => !storeIds.includes(id),
  );
  await auth.setCustomUserClaims(fromUid, { ...fromClaims, storeIds: nextFromStoreIds });
}
console.log("Updated the storeIds custom claim on both sides.");

console.log(
  `\nDone. ${toUser.email} must sign out and back in before the new claim is in their ID token.`,
);

process.exit(0);
