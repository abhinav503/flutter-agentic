import { adminDb } from "./firebase-admin";

// Platform-wide settings the shopper app reads at launch — today only the
// minimum version per platform and where to send a shopper to update.
// One doc, platform/appConfig, edited by a superadmin (no console UI yet:
// `scripts/set-app-config.mjs`). Absent doc or field = no gate.
//
// Raised before flipping App Check enforcement with real users, so a
// build that would be refused by Firebase gets an "update" screen instead
// of a failing sign-in.

export type AppConfig = {
  minVersion: { android: string; ios: string };
  updateUrl: { android: string; ios: string };
};

export const DEFAULT_APP_CONFIG: AppConfig = {
  minVersion: { android: "", ios: "" },
  updateUrl: {
    android: "https://play.google.com/store/apps/details?id=com.cordeliaapps.superapp",
    ios: "https://apps.apple.com/app/id0000000000",
  },
};

export async function getAppConfig(): Promise<AppConfig> {
  const snap = await adminDb.collection("platform").doc("appConfig").get();
  const d = snap.data() ?? {};
  const mv = (d.minVersion ?? {}) as Partial<AppConfig["minVersion"]>;
  const uu = (d.updateUrl ?? {}) as Partial<AppConfig["updateUrl"]>;
  return {
    minVersion: { android: mv.android ?? "", ios: mv.ios ?? "" },
    updateUrl: {
      android: uu.android || DEFAULT_APP_CONFIG.updateUrl.android,
      ios: uu.ios || DEFAULT_APP_CONFIG.updateUrl.ios,
    },
  };
}
