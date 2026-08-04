/**
 * Ordering for the dashboard's list tables — the counterpart to search.ts.
 *
 * Sorting is client-side over the already-streamed list (every page holds its
 * whole collection from a Firestore `watch*` subscription), so these are plain
 * array helpers — no query round-trip, no composite indexes.
 */

export type SortDirection = "asc" | "desc";

export type SortState<K extends string> = {
  key: K;
  direction: SortDirection;
};

export type Comparator<T> = (a: T, b: T) => number;

// numeric: "Maggi 2-Minute" sorts before "Maggi 12-Pack" by number, not
// digit-by-digit; base sensitivity: case and accents don't split groups.
const collator = new Intl.Collator(undefined, {
  numeric: true,
  sensitivity: "base",
});

export function compareText(a: string, b: string): number {
  return collator.compare(a, b);
}

export function compareNumbers(a: number, b: number): number {
  return a - b;
}

// For ISO-string date fields where "" means "unbounded" (a coupon with no
// expiry): empty sorts as latest-possible, so ascending reads
// soonest-expiring first with the never-expiring at the end.
export function compareIsoDates(a: string, b: string): number {
  if (a === b) return 0;
  if (a === "") return 1;
  if (b === "") return -1;
  return a < b ? -1 : 1;
}

// Copies before sorting (the rows array is React state). desc flips the
// comparator's arguments rather than negating its result, so a comparator's
// internal tiebreakers flip along with the primary key.
export function applySort<T, K extends string>(
  rows: T[],
  sort: SortState<K>,
  comparators: Record<K, Comparator<T>>,
): T[] {
  const cmp = comparators[sort.key];
  return [...rows].sort((a, b) =>
    sort.direction === "asc" ? cmp(a, b) : cmp(b, a),
  );
}
