import { cert, getApps, getApp, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

// Trusted server-side path — bypasses firestore.rules entirely (same as a
// Cloud Function would). Only cart/order writes and admin-token verification
// go through this; catalog reads stay on the plain client SDK (firebase.ts),
// which is already world-readable per firestore.rules.
const app = getApps().length
  ? getApp()
  : initializeApp({
      credential: cert({
        projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
        clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY,
      }),
    });

export const adminDb = getFirestore(app);
export const adminAuth = getAuth(app);
export const adminMessaging = getMessaging(app);

// Admin SDK's Firestore client defaults to gRPC, which hangs on DNS
// resolution to firestore.googleapis.com in this environment (and is a
// known flaky spot in serverless runtimes generally, incl. Vercel) — force
// plain HTTPS/REST instead, the same transport family firebase.ts's client
// SDK already uses successfully. Must be set before any Firestore call.
try {
  adminDb.settings({ preferRest: true });
} catch {
  // settings() is once-only per Firestore instance and throws on the second
  // call. In `next dev`, separate route chunks each evaluate this module
  // against the same reused app — the settings are already applied then, so
  // the retry is safely ignored.
}

// This database lives in asia-south1 (Mumbai) — `firebase
// firestore:databases:get '(default)'`. That is why vercel.json pins
// `regions: ["bom1"]`: Vercel's default iad1 (Washington DC) put every
// function two intercontinental round trips from its own data, since the
// CDN edge already terminates in Mumbai and every route here is a dynamic
// Firestore read with nothing for a US-side function to serve. It cost a
// ~0.65s floor on every call irrespective of payload — a 31-byte search
// response and a 1.9KB categories response timed identically. Moving the
// database region later means moving the Vercel region with it; the two
// are one decision, not two.
