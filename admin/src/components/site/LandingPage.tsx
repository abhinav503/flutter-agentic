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
import { AuthDialogProvider, type AuthMode } from "@/components/auth-dialog";
import { RedirectIfSignedIn } from "@/components/redirect-if-signed-in";

/**
 * The marketing page, shared by `/` and by the `/login` + `/signup` routes.
 *
 * Signing in is a dialog, not a screen — so those two routes render this same
 * page with `initialAuthMode` set, and the dialog is already open on arrival.
 * That keeps old bookmarks and the dashboard's signed-out bounce working
 * without an effect that pops the dialog after hydration.
 */
export function LandingPage({
  initialAuthMode,
}: {
  initialAuthMode?: AuthMode;
}) {
  return (
    <AuthDialogProvider initialMode={initialAuthMode}>
      {/* Signed in already? Straight to the dashboard — including from
          /login and /signup, which render this same page. */}
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
