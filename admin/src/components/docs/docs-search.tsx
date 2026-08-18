"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { FileText, Search } from "lucide-react";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogTitle,
} from "@/components/ui/dialog";
import { cn } from "@/lib/utils";

export type SearchEntry = {
  title: string;
  description: string;
  href: string;
  categoryName: string;
  /** Heading text, joined — so a search matches a section, not just a title. */
  headings: string;
};

/**
 * ⌘K search over the whole collection.
 *
 * The index is every article's title, description and headings — a few
 * kilobytes, built on the server and passed down whole. That is small enough
 * that filtering it is a substring scan on each keystroke, with no search
 * library, no network round trip and no stale index to rebuild.
 */
export function DocsSearch({ entries }: { entries: SearchEntry[] }) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [cursor, setCursor] = useState(0);
  const router = useRouter();

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if ((event.metaKey || event.ctrlKey) && event.key === "k") {
        event.preventDefault();
        setOpen((v) => !v);
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return entries.slice(0, 8);

    // Title matches first: someone typing "razorpay" wants the Razorpay guide,
    // not the four articles that mention it in passing.
    const scored = entries
      .map((entry) => {
        const title = entry.title.toLowerCase();
        const haystack =
          `${title} ${entry.description} ${entry.headings} ${entry.categoryName}`.toLowerCase();
        if (title.includes(q)) return { entry, score: 0 };
        if (haystack.includes(q)) return { entry, score: 1 };
        return null;
      })
      .filter((r): r is { entry: SearchEntry; score: number } => r !== null)
      .sort((a, b) => a.score - b.score);

    return scored.slice(0, 8).map((r) => r.entry);
  }, [entries, query]);

  const go = (href: string) => {
    setOpen(false);
    setQuery("");
    router.push(href);
  };

  const onKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      setCursor((c) => Math.min(c + 1, results.length - 1));
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      setCursor((c) => Math.max(c - 1, 0));
    } else if (event.key === "Enter" && results[cursor]) {
      event.preventDefault();
      go(results[cursor].href);
    }
  };

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="flex w-full items-center gap-3 rounded-xl border border-border bg-transparent px-3.5 py-2.5 text-left text-sm text-muted-foreground backdrop-blur-sm transition-colors hover:border-border-strong hover:text-foreground"
      >
        <Search aria-hidden="true" className="size-4" />
        <span className="flex-1">Search the docs</span>
        <kbd className="hidden rounded border border-border px-1.5 py-0.5 font-mono text-[0.6875rem] sm:inline">
          ⌘K
        </kbd>
      </button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent
          showCloseButton={false}
          className="top-[12%] max-w-lg translate-y-0 gap-0 p-0 sm:max-w-lg"
        >
          <DialogTitle className="sr-only">Search the documentation</DialogTitle>
          <DialogDescription className="sr-only">
            Type to filter guides by title, section or description.
          </DialogDescription>

          <div className="flex items-center gap-3 border-b border-border px-4 py-3">
            <Search aria-hidden="true" className="size-4 shrink-0 text-muted-foreground" />
            <input
              autoFocus
              value={query}
              onChange={(e) => {
                setQuery(e.target.value);
                // Reset with the query, not in an effect keyed to it: the
                // highlight must land on the new first result in the same
                // render, or Enter fires on whatever was under the old index.
                setCursor(0);
              }}
              onKeyDown={onKeyDown}
              placeholder="Search the docs…"
              className="w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
            />
          </div>

          {results.length === 0 ? (
            <p className="px-4 py-8 text-center text-sm text-muted-foreground">
              Nothing matches “{query}”.
            </p>
          ) : (
            <ul className="max-h-[60vh] overflow-y-auto p-2">
              {results.map((entry, index) => (
                <li key={entry.href}>
                  <button
                    type="button"
                    onClick={() => go(entry.href)}
                    onMouseEnter={() => setCursor(index)}
                    className={cn(
                      "flex w-full items-start gap-3 rounded-lg px-3 py-2.5 text-left transition-colors",
                      cursor === index && "bg-secondary",
                    )}
                  >
                    <FileText
                      aria-hidden="true"
                      className="mt-0.5 size-4 shrink-0 text-muted-foreground"
                    />
                    <span className="min-w-0 flex-1">
                      <span className="block truncate text-sm font-medium text-foreground">
                        {entry.title}
                      </span>
                      <span className="block truncate text-xs text-muted-foreground">
                        {entry.categoryName} · {entry.description}
                      </span>
                    </span>
                  </button>
                </li>
              ))}
            </ul>
          )}
        </DialogContent>
      </Dialog>
    </>
  );
}
