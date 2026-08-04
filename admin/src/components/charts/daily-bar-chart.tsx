"use client";

import { niceMax, shortDate, type DailyPoint } from "@/lib/analytics";

/**
 * A single-series daily column chart.
 *
 * One series, so there is no legend — the card's title says what is plotted,
 * and a legend box with one swatch would only restate it. Columns are plain
 * elements rather than SVG: the hit target for hover/focus can then be the
 * full column height (far bigger than the mark itself), and the whole thing
 * reflows with the card instead of being scaled by a viewBox.
 */
export function DailyBarChart({
  points,
  unit,
}: {
  points: DailyPoint[];
  /** Singular noun for the tooltip — "order", "review". */
  unit: string;
}) {
  const peak = Math.max(...points.map((point) => point.value), 0);
  const max = niceMax(peak);
  const midpoint = max / 2;

  return (
    // pt-6 reserves the band the tooltip rises into. Card clips its overflow,
    // so a tooltip without room of its own would be cut off at the top.
    <figure className="flex flex-col gap-1.5 pt-6">
      <div className="flex gap-2">
        <YAxis ticks={[max, midpoint, 0]} />

        <div className="relative h-36 flex-1">
          {/* Solid hairlines, one step off the surface — never dashed. */}
          <div aria-hidden="true" className="absolute inset-0">
            {[0, 50, 100].map((offset) => (
              <div
                key={offset}
                className="absolute inset-x-0 border-t border-border"
                style={{ top: `${offset}%` }}
              />
            ))}
          </div>

          {/* gap-0.5 is the 2px surface gap that separates touching marks. */}
          <div className="absolute inset-0 flex items-end gap-0.5">
            {points.map((point, index) => (
              <Column
                key={point.date.toISOString()}
                point={point}
                max={max}
                unit={unit}
                edge={
                  index < 3
                    ? "start"
                    : index > points.length - 4
                      ? "end"
                      : "middle"
                }
              />
            ))}
          </div>
        </div>
      </div>

      {/* Three dates rather than one per column: 30 labels in this width would
          collide, and the tooltip carries every day's exact date. */}
      <div className="flex gap-2">
        <div className="w-7 shrink-0" />
        <div className="flex flex-1 justify-between text-[0.65rem] text-muted-foreground">
          <span>{shortDate(points[0].date)}</span>
          <span>{shortDate(points[Math.floor(points.length / 2)].date)}</span>
          <span>{shortDate(points[points.length - 1].date)}</span>
        </div>
      </div>
    </figure>
  );
}

function YAxis({ ticks }: { ticks: number[] }) {
  return (
    <div
      aria-hidden="true"
      className="flex h-36 w-7 shrink-0 flex-col justify-between text-right text-[0.65rem] tabular-nums text-muted-foreground"
    >
      {ticks.map((tick) => (
        // -translate-y-1/2 sits each number on its gridline rather than under it.
        <span key={tick} className="-translate-y-1/2 leading-none">
          {tick}
        </span>
      ))}
    </div>
  );
}

function Column({
  point,
  max,
  unit,
  edge,
}: {
  point: DailyPoint;
  max: number;
  unit: string;
  edge: "start" | "middle" | "end";
}) {
  const label = `${shortDate(point.date)}: ${point.value} ${point.value === 1 ? unit : `${unit}s`}`;

  return (
    <div
      // Focusable so the tooltip is reachable by keyboard, not hover-only.
      tabIndex={0}
      role="img"
      aria-label={label}
      className="group relative flex h-full flex-1 items-end justify-center rounded-sm outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
    >
      {/* Capped at 24px so a short series doesn't render slab-like columns. */}
      <div
        className="w-full max-w-6 rounded-t-[4px] bg-chart-1 transition-opacity group-hover:opacity-80"
        style={{ height: `${(point.value / max) * 100}%` }}
      />
      <span
        className={`pointer-events-none absolute bottom-full z-10 mb-1 hidden whitespace-nowrap rounded-md border border-border bg-popover px-2 py-1 text-xs text-popover-foreground shadow-[var(--shadow-soft)] group-hover:block group-focus-visible:block ${
          // Centred tooltips overflow the card at either end of the series.
          edge === "start"
            ? "left-0"
            : edge === "end"
              ? "right-0"
              : "left-1/2 -translate-x-1/2"
        }`}
      >
        {label}
      </span>
    </div>
  );
}
