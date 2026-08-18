"use client";

import { useEffect, useState } from "react";

import { cn } from "@/lib/utils";
import type { DocHeading } from "@/lib/docs";

/**
 * The right rail. Highlights the section currently being read.
 *
 * Scroll-spy is an IntersectionObserver with a top-heavy root margin rather
 * than a scroll handler comparing offsets: it fires only when a heading
 * actually crosses the band, so it costs nothing while the page is still. The
 * band is the top ~30% of the viewport, which makes the active entry the
 * heading you have most recently scrolled past — not the one nearest the
 * middle, which flickers between two on a short section.
 */
export function TableOfContents({ headings }: { headings: DocHeading[] }) {
  const [activeId, setActiveId] = useState<string>();

  useEffect(() => {
    if (headings.length === 0) return;

    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting);
        if (visible.length > 0) setActiveId(visible[0].target.id);
      },
      { rootMargin: "-88px 0px -70% 0px", threshold: 0 },
    );

    for (const { id } of headings) {
      const el = document.getElementById(id);
      if (el) observer.observe(el);
    }

    return () => observer.disconnect();
  }, [headings]);

  if (headings.length < 2) return null;

  return (
    <nav aria-label="On this page" className="text-[0.8125rem]">
      <p className="mb-3 font-semibold text-foreground">On this page</p>
      <ul className="border-l border-border">
        {headings.map((heading) => (
          <li key={heading.id}>
            <a
              href={`#${heading.id}`}
              className={cn(
                "-ml-px block border-l border-transparent py-1.5 leading-5 transition-colors",
                heading.level === 3 ? "pl-6" : "pl-3",
                activeId === heading.id
                  ? "border-l-primary font-medium text-foreground"
                  : "text-muted-foreground hover:text-foreground",
              )}
            >
              {heading.text}
            </a>
          </li>
        ))}
      </ul>
    </nav>
  );
}
