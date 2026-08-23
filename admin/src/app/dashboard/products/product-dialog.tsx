"use client";

import { useState, type FormEvent } from "react";
import { toast } from "sonner";
import { computeDiscountPercentage, type ProductInput } from "@/lib/products";
import { createRecord, updateRecord, productBody } from "@/lib/catalog-api";
import type { Brand, Category, Product, UnitType, Variant } from "@/lib/types";
import { MAX_OPTION_AXES, UNIT_TYPE_LABELS } from "@/lib/types";
import { categoryPath } from "@/lib/categories";
import {
  findRestrictedTerms,
  restrictedProductMessage,
} from "@/lib/restricted-products";
import { currencySymbol } from "@/lib/money";
import { ImageUploadField } from "@/components/image-upload-field";
import { ExternalIdField } from "@/components/external-id-field";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
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
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";

// Select refuses "" as an item value, so "no brand" needs its own token.
const NO_BRAND = "none";

// Form-local rows — strings because they're bound to inputs.
type VariantRow = {
  id: string;
  options: string[];
  price: string;
  originalPrice: string;
  stock: string;
  sku: string;
  barcode: string;
  packSize: string;
};

type AttributeRow = { key: string; value: string };

// The pre-v2 prepTime field surfaces as this attribute row, so the form has
// one spec-list editor; it is written back to prepTime on save for the
// storefront builds that still read it.
const PREP_TIME_ATTRIBUTE = "Prep time";

function newVariantId(): string {
  return `v-${Math.random().toString(36).slice(2, 10)}`;
}

const OPTION_NAME_HINTS = ["e.g. Size", "e.g. Colour", "e.g. Material"];
const OPTION_VALUE_HINTS = ["e.g. M", "e.g. Red", "e.g. Cotton"];

export function ProductDialog({
  storeId,
  product,
  categories,
  brands,
  onClose,
  currency,
}: {
  storeId: string;
  product: Product | null;
  categories: Category[];
  brands: Brand[];
  onClose: () => void;
  currency: string;
}) {
  const sign = currencySymbol(currency);
  const [name, setName] = useState(product?.name ?? "");
  const [images, setImages] = useState<string[]>(
    product?.images.length ? product.images : [""],
  );
  const [price, setPrice] = useState(String(product?.price ?? ""));
  const [originalPrice, setOriginalPrice] = useState(
    String(product?.originalPrice ?? ""),
  );
  const [stock, setStock] = useState(String(product?.stock ?? ""));
  const [sku, setSku] = useState(product?.sku ?? "");
  const [barcode, setBarcode] = useState(product?.barcode ?? "");
  const [externalId, setExternalId] = useState(product?.externalId ?? "");
  const [unitValue, setUnitValue] = useState(
    product?.unitValue ? String(product.unitValue) : "",
  );
  const [unitType, setUnitType] = useState<UnitType>(product?.unitType ?? "g");
  const [description, setDescription] = useState(product?.description ?? "");
  const [categoryIds, setCategoryIds] = useState<string[]>(
    product?.categoryIds ?? [],
  );
  const [brandId, setBrandId] = useState(product?.brandId || NO_BRAND);
  const [isPopular, setIsPopular] = useState(product?.isPopular ?? false);
  const [optionNames, setOptionNames] = useState<string[]>(
    product?.optionNames ?? [],
  );
  const [variants, setVariants] = useState<VariantRow[]>(
    (product?.variants ?? []).map((v) => ({
      id: v.id,
      options: v.options,
      price: String(v.price),
      originalPrice: v.originalPrice === v.price ? "" : String(v.originalPrice),
      stock: String(v.stock),
      sku: v.sku,
      barcode: v.barcode,
      packSize: v.packSize > 0 ? String(v.packSize) : "",
    })),
  );
  const [attributes, setAttributes] = useState<AttributeRow[]>(() => {
    const rows = Object.entries(product?.attributes ?? {}).map(
      ([key, value]) => ({ key, value }),
    );
    if (
      product?.prepTime &&
      !rows.some((r) => r.key.toLowerCase() === PREP_TIME_ATTRIBUTE.toLowerCase())
    ) {
      rows.push({ key: PREP_TIME_ATTRIBUTE, value: product.prepTime });
    }
    return rows;
  });
  const [submitting, setSubmitting] = useState(false);

  const hasVariants = optionNames.length > 0;

  function setVariantField(
    index: number,
    field: Exclude<keyof VariantRow, "options" | "id">,
    raw: string,
  ) {
    setVariants((prev) =>
      prev.map((row, i) => (i === index ? { ...row, [field]: raw } : row)),
    );
  }

  function setVariantOption(index: number, axis: number, raw: string) {
    setVariants((prev) =>
      prev.map((row, i) => {
        if (i !== index) return row;
        const options = [...row.options];
        while (options.length < optionNames.length) options.push("");
        options[axis] = raw;
        return { ...row, options };
      }),
    );
  }

  function addOptionAxis() {
    if (optionNames.length >= MAX_OPTION_AXES) return;
    setOptionNames((prev) => [...prev, ""]);
    // The first axis turns a simple product into one with variants; seed a
    // row from the product's own numbers so nothing already typed is lost.
    if (optionNames.length === 0 && variants.length === 0) {
      setVariants([
        {
          id: newVariantId(),
          options: [""],
          price,
          originalPrice,
          stock,
          sku,
          barcode,
          packSize: "",
        },
      ]);
    }
  }

  function removeOptionAxis(axis: number) {
    const next = optionNames.filter((_, i) => i !== axis);
    setOptionNames(next);
    if (next.length === 0) {
      // Back to a simple product: keep the first variant's numbers as the
      // product's own so the admin doesn't retype them.
      const first = variants[0];
      if (first) {
        setPrice(first.price);
        setOriginalPrice(first.originalPrice);
        setStock(first.stock);
        setSku(first.sku);
        setBarcode(first.barcode);
      }
      setVariants([]);
      return;
    }
    setVariants((prev) =>
      prev.map((row) => ({
        ...row,
        options: row.options.filter((_, i) => i !== axis),
      })),
    );
  }

  function addVariantRow() {
    setVariants((prev) => [
      ...prev,
      {
        id: newVariantId(),
        options: optionNames.map(() => ""),
        price: "",
        originalPrice: "",
        stock: "",
        sku: "",
        barcode: "",
        packSize: "",
      },
    ]);
  }

  function toggleCategory(id: string) {
    setCategoryIds((prev) =>
      prev.includes(id) ? prev.filter((c) => c !== id) : [...prev, id],
    );
  }

  // Returns the cleaned variants, or a message explaining why the form can't
  // be saved yet.
  function validateVariants(
    cleanOptionNames: string[],
  ): { variants: Variant[] } | { error: string } {
    if (cleanOptionNames.length === 0) return { variants: [] };
    if (cleanOptionNames.some((n) => n === "")) {
      return { error: "Every option needs a name (e.g. Size, Colour)" };
    }
    const cleaned: Variant[] = variants.map((row) => {
      const rowPrice = Number(row.price);
      return {
        id: row.id,
        externalId: "",
        sku: row.sku.trim(),
        barcode: row.barcode.trim(),
        options: cleanOptionNames.map((_, i) => (row.options[i] ?? "").trim()),
        price: rowPrice,
        originalPrice: Number(row.originalPrice) || rowPrice,
        stock: Math.max(0, Math.trunc(Number(row.stock) || 0)),
        sellWhenOutOfStock: false,
        imageUrl: "",
        packSize: Math.max(0, Number(row.packSize) || 0),
      };
    });
    if (cleaned.length === 0) {
      return { error: "Add at least one variant, or remove the options" };
    }
    if (cleaned.some((v) => !(v.price > 0) || v.options.some((o) => o === ""))) {
      return { error: "Every variant needs a value for each option and a price" };
    }
    const labels = new Set<string>();
    for (const v of cleaned) {
      const label = v.options.join(" ");
      if (labels.has(label)) {
        return { error: `Two variants are both "${v.options.join(" / ")}"` };
      }
      labels.add(label);
    }
    return { variants: cleaned };
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    if (categoryIds.length === 0) {
      toast.error("Select at least one category");
      return;
    }
    // Refused here rather than only at publish, so the owner learns the rule
    // on the product that broke it instead of on a checklist weeks later.
    const restricted = findRestrictedTerms(name, description);
    if (restricted.length > 0) {
      toast.error(restrictedProductMessage(restricted));
      return;
    }
    const cleanOptionNames = optionNames.map((n) => n.trim());
    const validated = validateVariants(cleanOptionNames);
    if ("error" in validated) {
      toast.error(validated.error);
      return;
    }
    const cleanAttributes: Record<string, string> = {};
    for (const row of attributes) {
      const key = row.key.trim();
      if (key === "" || row.value.trim() === "") continue;
      cleanAttributes[key] = row.value.trim();
    }
    const prepTimeKey = Object.keys(cleanAttributes).find(
      (k) => k.toLowerCase() === PREP_TIME_ATTRIBUTE.toLowerCase(),
    );

    setSubmitting(true);
    try {
      const priceNum = Number(price);
      const originalPriceNum = Number(originalPrice) || priceNum;
      const data: ProductInput = {
        name: name.trim(),
        imageUrl: "",
        images: images.map((u) => u.trim()).filter((u) => u !== ""),
        externalId: externalId.trim(),
        sku: hasVariants ? "" : sku.trim(),
        barcode: hasVariants ? "" : barcode.trim(),
        price: priceNum,
        originalPrice: originalPriceNum,
        discountPercentage: computeDiscountPercentage(priceNum, originalPriceNum),
        unitValue: Number(unitValue) || 0,
        unitType,
        prepTime: prepTimeKey ? cleanAttributes[prepTimeKey] : "",
        description: description.trim(),
        stock: Number(stock) || 0,
        categoryIds,
        brandId: brandId === NO_BRAND ? "" : brandId,
        optionNames: cleanOptionNames,
        variants: validated.variants,
        attributes: cleanAttributes,
        // Derived by finaliseProductInput on write, with imageUrl and the
        // summary fields; placeholders here only satisfy the type.
        sizeOptions: [],
        sizeVariants: [],
        isPopular,
      };
      if (product) {
        await updateRecord(storeId, "products", product.id, productBody(data));
        toast.success("Product updated");
      } else {
        await createRecord(storeId, "products", productBody(data));
        toast.success("Product added");
      }
      onClose();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not save product");
    } finally {
      setSubmitting(false);
    }
  }

  const variantGridCols = `repeat(${optionNames.length}, minmax(5rem, 1fr)) 5rem 5rem 4rem 5rem 2rem`;

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-2xl">
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

          <div className="flex flex-col gap-2">
            {images.map((url, index) => (
              <div key={index} className="flex items-end gap-2">
                <div className="flex-1">
                  <ImageUploadField
                    id={`product-image-${index}`}
                    label={index === 0 ? "Image" : `Image ${index + 1}`}
                    storeId={storeId}
                    kind="products"
                    value={url}
                    onChange={(next) =>
                      setImages((prev) =>
                        prev.map((u, i) => (i === index ? next : u)),
                      )
                    }
                  />
                </div>
                {index > 0 && (
                  <RemoveButton
                    label={`Remove image ${index + 1}`}
                    onClick={() =>
                      setImages((prev) => prev.filter((_, i) => i !== index))
                    }
                  />
                )}
              </div>
            ))}
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="self-start"
              onClick={() => setImages((prev) => [...prev, ""])}
            >
              Add image
            </Button>
          </div>

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

          {!hasVariants && (
            <>
              <div className="grid grid-cols-3 gap-4">
                <div className="flex flex-col gap-1.5">
                  <Label htmlFor="product-price">Price ({sign})</Label>
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
                    Original ({sign}, optional)
                  </Label>
                  <Input
                    id="product-original-price"
                    type="number"
                    min="0"
                    step="0.01"
                    value={originalPrice}
                    onChange={(e) => setOriginalPrice(e.target.value)}
                    placeholder="Same as price"
                  />
                </div>
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
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="flex flex-col gap-1.5">
                  <Label htmlFor="product-sku">SKU (optional)</Label>
                  <Input
                    id="product-sku"
                    value={sku}
                    onChange={(e) => setSku(e.target.value)}
                  />
                </div>
                <div className="flex flex-col gap-1.5">
                  <Label htmlFor="product-barcode">Barcode (optional)</Label>
                  <Input
                    id="product-barcode"
                    value={barcode}
                    onChange={(e) => setBarcode(e.target.value)}
                  />
                </div>
              </div>
            </>
          )}

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="product-unit-value">Package size (optional)</Label>
              <Input
                id="product-unit-value"
                type="number"
                min="0"
                step="0.01"
                value={unitValue}
                onChange={(e) => setUnitValue(e.target.value)}
                placeholder="e.g. 500 — empty for non-packaged goods"
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

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="product-description">Description</Label>
            <Textarea
              id="product-description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={3}
            />
          </div>

          <div className="flex flex-col gap-2 rounded-md border border-border p-3">
            <Label>Options &amp; variants</Label>
            <p className="text-xs text-muted-foreground">
              Add an option (Size, Colour, Pack) when the product comes in more
              than one choice. Each variant then has its own price and stock;
              the product&apos;s own price becomes the cheapest variant&apos;s.
            </p>
            {optionNames.map((optionName, axis) => (
              <div key={axis} className="flex items-center gap-2">
                <Input
                  value={optionName}
                  onChange={(e) =>
                    setOptionNames((prev) =>
                      prev.map((n, i) => (i === axis ? e.target.value : n)),
                    )
                  }
                  placeholder={OPTION_NAME_HINTS[axis]}
                  aria-label={`Option ${axis + 1} name`}
                />
                <RemoveButton
                  label={`Remove option ${axis + 1}`}
                  onClick={() => removeOptionAxis(axis)}
                />
              </div>
            ))}
            {optionNames.length < MAX_OPTION_AXES && (
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="self-start"
                onClick={addOptionAxis}
              >
                Add option
              </Button>
            )}

            {hasVariants && (
              <div className="flex flex-col gap-2 overflow-x-auto pt-2">
                <div
                  className="grid items-center gap-2 text-xs text-muted-foreground"
                  style={{ gridTemplateColumns: variantGridCols }}
                >
                  {optionNames.map((n, i) => (
                    <span key={i}>{n || `Option ${i + 1}`}</span>
                  ))}
                  <span>Price ({sign})</span>
                  <span>Original</span>
                  <span>Stock</span>
                  <span>Pack ({unitType})</span>
                  <span />
                </div>
                {variants.map((row, index) => {
                  const rowPrice = Number(row.price);
                  const rowOriginal = Number(row.originalPrice) || rowPrice;
                  const discount = computeDiscountPercentage(rowPrice, rowOriginal);
                  return (
                    <div key={row.id} className="flex flex-col gap-1">
                      <div
                        className="grid items-center gap-2"
                        style={{ gridTemplateColumns: variantGridCols }}
                      >
                        {optionNames.map((_, axis) => (
                          <Input
                            key={axis}
                            value={row.options[axis] ?? ""}
                            onChange={(e) =>
                              setVariantOption(index, axis, e.target.value)
                            }
                            placeholder={OPTION_VALUE_HINTS[axis]}
                            aria-label={`Variant ${index + 1} option ${axis + 1}`}
                          />
                        ))}
                        <Input
                          type="number"
                          min="0"
                          step="0.01"
                          value={row.price}
                          onChange={(e) => setVariantField(index, "price", e.target.value)}
                          aria-label={`Variant ${index + 1} price`}
                        />
                        <Input
                          type="number"
                          min="0"
                          step="0.01"
                          value={row.originalPrice}
                          onChange={(e) =>
                            setVariantField(index, "originalPrice", e.target.value)
                          }
                          placeholder={discount > 0 ? `${discount}% off` : "Same"}
                          aria-label={`Variant ${index + 1} original price`}
                        />
                        <Input
                          type="number"
                          min="0"
                          step="1"
                          value={row.stock}
                          onChange={(e) => setVariantField(index, "stock", e.target.value)}
                          aria-label={`Variant ${index + 1} stock`}
                        />
                        <Input
                          type="number"
                          min="0"
                          step="0.01"
                          value={row.packSize}
                          onChange={(e) => setVariantField(index, "packSize", e.target.value)}
                          placeholder="None"
                          aria-label={`Variant ${index + 1} pack size`}
                        />
                        <RemoveButton
                          label={`Remove variant ${index + 1}`}
                          onClick={() =>
                            setVariants((prev) => prev.filter((_, i) => i !== index))
                          }
                        />
                      </div>
                      <div className="grid grid-cols-2 gap-2">
                        <Input
                          value={row.sku}
                          onChange={(e) => setVariantField(index, "sku", e.target.value)}
                          placeholder="SKU (optional)"
                          aria-label={`Variant ${index + 1} SKU`}
                        />
                        <Input
                          value={row.barcode}
                          onChange={(e) => setVariantField(index, "barcode", e.target.value)}
                          placeholder="Barcode (optional)"
                          aria-label={`Variant ${index + 1} barcode`}
                        />
                      </div>
                    </div>
                  );
                })}
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  className="self-start"
                  onClick={addVariantRow}
                >
                  Add variant
                </Button>
              </div>
            )}
          </div>

          <div className="flex flex-col gap-2 rounded-md border border-border p-3">
            <Label>Details</Label>
            <p className="text-xs text-muted-foreground">
              Facts shown as a list on the product page (Material, Prep time,
              Country of origin). They never affect price or stock.
            </p>
            {attributes.map((row, index) => (
              <div key={index} className="grid grid-cols-[1fr_2fr_2rem] items-center gap-2">
                <Input
                  value={row.key}
                  onChange={(e) =>
                    setAttributes((prev) =>
                      prev.map((r, i) => (i === index ? { ...r, key: e.target.value } : r)),
                    )
                  }
                  placeholder="e.g. Material"
                  aria-label={`Detail ${index + 1} name`}
                />
                <Input
                  value={row.value}
                  onChange={(e) =>
                    setAttributes((prev) =>
                      prev.map((r, i) => (i === index ? { ...r, value: e.target.value } : r)),
                    )
                  }
                  placeholder="e.g. 100% cotton"
                  aria-label={`Detail ${index + 1} value`}
                />
                <RemoveButton
                  label={`Remove detail ${index + 1}`}
                  onClick={() =>
                    setAttributes((prev) => prev.filter((_, i) => i !== index))
                  }
                />
              </div>
            ))}
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="self-start"
              onClick={() => setAttributes((prev) => [...prev, { key: "", value: "" }])}
            >
              Add detail
            </Button>
          </div>

          <ExternalIdField
            id="product-external-id"
            value={externalId}
            onChange={setExternalId}
          />

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
                  {categoryPath(category, categories)}
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

function RemoveButton({ label, onClick }: { label: string; onClick: () => void }) {
  return (
    <Button
      type="button"
      variant="ghost"
      size="sm"
      className="text-destructive"
      onClick={onClick}
      aria-label={label}
    >
      ✕
    </Button>
  );
}
