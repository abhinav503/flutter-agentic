import type { Metadata } from "next";
import Link from "next/link";
import { SiteNav } from "@/components/site/SiteNav";
import { SiteFooter } from "@/components/site/SiteFooter";
import { AuthDialogProvider } from "@/components/auth-dialog";
import {
  ghostButtonClasses,
  primaryButtonClasses,
} from "@/components/site/button-classes";

export const metadata: Metadata = {
  title: "Documentation — CordeliaApps",
  description:
    "Guides for setting up your CordeliaApps store: catalog, templates, payments and orders.",
  alternates: { canonical: "/docs" },
  // Nothing to index until the guides exist — an empty page ranking for
  // "CordeliaApps documentation" is worse than no page ranking for it.
  robots: { index: false, follow: true },
};

// A stub, deliberately: the marketing nav and footer both link here, and a
// 404 on the site's own Documentation link is worse than an honest holding
// page. Replace the body with real guides; drop the `robots.index: false`
// above when there is something worth indexing.
export default function DocsPage() {
  return (
    // The nav's Log in / Start free buttons open the shared auth dialog, so
    // this page needs the provider too.
    <AuthDialogProvider>
      <div className="bg-background text-foreground">
        <SiteNav />
        <main id="main" className="mx-auto w-full max-w-3xl px-5 py-24 sm:px-8">
          <h1 className="text-balance text-4xl font-extrabold tracking-tight text-ink sm:text-5xl">
            Documentation
          </h1>
          <p className="mt-5 text-pretty text-lg leading-8 text-muted-foreground">
            We&apos;re writing the setup guides — connecting your Razorpay
            account, building your catalog, choosing a template, and running
            orders day to day.
          </p>
          <p className="mt-4 text-pretty text-base leading-7 text-muted-foreground">
            Until they&apos;re published, email us and we&apos;ll walk you
            through any of it directly.
          </p>
          <div className="mt-10 flex flex-wrap gap-3">
            <a
              href="mailto:hello@cordeliaapps.com"
              className={primaryButtonClasses}
            >
              Email the CordeliaApps team
            </a>
            <Link href="/" className={ghostButtonClasses}>
              Back to the homepage
            </Link>
          </div>
        </main>
        <SiteFooter />
      </div>
    </AuthDialogProvider>
  );
}
