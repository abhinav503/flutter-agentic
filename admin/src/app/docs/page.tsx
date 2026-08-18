import type { Metadata } from "next";
import Link from "next/link";
import { ArrowRight } from "lucide-react";

import { DocIcon } from "@/components/docs/icon";
import { SITE_URL } from "@/lib/site";
import { docCategories, getAllDocs } from "@/lib/docs";

export const metadata: Metadata = {
  title: "Documentation — CordeliaApps",
  description:
    "Set up your CordeliaApps store step by step: catalog, templates, Razorpay and Stripe payments, delivery, orders and going live.",
  alternates: { canonical: "/docs" },
};

export default function DocsHomePage() {
  const docs = getAllDocs();

  return (
    <>
      <header className="max-w-2xl pb-10 pt-2">
        <h1 className="text-balance text-3xl font-extrabold tracking-tight text-ink sm:text-4xl">
          Set up your store, step by step
        </h1>
        <p className="mt-4 text-pretty text-lg leading-8 text-muted-foreground">
          Everything from creating your first store to taking a real payment.
          Follow it end to end, or jump to the part you&apos;re stuck on.
        </p>
      </header>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        {docCategories.map((category) => {
          const count = docs.filter((d) => d.categorySlug === category.slug).length;
          if (count === 0) return null;

          return (
            <Link
              key={category.slug}
              href={`/docs/${category.slug}`}
              className="group flex min-h-[10rem] flex-col rounded-2xl border border-border bg-transparent p-5 backdrop-blur-sm transition-all hover:border-border-strong hover:shadow-soft"
            >
              <DocIcon name={category.icon} className="mb-4 size-7 text-primary" />
              <h2 className="mb-1.5 flex items-center gap-1.5 text-base font-semibold text-foreground">
                {category.name}
                <ArrowRight
                  aria-hidden="true"
                  className="size-4 text-muted-foreground transition-transform group-hover:translate-x-0.5"
                />
              </h2>
              <p className="text-sm leading-6 text-muted-foreground">
                {category.description}
              </p>
              <span className="mt-auto pt-4 text-xs text-muted-foreground">
                {count} {count === 1 ? "guide" : "guides"}
              </span>
            </Link>
          );
        })}
      </div>

      {/* Names the collection for search engines. Every article carries its own
          TechArticle block; this one says what they belong to. */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "CollectionPage",
            name: "CordeliaApps documentation",
            url: `${SITE_URL}/docs`,
            hasPart: docs.map((doc) => ({
              "@type": "TechArticle",
              headline: doc.title,
              url: `${SITE_URL}${doc.href}`,
            })),
          }),
        }}
      />
    </>
  );
}
