"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import { Star } from "lucide-react";
import { useStore } from "@/lib/store-context";
import { watchCategories } from "@/lib/categories";
import { watchBrands } from "@/lib/brands";
import { watchProducts } from "@/lib/products";
import { deleteRecord } from "@/lib/catalog-api";
import type { Brand, Category, Product } from "@/lib/types";
import { ProductDialog } from "./product-dialog";
import { matchesSearch } from "@/lib/search";
import { formatMoney } from "@/lib/money";
import {
  applySort,
  compareNumbers,
  compareText,
  type Comparator,
} from "@/lib/sort";
import { SearchField } from "@/components/search-field";
import { ImportCsvDialog } from "@/components/import-csv-dialog";
import { importContext } from "@/lib/import/import-context";
import { PRODUCT_COLUMNS, sampleProductCsv } from "@/lib/import/product-csv";
import {
  SortableTableHead,
  useTableSort,
} from "@/components/sortable-table-head";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
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

type ProductSortKey = "name" | "price" | "stock" | "rating" | "added";

const PRODUCT_COMPARATORS: Record<ProductSortKey, Comparator<Product>> = {
  name: (a, b) => compareText(a.name, b.name),
  price: (a, b) => compareNumbers(a.price, b.price),
  stock: (a, b) => compareNumbers(a.stock, b.stock),
  // reviewCount tiebreak so among equal averages the better-attested rating
  // ranks first; unrated products (average 0) sink to the bottom on desc.
  rating: (a, b) =>
    compareNumbers(a.ratingAverage, b.ratingAverage) ||
    compareNumbers(a.reviewCount, b.reviewCount),
  added: (a, b) => compareNumbers(a.createdAtMs, b.createdAtMs),
};

// The filter Selects' "no filter" value — Select items can't carry "".
// Select refuses "" as an item value, so "no brand" needs its own token.
const NO_BRAND = "none";
const ALL = "all";

type StockFilter = "all" | "in" | "out";

export default function ProductsPage() {
  const { storeId, storeCurrency, storeLanguage } = useStore();
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [editing, setEditing] = useState<Product | "new" | null>(null);
  const [deleting, setDeleting] = useState<Product | null>(null);
  const [importing, setImporting] = useState(false);
  const [search, setSearch] = useState("");
  const [categoryFilter, setCategoryFilter] = useState(ALL);
  const [brandFilter, setBrandFilter] = useState(ALL);
  const [stockFilter, setStockFilter] = useState<StockFilter>("all");
  const { sort, toggle } = useTableSort<ProductSortKey>("name");
  const [loadError, setLoadError] = useState<string | null>(null);

  useEffect(() => {
    if (!storeId) return;
    // Only the products listener reports its failure: it is the one whose
    // empty state ("No products yet.") is indistinguishable from a broken
    // listen, and the one that sent someone hunting for a catalog that was
    // there all along. The error clears when data actually arrives, not on
    // subscribe — a listener that recovers should clear its own message.
    const unsubProducts = watchProducts(
      storeId,
      (next) => {
        setProducts(next);
        setLoadError(null);
      },
      (error) => setLoadError(error.message),
    );
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

  const passesFilters = (product: Product) => {
    if (categoryFilter !== ALL && !product.categoryIds.includes(categoryFilter))
      return false;
    if (brandFilter !== ALL) {
      if (brandFilter === NO_BRAND) {
        if (product.brandId !== "") return false;
      } else if (product.brandId !== brandFilter) {
        return false;
      }
    }
    if (stockFilter === "in" && product.stock <= 0) return false;
    if (stockFilter === "out" && product.stock > 0) return false;
    return true;
  };

  const hasActiveFilter =
    categoryFilter !== ALL || brandFilter !== ALL || stockFilter !== "all";

  // Match on what the row actually shows — searching the description would
  // return rows with nothing visibly matching the query.
  const visible = applySort(
    products
      .filter(passesFilters)
      .filter((product) =>
        matchesSearch(
          search,
          product.name,
          brandName(product.brandId),
          ...product.categoryIds.map(categoryName),
        ),
      ),
    sort,
    PRODUCT_COMPARATORS,
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
        <div className="flex shrink-0 flex-wrap items-center justify-end gap-3">
          <Select value={categoryFilter} onValueChange={setCategoryFilter}>
            <SelectTrigger size="sm" aria-label="Filter by category">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ALL}>All categories</SelectItem>
              {categories.map((category) => (
                <SelectItem key={category.id} value={category.id}>
                  {category.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select value={brandFilter} onValueChange={setBrandFilter}>
            <SelectTrigger size="sm" aria-label="Filter by brand">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ALL}>All brands</SelectItem>
              <SelectItem value={NO_BRAND}>No brand</SelectItem>
              {brands.map((brand) => (
                <SelectItem key={brand.id} value={brand.id}>
                  {brand.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select
            value={stockFilter}
            onValueChange={(value) => setStockFilter(value as StockFilter)}
          >
            <SelectTrigger size="sm" aria-label="Filter by stock">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All stock</SelectItem>
              <SelectItem value="in">In stock</SelectItem>
              <SelectItem value="out">Out of stock</SelectItem>
            </SelectContent>
          </Select>
          <SearchField
            value={search}
            onChange={setSearch}
            label="Search products"
            placeholder="Search name, brand, category…"
          />
          {/* Not gated on categories the way "Add product" is: the CSV's
              `categories` column is optional, so an empty store can be
              bulk-loaded — and when a file does name categories, the import's
              per-row errors name exactly which ones to create, which beats a
              disabled button that explains nothing. */}
          <Button variant="outline" onClick={() => setImporting(true)}>
            Import CSV
          </Button>
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
            <SortableTableHead columnKey="name" sort={sort} onToggle={toggle}>
              Name
            </SortableTableHead>
            <TableHead>Brand</TableHead>
            <SortableTableHead columnKey="price" sort={sort} onToggle={toggle}>
              Price
            </SortableTableHead>
            <SortableTableHead columnKey="stock" sort={sort} onToggle={toggle}>
              Stock
            </SortableTableHead>
            <SortableTableHead
              columnKey="rating"
              sort={sort}
              onToggle={toggle}
              firstDirection="desc"
            >
              Rating
            </SortableTableHead>
            <TableHead>Categories</TableHead>
            <SortableTableHead
              columnKey="added"
              sort={sort}
              onToggle={toggle}
              firstDirection="desc"
            >
              Added
            </SortableTableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell
                colSpan={9}
                className={
                  loadError
                    ? "text-center text-destructive"
                    : "text-center text-muted-foreground"
                }
              >
                {loadError
                  ? `Couldn't load products: ${loadError}`
                  : search || hasActiveFilter
                    ? "No products match your filters."
                    : "No products yet."}
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
                  <span>{formatMoney(product.price, storeCurrency)}</span>
                  {product.discountPercentage > 0 && (
                    <span className="text-xs text-muted-foreground line-through">
                      {formatMoney(product.originalPrice, storeCurrency)}
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
              <TableCell className="text-muted-foreground">
                {/* 0 = doc predates the createdAt field (see Category.createdAtMs) */}
                {product.createdAtMs
                  ? new Date(product.createdAtMs).toLocaleDateString()
                  : "—"}
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
          currency={storeCurrency}
          storeId={storeId}
          product={editing === "new" ? null : editing}
          categories={categories}
          brands={brands}
          onClose={() => setEditing(null)}
        />
      )}

      {importing && (
        <ImportCsvDialog
          storeId={storeId}
          spec={(() => {
            const ctx = importContext(storeLanguage, storeCurrency, {
              products,
              categories,
              brands,
            });
            return {
              entity: "products" as const,
              entityPlural: "products",
              entitySingular: "product",
              matchOn: "product name",
              columns: PRODUCT_COLUMNS,
              sampleCsv: () => sampleProductCsv(ctx.seed, ctx.catalog),
              formats: ["cordelia", "shopify", "woocommerce", "meta"] as const,
              sampleLabel: ctx.sampleLabel,
              sampleSlug: ctx.sampleSlug,
            };
          })()}
          onClose={() => setImporting(false)}
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
                  await deleteRecord(storeId, "products", deleting.id);
                  toast.success("Product deleted");
                } catch (e) {
                  toast.error(e instanceof Error ? e.message : "Could not delete product");
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

