import type { Metadata } from "next";
import { LandingPage } from "@/components/site/LandingPage";

export const metadata: Metadata = {
  title: "Log in — CordeliaApps",
  // Same page as `/` with a dialog over it — canonical points home, and there
  // is nothing here for a crawler to index separately.
  alternates: { canonical: "/" },
  robots: { index: false, follow: true },
};

// Signing in is a dialog now, not a screen. The route survives so bookmarks
// and the dashboard's signed-out redirect still land somewhere sensible: the
// marketing page with the sign-in dialog already open.
export default function LoginPage() {
  return <LandingPage initialAuthMode="login" />;
}
