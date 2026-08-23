/**
 * `npm run verify:product-model` — regression checks for the v2 product
 * model (lib/product-model.ts): the read-time upgrade of the three doc
 * generations, the summary derived from variants, and line resolution.
 *
 * Pure functions, no Firestore, non-zero exit on failure (see
 * verify-delivery.ts for why a script and not a test suite). Worth running
 * because the same upgrade runs in the dashboard mapper, the shopper API and
 * the order transaction — a product that reads differently in any one of
 * them is a price the shopper saw and wasn't charged.
 */
import {
  applyStock,
  availableFor,
  deriveProductSummary,
  formatPackSize,
  packSizeVariantId,
  resolveLine,
  upgradeProductData,
} from "@/lib/product-model";
import type { Variant } from "@/lib/types";

let failures = 0;
function check(label: string, actual: unknown, expected: unknown) {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (!ok) failures++;
  console.log(
    `${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n        got ${JSON.stringify(actual)} want ${JSON.stringify(expected)}`}`,
  );
}

function variant(over: Partial<Variant>): Variant {
  return {
    id: "v1",
    externalId: "",
    sku: "",
    barcode: "",
    options: [],
    price: 0,
    originalPrice: 0,
    stock: 0,
    sellWhenOutOfStock: false,
    imageUrl: "",
    packSize: 0,
    ...over,
  };
}

// --- formatPackSize -------------------------------------------------------
check("500 g", formatPackSize(500, "g"), "500 g");
check("1 kg", formatPackSize(1000, "g"), "1 kg");
check("1.5 L", formatPackSize(1500, "ml"), "1.5 L");
check("6 pcs never rolls up", formatPackSize(6000, "pcs"), "6000 pcs");

// --- generation 1: sizeOptions only ---------------------------------------
const gen1 = upgradeProductData({
  name: "Rice",
  price: 100,
  originalPrice: 120,
  unitValue: 500,
  unitType: "g",
  stock: 7,
  sizeOptions: [500, 1000],
});
check("gen1 option axis", gen1.optionNames, ["Size"]);
check(
  "gen1 variants scaled linearly with the product stock",
  gen1.variants.map((v) => [v.id, v.options, v.price, v.originalPrice, v.stock, v.packSize]),
  [
    [packSizeVariantId(500), ["500 g"], 100, 120, 7, 500],
    [packSizeVariantId(1000), ["1 kg"], 200, 240, 7, 1000],
  ],
);
check("gen1 keeps its own stock (packs share it)", gen1.stock, 7);
check("gen1 sizeVariants re-derived", gen1.sizeVariants, [
  { value: 500, price: 100, originalPrice: 120 },
  { value: 1000, price: 200, originalPrice: 240 },
]);
check("gen1 images from imageUrl", upgradeProductData({ imageUrl: "a.jpg" }).images, ["a.jpg"]);

// --- generation 2: sizeVariants --------------------------------------------
const gen2 = upgradeProductData({
  price: 100,
  originalPrice: 100,
  unitValue: 500,
  unitType: "ml",
  stock: 3,
  sizeOptions: [500, 750],
  sizeVariants: [
    { value: 500, price: 100, originalPrice: 100 },
    { value: 750, price: 140, originalPrice: 160 },
  ],
});
check("gen2 explicit prices win over scaling", gen2.variants.map((v) => v.price), [100, 140]);
check("gen2 labels in ml", gen2.variants.map((v) => v.options[0]), ["500 ml", "750 ml"]);
check("gen2 product price untouched", [gen2.price, gen2.discountPercentage], [100, 0]);

// --- simple product, no sizes ---------------------------------------------
const simple = upgradeProductData({ price: 50, originalPrice: 50, stock: 2 });
check("simple product has no axes", [simple.optionNames, simple.variants], [[], []]);
check("unknown unitType falls back to g", upgradeProductData({ unitType: "lb" }).unitType, "g");

// --- generation 3: v2 variants --------------------------------------------
const gen3 = upgradeProductData({
  name: "Tee",
  price: 999, // stale — must be re-derived from variants
  stock: 999,
  images: ["front.jpg", "back.jpg"],
  optionNames: ["Size", "Colour"],
  variants: [
    { id: "m-red", options: ["M", "Red"], price: 30, originalPrice: 40, stock: 2 },
    { id: "l-red", options: ["L", "Red"], price: 25, stock: 5, sellWhenOutOfStock: true },
    { price: "oops" }, // unparsable → dropped
  ],
  attributes: { Material: "Cotton", "": "ignored", Empty: null },
});
check("v2 imageUrl is images[0]", gen3.imageUrl, "front.jpg");
check("v2 summary = cheapest price, summed stock", [gen3.price, gen3.originalPrice, gen3.discountPercentage, gen3.stock], [25, 25, 0, 7]);
check("v2 variants normalised", gen3.variants.map((v) => [v.id, v.originalPrice, v.sellWhenOutOfStock]), [
  ["m-red", 40, false],
  ["l-red", 25, true],
]);
check("v2 no pack sizes → no legacy size shape", [gen3.sizeOptions, gen3.sizeVariants], [[], []]);
check("v2 attributes cleaned", gen3.attributes, { Material: "Cotton" });

const packs = upgradeProductData({
  optionNames: ["Size"],
  unitType: "g",
  variants: [
    { id: "b", options: ["1 kg"], price: 180, originalPrice: 200, stock: 1, packSize: 1000 },
    { id: "a", options: ["500 g"], price: 100, originalPrice: 100, stock: 4, packSize: 500 },
  ],
});
check("v2 pack variants re-derive sizeVariants smallest-first", packs.sizeVariants, [
  { value: 500, price: 100, originalPrice: 100 },
  { value: 1000, price: 180, originalPrice: 200 },
]);
check("v2 sizeOptions follow", packs.sizeOptions, [500, 1000]);

// --- deriveProductSummary -------------------------------------------------
check(
  "simple summary keeps entered numbers, originalPrice defaults to price",
  deriveProductSummary({ price: 10, originalPrice: 0, stock: 3 }, []),
  { price: 10, originalPrice: 10, discountPercentage: 0, stock: 3, sizeOptions: [], sizeVariants: [] },
);
check(
  "negative variant stock doesn't subtract",
  deriveProductSummary({ price: 0, originalPrice: 0, stock: 0 }, [
    variant({ price: 5, stock: -3 }),
    variant({ id: "v2", price: 9, stock: 2 }),
  ]).stock,
  2,
);

// --- resolveLine ----------------------------------------------------------
const product = {
  price: 25,
  originalPrice: 25,
  unitValue: 0,
  variants: gen3.variants,
  stockPerVariant: true,
};
check("by variantId", resolveLine(product, { variantId: "m-red" })?.price, 30);
check("unknown variantId refuses", resolveLine(product, { variantId: "gone" }), null);
check("no selection on a variant product = cheapest", resolveLine(product)?.variant?.id, "l-red");
check("by legacy sizeValue", resolveLine({ ...packs, unitValue: 500 }, { sizeValue: 1000 })?.price, 180);
check("unknown sizeValue refuses", resolveLine({ ...packs, unitValue: 500 }, { sizeValue: 250 }), null);
check(
  "simple product resolves to itself with its unitValue as pack",
  resolveLine({ price: 7, originalPrice: 9, unitValue: 250, variants: [], stockPerVariant: false }),
  { price: 7, originalPrice: 9, packSize: 250, variant: null },
);
check(
  "legacy sized product with no selection = its own pack, not a chip",
  resolveLine({ ...gen2, unitValue: 500 })?.variant,
  null,
);
check("gen2 is not stockPerVariant", gen2.stockPerVariant, false);
check("v2 with variants is stockPerVariant", gen3.stockPerVariant, true);

// --- applyStock -----------------------------------------------------------
const legacyDoc = { stock: 5, sizeVariants: [{ value: 500, price: 1, originalPrice: 1 }] };
check(
  "legacy: packs share one count, summed across lines",
  applyStock(legacyDoc, [{ variantId: packSizeVariantId(500), quantity: 2 }, { variantId: null, quantity: 1 }], -1),
  { update: { stock: 2 } },
);
check(
  "legacy: refusal reports the product's count",
  applyStock(legacyDoc, [{ variantId: null, quantity: 6 }], -1),
  { refusal: { variantId: null, available: 5 } },
);
const v2Doc = {
  price: 1,
  optionNames: ["Size"],
  variants: [
    { id: "s", options: ["S"], price: 10, stock: 1 },
    { id: "m", options: ["M"], price: 12, stock: 3, sellWhenOutOfStock: true },
  ],
};
const sold = applyStock(v2Doc, [{ variantId: "s", quantity: 1 }, { variantId: "m", quantity: 5 }], -1);
check(
  "v2: per-variant decrement, oversell allowed where flagged, product stock re-summed",
  "update" in sold ? [(sold.update.variants as Variant[]).map((v) => v.stock), sold.update.stock] : sold,
  [[0, 0], 0],
);
check(
  "v2: refusal names the variant and its count",
  applyStock(v2Doc, [{ variantId: "s", quantity: 2 }], -1),
  { refusal: { variantId: "s", available: 1 } },
);
check(
  "v2: unknown variant refused",
  applyStock(v2Doc, [{ variantId: "xl", quantity: 1 }], -1),
  { refusal: { variantId: "xl", available: 0 } },
);
check(
  "v2: restock adds back per variant",
  "update" in sold ? (applyStock({ ...v2Doc, variants: sold.update.variants }, [{ variantId: "s", quantity: 1 }], 1) as { update: { stock: number } }).update.stock : -1,
  1,
);
check(
  "v2 simple product (no variants) keeps product-level stock",
  applyStock({ variants: [], stock: 4 }, [{ variantId: null, quantity: 3 }], -1),
  { update: { stock: 1 } },
);
check("availableFor: legacy pack line reads product stock", availableFor(gen2, gen2.variants[0]), 3);
check("availableFor: v2 variant reads its own", availableFor(gen3, gen3.variants[0]), 2);
check("availableFor: sellWhenOutOfStock = unlimited", availableFor(gen3, gen3.variants[1]), null);

if (failures > 0) {
  console.error(`\n${failures} check(s) failed`);
  process.exit(1);
}
console.log("\nAll product-model checks passed");
