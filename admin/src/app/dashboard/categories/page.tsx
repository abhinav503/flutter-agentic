"use client";

import { useEffect, useState, type FormEvent } from "react";
import Image from "next/image";
import { useStore } from "@/lib/store-context";
import {
  watchCategories,
  addCategory,
  updateCategory,
  deleteCategory,
} from "@/lib/categories";
import type { Category } from "@/lib/types";
import { matchesSearch } from "@/lib/search";
import { applySort, compareText, type Comparator } from "@/lib/sort";
import { ImageUploadField } from "@/components/image-upload-field";
import { SearchField } from "@/components/search-field";
import {
  SortableTableHead,
  useTableSort,
} from "@/components/sortable-table-head";
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

type CategorySortKey = "name" | "group";

const CATEGORY_COMPARATORS: Record<CategorySortKey, Comparator<Category>> = {
  name: (a, b) => compareText(a.name, b.name),
  // Name tiebreak so a group's categories read as one alphabetised block.
  group: (a, b) =>
    compareText(a.groupName, b.groupName) || compareText(a.name, b.name),
};

export default function CategoriesPage() {
  const { storeId } = useStore();
  const [categories, setCategories] = useState<Category[]>([]);
  const [editing, setEditing] = useState<Category | "new" | null>(null);
  const [deleting, setDeleting] = useState<Category | null>(null);
  const [search, setSearch] = useState("");
  const { sort, toggle } = useTableSort<CategorySortKey>("name");

  useEffect(() => {
    if (!storeId) return;
    return watchCategories(storeId, setCategories);
  }, [storeId]);

  if (!storeId) return null;

  const visible = applySort(
    categories.filter((category) =>
      matchesSearch(search, category.name, category.groupName),
    ),
    sort,
    CATEGORY_COMPARATORS,
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Categories</h1>
          <p className="text-sm text-muted-foreground">
            Categories a product can be linked to.
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <SearchField
            value={search}
            onChange={setSearch}
            label="Search categories"
            placeholder="Search name or group…"
          />
          <Button onClick={() => setEditing("new")}>Add category</Button>
        </div>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-16">Image</TableHead>
            <SortableTableHead columnKey="name" sort={sort} onToggle={toggle}>
              Name
            </SortableTableHead>
            <SortableTableHead columnKey="group" sort={sort} onToggle={toggle}>
              Group
            </SortableTableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell colSpan={4} className="text-center text-muted-foreground">
                {search ? "No categories match your search." : "No categories yet."}
              </TableCell>
            </TableRow>
          )}
          {visible.map((category) => (
            <TableRow key={category.id}>
              <TableCell>
                {category.imageUrl ? (
                  <Image
                    src={category.imageUrl}
                    alt={category.name}
                    width={40}
                    height={40}
                    unoptimized
                    className="size-10 rounded-md object-cover"
                  />
                ) : (
                  <div className="size-10 rounded-md bg-muted" />
                )}
              </TableCell>
              <TableCell className="font-medium">{category.name}</TableCell>
              <TableCell className="text-muted-foreground">{category.groupName}</TableCell>
              <TableCell className="text-right">
                <Button variant="ghost" size="sm" onClick={() => setEditing(category)}>
                  Edit
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-destructive"
                  onClick={() => setDeleting(category)}
                >
                  Delete
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {editing && (
        <CategoryDialog
          storeId={storeId}
          category={editing === "new" ? null : editing}
          existingGroupNames={[...new Set(categories.map((c) => c.groupName))]}
          onClose={() => setEditing(null)}
        />
      )}

      <AlertDialog open={!!deleting} onOpenChange={(open) => !open && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete &quot;{deleting?.name}&quot;?</AlertDialogTitle>
            <AlertDialogDescription>
              This can&apos;t be undone. Products linked to this category will keep
              the reference but it will no longer resolve to a category.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={async () => {
                if (!deleting) return;
                try {
                  await deleteCategory(storeId, deleting.id);
                  toast.success("Category deleted");
                } catch {
                  toast.error("Could not delete category");
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

function CategoryDialog({
  storeId,
  category,
  existingGroupNames,
  onClose,
}: {
  storeId: string;
  category: Category | null;
  existingGroupNames: string[];
  onClose: () => void;
}) {
  const [name, setName] = useState(category?.name ?? "");
  const [imageUrl, setImageUrl] = useState(category?.imageUrl ?? "");
  const [groupName, setGroupName] = useState(category?.groupName ?? "");
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setSubmitting(true);
    try {
      const data = {
        name: name.trim(),
        imageUrl: imageUrl.trim(),
        groupName: groupName.trim(),
      };
      if (category) {
        await updateCategory(storeId, category.id, data);
        toast.success("Category updated");
      } else {
        await addCategory(storeId, data);
        toast.success("Category added");
      }
      onClose();
    } catch {
      toast.error("Could not save category");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{category ? "Edit category" : "Add category"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="category-name">Name</Label>
            <Input
              id="category-name"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g. Fresh Fruits"
            />
          </div>
          <ImageUploadField
            id="category-image"
            label="Image"
            storeId={storeId}
            kind="categories"
            value={imageUrl}
            onChange={setImageUrl}
          />
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="category-group">Group</Label>
            <Input
              id="category-group"
              list="category-group-suggestions"
              required
              value={groupName}
              onChange={(e) => setGroupName(e.target.value)}
              placeholder="e.g. Grocery & Kitchen"
            />
            <datalist id="category-group-suggestions">
              {existingGroupNames.map((g) => (
                <option key={g} value={g} />
              ))}
            </datalist>
          </div>
          <DialogFooter>
            <Button type="submit" disabled={submitting || !name.trim() || !groupName.trim()}>
              {submitting ? "Saving…" : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
