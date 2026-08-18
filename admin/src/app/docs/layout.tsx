import type { ReactNode } from "react";
import { ChevronDown } from "lucide-react";

import { AuthDialogProvider } from "@/components/auth-dialog";
import { SiteFooter } from "@/components/site/SiteFooter";
import { SiteNav } from "@/components/site/SiteNav";
import { DocsSearch, type SearchEntry } from "@/components/docs/docs-search";
import { DocsSidebar, type DocsNavGroup } from "@/components/docs/docs-sidebar";
import { docCategories, getAllDocs } from "@/lib/docs";

/**
 * The docs shell: the marketing nav on top, a category rail on the left, the
 * article in the middle.
 *
 * It reuses `SiteNav`/`SiteFooter` rather than shipping a header of its own, so
 * the docs read as a room in the same building as the landing page — one nav,
 * one set of CTAs, one footer. The template this design came from was a
 * free-standing site and needed its own; here that would be a second brand.
 */
export default function DocsLayout({ children }: { children: ReactNode }) {
  const docs = getAllDocs();

  const groups: DocsNavGroup[] = docCategories
    .map((category) => ({
      category,
      docs: docs.filter((d) => d.categorySlug === category.slug),
    }))
    // A category with no articles yet is a dead heading in the rail.
    .filter((group) => group.docs.length > 0);

  const searchEntries: SearchEntry[] = docs.map((doc) => ({
    title: doc.title,
    description: doc.description,
    href: doc.href,
    categoryName:
      docCategories.find((c) => c.slug === doc.categorySlug)?.name ?? "",
    headings: doc.headings.map((h) => h.text).join(" "),
  }));

  return (
    // The nav's Log in / Start free buttons open the shared auth dialog.
    <AuthDialogProvider>
      <div className="bg-background text-foreground">
        <SiteNav />

        <div className="mx-auto flex w-full max-w-[1400px] gap-8 px-5 sm:px-8">
          {/* Sticky under the nav, scrolling independently: a long article
              should never scroll its own table of contents out of reach. */}
          <aside className="sticky top-16 hidden h-[calc(100vh-4rem)] w-60 shrink-0 overflow-y-auto border-r border-border pr-3 pt-8 lg:block">
            <div className="mb-7">
              <DocsSearch entries={searchEntries} />
            </div>
            <DocsSidebar groups={groups} />
          </aside>

          <div className="min-w-0 flex-1 py-8">
            {/* Below `lg` the rail is a disclosure. Native `<details>`, so it
                needs no focus trap and no scroll lock — it is part of the page
                rather than a layer over it. */}
            <details className="group mb-8 rounded-2xl border border-border lg:hidden">
              <summary className="flex cursor-pointer list-none items-center gap-2 px-4 py-3 text-sm font-medium [&::-webkit-details-marker]:hidden">
                <ChevronDown
                  aria-hidden="true"
                  className="size-4 text-muted-foreground transition-transform group-open:rotate-180"
                />
                Browse documentation
              </summary>
              <div className="border-t border-border p-4">
                <div className="mb-6">
                  <DocsSearch entries={searchEntries} />
                </div>
                <DocsSidebar groups={groups} />
              </div>
            </details>

            {children}
          </div>
        </div>

        <SiteFooter />
      </div>
    </AuthDialogProvider>
  );
}
