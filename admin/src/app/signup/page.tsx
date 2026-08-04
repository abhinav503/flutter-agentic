import type { Metadata } from "next";
import { LandingPage } from "@/components/site/LandingPage";

export const metadata: Metadata = {
  title: "Create your store account — CordeliaApps",
  alternates: { canonical: "/" },
  robots: { index: false, follow: true },
};

// See app/login/page.tsx — the same dialog in its other mode.
export default function SignupPage() {
  return <LandingPage initialAuthMode="signup" />;
}
