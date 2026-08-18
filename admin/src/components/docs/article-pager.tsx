import Link from "next/link";
import { ArrowLeft, ArrowRight } from "lucide-react";

import type { Doc } from "@/lib/docs";

/**
 * Previous / next across the whole collection, not just within a category —
 * someone reading the setup path straight through should walk off the end of
 * Catalog into Payments without going back to the index.
 */
export function ArticlePager({
  previous,
  next,
}: {
  previous?: Doc;
  next?: Doc;
}) {
  if (!previous && !next) return null;

  return (
    <nav className="mt-12 grid grid-cols-1 gap-4 sm:grid-cols-2">
      {previous ? (
        <Link
          href={previous.href}
          className="group flex flex-col gap-1 rounded-2xl border border-border p-4 transition-all hover:border-border-strong hover:shadow-soft"
        >
          <span className="flex items-center gap-1.5 text-xs text-muted-foreground">
            <ArrowLeft
              aria-hidden="true"
              className="size-3.5 transition-transform group-hover:-translate-x-0.5"
            />
            Previous
          </span>
          <span className="text-sm font-medium text-foreground">{previous.title}</span>
        </Link>
      ) : (
        // Holds the right-hand column in place when there is no previous page.
        <span aria-hidden="true" className="hidden sm:block" />
      )}

      {next ? (
        <Link
          href={next.href}
          className="group flex flex-col items-end gap-1 rounded-2xl border border-border p-4 text-right transition-all hover:border-border-strong hover:shadow-soft sm:col-start-2"
        >
          <span className="flex items-center gap-1.5 text-xs text-muted-foreground">
            Next
            <ArrowRight
              aria-hidden="true"
              className="size-3.5 transition-transform group-hover:translate-x-0.5"
            />
          </span>
          <span className="text-sm font-medium text-foreground">{next.title}</span>
        </Link>
      ) : null}
    </nav>
  );
}
