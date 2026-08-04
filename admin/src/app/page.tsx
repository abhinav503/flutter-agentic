import type { Metadata } from "next";
import { LandingPage } from "@/components/site/LandingPage";

const title = "CordeliaApps — Your store's own app, zero commission";
const description =
  "Give your grocery or retail store its own branded shopping app in India. Free to use, Razorpay settles into your account, zero commission, live in minutes.";

// From the marketing build's SEO_METADATA deliverable. Next owns the <head>
// here, so this replaces the framework-specific head() the page shipped with —
// the same strings through a different mechanism.
export const metadata: Metadata = {
  metadataBase: new URL("https://cordeliaapps.com"),
  title,
  description,
  alternates: { canonical: "/" },
  openGraph: {
    title,
    description,
    type: "website",
    url: "/",
    siteName: "CordeliaApps",
    locale: "en_IN",
    images: [
      {
        url: "/og.png",
        width: 1200,
        height: 630,
        alt: "CordeliaApps — a branded store app with zero commission",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title,
    description,
    images: ["/og.png"],
  },
};

// The marketing site now owns `/` — it used to redirect straight to
// /login or /dashboard, which a public website can't do.
export default function Home() {
  return <LandingPage />;
}
