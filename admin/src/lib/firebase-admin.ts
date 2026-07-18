import { cert, getApps, getApp, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";

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

// Admin SDK's Firestore client defaults to gRPC, which hangs on DNS
// resolution to firestore.googleapis.com in this environment (and is a
// known flaky spot in serverless runtimes generally, incl. Vercel) — force
// plain HTTPS/REST instead, the same transport family firebase.ts's client
// SDK already uses successfully. Must be set before any Firestore call.
adminDb.settings({ preferRest: true });
