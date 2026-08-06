"use client";

import { useRef, useState } from "react";
import { Download, FileUp } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import type { ImportColumn, ImportPlan } from "@/lib/import/csv-core";
import { BATCH_LIMIT, importRows } from "@/lib/import/import-rows";

// Enough to see the shape of what's wrong without turning the dialog into a
// log viewer; the count above it says how many more there are.
const ERRORS_SHOWN = 8;

/**
 * What one entity needs to be importable. The page owns this — it is the only
 * place that already holds the store's live data.
 */
export type ImportSpec<T extends object> = {
  /** Plural, lower-case: "products", "coupons". */
  entityPlural: string;
  entitySingular: string;
  /** Subcollection under stores/{id}. */
  collectionName: string;
  /** What the match key is, for the dialog's one-line explanation. */
  matchOn: string;
  columns: ImportColumn[];
  buildPlan: (csvText: string) => ImportPlan<T>;
  sampleCsv: () => string;
  /** Named in the download button and filename — the seed market. */
  sampleLabel: string;
  sampleSlug: string;
  /** Fields a create seeds that the CSV doesn't carry (e.g. usedCount). */
  createDefaults?: Record<string, unknown>;
};

/**
 * Bulk import from a CSV, shared by every catalog entity.
 *
 * Two-step by design: the file is parsed and fully validated against the
 * store's real contents *before* anything is written, and the owner confirms a
 * plan ("12 new, 3 updated, 2 rows can't be imported") rather than uploading
 * into the dark. A row that fails is skipped and named by line number; the
 * rest still import, because a 400-row sheet with two typos should not be
 * all-or-nothing at the owner's end.
 */
export function ImportCsvDialog<T extends object>({
  storeId,
  spec,
  onClose,
}: {
  storeId: string;
  spec: ImportSpec<T>;
  onClose: () => void;
}) {
  const [fileName, setFileName] = useState<string | null>(null);
  const [plan, setPlan] = useState<ImportPlan<T> | null>(null);
  const [importing, setImporting] = useState(false);
  const [written, setWritten] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);

  function downloadSample() {
    const blob = new Blob([spec.sampleCsv()], { type: "text/csv;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `cordelia-${spec.entityPlural}-sample-${spec.sampleSlug}.csv`;
    link.click();
    URL.revokeObjectURL(url);
  }

  async function handleFile(file: File) {
    setFileName(file.name);
    setPlan(spec.buildPlan(await file.text()));
  }

  async function handleImport() {
    if (!plan || plan.writes.length === 0) return;
    setImporting(true);
    setWritten(0);
    try {
      await importRows(storeId, spec.collectionName, plan.writes, {
        createDefaults: spec.createDefaults,
        onProgress: (p) => setWritten(p.written),
      });
      const created = plan.writes.filter((w) => w.kind === "create").length;
      toast.success(
        `Imported ${plan.writes.length} ${plan.writes.length === 1 ? spec.entitySingular : spec.entityPlural} — ${created} new, ${plan.writes.length - created} updated.`,
      );
      onClose();
    } catch (e) {
      // Named explicitly because a chunked import can stop half-way: the owner
      // needs to know some rows landed before deciding what to do.
      toast.error(
        `Import stopped after ${written} of ${plan.writes.length}. ${e instanceof Error ? e.message : "Please try again."}`,
      );
    } finally {
      setImporting(false);
    }
  }

  const created = plan?.writes.filter((w) => w.kind === "create").length ?? 0;
  const updated = (plan?.writes.length ?? 0) - created;

  return (
    <Dialog open onOpenChange={(open) => !open && !importing && onClose()}>
      <DialogContent className="sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>
            Import {spec.entityPlural} from CSV
          </DialogTitle>
          <DialogDescription>
            Matches on the <code>id</code> column when present, otherwise on{" "}
            {spec.matchOn} — so re-importing an edited file updates rather than
            duplicating.
          </DialogDescription>
        </DialogHeader>

        <div className="flex flex-col gap-4">
          <div className="flex flex-wrap items-center gap-2">
            <Button type="button" variant="outline" onClick={downloadSample}>
              <Download className="size-4" />
              Download sample ({spec.sampleLabel})
            </Button>
            <Button
              type="button"
              variant="outline"
              onClick={() => inputRef.current?.click()}
              disabled={importing}
            >
              <FileUp className="size-4" />
              {fileName ? "Choose a different file" : "Choose CSV file"}
            </Button>
            {fileName && (
              <span className="text-sm text-muted-foreground">{fileName}</span>
            )}
            <input
              ref={inputRef}
              type="file"
              accept=".csv,text/csv"
              className="hidden"
              onChange={(event) => {
                const file = event.target.files?.[0];
                // Cleared so choosing the same file twice still fires change —
                // an owner who fixes their sheet and re-picks it expects a
                // fresh parse.
                event.target.value = "";
                if (file) void handleFile(file);
              }}
            />
          </div>

          {!plan && (
            <div className="rounded-lg border border-border bg-muted/40 p-4">
              <p className="mb-2 text-sm font-medium">Expected columns</p>
              <ul className="grid gap-1 text-xs text-muted-foreground sm:grid-cols-2">
                {spec.columns.map((column) => (
                  <li key={column.key}>
                    <code className="font-semibold text-foreground">
                      {column.key}
                    </code>
                    {column.required ? " (required) — " : " — "}
                    {column.description}
                  </li>
                ))}
              </ul>
            </div>
          )}

          {plan && (
            <div className="flex flex-col gap-3">
              <div className="flex flex-wrap gap-4 rounded-lg border border-border p-4 text-sm">
                <span>
                  <strong className="text-lg">{created}</strong> to create
                </span>
                <span>
                  <strong className="text-lg">{updated}</strong> to update
                </span>
                <span className={plan.errors.length > 0 ? "text-destructive" : ""}>
                  <strong className="text-lg">{plan.errors.length}</strong>{" "}
                  cannot be imported
                </span>
              </div>

              {plan.writes.length > BATCH_LIMIT && (
                <p className="text-sm text-muted-foreground">
                  Over {BATCH_LIMIT} rows, so this is written in several
                  batches — if it fails part-way, the earlier batches stay
                  imported.
                </p>
              )}

              {plan.errors.length > 0 && (
                <div className="rounded-lg border border-destructive/40 bg-destructive/5 p-4">
                  <p className="mb-2 text-sm font-medium text-destructive">
                    These rows will be skipped
                  </p>
                  <ul className="flex flex-col gap-1 text-xs">
                    {plan.errors.slice(0, ERRORS_SHOWN).map((error) => (
                      <li key={`${error.line}-${error.message}`}>
                        <span className="font-semibold">Line {error.line}</span>
                        {error.name ? ` (${error.name})` : ""} — {error.message}
                      </li>
                    ))}
                  </ul>
                  {plan.errors.length > ERRORS_SHOWN && (
                    <p className="mt-2 text-xs text-muted-foreground">
                      …and {plan.errors.length - ERRORS_SHOWN} more.
                    </p>
                  )}
                </div>
              )}

              {plan.writes.length === 0 && plan.errors.length === 0 && (
                <p className="text-sm text-muted-foreground">
                  No rows found in this file.
                </p>
              )}
            </div>
          )}
        </div>

        <DialogFooter>
          <Button variant="ghost" onClick={onClose} disabled={importing}>
            Cancel
          </Button>
          <Button
            onClick={handleImport}
            disabled={importing || !plan || plan.writes.length === 0}
          >
            {importing
              ? `Importing ${written} of ${plan?.writes.length ?? 0}…`
              : `Import ${plan?.writes.length ?? 0} ${plan?.writes.length === 1 ? spec.entitySingular : spec.entityPlural}`}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
