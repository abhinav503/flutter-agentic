// Grants (or revokes) the `role: 'superAdmin'` custom claim — the authority
// behind the platform-wide notification feed. Deliberately a script and not a
// route: nothing reachable over HTTP can hand out this role, so there is no
// endpoint to find, guess or misconfigure.
//
// The claim is what firestore.rules and requireSuperAdmin trust. The mirrored
// `admins/{uid}.role` field written alongside it is only so the console can
// decide whether to render the nav item — that doc is client-creatable at
// sign-up, which is exactly why it is never the authority.
//
// The target must already have signed in to the console once, so their Auth
// user and admins doc exist.
//
// Run (needs the FIREBASE_ADMIN_* env vars from .env.local):
//   node --env-file=.env.local scripts/grant-superadmin.mjs someone@example.com
//   node --env-file=.env.local scripts/grant-superadmin.mjs someone@example.com --revoke
//
// A granted user must sign out and back in (or wait up to an hour) before the
// new claim is in their ID token — claims are baked in at token mint time.

import { cert, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";

const [email, ...flags] = process.argv.slice(2);
const revoke = flags.includes("--revoke");

if (!email) {
  console.error(
    "Usage: node --env-file=.env.local scripts/grant-superadmin.mjs <email> [--revoke]",
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
const auth = getAuth(app);
const db = getFirestore(app);
db.settings({ preferRest: true });

const user = await auth.getUserByEmail(email).catch(() => null);
if (!user) {
  console.error(
    `No Firebase user for ${email}. They must sign in to the console once first.`,
  );
  process.exit(1);
}

// Merge rather than replace: setCustomUserClaims overwrites the whole object,
// and dropping `storeIds` would silently revoke every store this admin owns.
const existing = user.customClaims ?? {};
const nextClaims = { ...existing };
if (revoke) {
  delete nextClaims.role;
} else {
  nextClaims.role = "superAdmin";
}

await auth.setCustomUserClaims(user.uid, nextClaims);

// Mirror onto the admins doc so the console knows whether to show the nav
// item. `storeAdmin` on revoke, not a delete — store-context's
// isAdminRecordComplete treats a missing role as a broken record and would
// fire the repair route forever.
await db
  .collection("admins")
  .doc(user.uid)
  .set({ role: revoke ? "storeAdmin" : "superAdmin" }, { merge: true });

console.log(
  revoke
    ? `Revoked superadmin from ${email} (${user.uid}).`
    : `Granted superadmin to ${email} (${user.uid}).`,
);
console.log("They must sign out and back in for the change to take effect.");

process.exit(0);
