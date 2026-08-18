import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowRight, FileText } from "lucide-react";

import { DocIcon } from "@/components/docs/icon";
import { docCategories, getAllDocs, getCategory, getDocsByCategory } from "@/lib/docs";

type Params = { params: Promise<{ category: string }> };

export function generateStaticParams() {
  // Only categories that actually hold a guide. The others `notFound()` below,
  // and prerendering a 404 spends build time to produce a page nothing links to.
  const docs = getAllDocs();
  return docCategories
    .filter((c) => docs.some((d) => d.categorySlug === c.slug))
    .map((c) => ({ category: c.slug }));
}

export async function generateMetadata({ params }: Params): Promise<Metadata> {
  const { category: slug } = await params;
  const category = getCategory(slug);
  if (!category) return {};

  return {
    title: `${category.name} — CordeliaApps docs`,
    description: category.description,
    alternates: { canonical: `/docs/${category.slug}` },
  };
}

export default async function DocsCategoryPage({ params }: Params) {
  const { category: slug } = await params;
  const category = getCategory(slug);
  const docs = getDocsByCategory(slug);

  // A declared category with nothing in it yet is a 404, not an empty page —
  // the sidebar hides it for the same reason.
  if (!category || docs.length === 0) notFound();

  return (
    <>
      <nav aria-label="Breadcrumb" className="mb-6 text-sm text-muted-foreground">
        <Link href="/docs" className="hover:text-foreground">
          Documentation
        </Link>
        <span className="mx-2" aria-hidden="true">
          /
        </span>
        <span className="text-foreground">{category.name}</span>
      </nav>

      <header className="mb-8 max-w-2xl">
        <DocIcon name={category.icon} className="mb-4 size-8 text-primary" />
        <h1 className="text-3xl font-bold tracking-tight text-ink">{category.name}</h1>
        <p className="mt-3 text-lg leading-8 text-muted-foreground">
          {category.description}
        </p>
      </header>

      <ul className="flex flex-col gap-2">
        {docs.map((doc) => (
          <li key={doc.href}>
            <Link
              href={doc.href}
              className="group flex items-start gap-4 rounded-xl border border-border bg-transparent p-4 backdrop-blur-sm transition-all hover:border-border-strong hover:shadow-soft"
            >
              <FileText
                aria-hidden="true"
                className="mt-0.5 size-5 shrink-0 text-muted-foreground"
              />
              <span className="min-w-0 flex-1">
                <span className="block font-medium text-foreground">{doc.title}</span>
                <span className="mt-0.5 block text-sm leading-6 text-muted-foreground">
                  {doc.description}
                </span>
              </span>
              <ArrowRight
                aria-hidden="true"
                className="mt-0.5 size-5 shrink-0 text-muted-foreground transition-transform group-hover:translate-x-0.5"
              />
            </Link>
          </li>
        ))}
      </ul>
    </>
  );
}
