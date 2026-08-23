"use client";

import { useEffect, useState, type FormEvent } from "react";
import Image from "next/image";
import { useStore } from "@/lib/store-context";
import { watchBrands } from "@/lib/brands";
import {
  createRecord,
  updateRecord,
  deleteRecord,
  brandBody,
} from "@/lib/catalog-api";
import type { Brand } from "@/lib/types";
import { matchesSearch } from "@/lib/search";
import { applySort, compareText, type Comparator } from "@/lib/sort";
import { ImageUploadField } from "@/components/image-upload-field";
import { ExternalIdField } from "@/components/external-id-field";
import { SearchField } from "@/components/search-field";
import {
  SortableTableHead,
  useTableSort,
} from "@/components/sortable-table-head";
import { Button } from "@/components/ui/button";
import { RecentlyDeletedButton } from "@/components/recently-deleted-dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
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

type BrandSortKey = "name";

const BRAND_COMPARATORS: Record<BrandSortKey, Comparator<Brand>> = {
  name: (a, b) => compareText(a.name, b.name),
};

export default function BrandsPage() {
  const { storeId } = useStore();
  const [brands, setBrands] = useState<Brand[]>([]);
  const [editing, setEditing] = useState<Brand | "new" | null>(null);
  const [deleting, setDeleting] = useState<Brand | null>(null);
  const [search, setSearch] = useState("");
  const { sort, toggle } = useTableSort<BrandSortKey>("name");

  useEffect(() => {
    if (!storeId) return;
    return watchBrands(storeId, setBrands);
  }, [storeId]);

  if (!storeId) return null;

  const visible = applySort(
    brands.filter((brand) => matchesSearch(search, brand.name)),
    sort,
    BRAND_COMPARATORS,
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Brands</h1>
          <p className="text-sm text-muted-foreground">
            Brands a product can be labelled with.
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <SearchField
            value={search}
            onChange={setSearch}
            label="Search brands"
            placeholder="Search name…"
          />
          <RecentlyDeletedButton storeId={storeId} entity="brands" entityPlural="brands" />
          <Button onClick={() => setEditing("new")}>Add brand</Button>
        </div>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-16">Logo</TableHead>
            <SortableTableHead columnKey="name" sort={sort} onToggle={toggle}>
              Name
            </SortableTableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell colSpan={3} className="text-center text-muted-foreground">
                {search ? "No brands match your search." : "No brands yet."}
              </TableCell>
            </TableRow>
          )}
          {visible.map((brand) => (
            <TableRow key={brand.id}>
              <TableCell>
                {brand.logoUrl ? (
                  <Image
                    src={brand.logoUrl}
                    alt={brand.name}
                    width={40}
                    height={40}
                    unoptimized
                    className="size-10 rounded-md object-cover"
                  />
                ) : (
                  <div className="size-10 rounded-md bg-muted" />
                )}
              </TableCell>
              <TableCell className="font-medium">{brand.name}</TableCell>
              <TableCell className="text-right">
                <Button variant="ghost" size="sm" onClick={() => setEditing(brand)}>
                  Edit
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-destructive"
                  onClick={() => setDeleting(brand)}
                >
                  Delete
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {editing && (
        <BrandDialog
          storeId={storeId}
          brand={editing === "new" ? null : editing}
          onClose={() => setEditing(null)}
        />
      )}

      <AlertDialog open={!!deleting} onOpenChange={(open) => !open && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete &quot;{deleting?.name}&quot;?</AlertDialogTitle>
            <AlertDialogDescription>
              This can&apos;t be undone. Products labelled with this brand will
              keep the reference but it will no longer resolve to a brand.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={async () => {
                if (!deleting) return;
                try {
                  await deleteRecord(storeId, "brands", deleting.id);
                  toast.success("Brand deleted");
                } catch (e) {
                  toast.error(e instanceof Error ? e.message : "Could not delete brand");
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

function BrandDialog({
  storeId,
  brand,
  onClose,
}: {
  storeId: string;
  brand: Brand | null;
  onClose: () => void;
}) {
  const [name, setName] = useState(brand?.name ?? "");
  const [logoUrl, setLogoUrl] = useState(brand?.logoUrl ?? "");
  const [externalId, setExternalId] = useState(brand?.externalId ?? "");
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setSubmitting(true);
    try {
      const data = {
        name: name.trim(),
        logoUrl: logoUrl.trim(),
        externalId: externalId.trim(),
      };
      if (brand) {
        await updateRecord(storeId, "brands", brand.id, brandBody(data));
        toast.success("Brand updated");
      } else {
        await createRecord(storeId, "brands", brandBody(data));
        toast.success("Brand added");
      }
      onClose();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not save brand");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{brand ? "Edit brand" : "Add brand"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="brand-name">Name</Label>
            <Input
              id="brand-name"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g. Amul"
            />
          </div>
          <ImageUploadField
            id="brand-logo"
            label="Logo (optional)"
            storeId={storeId}
            kind="brands"
            value={logoUrl}
            onChange={setLogoUrl}
          />
          <ExternalIdField
            id="brand-external-id"
            value={externalId}
            onChange={setExternalId}
          />
          <DialogFooter>
            <Button type="submit" disabled={submitting || !name.trim()}>
              {submitting ? "Saving…" : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
