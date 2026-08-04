"use client";

import { useEffect, useState, type FormEvent } from "react";
import Image from "next/image";
import { useStore } from "@/lib/store-context";
import { watchBrands, addBrand, updateBrand, deleteBrand } from "@/lib/brands";
import type { Brand } from "@/lib/types";
import { ImageUploadField } from "@/components/image-upload-field";
import { Button } from "@/components/ui/button";
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

export default function BrandsPage() {
  const { storeId } = useStore();
  const [brands, setBrands] = useState<Brand[]>([]);
  const [editing, setEditing] = useState<Brand | "new" | null>(null);
  const [deleting, setDeleting] = useState<Brand | null>(null);

  useEffect(() => {
    if (!storeId) return;
    return watchBrands(storeId, setBrands);
  }, [storeId]);

  if (!storeId) return null;

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-lg font-semibold">Brands</h1>
          <p className="text-sm text-muted-foreground">
            Brands a product can be labelled with.
          </p>
        </div>
        <Button onClick={() => setEditing("new")}>Add brand</Button>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-16">Logo</TableHead>
            <TableHead>Name</TableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {brands.length === 0 && (
            <TableRow>
              <TableCell colSpan={3} className="text-center text-muted-foreground">
                No brands yet.
              </TableCell>
            </TableRow>
          )}
          {brands.map((brand) => (
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
                  await deleteBrand(storeId, deleting.id);
                  toast.success("Brand deleted");
                } catch {
                  toast.error("Could not delete brand");
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
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setSubmitting(true);
    try {
      const data = { name: name.trim(), logoUrl: logoUrl.trim() };
      if (brand) {
        await updateBrand(storeId, brand.id, data);
        toast.success("Brand updated");
      } else {
        await addBrand(storeId, data);
        toast.success("Brand added");
      }
      onClose();
    } catch {
      toast.error("Could not save brand");
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
