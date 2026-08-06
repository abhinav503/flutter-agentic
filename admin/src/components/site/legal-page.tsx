import Link from "next/link";
import type { ReactNode } from "react";
import { SiteNav } from "@/components/site/SiteNav";
import { SiteFooter } from "@/components/site/SiteFooter";
import { AuthDialogProvider } from "@/components/auth-dialog";
import { ghostButtonClasses } from "@/components/site/button-classes";

/**
 * The shell every legal page shares — nav, footer, title, effective date, and
 * the way back. Extracted the moment there were two of these, so Terms and
 * Privacy can't drift into looking like pages from different sites.
 *
 * Server component: nothing here is interactive. The one interactive part of
 * a legal page (the analytics consent control on Privacy) is passed in as
 * children and carries its own "use client".
 */
export function LegalPage({
  title,
  lastUpdated,
  intro,
  children,
}: {
  title: string;
  lastUpdated: string;
  intro: ReactNode;
  children: ReactNode;
}) {
  return (
    // The nav's Log in / Start free buttons open the shared auth dialog, so
    // every page that renders SiteNav needs the provider above it.
    <AuthDialogProvider>
      <div className="bg-background text-foreground">
        <SiteNav />
        <main id="main" className="mx-auto w-full max-w-3xl px-5 py-24 sm:px-8">
          <h1 className="text-balance text-4xl font-extrabold tracking-tight text-ink sm:text-5xl">
            {title}
          </h1>
          <p className="mt-3 text-sm text-muted-foreground">
            Last updated {lastUpdated}
          </p>
          <p className="mt-5 text-pretty text-lg leading-8 text-muted-foreground">
            {intro}
          </p>
          {children}
          <div className="mt-12">
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

export function LegalSection({
  title,
  children,
}: {
  title: string;
  children: ReactNode;
}) {
  return (
    <section className="mt-10">
      <h2 className="text-xl font-extrabold tracking-tight text-ink">
        {title}
      </h2>
      <div className="mt-3 space-y-3 text-base leading-7 text-muted-foreground">
        {children}
      </div>
    </section>
  );
}
