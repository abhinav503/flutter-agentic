/**
 * Derivations behind the dashboard's overview charts.
 *
 * Everything here is pure and works off data the dashboard already streams —
 * there is no analytics collection in Firestore, and none of these numbers is
 * stored anywhere. Orders/products/coupons arrive over their existing
 * `watch*` subscriptions and reviews over the owner-gated REST route, so
 * adding a metric here costs no extra reads.
 */

export type DailyPoint = {
  date: Date;
  value: number;
};

/** Local calendar day, not UTC — a store owner's "today" is their own. */
function localDayKey(date: Date): string {
  return `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`;
}

/** Local midnight, `daysBack` days ago. */
export function startOfDayAgo(daysBack: number, now: Date = new Date()): Date {
  // Built from Y/M/D parts rather than by subtracting milliseconds: a
  // DST boundary makes a "24 hours ago" arithmetic land on 23:00 of the
  // wrong day, and this form can't.
  return new Date(now.getFullYear(), now.getMonth(), now.getDate() - daysBack);
}

/**
 * Counts ISO timestamps into one bucket per day for the last `days` days,
 * oldest first and including today. Days with nothing keep a 0 bucket — the
 * gaps in a trend are as much a part of it as the spikes.
 */
export function dailyCounts(
  timestamps: (string | null | undefined)[],
  days: number,
  now: Date = new Date(),
): DailyPoint[] {
  const counts = new Map<string, number>();
  for (const timestamp of timestamps) {
    if (!timestamp) continue;
    const date = new Date(timestamp);
    // Documents written before a field existed read back as "" or a partial
    // value; an Invalid Date must not become an NaN-keyed bucket.
    if (Number.isNaN(date.getTime())) continue;
    const key = localDayKey(date);
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }

  return Array.from({ length: days }, (_, index) => {
    const date = startOfDayAgo(days - 1 - index, now);
    return { date, value: counts.get(localDayKey(date)) ?? 0 };
  });
}

/** True when `timestamp` falls inside the same window `dailyCounts` covers. */
export function withinLastDays(
  timestamp: string | null | undefined,
  days: number,
  now: Date = new Date(),
): boolean {
  if (!timestamp) return false;
  const date = new Date(timestamp);
  if (Number.isNaN(date.getTime())) return false;
  return date >= startOfDayAgo(days - 1, now);
}

/**
 * The y-axis top: the smallest "round" number at or above the peak.
 *
 * Picked as two intervals of a nice step, so the midpoint gridline is always
 * a whole number — these axes count orders and reviews, and a gridline
 * reading "2.5 orders" is nonsense. Never returns less than 2, so an empty
 * chart still has a scale to draw against instead of dividing by zero.
 */
export function niceMax(peak: number): number {
  if (!Number.isFinite(peak) || peak <= 2) return 2;
  const perInterval = peak / 2;
  const magnitude = 10 ** Math.floor(Math.log10(perInterval));
  // No 2.5 in the ladder: at magnitude 1 it would make the top 5 and the
  // midpoint 2.5, the fractional tick this function exists to avoid.
  for (const step of [1, 2, 4, 5, 6, 8, 10]) {
    const candidate = step * magnitude;
    if (candidate >= perInterval) return candidate * 2;
  }
  return 20 * magnitude;
}

const MONTHS = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
];

/**
 * "12 Aug" — the axis/tooltip date format, deliberately year-less.
 *
 * Formatted from a fixed table rather than `toLocaleDateString`: that reads
 * the *runtime's* default locale, which differs between the Node render and
 * the browser, and the two producing "12 Aug" vs "Aug 12" is a hydration
 * mismatch that blows away the whole tree.
 */
export function shortDate(date: Date): string {
  return `${date.getDate()} ${MONTHS[date.getMonth()]}`;
}

/** ₹1,24,500 → "₹1.2L". Keeps a stat tile's value on one line. */
export function compactCurrency(amount: number): string {
  const abs = Math.abs(amount);
  if (abs >= 10_000_000) return `₹${(amount / 10_000_000).toFixed(1)}Cr`;
  if (abs >= 100_000) return `₹${(amount / 100_000).toFixed(1)}L`;
  if (abs >= 1_000) return `₹${(amount / 1_000).toFixed(1)}K`;
  return `₹${Math.round(amount)}`;
}

/** Whole-number percentage share, guarding the empty-denominator case. */
export function share(value: number, total: number): number {
  return total > 0 ? (value / total) * 100 : 0;
}
