"use client";

import { useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { GROCERY_SEED } from "@/lib/seed/grocery-seed-data";
import {
  seedGroceryData,
  type SeedPhase,
  type SeedProgress,
} from "@/lib/seed/seed-grocery";

const PHASE_LABELS: Record<SeedPhase, string> = {
  categories: "Preparing categories…",
  brands: "Preparing brands…",
  products: "Preparing products…",
  coupons: "Preparing coupons…",
  banners: "Preparing banners…",
  committing: "Writing to your store…",
};

/**
 * "Generate sample data" — seeds the bundled Indian grocery catalog
 * (lib/seed/grocery-seed-data.ts) into the active store in one atomic batch.
 *
 * Generating into a non-empty store is warned about but not blocked: items
 * are only ever added alongside what exists, and the per-item delete flows
 * are the recovery story.
 */
export function GenerateGroceryDataDialog({
  storeId,
  existingProductCount,
  existingCategoryCount,
  onClose,
}: {
  storeId: string;
  existingProductCount: number;
  existingCategoryCount: number;
  onClose: () => void;
}) {
  const [progress, setProgress] = useState<SeedProgress | null>(null);
  const running = progress !== null;

  const seed = GROCERY_SEED;
  const storeHasData = existingProductCount > 0 || existingCategoryCount > 0;

  async function handleGenerate() {
    setProgress({ phase: "categories", done: 0, total: 1 });
    try {
      const result = await seedGroceryData(storeId, setProgress);
      toast.success(
        `Sample data generated — ${result.total} items created`,
      );
      onClose();
    } catch {
      // The single batch commit is all-or-nothing, so this copy can promise
      // a clean slate.
      toast.error("Could not generate sample data — nothing was written.");
      setProgress(null);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && !running && onClose()}>
      <DialogContent showCloseButton={!running}>
        <DialogHeader>
          <DialogTitle>Generate sample grocery data</DialogTitle>
        </DialogHeader>

        {running ? (
          <div className="flex flex-col gap-3 py-2">
            <p className="text-sm text-muted-foreground">
              {PHASE_LABELS[progress.phase]}
            </p>
            <div
              role="progressbar"
              aria-valuemin={0}
              aria-valuemax={progress.total}
              aria-valuenow={progress.done}
              className="h-2 overflow-hidden rounded-full bg-muted"
            >
              <div
                className="h-full rounded-full bg-primary transition-all"
                style={{
                  width: `${Math.round((progress.done / progress.total) * 100)}%`,
                }}
              />
            </div>
          </div>
        ) : (
          <div className="flex flex-col gap-4">
            <p className="text-sm text-muted-foreground">
              Fills this store with a realistic Indian grocery catalog — real
              brands like Amul, Britannia, Tata and Maggi, ₹ prices, product
              photos, plus ready-made coupons and promo banners:
            </p>
            <p className="text-sm font-medium">
              {seed.categories.length} categories · {seed.brands.length} brands
              · {seed.products.length} products · {seed.coupons.length} coupons
              · {seed.banners.length} banners
            </p>
            {storeHasData && (
              <div className="rounded-lg border border-border-strong bg-muted/60 p-3 text-sm">
                This store already has {existingProductCount} product
                {existingProductCount === 1 ? "" : "s"} and{" "}
                {existingCategoryCount} categor
                {existingCategoryCount === 1 ? "y" : "ies"}. Generated items
                are added alongside them — nothing is deleted or overwritten —
                but generating again creates duplicates, including duplicate
                coupon codes. Delete previously generated coupons first if you
                use coupon codes.
              </div>
            )}
          </div>
        )}

        <DialogFooter className="items-center gap-3 sm:justify-between">
          {/* Product photos are hotlinked from Open Food Facts under
              CC-BY-SA — attribution is part of the licence. */}
          <p className="text-xs text-muted-foreground">
            Product images ©{" "}
            <a
              href="https://world.openfoodfacts.org"
              target="_blank"
              rel="noreferrer"
              className="underline underline-offset-2"
            >
              Open Food Facts
            </a>{" "}
            contributors, CC-BY-SA 4.0
          </p>
          <div className="flex shrink-0 gap-2">
            <Button variant="outline" onClick={onClose} disabled={running}>
              Cancel
            </Button>
            <Button onClick={handleGenerate} disabled={running}>
              {running ? "Generating…" : "Generate"}
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
