"use client";

import type { ReactNode } from "react";
import { Card, CardContent } from "@/components/ui/card";

/**
 * One headline number: label, value, and an optional supporting line.
 *
 * The value uses the font's default proportional figures — `tabular-nums`
 * gives every digit the width of a `0`, which makes a number like 121 look
 * loose at this size. Tabular figures are for columns that align vertically,
 * not for a standalone figure.
 */
export function StatTile({
  label,
  value,
  detail,
  loading = false,
}: {
  label: string;
  value: string;
  detail?: ReactNode;
  loading?: boolean;
}) {
  return (
    <Card>
      <CardContent className="flex flex-col gap-1">
        <span className="text-xs font-medium tracking-wide text-muted-foreground">
          {label}
        </span>
        {loading ? (
          <span className="my-1 h-6 w-16 animate-pulse rounded bg-muted" />
        ) : (
          <span className="text-2xl font-extrabold tracking-tight text-ink">
            {value}
          </span>
        )}
        <span className="min-h-4 text-xs text-muted-foreground">
          {loading ? "" : detail}
        </span>
      </CardContent>
    </Card>
  );
}
