"use client";

import { useEffect, useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { countCategories } from "@/lib/categories";
import { countProducts } from "@/lib/products";
import { getStore } from "@/lib/stores";
import {
  SEED_MARKETS,
  SEED_MARKET_CATALOGS,
  SEED_MARKET_DESCRIPTIONS,
  SEED_MARKET_LABELS,
  defaultSeedMarketForCurrency,
  type SeedMarket,
} from "@/lib/seed/seed-markets";
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
 * "Generate sample data" — seeds one market's bundled grocery catalog
 * (lib/seed/seed-markets.ts) into the active store in one atomic batch.
 *
 * The market defaults from the store's currency but stays a choice: EUR alone
 * doesn't identify a country, and a catalog's brands and language are as
 * market-specific as its prices.
 *
 * Generating into a non-empty store is warned about but not blocked: items
 * are only ever added alongside what exists, and the per-item delete flows
 * are the recovery story.
 *
 * Takes nothing but the store id: everything it shows it reads itself, so it
 * can be opened from any page. It lives on Settings, which is where a store is
 * set up; the Products page — the only page that already held the catalog in
 * memory — is not where an owner looks for it.
 */
export function GenerateGroceryDataDialog({
  storeId,
  onClose,
}: {
  storeId: string;
  onClose: () => void;
}) {
  const [progress, setProgress] = useState<SeedProgress | null>(null);
  const [market, setMarket] = useState<SeedMarket | null>(null);
  const [existing, setExisting] = useState<{
    products: number;
    categories: number;
  } | null>(null);
  const running = progress !== null;

  // Read here rather than threaded in from the opening page — the currency
  // picks the default market, and the two counts drive the already-has-data
  // warning. Three reads when the dialog opens (the counts are aggregation
  // queries, so a 500-product store still costs one read each).
  //
  // Neither failure is fatal: the picker falls back to the India default, and
  // a missing count just omits a warning about data the owner can see anyway.
  useEffect(() => {
    let active = true;
    getStore(storeId)
      .then((store) => {
        if (active) {
          setMarket(defaultSeedMarketForCurrency(store?.currency ?? "INR"));
        }
      })
      .catch(() => active && setMarket("india"));

    Promise.all([countProducts(storeId), countCategories(storeId)])
      .then(([products, categories]) => {
        if (active) setExisting({ products, categories });
      })
      .catch(() => {});

    return () => {
      active = false;
    };
  }, [storeId]);

  const seed = market ? SEED_MARKET_CATALOGS[market] : null;
  const storeHasData = !!existing && (existing.products > 0 || existing.categories > 0);

  async function handleGenerate() {
    if (!market) return;
    setProgress({ phase: "categories", done: 0, total: 1 });
    try {
      const result = await seedGroceryData(storeId, market, setProgress);
      toast.success(`Sample data generated — ${result.total} items created`);
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
            <div className="flex flex-col gap-2">
              <Label htmlFor="seed-market">Catalog</Label>
              <Select
                value={market ?? undefined}
                onValueChange={(value) => setMarket(value as SeedMarket)}
              >
                <SelectTrigger id="seed-market" className="w-full">
                  <SelectValue placeholder="Loading…" />
                </SelectTrigger>
                <SelectContent>
                  {SEED_MARKETS.map((code) => (
                    <SelectItem key={code} value={code}>
                      {SEED_MARKET_LABELS[code]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <p className="text-xs text-muted-foreground">
                Pre-selected from your store&apos;s currency. Prices are that
                market&apos;s real shelf prices, not converted — so they land in
                the price bands your storefront&apos;s filter uses.
              </p>
            </div>

            {market && (
              <>
                <p className="text-sm text-muted-foreground">
                  {SEED_MARKET_DESCRIPTIONS[market]} Includes product photos plus
                  ready-made coupons and promo banners:
                </p>
                <p className="text-sm font-medium">
                  {seed!.categories.length} categories · {seed!.brands.length}{" "}
                  brands · {seed!.products.length} products ·{" "}
                  {seed!.coupons.length} coupons · {seed!.banners.length} banners
                </p>
              </>
            )}

            {storeHasData && (
              <div className="rounded-lg border border-border-strong bg-muted/60 p-3 text-sm">
                This store already has {existing!.products} product
                {existing!.products === 1 ? "" : "s"} and{" "}
                {existing!.categories} categor
                {existing!.categories === 1 ? "y" : "ies"}. Generated items
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
            <Button onClick={handleGenerate} disabled={running || !market}>
              {running ? "Generating…" : "Generate"}
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
