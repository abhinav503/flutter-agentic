/**
 * Matching for the dashboard's list filters.
 *
 * Every whitespace-separated term must appear somewhere in the row's searchable
 * fields — so "amul milk" finds the Amul milk even though the brand and the
 * name are different columns, which a plain substring test on the joined
 * string would miss the moment the words are in the other order.
 */
export function matchesSearch(
  query: string,
  ...fields: (string | number | null | undefined)[]
): boolean {
  const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
  if (terms.length === 0) return true;

  const haystack = fields
    .filter((field) => field !== null && field !== undefined && field !== "")
    .join(" ")
    .toLowerCase();

  return terms.every((term) => haystack.includes(term));
}
