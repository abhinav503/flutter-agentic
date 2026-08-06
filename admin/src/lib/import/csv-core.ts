import Papa from "papaparse";

/**
 * The pieces every catalog CSV importer shares — parsing, coercion, and the
 * plan/error shapes the dialog renders.
 *
 * Each entity (products, categories, banners, coupons) owns a module beside
 * this one declaring its columns and validating its own rows. Everything that
 * would otherwise be re-typed per entity — header normalisation, RFC-4180
 * quoting, "is this a number a spreadsheet formatted as money", line
 * numbering — lives here so the four can't disagree about it.
 *
 * All of it is pure: no Firestore, no React. That is what lets the whole plan
 * be shown to the owner before anything is written, and what lets
 * `verify:import-csv` exercise every entity without a project.
 */

export type ImportColumn = {
  key: string;
  required: boolean;
  description: string;
};

export type ImportRowError = {
  /** 1-based line in the uploaded file, header included — what their editor shows. */
  line: number;
  /** The row's identifying value, blank when it has none yet. */
  name: string;
  message: string;
};

export type PlannedWrite<T> = {
  line: number;
  kind: "create" | "update";
  /** Set for updates; creates get their id at write time. */
  id?: string;
  name: string;
  data: T;
};

export type ImportPlan<T> = {
  writes: PlannedWrite<T>[];
  errors: ImportRowError[];
  /** Data rows read, whether they planned or failed. */
  rowCount: number;
};

// Excel writes "TRUE", a hand-typed sheet writes "yes", an exported one
// writes "1". All three mean the same thing to the person filling it in.
const TRUTHY = new Set(["true", "yes", "y", "1"]);
const FALSY = new Set(["false", "no", "n", "0"]);

function normalizeKey(header: string): string {
  return header.trim().toLowerCase().replace(/\s+/g, "_");
}

/** Case- and whitespace-insensitive, so "Fresh Fruits " matches "fresh fruits". */
export function matchKey(value: string): string {
  return value.trim().toLowerCase();
}

/** RFC-4180 quoting — descriptions carry commas, and some carry quotes. */
export function csvCell(value: string): string {
  return /[",\r\n]/.test(value) ? `"${value.replace(/"/g, '""')}"` : value;
}

export function toCsv(columns: ImportColumn[], rows: string[][]): string {
  const header = columns.map((c) => c.key).join(",");
  const body = rows.map((row) => row.map(csvCell).join(","));
  return [header, ...body].join("\n") + "\n";
}

export function parseNumber(raw: string): number | null {
  const trimmed = raw.trim();
  if (!trimmed) return null;
  // Strip thousands separators and any currency glyph a spreadsheet added
  // when the column was formatted as money — "₹1,299.00" is a number the
  // owner believes they typed.
  const cleaned = trimmed.replace(/[^0-9.\-]/g, "");
  if (!cleaned || !/^-?\d*\.?\d+$/.test(cleaned)) return null;
  const value = Number(cleaned);
  return Number.isFinite(value) ? value : null;
}

/** null = not a recognised boolean. Blank counts as `false`, not an error. */
export function parseBoolean(raw: string): boolean | null {
  const value = raw.trim().toLowerCase();
  if (!value || FALSY.has(value)) return false;
  if (TRUTHY.has(value)) return true;
  return null;
}

/**
 * ISO-8601 date or datetime, as the coupon forms store them. Returns the
 * original string on success (the field is stored as typed), null on garbage,
 * and "" for blank — which every date column treats as "no bound".
 */
export function parseIsoDate(raw: string): string | null {
  const value = raw.trim();
  if (!value) return "";
  return Number.isNaN(Date.parse(value)) ? null : value;
}

export type ParsedCsv = {
  rows: Record<string, string>[];
  /** Set when required columns are missing — the caller returns immediately. */
  headerError?: ImportRowError;
};

export function readCsv(csvText: string, columns: ImportColumn[]): ParsedCsv {
  // Deliberately NOT skipEmptyLines: dropping blank rows here would shift
  // every subsequent row's index, and the line numbers in our errors are
  // derived from that index — a sheet with one blank row in the middle would
  // send the owner to the wrong line for every error after it. Blank rows are
  // skipped in eachRow instead, where the index has already been counted.
  const parsed = Papa.parse<Record<string, string>>(csvText, {
    header: true,
    skipEmptyLines: false,
    transformHeader: normalizeKey,
  });

  const headers = (parsed.meta.fields ?? []).map(normalizeKey);
  const missing = columns
    .filter((c) => c.required && !headers.includes(c.key))
    .map((c) => c.key);

  if (missing.length > 0) {
    return {
      rows: parsed.data,
      headerError: {
        line: 1,
        name: "",
        message: `Missing required column${missing.length > 1 ? "s" : ""}: ${missing.join(", ")}. Download the sample file for the expected header.`,
      },
    };
  }

  return { rows: parsed.data };
}

/**
 * The per-row bookkeeping every entity repeats: line numbers, a `get` that
 * trims, an error collector, and duplicate detection across the file.
 *
 * Two rows claiming the same record would have the second silently win, and
 * on a create they would become two records with one name — caught here so
 * the owner fixes the sheet instead of finding the duplicate later.
 */
export function eachRow<T>(
  rows: Record<string, string>[],
  errors: ImportRowError[],
  handle: (ctx: {
    line: number;
    get: (key: string) => string;
    fail: (message: string) => void;
    /** The value this row is identified by, for duplicate detection and errors. */
    identify: (name: string, dedupeKey?: string) => boolean;
  }) => PlannedWrite<T> | undefined,
): PlannedWrite<T>[] {
  const writes: PlannedWrite<T>[] = [];
  const seen = new Map<string, number>();

  rows.forEach((row, index) => {
    const line = index + 2; // header is line 1
    const get = (key: string) => (row[key] ?? "").trim();

    // A row with nothing in any column is a spreadsheet artefact — a spacer,
    // or the trailing newline every editor adds — not something the owner
    // meant to import and not something to complain about. Skipped here
    // rather than by the parser so `line` above stays true to the file.
    if (Object.values(row).every((value) => !String(value ?? "").trim())) return;
    let name = "";
    const fail = (message: string) => errors.push({ line, name, message });

    const identify = (value: string, dedupeKey?: string) => {
      name = value;
      const key = matchKey(dedupeKey ?? value);
      const firstSeen = seen.get(key);
      if (firstSeen !== undefined) {
        fail(`Duplicate of line ${firstSeen} — the same record appears twice.`);
        return false;
      }
      seen.set(key, line);
      return true;
    };

    const write = handle({ line, get, fail, identify });
    if (write) writes.push(write);
  });

  return writes;
}
