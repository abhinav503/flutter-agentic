// Tidies an admin's own record: drops stores from their list, and deletes
// `admins/` documents whose Auth user is gone.
//
// Two different kinds of stale build up:
//
//   1. A store the admin owns but no longer wants in their switcher — a
//      half-set-up duplicate, say. `storeIds` lives in TWO places that must
//      move together (see transfer-store-ownership.mjs for the full rule):
//      `admins/{uid}.storeIds`, which the console reads, and the `storeIds`
//      custom claim, which every REST route trusts. Drop it from one only
//      and the console hides a store the API still lets them write, or the
//      reverse. The store document itself is left alone — this changes who
//      sees it, not whether it exists.
//
//   2. An `admins/{uid}` document whose Auth user has been deleted. Nothing
//      can ever sign into it, but it still shows up in every listing of
//      administrators and makes a duplicate-looking second account for the
//      same email. Refused unless the Auth user really is gone, so this can
//      never delete a live admin.
//
// Dry run by default — prints what it would do and exits. Pass --apply.
//
//   node --env-file=.env.local scripts/prune-admin-records.mjs \
//     --uid <uid> [--drop-store <storeId>]... [--delete-orphan <uid>]... [--apply]
//
// After a claim change the admin must sign out and back in (or wait up to an
// hour) before their ID token carries it — claims are baked in at mint time.

import { cert, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

const args = process.argv.slice(2);
const apply = args.includes("--apply");

function valuesFor(flag) {
  return args.reduce(
    (found, arg, i) => (arg === flag && args[i + 1] ? [...found, args[i + 1]] : found),
    [],
  );
}

const [uid] = valuesFor("--uid");
const dropStores = valuesFor("--drop-store");
const orphans = valuesFor("--delete-orphan");

if ((!uid || dropStores.length === 0) && orphans.length === 0) {
  console.error(
    "Usage: node --env-file=.env.local scripts/prune-admin-records.mjs \\\n" +
      "  --uid <uid> [--drop-store <storeId>]... [--delete-orphan <uid>]... [--apply]",
  );
  process.exit(1);
}

initializeApp({
  credential: cert({
    projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
    clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY,
  }),
});
const db = getFirestore();
const auth = getAuth();

async function authUserOrNull(id) {
  try {
    return await auth.getUser(id);
  } catch (error) {
    if (error.code === "auth/user-not-found") return null;
    throw error;
  }
}

if (uid && dropStores.length > 0) {
  const ref = db.collection("admins").doc(uid);
  const before = (await ref.get()).data()?.storeIds ?? [];
  const after = before.filter((id) => !dropStores.includes(id));
  const missing = dropStores.filter((id) => !before.includes(id));

  console.log(`\nadmins/${uid}`);
  for (const id of dropStores) {
    console.log(`  drop ${id} ${before.includes(id) ? "" : "(not in the list — skipping)"}`);
  }
  console.log(`  storeIds ${before.length} -> ${after.length}`);
  if (missing.length === dropStores.length) {
    console.log("  nothing to do");
  } else if (apply) {
    await ref.update({ storeIds: FieldValue.arrayRemove(...dropStores) });
    const user = await authUserOrNull(uid);
    if (!user) {
      console.error(`  !! no Auth user for ${uid} — claim NOT updated`);
    } else {
      // setCustomUserClaims replaces the whole object, so merge.
      await auth.setCustomUserClaims(uid, {
        ...(user.customClaims ?? {}),
        storeIds: (await ref.get()).data()?.storeIds ?? [],
      });
      console.log("  claim restamped — sign out and back in to pick it up");
    }
  }
}

for (const orphan of orphans) {
  const ref = db.collection("admins").doc(orphan);
  const snap = await ref.get();
  if (!snap.exists) {
    console.log(`\nadmins/${orphan}\n  already gone`);
    continue;
  }
  const user = await authUserOrNull(orphan);
  console.log(`\nadmins/${orphan}  (${snap.data().email ?? "no email"})`);
  if (user) {
    console.log("  REFUSED — an Auth user exists, so this is a live admin");
    continue;
  }
  const owned = await db.collection("stores").where("ownerUid", "==", orphan).get();
  if (!owned.empty) {
    console.log(`  REFUSED — still owns ${owned.size} store(s); transfer them first`);
    continue;
  }
  console.log("  no Auth user, owns no stores — safe to delete");
  if (apply) {
    await ref.delete();
    console.log("  deleted");
  }
}

console.log(apply ? "\nApplied." : "\nDry run — nothing written. Pass --apply.");
