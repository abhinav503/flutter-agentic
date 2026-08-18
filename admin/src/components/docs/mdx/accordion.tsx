import type { ReactNode } from "react";
import { ChevronRight } from "lucide-react";

/**
 * A collapsed aside — the edge case, the "what if it fails", the field
 * reference nobody needs on the first read.
 *
 * Native `<details>`: it opens with no JavaScript, survives a failed hydration,
 * and browser find-in-page opens it to reveal a match. A state-driven panel
 * does none of those three.
 */
export function Accordion({
  title,
  children,
}: {
  title: string;
  children: ReactNode;
}) {
  return (
    <details className="not-prose group rounded-2xl border border-border px-4 open:bg-surface/40">
      <summary className="flex cursor-pointer list-none items-center gap-2 py-3.5 text-[0.9375rem] font-medium text-foreground [&::-webkit-details-marker]:hidden">
        <ChevronRight
          aria-hidden="true"
          className="size-4 shrink-0 text-muted-foreground transition-transform group-open:rotate-90"
        />
        {title}
      </summary>
      <div className="docs-prose pb-4 pl-6 text-[0.9375rem]">{children}</div>
    </details>
  );
}
