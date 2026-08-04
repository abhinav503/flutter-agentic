"use client";

import { useEffect, useState, type FormEvent } from "react";
import Image from "next/image";
import { Star } from "lucide-react";
import { useStore } from "@/lib/store-context";
import { watchCategories } from "@/lib/categories";
import { watchBrands } from "@/lib/brands";
import {
  watchProducts,
  addProduct,
  updateProduct,
  deleteProduct,
  computeDiscountPercentage,
  scalePriceToSize,
} from "@/lib/products";
import type { Brand, Category, Product, UnitType } from "@/lib/types";
import { UNIT_TYPE_LABELS } from "@/lib/types";
import { matchesSearch } from "@/lib/search";
import { ImageUploadField } from "@/components/image-upload-field";
import { SearchField } from "@/components/search-field";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
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

export default function ProductsPage() {
  const { storeId } = useStore();
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [editing, setEditing] = useState<Product | "new" | null>(null);
  const [deleting, setDeleting] = useState<Product | null>(null);
  const [search, setSearch] = useState("");

  useEffect(() => {
    if (!storeId) return;
    const unsubProducts = watchProducts(storeId, setProducts);
    const unsubCategories = watchCategories(storeId, setCategories);
    const unsubBrands = watchBrands(storeId, setBrands);
    return () => {
      unsubProducts();
      unsubCategories();
      unsubBrands();
    };
  }, [storeId]);

  if (!storeId) return null;

  const categoryName = (id: string) =>
    categories.find((c) => c.id === id)?.name ?? "Unknown";
  const brandName = (id: string) => brands.find((b) => b.id === id)?.name;

  // Match on what the row actually shows — searching the description would
  // return rows with nothing visibly matching the query.
  const visible = products.filter((product) =>
    matchesSearch(
      search,
      product.name,
      brandName(product.brandId),
      ...product.categoryIds.map(categoryName),
    ),
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Products</h1>
          <p className="text-sm text-muted-foreground">
            Manage pricing, stock, and category links.
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <SearchField
            value={search}
            onChange={setSearch}
            label="Search products"
            placeholder="Search name, brand, category…"
          />
          <Button onClick={() => setEditing("new")} disabled={categories.length === 0}>
            Add product
          </Button>
        </div>
      </div>

      {categories.length === 0 && (
        <p className="text-sm text-muted-foreground">
          Add at least one category first — products link to categories.
        </p>
      )}

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-16">Image</TableHead>
            <TableHead>Name</TableHead>
            <TableHead>Brand</TableHead>
            <TableHead>Price</TableHead>
            <TableHead>Stock</TableHead>
            <TableHead>Rating</TableHead>
            <TableHead>Categories</TableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell colSpan={8} className="text-center text-muted-foreground">
                {search ? "No products match your search." : "No products yet."}
              </TableCell>
            </TableRow>
          )}
          {visible.map((product) => (
            <TableRow key={product.id}>
              <TableCell>
                {product.imageUrl ? (
                  <Image
                    src={product.imageUrl}
                    alt={product.name}
                    width={40}
                    height={40}
                    unoptimized
                    className="size-10 rounded-md object-cover"
                  />
                ) : (
                  <div className="size-10 rounded-md bg-muted" />
                )}
              </TableCell>
              <TableCell className="font-medium">
                <div className="flex items-center gap-1.5">
                  {product.name}
                  {product.isPopular && <Badge>Popular</Badge>}
                </div>
              </TableCell>
              <TableCell className="text-muted-foreground">
                {brandName(product.brandId) ?? "—"}
              </TableCell>
              <TableCell>
                <div className="flex items-center gap-1.5">
                  <span>₹{product.price}</span>
                  {product.discountPercentage > 0 && (
                    <span className="text-xs text-muted-foreground line-through">
                      ₹{product.originalPrice}
                    </span>
                  )}
                </div>
              </TableCell>
              <TableCell>
                {product.stock > 0 ? (
                  product.stock
                ) : (
                  <Badge variant="destructive">Out of stock</Badge>
                )}
              </TableCell>
              <TableCell className="whitespace-nowrap">
                {/* Rolled up from the product's reviews (see lib/reviews.ts);
                    read-only here — the form never writes these. */}
                {product.reviewCount > 0 ? (
                  <span className="flex items-center gap-1">
                    <Star className="size-3.5 fill-amber-400 text-amber-400" />
                    {product.ratingAverage.toFixed(1)}
                    <span className="text-xs text-muted-foreground">
                      ({product.reviewCount})
                    </span>
                  </span>
                ) : (
                  <span className="text-muted-foreground">—</span>
                )}
              </TableCell>
              <TableCell>
                <div className="flex flex-wrap gap-1">
                  {product.categoryIds.map((id) => (
                    <Badge key={id} variant="secondary">
                      {categoryName(id)}
                    </Badge>
                  ))}
                </div>
              </TableCell>
              <TableCell className="text-right">
                <Button variant="ghost" size="sm" onClick={() => setEditing(product)}>
                  Edit
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-destructive"
                  onClick={() => setDeleting(product)}
                >
                  Delete
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {editing && (
        <ProductDialog
          storeId={storeId}
          product={editing === "new" ? null : editing}
          categories={categories}
          brands={brands}
          onClose={() => setEditing(null)}
        />
      )}

      <AlertDialog open={!!deleting} onOpenChange={(open) => !open && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete &quot;{deleting?.name}&quot;?</AlertDialogTitle>
            <AlertDialogDescription>This can&apos;t be undone.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={async () => {
                if (!deleting) return;
                try {
                  await deleteProduct(storeId, deleting.id);
                  toast.success("Product deleted");
                } catch {
                  toast.error("Could not delete product");
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

// Select items can't carry an empty-string value, so "unbranded" travels
// through the picker as this sentinel and is mapped back to "" on save.
const NO_BRAND = "none";

// Form-local variant row — strings because they're bound to inputs; empty
// price fields mean "use the scaled suggestion shown as the placeholder".
type VariantRow = { value: string; price: string; originalPrice: string };

function ProductDialog({
  storeId,
  product,
  categories,
  brands,
  onClose,
}: {
  storeId: string;
  product: Product | null;
  categories: Category[];
  brands: Brand[];
  onClose: () => void;
}) {
  const [name, setName] = useState(product?.name ?? "");
  const [imageUrl, setImageUrl] = useState(product?.imageUrl ?? "");
  const [price, setPrice] = useState(String(product?.price ?? ""));
  const [originalPrice, setOriginalPrice] = useState(
    String(product?.originalPrice ?? ""),
  );
  const [unitValue, setUnitValue] = useState(String(product?.unitValue ?? ""));
  const [unitType, setUnitType] = useState<UnitType>(product?.unitType ?? "g");
  const [prepTime, setPrepTime] = useState(product?.prepTime ?? "");
  const [stock, setStock] = useState(String(product?.stock ?? ""));
  const [description, setDescription] = useState(product?.description ?? "");
  const [categoryIds, setCategoryIds] = useState<string[]>(
    product?.categoryIds ?? [],
  );
  const [brandId, setBrandId] = useState(product?.brandId || NO_BRAND);
  const [isPopular, setIsPopular] = useState(product?.isPopular ?? false);
  const [variants, setVariants] = useState<VariantRow[]>(
    (product?.sizeVariants ?? []).map((v) => ({
      value: String(v.value),
      price: String(v.price),
      originalPrice: String(v.originalPrice),
    })),
  );
  const [submitting, setSubmitting] = useState(false);

  function setVariantField(index: number, field: keyof VariantRow, raw: string) {
    setVariants((prev) =>
      prev.map((row, i) => (i === index ? { ...row, [field]: raw } : row)),
    );
  }

  function toggleCategory(id: string) {
    setCategoryIds((prev) =>
      prev.includes(id) ? prev.filter((c) => c !== id) : [...prev, id],
    );
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    if (categoryIds.length === 0) {
      toast.error("Select at least one category");
      return;
    }
    setSubmitting(true);
    try {
      const priceNum = Number(price);
      const originalPriceNum = Number(originalPrice) || priceNum;
      const unitValueNum = Number(unitValue);
      // Empty price fields resolve to the scaled suggestion the row showed as
      // its placeholder; rows without a valid size are dropped, and chips
      // render smallest-first regardless of entry order.
      const sizeVariants = variants
        .map((row) => {
          const value = Number(row.value);
          const rowPrice =
            Number(row.price) || scalePriceToSize(priceNum, unitValueNum, value);
          return {
            value,
            price: rowPrice,
            originalPrice:
              Number(row.originalPrice) ||
              scalePriceToSize(originalPriceNum, unitValueNum, value) ||
              rowPrice,
          };
        })
        .filter((v) => Number.isFinite(v.value) && v.value > 0 && v.price > 0)
        .sort((a, b) => a.value - b.value);
      const data = {
        name: name.trim(),
        imageUrl: imageUrl.trim(),
        price: priceNum,
        originalPrice: originalPriceNum,
        discountPercentage: computeDiscountPercentage(priceNum, originalPriceNum),
        unitValue: unitValueNum,
        unitType,
        prepTime: prepTime.trim(),
        description: description.trim(),
        stock: Number(stock),
        categoryIds,
        brandId: brandId === NO_BRAND ? "" : brandId,
        sizeVariants,
        // Derived from the variants on every save so pre-variant storefront
        // readers keep seeing the same "Select QTY" values.
        sizeOptions: sizeVariants.map((v) => v.value),
        isPopular,
      };
      if (product) {
        await updateProduct(storeId, product.id, data);
        toast.success("Product updated");
      } else {
        await addProduct(storeId, data);
        toast.success("Product added");
      }
      onClose();
    } catch {
      toast.error("Could not save product");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{product ? "Edit product" : "Add product"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="product-name">Name</Label>
            <Input
              id="product-name"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g. Organic Bananas"
            />
          </div>

          <ImageUploadField
            id="product-image"
            label="Image"
            storeId={storeId}
            kind="products"
            value={imageUrl}
            onChange={setImageUrl}
          />

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="product-brand">Brand</Label>
            <Select value={brandId} onValueChange={setBrandId}>
              <SelectTrigger id="product-brand">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={NO_BRAND}>No brand</SelectItem>
                {brands.map((brand) => (
                  <SelectItem key={brand.id} value={brand.id}>
                    {brand.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-price">Price (₹)</Label>
              <Input
                id="product-price"
                required
                type="number"
                min="0"
                step="0.01"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-original-price">
                Original price (₹, optional)
              </Label>
              <Input
                id="product-original-price"
                type="number"
                min="0"
                step="0.01"
                value={originalPrice}
                onChange={(e) => setOriginalPrice(e.target.value)}
                placeholder="Same as price if empty"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-unit-value">Package size</Label>
              <Input
                id="product-unit-value"
                required
                type="number"
                min="0"
                step="0.01"
                value={unitValue}
                onChange={(e) => setUnitValue(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-unit-type">Unit</Label>
              <Select value={unitType} onValueChange={(v) => setUnitType(v as UnitType)}>
                <SelectTrigger id="product-unit-type">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {Object.entries(UNIT_TYPE_LABELS).map(([value, label]) => (
                    <SelectItem key={value} value={value}>
                      {label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-stock">Stock</Label>
              <Input
                id="product-stock"
                required
                type="number"
                min="0"
                step="1"
                value={stock}
                onChange={(e) => setStock(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-prep-time">Prep time</Label>
              <Input
                id="product-prep-time"
                value={prepTime}
                onChange={(e) => setPrepTime(e.target.value)}
                placeholder="e.g. 10 mins"
              />
            </div>
          </div>

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="product-description">Description</Label>
            <Textarea
              id="product-description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={3}
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <Label>Size options</Label>
            <p className="text-xs text-muted-foreground">
              Pack sizes shown as the &ldquo;Select QTY&rdquo; row on the product
              page, each with its own price. Leave a price empty to charge the
              suggested one (base price scaled by size).
            </p>
            {variants.length > 0 && (
              <div className="flex flex-col gap-2">
                <div className="grid grid-cols-[1fr_1fr_1fr_3.5rem_2rem] items-center gap-2 text-xs text-muted-foreground">
                  <span>Size ({unitType})</span>
                  <span>Price (₹)</span>
                  <span>Original (₹)</span>
                  <span>Off</span>
                  <span />
                </div>
                {variants.map((row, index) => {
                  const value = Number(row.value);
                  const suggestedPrice = scalePriceToSize(
                    Number(price),
                    Number(unitValue),
                    value,
                  );
                  const suggestedOriginal = scalePriceToSize(
                    Number(originalPrice) || Number(price),
                    Number(unitValue),
                    value,
                  );
                  const rowPrice = Number(row.price) || suggestedPrice;
                  const rowOriginal = Number(row.originalPrice) || suggestedOriginal;
                  const discount = computeDiscountPercentage(rowPrice, rowOriginal);
                  return (
                    <div
                      key={index}
                      className="grid grid-cols-[1fr_1fr_1fr_3.5rem_2rem] items-center gap-2"
                    >
                      <Input
                        type="number"
                        min="0"
                        step="0.01"
                        value={row.value}
                        onChange={(e) => setVariantField(index, "value", e.target.value)}
                        placeholder="e.g. 250"
                        aria-label={`Size ${index + 1} value`}
                      />
                      <Input
                        type="number"
                        min="0"
                        step="0.01"
                        value={row.price}
                        onChange={(e) => setVariantField(index, "price", e.target.value)}
                        placeholder={value > 0 ? String(suggestedPrice) : ""}
                        aria-label={`Size ${index + 1} price`}
                      />
                      <Input
                        type="number"
                        min="0"
                        step="0.01"
                        value={row.originalPrice}
                        onChange={(e) =>
                          setVariantField(index, "originalPrice", e.target.value)
                        }
                        placeholder={value > 0 ? String(suggestedOriginal) : ""}
                        aria-label={`Size ${index + 1} original price`}
                      />
                      <span className="text-xs text-muted-foreground">
                        {discount > 0 ? `${discount}%` : "—"}
                      </span>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        className="text-destructive"
                        onClick={() =>
                          setVariants((prev) => prev.filter((_, i) => i !== index))
                        }
                        aria-label={`Remove size ${index + 1}`}
                      >
                        ✕
                      </Button>
                    </div>
                  );
                })}
              </div>
            )}
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="self-start"
              onClick={() =>
                setVariants((prev) => [
                  ...prev,
                  { value: "", price: "", originalPrice: "" },
                ])
              }
            >
              Add size
            </Button>
          </div>

          <div className="flex flex-col gap-1.5">
            <Label>Categories</Label>
            <div className="flex flex-col gap-2 rounded-md border border-border p-3">
              {categories.map((category) => (
                <label
                  key={category.id}
                  className="flex items-center gap-2 text-sm"
                >
                  <Checkbox
                    checked={categoryIds.includes(category.id)}
                    onCheckedChange={() => toggleCategory(category.id)}
                  />
                  {category.name}
                </label>
              ))}
            </div>
          </div>

          <label className="flex items-center gap-2 text-sm">
            <Checkbox
              checked={isPopular}
              onCheckedChange={(checked) => setIsPopular(checked === true)}
            />
            Show in Popular Products
          </label>

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
