// One-off seed for the `templates` collection the create-store dialog's
// template dropdown reads (world-readable, no client write — see
// firestore.rules). Idempotent: re-running just overwrites the same two
// docs, so it's safe to run again after adding a new template here.
//
// Run (needs the FIREBASE_ADMIN_* env vars from .env.local):
//   node --env-file=.env.local scripts/seed-templates.mjs

import { cert, initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const app = initializeApp({
  credential: cert({
    projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
    clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY,
  }),
});
const db = getFirestore(app);
db.settings({ preferRest: true });

// Add a new template here (and to cordelia's StorefrontTemplate enum once a
// real presentation/templates/<name>/ exists for it) — everything else
// (the dropdown, Store.templateId) reads from this collection already.
const TEMPLATES = [
  { id: "gravia", name: "Gravia" },
  { id: "dailymart", name: "Dailymart" },
  { id: "grofast", name: "Grofast" },
];

for (const { id, name } of TEMPLATES) {
  await db.collection("templates").doc(id).set({ name });
  console.log(`✓ seeded templates/${id} (${name})`);
}

console.log("Done.");
