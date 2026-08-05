"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useStore } from "@/lib/store-context";
import { watchCategories } from "@/lib/categories";
import { watchProducts } from "@/lib/products";
import {
  watchCoupons,
  addCoupon,
  updateCoupon,
  deleteCoupon,
  type CouponInput,
} from "@/lib/coupons";
import type {
  Category,
  Coupon,
  CouponScope,
  CouponType,
  Product,
} from "@/lib/types";
import { COUPON_SCOPE_LABELS, couponTypeLabels } from "@/lib/types";
import { matchesSearch } from "@/lib/search";
import { currencySymbol, formatMoney } from "@/lib/money";
import {
  applySort,
  compareIsoDates,
  compareNumbers,
  compareText,
  type Comparator,
} from "@/lib/sort";
import { SearchField } from "@/components/search-field";
import {
  SortableTableHead,
  useTableSort,
} from "@/components/sortable-table-head";
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

function discountLabel(coupon: Coupon, currency: string): string {
  if (coupon.type === "flat") {
    return `${formatMoney(coupon.value, currency)} off`;
  }
  return coupon.maxDiscount > 0
    ? `${coupon.value}% off (max ${formatMoney(coupon.maxDiscount, currency)})`
    : `${coupon.value}% off`;
}

// ISO (stored) ↔ the browser's datetime-local value (local wall time).
function isoToLocalInput(iso: string): string {
  if (!iso) return "";
  const date = new Date(iso);
  const pad = (n: number) => String(n).padStart(2, "0");
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

function localInputToIso(value: string): string {
  return value ? new Date(value).toISOString() : "";
}

type CouponSortKey = "code" | "used" | "validUntil";

// The Discount column is deliberately not sortable — percent and flat values
// share no unit, so ordering by raw value would interleave "10% off" and
// a flat amount off meaninglessly.
const COUPON_COMPARATORS: Record<CouponSortKey, Comparator<Coupon>> = {
  code: (a, b) => compareText(a.code, b.code),
  used: (a, b) => compareNumbers(a.usedCount, b.usedCount),
  validUntil: (a, b) => compareIsoDates(a.validUntil, b.validUntil),
};

type StatusFilter = "all" | "active" | "inactive";

export default function CouponsPage() {
  const { storeId, storeCurrency } = useStore();
  const [coupons, setCoupons] = useState<Coupon[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [editing, setEditing] = useState<Coupon | "new" | null>(null);
  const [deleting, setDeleting] = useState<Coupon | null>(null);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<StatusFilter>("all");
  const { sort, toggle } = useTableSort<CouponSortKey>("code");

  useEffect(() => {
    if (!storeId) return;
    const unsubCoupons = watchCoupons(storeId, setCoupons);
    const unsubCategories = watchCategories(storeId, setCategories);
    const unsubProducts = watchProducts(storeId, setProducts);
    return () => {
      unsubCoupons();
      unsubCategories();
      unsubProducts();
    };
  }, [storeId]);

  if (!storeId) return null;

  const visible = applySort(
    coupons
      .filter(
        (coupon) =>
          statusFilter === "all" ||
          coupon.isActive === (statusFilter === "active"),
      )
      .filter((coupon) =>
        matchesSearch(
          search,
          coupon.code,
          discountLabel(coupon, storeCurrency),
          COUPON_SCOPE_LABELS[coupon.scope],
          coupon.isActive ? "Active" : "Inactive",
        ),
      ),
    sort,
    COUPON_COMPARATORS,
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-lg font-semibold">Coupons</h1>
          <p className="text-sm text-muted-foreground">
            Discount codes for the whole order, a category, or a product.
          </p>
        </div>
        <div className="flex shrink-0 flex-wrap items-center justify-end gap-3">
          <Select
            value={statusFilter}
            onValueChange={(value) => setStatusFilter(value as StatusFilter)}
          >
            <SelectTrigger size="sm" aria-label="Filter by status">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All statuses</SelectItem>
              <SelectItem value="active">Active</SelectItem>
              <SelectItem value="inactive">Inactive</SelectItem>
            </SelectContent>
          </Select>
          <SearchField
            value={search}
            onChange={setSearch}
            label="Search coupons"
            placeholder="Search code or status…"
          />
          <Button onClick={() => setEditing("new")}>Add coupon</Button>
        </div>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <SortableTableHead columnKey="code" sort={sort} onToggle={toggle}>
              Code
            </SortableTableHead>
            <TableHead>Discount</TableHead>
            <TableHead>Applies to</TableHead>
            <SortableTableHead
              columnKey="used"
              sort={sort}
              onToggle={toggle}
              firstDirection="desc"
            >
              Used
            </SortableTableHead>
            <SortableTableHead
              columnKey="validUntil"
              sort={sort}
              onToggle={toggle}
            >
              Valid until
            </SortableTableHead>
            <TableHead>Status</TableHead>
            <TableHead className="w-32 text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {visible.length === 0 && (
            <TableRow>
              <TableCell colSpan={7} className="text-center text-muted-foreground">
                {search || statusFilter !== "all"
                  ? "No coupons match your filters."
                  : "No coupons yet."}
              </TableCell>
            </TableRow>
          )}
          {visible.map((coupon) => (
            <TableRow key={coupon.id}>
              <TableCell className="font-medium">{coupon.code}</TableCell>
              <TableCell>{discountLabel(coupon, storeCurrency)}</TableCell>
              <TableCell className="text-muted-foreground">
                {COUPON_SCOPE_LABELS[coupon.scope]}
                {coupon.scope !== "store" && ` (${coupon.targetIds.length})`}
              </TableCell>
              <TableCell className="text-muted-foreground">
                {coupon.usedCount}
                {coupon.usageLimit > 0 && ` / ${coupon.usageLimit}`}
              </TableCell>
              <TableCell className="text-muted-foreground">
                {coupon.validUntil
                  ? new Date(coupon.validUntil).toLocaleDateString()
                  : "No expiry"}
              </TableCell>
              <TableCell>
                {coupon.isActive ? (
                  <Badge>Active</Badge>
                ) : (
                  <Badge variant="secondary">Inactive</Badge>
                )}
              </TableCell>
              <TableCell className="text-right">
                <Button variant="ghost" size="sm" onClick={() => setEditing(coupon)}>
                  Edit
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-destructive"
                  onClick={() => setDeleting(coupon)}
                >
                  Delete
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {editing && (
        <CouponDialog
          currency={storeCurrency}
          storeId={storeId}
          coupon={editing === "new" ? null : editing}
          existingCoupons={coupons}
          categories={categories}
          products={products}
          onClose={() => setEditing(null)}
        />
      )}

      <AlertDialog open={!!deleting} onOpenChange={(open) => !open && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete &quot;{deleting?.code}&quot;?</AlertDialogTitle>
            <AlertDialogDescription>
              This can&apos;t be undone. Shoppers will no longer be able to apply
              this code; orders already placed with it are unaffected.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={async () => {
                if (!deleting) return;
                try {
                  await deleteCoupon(storeId, deleting.id);
                  toast.success("Coupon deleted");
                } catch {
                  toast.error("Could not delete coupon");
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

function CouponDialog({
  storeId,
  coupon,
  existingCoupons,
  categories,
  products,
  onClose,
  currency,
}: {
  storeId: string;
  coupon: Coupon | null;
  existingCoupons: Coupon[];
  categories: Category[];
  products: Product[];
  onClose: () => void;
  currency: string;
}) {
  const sign = currencySymbol(currency);
  const [code, setCode] = useState(coupon?.code ?? "");
  const [type, setType] = useState<CouponType>(coupon?.type ?? "percent");
  const [value, setValue] = useState(String(coupon?.value ?? ""));
  const [maxDiscount, setMaxDiscount] = useState(
    coupon && coupon.maxDiscount > 0 ? String(coupon.maxDiscount) : "",
  );
  const [scope, setScope] = useState<CouponScope>(coupon?.scope ?? "store");
  const [targetIds, setTargetIds] = useState<string[]>(coupon?.targetIds ?? []);
  const [minOrderValue, setMinOrderValue] = useState(
    coupon && coupon.minOrderValue > 0 ? String(coupon.minOrderValue) : "",
  );
  const [validFrom, setValidFrom] = useState(
    isoToLocalInput(coupon?.validFrom ?? ""),
  );
  const [validUntil, setValidUntil] = useState(
    isoToLocalInput(coupon?.validUntil ?? ""),
  );
  const [usageLimit, setUsageLimit] = useState(
    coupon && coupon.usageLimit > 0 ? String(coupon.usageLimit) : "",
  );
  const [perUserLimit, setPerUserLimit] = useState(
    coupon && coupon.perUserLimit > 0 ? String(coupon.perUserLimit) : "",
  );
  const [isActive, setIsActive] = useState(coupon?.isActive ?? true);
  const [submitting, setSubmitting] = useState(false);

  const targetOptions = scope === "product" ? products : categories;

  function toggleTarget(id: string) {
    setTargetIds((prev) =>
      prev.includes(id) ? prev.filter((t) => t !== id) : [...prev, id],
    );
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    const normalizedCode = code.trim().toUpperCase();
    const duplicate = existingCoupons.some(
      (c) => c.id !== coupon?.id && c.code === normalizedCode,
    );
    if (duplicate) {
      toast.error(`Code ${normalizedCode} already exists`);
      return;
    }
    const valueNum = Number(value);
    if (type === "percent" && (valueNum <= 0 || valueNum > 100)) {
      toast.error("Percentage must be between 1 and 100");
      return;
    }
    if (type === "flat" && valueNum <= 0) {
      toast.error("Amount must be greater than 0");
      return;
    }
    if (scope !== "store" && targetIds.length === 0) {
      toast.error(
        `Select at least one ${scope === "product" ? "product" : "category"}`,
      );
      return;
    }
    setSubmitting(true);
    try {
      const data: CouponInput = {
        code: normalizedCode,
        type,
        value: valueNum,
        scope,
        targetIds: scope === "store" ? [] : targetIds,
        minOrderValue: Number(minOrderValue) || 0,
        maxDiscount: type === "percent" ? Number(maxDiscount) || 0 : 0,
        validFrom: localInputToIso(validFrom),
        validUntil: localInputToIso(validUntil),
        usageLimit: Number(usageLimit) || 0,
        perUserLimit: Number(perUserLimit) || 0,
        isActive,
      };
      if (coupon) {
        await updateCoupon(storeId, coupon.id, data);
        toast.success("Coupon updated");
      } else {
        await addCoupon(storeId, data);
        toast.success("Coupon added");
      }
      onClose();
    } catch {
      toast.error("Could not save coupon");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{coupon ? "Edit coupon" : "Add coupon"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="coupon-code">Code</Label>
            <Input
              id="coupon-code"
              required
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              placeholder="e.g. WELCOME10"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-type">Discount type</Label>
              <Select value={type} onValueChange={(v) => setType(v as CouponType)}>
                <SelectTrigger id="coupon-type">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {Object.entries(couponTypeLabels(sign)).map(([v, label]) => (
                    <SelectItem key={v} value={v}>
                      {label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-value">
                {type === "percent" ? "Percent off" : `Amount off (${sign})`}
              </Label>
              <Input
                id="coupon-value"
                required
                type="number"
                min="0"
                step="0.01"
                value={value}
                onChange={(e) => setValue(e.target.value)}
              />
            </div>
          </div>

          {type === "percent" && (
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-max-discount">
                Maximum discount ({sign}, optional)
              </Label>
              <Input
                id="coupon-max-discount"
                type="number"
                min="0"
                step="0.01"
                value={maxDiscount}
                onChange={(e) => setMaxDiscount(e.target.value)}
                placeholder="No cap if empty"
              />
            </div>
          )}

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="coupon-scope">Applies to</Label>
            <Select
              value={scope}
              onValueChange={(v) => {
                setScope(v as CouponScope);
                setTargetIds([]);
              }}
            >
              <SelectTrigger id="coupon-scope">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {Object.entries(COUPON_SCOPE_LABELS).map(([v, label]) => (
                  <SelectItem key={v} value={v}>
                    {label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {scope !== "store" && (
            <div className="flex flex-col gap-1.5">
              <Label>{scope === "product" ? "Products" : "Categories"}</Label>
              {targetOptions.length === 0 ? (
                <p className="text-sm text-muted-foreground">
                  You have no {scope === "product" ? "products" : "categories"} yet.
                </p>
              ) : (
                <div className="flex max-h-48 flex-col gap-2 overflow-y-auto rounded-md border border-border p-3">
                  {targetOptions.map((option) => (
                    <label key={option.id} className="flex items-center gap-2 text-sm">
                      <Checkbox
                        checked={targetIds.includes(option.id)}
                        onCheckedChange={() => toggleTarget(option.id)}
                      />
                      {option.name}
                    </label>
                  ))}
                </div>
              )}
            </div>
          )}

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="coupon-min-order">
              Minimum order value ({sign}, optional)
            </Label>
            <Input
              id="coupon-min-order"
              type="number"
              min="0"
              step="0.01"
              value={minOrderValue}
              onChange={(e) => setMinOrderValue(e.target.value)}
              placeholder="No minimum if empty"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-valid-from">Valid from (optional)</Label>
              <Input
                id="coupon-valid-from"
                type="datetime-local"
                value={validFrom}
                onChange={(e) => setValidFrom(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-valid-until">Valid until (optional)</Label>
              <Input
                id="coupon-valid-until"
                type="datetime-local"
                value={validUntil}
                onChange={(e) => setValidUntil(e.target.value)}
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-usage-limit">Total uses (optional)</Label>
              <Input
                id="coupon-usage-limit"
                type="number"
                min="0"
                step="1"
                value={usageLimit}
                onChange={(e) => setUsageLimit(e.target.value)}
                placeholder="Unlimited if empty"
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="coupon-per-user-limit">Uses per customer (optional)</Label>
              <Input
                id="coupon-per-user-limit"
                type="number"
                min="0"
                step="1"
                value={perUserLimit}
                onChange={(e) => setPerUserLimit(e.target.value)}
                placeholder="Unlimited if empty"
              />
            </div>
          </div>

          <label className="flex items-center gap-2 text-sm">
            <Checkbox
              checked={isActive}
              onCheckedChange={(checked) => setIsActive(checked === true)}
            />
            Active
          </label>

          <DialogFooter>
            <Button type="submit" disabled={submitting || !code.trim() || !value}>
              {submitting ? "Saving…" : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
