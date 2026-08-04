"use client";

import { useState } from "react";
import { ArrowDownIcon, ArrowUpIcon, ChevronsUpDownIcon } from "lucide-react";
import { TableHead } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import type { SortDirection, SortState } from "@/lib/sort";

/**
 * Column-header sorting for the dashboard's list tables.
 *
 * One `useTableSort` per page plus a `SortableTableHead` per sortable column;
 * the page applies the resulting state with `applySort` (lib/sort.ts). Kept
 * here rather than in lib/sort.ts because the hook holds React state — the
 * lib file stays pure array helpers.
 */
export function useTableSort<K extends string>(
  defaultKey: K,
  defaultDirection: SortDirection = "asc",
) {
  const [sort, setSort] = useState<SortState<K>>({
    key: defaultKey,
    direction: defaultDirection,
  });

  // Clicking a new column starts it at its natural direction (firstDirection —
  // "desc" for dates/counts where "most" is the interesting end); clicking the
  // active column flips it.
  const toggle = (key: K, firstDirection: SortDirection = "asc") => {
    setSort((current) =>
      current.key === key
        ? { key, direction: current.direction === "asc" ? "desc" : "asc" }
        : { key, direction: firstDirection },
    );
  };

  return { sort, toggle };
}

export function SortableTableHead<K extends string>({
  columnKey,
  sort,
  onToggle,
  firstDirection = "asc",
  className,
  children,
}: {
  columnKey: K;
  sort: SortState<K>;
  onToggle: (key: K, firstDirection?: SortDirection) => void;
  /** Direction a first click on this column starts at. */
  firstDirection?: SortDirection;
  className?: string;
  children: React.ReactNode;
}) {
  const isActive = sort.key === columnKey;
  const Icon = !isActive
    ? ChevronsUpDownIcon
    : sort.direction === "asc"
      ? ArrowUpIcon
      : ArrowDownIcon;
  return (
    <TableHead
      className={className}
      aria-sort={
        isActive
          ? sort.direction === "asc"
            ? "ascending"
            : "descending"
          : "none"
      }
    >
      {/* -ml-2.5 cancels the button's padding so the label stays optically
          aligned with plain TableHeads (px-2 on the th). */}
      <Button
        type="button"
        variant="ghost"
        size="sm"
        onClick={() => onToggle(columnKey, firstDirection)}
        className="-ml-2.5 gap-1 font-medium"
      >
        {children}
        <Icon
          aria-hidden="true"
          className={
            isActive ? "size-3.5" : "size-3.5 text-muted-foreground/60"
          }
        />
      </Button>
    </TableHead>
  );
}
