import { initializeApp, getApps, getApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { initializeAppCheck, ReCaptchaEnterpriseProvider } from "firebase/app-check";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
  measurementId: process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID,
};

// Exported for lib/telemetry.ts, which initialises Analytics lazily against
// this same app — it must not import firebase/analytics at module scope, so it
// needs the instance rather than the config.
export const app = getApps().length ? getApp() : initializeApp(firebaseConfig);

// Firebase App Check for the console — reCAPTCHA Enterprise, which scores a
// browser session invisibly (no challenge for a normal owner). Activated
// only when a site key is configured, so a local run or a preview without
// one is unaffected; until enforcement is switched on in Firebase, a
// missing token costs nothing either way. The key is public by design
// (it's in every page), like the rest of this config.
// Debug on localhost: set `self.FIREBASE_APPCHECK_DEBUG_TOKEN = true` in
// the browser console once, copy the token it prints, and register it in
// Firebase → App Check → the web app → Manage debug tokens.
const appCheckSiteKey = process.env.NEXT_PUBLIC_RECAPTCHA_ENTERPRISE_SITE_KEY;
if (typeof window !== "undefined" && appCheckSiteKey) {
  initializeAppCheck(app, {
    provider: new ReCaptchaEnterpriseProvider(appCheckSiteKey),
    isTokenAutoRefreshEnabled: true,
  });
}

export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
