"use client";

import { share } from "@/lib/analytics";

export type ShareSegment = {
  key: string;
  label: string;
  value: number;
  /** A CSS colour — pass a theme token, e.g. `var(--chart-1)`. */
  color: string;
};

/**
 * Part-to-whole as one horizontal stacked bar plus a legend carrying the
 * exact counts.
 *
 * The legend is not decoration: it is this chart's table view. Every value is
 * written out beside its swatch, so nothing is reachable only by decoding a
 * colour or by hovering.
 */
export function ShareBar({ segments }: { segments: ShareSegment[] }) {
  const total = segments.reduce((sum, segment) => sum + segment.value, 0);
  const present = segments.filter((segment) => segment.value > 0);

  return (
    <div className="flex flex-col gap-4">
      <div className="flex h-2.5 gap-0.5 overflow-hidden rounded-full">
        {present.length === 0 ? (
          <div className="flex-1 bg-muted" />
        ) : (
          present.map((segment) => (
            <div
              key={segment.key}
              // A share under ~1% would round to a sub-pixel sliver and read as
              // absent while the legend counts it, so keep a visible floor.
              className="min-w-1 first:rounded-l-full last:rounded-r-full"
              style={{
                width: `${share(segment.value, total)}%`,
                backgroundColor: segment.color,
              }}
            />
          ))
        )}
      </div>

      <ul className="flex flex-col gap-2">
        {segments.map((segment) => (
          <li
            key={segment.key}
            className="flex items-center gap-2 text-sm leading-none"
          >
            <span
              aria-hidden="true"
              className="size-2 shrink-0 rounded-full"
              style={{ backgroundColor: segment.color }}
            />
            <span className="flex-1 text-muted-foreground">{segment.label}</span>
            <span className="tabular-nums">{segment.value}</span>
            <span className="w-10 text-right tabular-nums text-muted-foreground">
              {Math.round(share(segment.value, total))}%
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
}
