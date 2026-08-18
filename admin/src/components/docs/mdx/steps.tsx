import type { ReactNode } from "react";

/**
 * A numbered procedure. The rail is drawn once on the list rather than per
 * step, so the line is continuous through the gaps between them; each step's
 * disc then sits on top of it.
 *
 * Numbering comes from CSS counters, not a prop — a step inserted in the
 * middle of a guide should not require renumbering the ones below it.
 */
export function Steps({ children }: { children: ReactNode }) {
  return (
    <div className="not-prose relative [counter-reset:step] before:absolute before:bottom-4 before:left-[0.9375rem] before:top-4 before:w-px before:bg-border">
      <div className="flex flex-col gap-7">{children}</div>
    </div>
  );
}

export function Step({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div className="relative flex gap-4 [counter-increment:step]">
      <span
        aria-hidden="true"
        className="relative z-10 grid size-8 shrink-0 place-items-center rounded-full border border-border bg-surface text-[0.8125rem] font-semibold text-foreground shadow-soft before:content-[counter(step)]"
      />
      <div className="min-w-0 flex-1 pt-1">
        <h4 className="mb-1.5 text-base font-semibold text-foreground">{title}</h4>
        <div className="docs-prose text-[0.9375rem]">{children}</div>
      </div>
    </div>
  );
}
