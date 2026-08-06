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
import { AuthDialogProvider } from "@/components/auth-dialog";
import { RedirectIfSignedIn } from "@/components/redirect-if-signed-in";

/**
 * The marketing page. Signing in is a dialog over it, opened by the nav's
 * "Log in" or any "Start free" CTA — never on arrival, so what a visitor sees
 * first is always the page itself.
 */
export function LandingPage() {
  return (
    <AuthDialogProvider>
      {/* Signed in already? Straight to the dashboard. */}
      <RedirectIfSignedIn />
      <div className="bg-background text-foreground">
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
    </AuthDialogProvider>
  );
}
