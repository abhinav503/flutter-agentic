// Sets the shopper app's minimum version per platform (platform/appConfig).
//   node --env-file=.env.local scripts/set-app-config.mjs --android 1.0.5 --ios 1.0.5
//   node --env-file=.env.local scripts/set-app-config.mjs --android ""   (clears the gate)
// A script and not a route, like grant-superadmin: raising the floor logs
// every older build out of the store, so it is a deliberate operator act.
import { initializeApp, cert } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

const args = process.argv.slice(2);
const pick = (flag) => {
  const i = args.indexOf(flag);
  return i === -1 ? undefined : (args[i + 1] ?? "");
};
const android = pick("--android");
const ios = pick("--ios");
if (android === undefined && ios === undefined) {
  console.error("usage: set-app-config.mjs [--android X.Y.Z] [--ios X.Y.Z] [--android-url U] [--ios-url U]");
  process.exit(2);
}
const semver = /^\d+\.\d+\.\d+$/;
for (const [name, v] of [["android", android], ["ios", ios]]) {
  if (v !== undefined && v !== "" && !semver.test(v)) {
    console.error(`${name} must be X.Y.Z or empty, got "${v}"`);
    process.exit(2);
  }
}

initializeApp({
  credential: cert({
    projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
    clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY,
  }),
});
const db = getFirestore();
const patch = { updatedAt: FieldValue.serverTimestamp() };
if (android !== undefined) patch["minVersion.android"] = android;
if (ios !== undefined) patch["minVersion.ios"] = ios;
if (pick("--android-url") !== undefined) patch["updateUrl.android"] = pick("--android-url");
if (pick("--ios-url") !== undefined) patch["updateUrl.ios"] = pick("--ios-url");
const ref = db.collection("platform").doc("appConfig");
await ref.set({}, { merge: true });
await ref.update(patch);
console.log("platform/appConfig:", (await ref.get()).data());
