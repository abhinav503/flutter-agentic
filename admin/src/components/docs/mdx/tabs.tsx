"use client";

import { Children, useId, useState, type ReactNode } from "react";
import { cn } from "@/lib/utils";

/**
 * Alternative paths through the same step — Android vs iOS, Razorpay vs
 * Stripe. One is always shown, so nothing a reader needs is hidden behind a
 * tab they might not open; the tabs only pick *which* one.
 */
export function Tabs({
  labels,
  children,
}: {
  labels: string[];
  children: ReactNode[];
}) {
  const [active, setActive] = useState(0);
  const id = useId();

  // MDX can leave whitespace text nodes between sibling panels, which would
  // shift every panel out of step with its label.
  const panels = Children.toArray(children).filter(
    (child) => typeof child !== "string" || child.trim() !== "",
  );

  return (
    <div className="not-prose overflow-hidden rounded-2xl border border-border">
      <div role="tablist" className="flex gap-1 border-b border-border bg-surface/60 p-1.5">
        {labels.map((label, index) => (
          <button
            key={label}
            role="tab"
            id={`${id}-tab-${index}`}
            aria-selected={active === index}
            aria-controls={`${id}-panel-${index}`}
            type="button"
            onClick={() => setActive(index)}
            className={cn(
              "rounded-lg px-3 py-1.5 text-[0.8125rem] font-medium transition-colors",
              active === index
                ? "bg-secondary text-foreground"
                : "text-muted-foreground hover:text-foreground",
            )}
          >
            {label}
          </button>
        ))}
      </div>
      <div
        role="tabpanel"
        id={`${id}-panel-${active}`}
        aria-labelledby={`${id}-tab-${active}`}
        className="docs-prose p-4 text-[0.9375rem]"
      >
        {panels[active]}
      </div>
    </div>
  );
}
