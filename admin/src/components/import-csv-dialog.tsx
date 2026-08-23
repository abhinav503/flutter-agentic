"use client";

import { useRef, useState } from "react";
import { Download, FileUp } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type { ImportColumn } from "@/lib/import/csv-core";
import {
  importCsv,
  type CatalogEntity,
  type ImportFormat,
  type ImportReport,
} from "@/lib/catalog-api";

// Enough to see the shape of what's wrong without turning the dialog into a
// log viewer; the count above it says how many more there are.
const ERRORS_SHOWN = 8;

const FORMAT_LABELS: Record<ImportFormat, string> = {
  cordelia: "Cordelia CSV (the sample below)",
  shopify: "Shopify products export",
  woocommerce: "WooCommerce products export",
  meta: "WhatsApp / Meta catalog feed",
};

/**
 * What one entity needs to be importable. The page owns the sample (it is
 * the only place that already holds the store's live data); the server
 * owns the rules.
 */
export type ImportSpec = {
  entity: CatalogEntity;
  /** Plural, lower-case: "products", "coupons". */
  entityPlural: string;
  entitySingular: string;
  /** What the match key is, for the dialog's one-line explanation. */
  matchOn: string;
  columns: ImportColumn[];
  sampleCsv: () => string;
  /** Named in the download button and filename — the seed market. */
  sampleLabel: string;
  sampleSlug: string;
  /** Products only: the file may be a platform export instead of ours. */
  formats?: ImportFormat[];
};

/**
 * Bulk import from a CSV, shared by every catalog entity.
 *
 * Two-step by design: the file goes to the server as a dry run first and
 * the owner confirms the plan it returns ("12 new, 3 updated, 2 rows can't
 * be imported") rather than uploading into the dark. A row that fails is
 * skipped and named; the rest still import. The same route, plan and rules
 * serve the CLI and any script, so what this dialog accepts is exactly what
 * the API accepts.
 */
export function ImportCsvDialog({
  storeId,
  spec,
  onClose,
}: {
  storeId: string;
  spec: ImportSpec;
  onClose: () => void;
}) {
  const formats = spec.formats ?? ["cordelia"];
  const [format, setFormat] = useState<ImportFormat>(formats[0]);
  const [fileName, setFileName] = useState<string | null>(null);
  const [csv, setCsv] = useState<string | null>(null);
  const [plan, setPlan] = useState<ImportReport | null>(null);
  const [planning, setPlanning] = useState(false);
  const [importing, setImporting] = useState(false);
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

  async function dryRun(text: string, fmt: ImportFormat) {
    setPlanning(true);
    setPlan(null);
    try {
      setPlan(await importCsv(storeId, { csv: text, entity: spec.entity, format: fmt, commit: false }));
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not read the file");
    } finally {
      setPlanning(false);
    }
  }

  async function handleFile(file: File) {
    const text = await file.text();
    setFileName(file.name);
    setCsv(text);
    await dryRun(text, format);
  }

  async function handleFormat(next: ImportFormat) {
    setFormat(next);
    if (csv) await dryRun(csv, next);
  }

  async function handleImport() {
    if (!csv || !plan) return;
    setImporting(true);
    try {
      const report = await importCsv(storeId, {
        csv,
        entity: spec.entity,
        format,
        commit: true,
      });
      const written = report.created + report.updated;
      toast.success(
        `Imported ${written} ${written === 1 ? spec.entitySingular : spec.entityPlural} — ${report.created} new, ${report.updated} updated${report.failed ? `, ${report.failed} skipped` : ""}.`,
      );
      onClose();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Import failed. Please try again.");
    } finally {
      setImporting(false);
    }
  }

  const writable = plan ? plan.created + plan.updated : 0;
  const errorRows = plan?.results.filter((r) => r.action === "error") ?? [];
  const busy = planning || importing;

  return (
    <Dialog open onOpenChange={(open) => !open && !busy && onClose()}>
      <DialogContent className="sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>Import {spec.entityPlural} from CSV</DialogTitle>
          <DialogDescription>
            Matches on the <code>id</code> column when present, then{" "}
            <code>external_id</code>, otherwise on {spec.matchOn} — so
            re-importing an edited file updates rather than duplicating.
          </DialogDescription>
        </DialogHeader>

        <div className="flex flex-col gap-4">
          {formats.length > 1 && (
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="import-format">File format</Label>
              <Select value={format} onValueChange={(v) => handleFormat(v as ImportFormat)}>
                <SelectTrigger id="import-format" className="w-full sm:w-80">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {formats.map((f) => (
                    <SelectItem key={f} value={f}>
                      {FORMAT_LABELS[f]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {format === "shopify" && (
                <p className="text-xs text-muted-foreground">
                  Shopify Admin → Products → Export. Vendors become brands and
                  each product&apos;s Type its category (created if missing);
                  variants, galleries and stock come across. Draft and archived
                  products are skipped.
                </p>
              )}
              {format === "meta" && (
                <p className="text-xs text-muted-foreground">
                  The CSV feed behind a WhatsApp Business or Facebook/Instagram
                  shop catalog (Commerce Manager → Catalog → Data sources).
                  Items sharing an item_group_id become one product with
                  size/colour variants; product_type paths become categories.
                  Archived and discontinued items are skipped.
                </p>
              )}
              {format === "woocommerce" && (
                <p className="text-xs text-muted-foreground">
                  WooCommerce → Products → Export (all columns). Category
                  paths become a category tree, variable products their
                  variations, sale prices the selling price. Drafts, grouped,
                  external and virtual products are skipped.
                </p>
              )}
            </div>
          )}

          <div className="flex flex-wrap items-center gap-2">
            {format === "cordelia" && (
              <Button type="button" variant="outline" onClick={downloadSample}>
                <Download className="size-4" />
                Download sample ({spec.sampleLabel})
              </Button>
            )}
            <Button
              type="button"
              variant="outline"
              onClick={() => inputRef.current?.click()}
              disabled={busy}
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

          {!plan && !planning && format === "cordelia" && (
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

          {planning && (
            <p className="text-sm text-muted-foreground">Checking the file…</p>
          )}

          {plan && (
            <div className="flex flex-col gap-3">
              <div className="flex flex-wrap gap-4 rounded-lg border border-border p-4 text-sm">
                <span>
                  <strong className="text-lg">{plan.created}</strong> to create
                </span>
                <span>
                  <strong className="text-lg">{plan.updated}</strong> to update
                </span>
                <span className={plan.failed > 0 ? "text-destructive" : ""}>
                  <strong className="text-lg">{plan.failed}</strong> cannot be imported
                </span>
                {plan.skipped.length > 0 && (
                  <span className="text-muted-foreground">
                    <strong className="text-lg">{plan.skipped.length}</strong> skipped
                  </span>
                )}
              </div>

              {(plan.created_categories.length > 0 || plan.created_brands.length > 0) && (
                <p className="text-sm text-muted-foreground">
                  Will also create
                  {plan.created_categories.length > 0 && (
                    <> {plan.created_categories.length} categor{plan.created_categories.length === 1 ? "y" : "ies"} ({plan.created_categories.join(", ")})</>
                  )}
                  {plan.created_categories.length > 0 && plan.created_brands.length > 0 && " and"}
                  {plan.created_brands.length > 0 && (
                    <> {plan.created_brands.length} brand{plan.created_brands.length === 1 ? "" : "s"} ({plan.created_brands.join(", ")})</>
                  )}
                  .
                </p>
              )}

              {plan.notes.length > 0 && (
                <ul className="list-disc pl-5 text-xs text-muted-foreground">
                  {plan.notes.map((n) => (
                    <li key={n}>{n}</li>
                  ))}
                </ul>
              )}

              {!plan.atomic && (
                <p className="text-sm text-muted-foreground">
                  Over 500 rows, so this is written in several batches — if it
                  fails part-way, the earlier batches stay imported.
                </p>
              )}

              {(errorRows.length > 0 || plan.skipped.length > 0) && (
                <div className="rounded-lg border border-destructive/40 bg-destructive/5 p-4">
                  <p className="mb-2 text-sm font-medium text-destructive">
                    These rows will be skipped
                  </p>
                  <ul className="flex flex-col gap-1 text-xs">
                    {plan.skipped.slice(0, ERRORS_SHOWN).map((s) => (
                      <li key={`s-${s.line}`}>
                        <span className="font-semibold">Line {s.line}</span> — {s.reason}
                      </li>
                    ))}
                    {errorRows.slice(0, Math.max(0, ERRORS_SHOWN - plan.skipped.length)).map((r) => (
                      <li key={`e-${r.index}`}>
                        <span className="font-semibold">
                          {format === "cordelia" ? `Row ${r.index + 1}` : `Product ${r.index + 1}`}
                        </span>{" "}
                        — {r.action === "error" ? r.errors.join(" ") : ""}
                      </li>
                    ))}
                  </ul>
                  {errorRows.length + plan.skipped.length > ERRORS_SHOWN && (
                    <p className="mt-2 text-xs text-muted-foreground">
                      …and {errorRows.length + plan.skipped.length - ERRORS_SHOWN} more.
                    </p>
                  )}
                </div>
              )}

              {plan.rows_read === 0 && (
                <p className="text-sm text-muted-foreground">No rows found in this file.</p>
              )}
            </div>
          )}
        </div>

        <DialogFooter>
          <Button variant="ghost" onClick={onClose} disabled={busy}>
            Cancel
          </Button>
          <Button onClick={handleImport} disabled={busy || !plan || writable === 0}>
            {importing
              ? "Importing…"
              : `Import ${writable} ${writable === 1 ? spec.entitySingular : spec.entityPlural}`}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
