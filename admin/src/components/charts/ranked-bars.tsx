"use client";

export type RankedItem = {
  key: string;
  label: string;
  value: number;
  /** Optional second line under the label — a subtotal, a category. */
  detail?: string;
};

/**
 * A ranked horizontal bar list — "top N by <measure>".
 *
 * Every bar is the same colour on purpose. These are nominal categories
 * (product names), so shading them by value would re-encode the bar length
 * that already shows it and spend the identity channel on nothing. The value
 * is direct-labelled at each bar's end, so the list reads without hovering.
 */
export function RankedBars({
  items,
  formatValue = (value) => String(value),
}: {
  items: RankedItem[];
  formatValue?: (value: number) => string;
}) {
  const max = Math.max(...items.map((item) => item.value), 1);

  return (
    <ul className="flex flex-col gap-3">
      {items.map((item) => (
        <li key={item.key} className="flex flex-col gap-1.5">
          <div className="flex items-baseline justify-between gap-3 text-sm">
            <span className="truncate">{item.label}</span>
            <span className="shrink-0 tabular-nums text-muted-foreground">
              {formatValue(item.value)}
            </span>
          </div>
          <div className="h-1.5 rounded-full bg-muted">
            <div
              className="h-full rounded-full bg-chart-1"
              style={{ width: `${(item.value / max) * 100}%` }}
            />
          </div>
          {item.detail && (
            <span className="text-xs text-muted-foreground">{item.detail}</span>
          )}
        </li>
      ))}
    </ul>
  );
}
