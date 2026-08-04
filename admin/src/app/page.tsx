import type { Metadata } from "next";
import { SiteNav } from "@/components/site/SiteNav";
import { Hero } from "@/components/site/Hero";
import { HowItWorks } from "@/components/site/HowItWorks";
import { Templates } from "@/components/site/Templates";
import { ShopperFeatures } from "@/components/site/ShopperFeatures";
import { AdminFeatures } from "@/components/site/AdminFeatures";
import { Trust } from "@/components/site/Trust";
import { Pricing } from "@/components/site/Pricing";
import { Faq } from "@/components/site/Faq";
import { FinalCta } from "@/components/site/FinalCta";
import { SiteFooter } from "@/components/site/SiteFooter";
import { StructuredData } from "@/components/site/structured-data";

const title = "CordeliaApps — Your store's own app, zero commission";
const description =
  "Give your grocery or retail store its own branded shopping app in India. Razorpay settles into your account, zero commission, live in minutes.";

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
//
// `.site` scopes the landing page's palette (see globals.css): the marketing
// design is built on its own green brand tokens, and without the scope those
// would repaint the whole shadcn dashboard.
export default function Home() {
  return (
    <div className="site bg-background text-foreground">
      <StructuredData />
      <a
        href="#main"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-[60] focus:rounded-full focus:bg-primary focus:px-4 focus:py-2 focus:text-sm focus:font-semibold focus:text-primary-foreground"
      >
        Skip to main content
      </a>
      <SiteNav />
      <main id="main">
        <Hero />
        <HowItWorks />
        <Templates />
        <ShopperFeatures />
        <AdminFeatures />
        <Trust />
        <Pricing />
        <Faq />
        <FinalCta />
      </main>
      <SiteFooter />
    </div>
  );
}
