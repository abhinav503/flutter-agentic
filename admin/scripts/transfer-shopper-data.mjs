// Reassigns a shopper's surviving data from one uid to another — the
// counterpart to transfer-store-ownership.mjs, which moves the *admin* side.
//
// The usual reason: an account was deleted and re-created. Account deletion
// (admin/src/app/api/users/delete) removes the profile, addresses, cart,
// favourites, recent searches and reviews, but deliberately KEEPS orders —
// they are the stores' sales records, not the shopper's to erase. Those
// orphaned orders are what this reattaches.
//
// The two collections are structurally different, which is why neither can be
// done by hand in the Firebase console without getting one of them wrong:
//
//   orders/{orderId}.uid           — a FIELD. Top-level collection, so this
//                                    is an in-place update.
//   users/{uid}/addresses/{id}     — a PATH. The uid is the parent document,
//                                    so there is no field to change: each doc
//                                    is copied under the new uid and the
//                                    original deleted.
//
// Deliberately NOT touched, because each is either worthless or actively
// wrong to move:
//   users/{uid}/carts/{storeId}    — a live basket belongs to the session that
//                                    built it, not to a historical identity.
//   users/{uid}/notifications      — server-authored and addressed to the uid
//   users/{uid}/notificationReads    that received them; re-pointing them
//                                    would fabricate a delivery history.
//   devices/{token}                — a handset re-registers on next launch.
//   products/{id}/reviews/{uid}    — doc id is the uid AND the product's
//                                    rating aggregates moved in the same
//                                    transaction; a raw move would leave
//                                    ratingAverage/reviewCount inconsistent.
//
// Dry run by default. Pass --apply to write. Fully reversible by re-running
// with the two uids swapped.
//
//   node --env-file=.env.local scripts/transfer-shopper-data.mjs <fromUid> <toUid>
//   node --env-file=.env.local scripts/transfer-shopper-data.mjs <fromUid> <toUid> --apply

import { cert, initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const [fromUid, toUid, ...flags] = process.argv.slice(2);
const apply = flags.includes("--apply");

if (!fromUid || !toUid) {
  console.error(
    "Usage: node --env-file=.env.local scripts/transfer-shopper-data.mjs <fromUid> <toUid> [--apply]",
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
const db = getFirestore(app);
db.settings({ preferRest: true });

const orders = await db.collection("orders").where("uid", "==", fromUid).get();
const addresses = await db
  .collection("users")
  .doc(fromUid)
  .collection("addresses")
  .get();

console.log(`From: ${fromUid}`);
console.log(`To:   ${toUid}\n`);

const byStatus = {};
for (const doc of orders.docs) {
  const status = doc.data().status ?? "(none)";
  byStatus[status] = (byStatus[status] ?? 0) + 1;
}
console.log(`orders    ${orders.size}`, orders.size ? byStatus : "");
console.log(`addresses ${addresses.size}`);

if (orders.size === 0 && addresses.size === 0) {
  console.log("\nNothing to transfer.");
  process.exit(0);
}

if (!apply) {
  console.log("\nDry run — nothing written. Re-run with --apply to transfer.");
  process.exit(0);
}

// Chunked at 400 rather than the 500 hard cap — an address move costs two
// writes per doc (the copy and the delete), so the halved chunk keeps both
// loops under the limit with one rule instead of two.
for (let i = 0; i < orders.docs.length; i += 400) {
  const batch = db.batch();
  for (const doc of orders.docs.slice(i, i + 400)) {
    batch.update(doc.ref, { uid: toUid });
  }
  await batch.commit();
}
if (orders.size) console.log(`\nReassigned ${orders.size} order(s).`);

const targetAddresses = db.collection("users").doc(toUid).collection("addresses");
for (let i = 0; i < addresses.docs.length; i += 200) {
  const batch = db.batch();
  for (const doc of addresses.docs.slice(i, i + 200)) {
    // Same doc id on the far side: an address id is referenced by the
    // shopper's persisted "last selected address" pref, so regenerating it
    // would silently unselect their default.
    batch.set(targetAddresses.doc(doc.id), doc.data());
    batch.delete(doc.ref);
  }
  await batch.commit();
}
if (addresses.size) console.log(`Moved ${addresses.size} address(es).`);

console.log("\nDone.");
process.exit(0);
