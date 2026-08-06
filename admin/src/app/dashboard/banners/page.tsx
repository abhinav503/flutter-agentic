"use client";

import { useEffect, useState, type FormEvent } from "react";
import Image from "next/image";
import { useStore } from "@/lib/store-context";
import { watchCategories } from "@/lib/categories";
import { watchProducts } from "@/lib/products";
import { ImportCsvDialog } from "@/components/import-csv-dialog";
import { importContext } from "@/lib/import/import-context";
import {
  BANNER_COLUMNS,
  buildBannerPlan,
  sampleBannerCsv,
} from "@/lib/import/banner-csv";
import {
  watchBanners,
  addBanner,
  updateBanner,
  deleteBanner,
} from "@/lib/banners";
import type {
  Banner,
  BannerTargetType,
  Category,
  Product,
} from "@/lib/types";
import { BANNER_TARGET_TYPE_LABELS } from "@/lib/types";
import { matchesSearch } from "@/lib/search";
import { ImageUploadField } from "@/components/image-upload-field";
import { SearchField } from "@/components/search-field";
import { ColorPickerField, isHexColor } from "@/components/color-picker-field";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { toast } from "sonner";

export default function BannersPage() {
  const { storeId, storeCurrency, storeLanguage } = useStore();
  const [banners, setBanners] = useState<Banner[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [editing, setEditing] = useState<Banner | "new" | null>(null);
  const [deleting, setDeleting] = useState<Banner | null>(null);
  const [search, setSearch] = useState("");
  const [importing, setImporting] = useState(false);

  // Products and categories are watched only to populate the dialog's link
  // target picker — a banner itself references one by id.
  useEffect(() => {
    if (!storeId) return;
    const unsubBanners = watchBanners(storeId, setBanners);
    const unsubProducts = watchProducts(storeId, setProducts);
    const unsubCategories = watchCategories(storeId, setCategories);
    return () => {
      unsubBanners();
      unsubProducts();
      unsubCategories();
    };
  }, [storeId]);

  if (!storeId) return null;

  function targetLabel(banner: Banner) {
    if (banner.targetType === "product") {
      return products.find((p) => p.id === banner.targetId)?.name ?? "Unknown";
    }
    if (banner.targetType === "category") {
      return (
        categories.find((c) => c.id === banner.targetId)?.name ?? "Unknown"
      );
    }
    return "—";
  }

  // Search only — ordering stays bySortOrder from watchBanners, since order
  // IS the carousel position the admin is managing here.
  const visible = banners.filter((banner) =>
    matchesSearch(search, banner.title, banner.subtitle, targetLabel(banner)),
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Banners</h1>
          <p className="text-sm text-muted-foreground">
            Promo cards in your storefront&apos;s home carousel, shown in order.
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <SearchField
            value={search}
            onChange={setSearch}
            label="Search banners"
            placeholder="Search title or target…"
          />
          <Button variant="outline" onClick={() => setImporting(true)}>
            Import CSV
          </Button>
          <Button onClick={() => setEditing("new")}>Add banner</Button>
        </div>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-36">Image</TableHead>
            <TableHead>Title</TableHead>
            <TableHead>Links to</TableHead>
            <TableHead className="w-20">Order</TableHead>
            <TableHead className="w-24">Status</TableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell colSpan={6} className="text-center text-muted-foreground">
                {search
                  ? "No banners match your search."
                  : "No banners yet — the carousel falls back to your top-selling products until you add one."}
              </TableCell>
            </TableRow>
          )}
          {visible.map((banner) => (
            <TableRow key={banner.id}>
              <TableCell>
                <div className="flex items-center gap-2">
                  {banner.backgroundColor && (
                    <span
                      title={banner.backgroundColor}
                      style={{ backgroundColor: banner.backgroundColor }}
                      className="size-10 shrink-0 rounded-md border border-border"
                    />
                  )}
                  {banner.imageUrl ? (
                    <Image
                      src={banner.imageUrl}
                      alt={banner.title}
                      width={80}
                      height={40}
                      unoptimized
                      className="h-10 w-20 rounded-md object-cover"
                    />
                  ) : (
                    <div className="h-10 w-20 rounded-md bg-muted" />
                  )}
                </div>
              </TableCell>
              <TableCell className="font-medium">
                <div>{banner.title}</div>
                {banner.subtitle && (
                  <div className="text-xs text-muted-foreground">
                    {banner.subtitle}
                  </div>
                )}
              </TableCell>
              <TableCell className="text-muted-foreground">
                {targetLabel(banner)}
              </TableCell>
              <TableCell className="text-muted-foreground">
                {banner.sortOrder}
              </TableCell>
              <TableCell>
                {banner.isActive ? (
                  <Badge>Live</Badge>
                ) : (
                  <Badge variant="secondary">Hidden</Badge>
                )}
              </TableCell>
              <TableCell className="text-right">
                <Button variant="ghost" size="sm" onClick={() => setEditing(banner)}>
                  Edit
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-destructive"
                  onClick={() => setDeleting(banner)}
                >
                  Delete
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {importing && (
        <ImportCsvDialog
          storeId={storeId}
          spec={(() => {
            const ctx = importContext(storeLanguage, storeCurrency, {
              products,
              categories,
              brands: [],
            });
            return {
              entityPlural: "banners",
              entitySingular: "banner",
              collectionName: "banners",
              matchOn: "banner title",
              columns: BANNER_COLUMNS,
              buildPlan: (csv: string) => buildBannerPlan(csv, ctx.catalog, banners),
              sampleCsv: () => sampleBannerCsv(ctx.seed, ctx.catalog),
              sampleLabel: ctx.sampleLabel,
              sampleSlug: ctx.sampleSlug,
            };
          })()}
          onClose={() => setImporting(false)}
        />
      )}

      {editing && (
        <BannerDialog
          storeId={storeId}
          banner={editing === "new" ? null : editing}
          products={products}
          categories={categories}
          nextSortOrder={
            banners.length === 0
              ? 0
              : Math.max(...banners.map((b) => b.sortOrder)) + 1
          }
          onClose={() => setEditing(null)}
        />
      )}

      <AlertDialog open={!!deleting} onOpenChange={(open) => !open && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete &quot;{deleting?.title}&quot;?</AlertDialogTitle>
            <AlertDialogDescription>
              This can&apos;t be undone. To take a banner off the carousel
              without losing it, uncheck &ldquo;Show in carousel&rdquo; instead.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={async () => {
                if (!deleting) return;
                try {
                  await deleteBanner(storeId, deleting.id);
                  toast.success("Banner deleted");
                } catch {
                  toast.error("Could not delete banner");
                } finally {
                  setDeleting(null);
                }
              }}
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

function BannerDialog({
  storeId,
  banner,
  products,
  categories,
  nextSortOrder,
  onClose,
}: {
  storeId: string;
  banner: Banner | null;
  products: Product[];
  categories: Category[];
  nextSortOrder: number;
  onClose: () => void;
}) {
  const [imageUrl, setImageUrl] = useState(banner?.imageUrl ?? "");
  const [title, setTitle] = useState(banner?.title ?? "");
  const [subtitle, setSubtitle] = useState(banner?.subtitle ?? "");
  const [targetType, setTargetType] = useState<BannerTargetType>(
    banner?.targetType ?? "none",
  );
  const [targetId, setTargetId] = useState(banner?.targetId ?? "");
  const [sortOrder, setSortOrder] = useState(
    String(banner?.sortOrder ?? nextSortOrder),
  );
  const [isActive, setIsActive] = useState(banner?.isActive ?? true);
  const [backgroundColor, setBackgroundColor] = useState(
    banner?.backgroundColor ?? "",
  );
  const [submitting, setSubmitting] = useState(false);

  const targetOptions = targetType === "product" ? products : categories;

  function handleTargetTypeChange(value: BannerTargetType) {
    setTargetType(value);
    setTargetId(""); // a product id is meaningless once the type is category
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    if (!imageUrl.trim()) {
      toast.error("Add a banner image");
      return;
    }
    if (targetType !== "none" && !targetId) {
      toast.error(`Choose which ${targetType} this banner opens`);
      return;
    }
    if (backgroundColor && !isHexColor(backgroundColor)) {
      toast.error("Background colour must be a 6-digit hex, e.g. #C8DFC3");
      return;
    }
    setSubmitting(true);
    try {
      const data = {
        imageUrl: imageUrl.trim(),
        title: title.trim(),
        subtitle: subtitle.trim(),
        targetType,
        targetId: targetType === "none" ? "" : targetId,
        sortOrder: Number(sortOrder) || 0,
        isActive,
        backgroundColor,
      };
      if (banner) {
        await updateBanner(storeId, banner.id, data);
        toast.success("Banner updated");
      } else {
        await addBanner(storeId, data);
        toast.success("Banner added");
      }
      onClose();
    } catch {
      toast.error("Could not save banner");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{banner ? "Edit banner" : "Add banner"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <ImageUploadField
              id="banner-image"
              label="Image"
              storeId={storeId}
              kind="banners"
              value={imageUrl}
              onChange={setImageUrl}
            />
            <p className="text-xs text-muted-foreground">
              Landscape, roughly 2:1. Some storefronts show it beside the
              copy rather than behind it, so keep the subject centred.
            </p>
          </div>

          <ColorPickerField
            id="banner-background"
            label="Background colour"
            value={backgroundColor}
            onChange={setBackgroundColor}
            description="Fills the panel the title and subtitle sit on, next to the
              image. Pick one from the image so the card reads as one piece.
              Leave it clear to use your storefront's own card colour."
          />

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="banner-title">Title</Label>
            <Input
              id="banner-title"
              required
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="e.g. Fresh Deals This Week"
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="banner-subtitle">Subtitle</Label>
            <Input
              id="banner-subtitle"
              value={subtitle}
              onChange={(e) => setSubtitle(e.target.value)}
              placeholder="e.g. Up to 40% off on daily essentials"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="banner-target-type">Tapping it opens</Label>
              <Select
                value={targetType}
                onValueChange={(v) =>
                  handleTargetTypeChange(v as BannerTargetType)
                }
              >
                <SelectTrigger id="banner-target-type" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {Object.entries(BANNER_TARGET_TYPE_LABELS).map(
                    ([value, label]) => (
                      <SelectItem key={value} value={value}>
                        {label}
                      </SelectItem>
                    ),
                  )}
                </SelectContent>
              </Select>
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="banner-sort-order">Position</Label>
              <Input
                id="banner-sort-order"
                type="number"
                min="0"
                step="1"
                value={sortOrder}
                onChange={(e) => setSortOrder(e.target.value)}
              />
            </div>
          </div>

          {targetType !== "none" && (
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="banner-target">
                {targetType === "product" ? "Product" : "Category"}
              </Label>
              <Select value={targetId} onValueChange={setTargetId}>
                <SelectTrigger id="banner-target" className="w-full">
                  <SelectValue
                    placeholder={`Choose a ${targetType}`}
                  />
                </SelectTrigger>
                <SelectContent>
                  {targetOptions.map((option) => (
                    <SelectItem key={option.id} value={option.id}>
                      {option.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {targetOptions.length === 0 && (
                <p className="text-xs text-muted-foreground">
                  You have no {targetType === "product" ? "products" : "categories"}{" "}
                  yet — add one first, or leave this banner display-only.
                </p>
              )}
            </div>
          )}

          <label className="flex items-center gap-2 text-sm">
            <Checkbox
              checked={isActive}
              onCheckedChange={(checked) => setIsActive(checked === true)}
            />
            Show in carousel
          </label>

          <DialogFooter>
            <Button type="submit" disabled={submitting || !title.trim()}>
              {submitting ? "Saving…" : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
