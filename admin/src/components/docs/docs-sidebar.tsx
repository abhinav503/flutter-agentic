"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { cn } from "@/lib/utils";
import type { Doc, DocCategory } from "@/lib/docs";
import { DocIcon } from "./icon";

export type DocsNavGroup = { category: DocCategory; docs: Doc[] };

/**
 * The left rail: every category, every article, always expanded.
 *
 * Nothing collapses. The whole tree is about thirty links — small enough to
 * scan, and a collapsed section is a section a reader never learns exists.
 * That is also why this is a client component: it needs the current path to
 * mark the active row, and nothing else.
 */
export function DocsSidebar({
  groups,
  onNavigate,
}: {
  groups: DocsNavGroup[];
  onNavigate?: () => void;
}) {
  const pathname = usePathname();

  return (
    <nav aria-label="Documentation" className="flex flex-col gap-7 pb-16">
      {groups.map(({ category, docs }) => (
        <div key={category.slug}>
          <Link
            href={`/docs/${category.slug}`}
            onClick={onNavigate}
            className="mb-2 flex items-center gap-2 px-3 text-[0.8125rem] font-semibold text-foreground"
          >
            <DocIcon name={category.icon} className="size-4 text-primary" />
            {category.name}
          </Link>

          {/* The hairline runs the height of the group so the articles read as
              hanging off their category rather than as a flat list. */}
          <ul className="ml-[1.4rem] border-l border-border pl-2">
            {docs.map((doc) => {
              const active = pathname === doc.href;
              return (
                <li key={doc.href}>
                  <Link
                    href={doc.href}
                    onClick={onNavigate}
                    aria-current={active ? "page" : undefined}
                    className={cn(
                      "-ml-[calc(0.5rem+1px)] block border-l border-transparent py-1.5 pl-[calc(0.5rem+1px)] pr-3 text-[0.8125rem] leading-6 transition-colors",
                      active
                        ? "border-l-primary font-medium text-foreground"
                        : "text-muted-foreground hover:text-foreground",
                    )}
                  >
                    {doc.sidebarTitle ?? doc.title}
                  </Link>
                </li>
              );
            })}
          </ul>
        </div>
      ))}
    </nav>
  );
}
