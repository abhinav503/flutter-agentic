"use client";

import { SearchIcon, XIcon } from "lucide-react";
import { Input } from "@/components/ui/input";

/**
 * The dashboard's list filter: one control, same shape on every page, sized
 * to sit beside a page's action button in the title row.
 *
 * Filtering is client-side over the already-streamed list (every page holds
 * its whole collection from a Firestore `watch*` subscription), so this is
 * plain controlled state — no query round-trip, no debounce needed.
 */
export function SearchField({
  value,
  onChange,
  placeholder = "Search…",
  label,
  className = "",
}: {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  /** Accessible name — the field has no visible <label> in the title row. */
  label: string;
  className?: string;
}) {
  return (
    <div className={`relative w-56 shrink-0 sm:w-64 ${className}`}>
      <SearchIcon
        aria-hidden="true"
        className="pointer-events-none absolute top-1/2 left-2.5 size-3.5 -translate-y-1/2 text-muted-foreground"
      />
      <Input
        // Not type="search": Safari and Chrome paint their own clear affordance
        // on it, which would sit beside the themed one below.
        type="text"
        role="searchbox"
        aria-label={label}
        value={value}
        onChange={(event) => onChange(event.target.value)}
        placeholder={placeholder}
        className="pr-8 pl-7.5"
      />
      {value && (
        <button
          type="button"
          onClick={() => onChange("")}
          aria-label="Clear search"
          className="absolute top-1/2 right-1.5 grid size-5 -translate-y-1/2 place-items-center rounded-full text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
        >
          <XIcon aria-hidden="true" className="size-3.5" />
        </button>
      )}
    </div>
  );
}
