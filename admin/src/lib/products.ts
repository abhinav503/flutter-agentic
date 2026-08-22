import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  getCountFromServer,
  getDocs,
  getDoc,
  query,
  where,
  serverTimestamp,
  type QueryDocumentSnapshot,
  type Timestamp,
  type FirestoreError,
} from "firebase/firestore";

import { watchQuery } from "./watch";
import { db } from "./firebase";
import {
  EMPTY_RATING_BUCKETS,
  type Product,
  type RatingBuckets,
  type SizeVariant,
  type UnitType,
} from "./types";

function productsRef(storeId: string) {
  return collection(db, "stores", storeId, "products");
}

// The price a pack size implies when it has no admin-entered one: the base
// price scaled linearly by size (₹100 per 500g → ₹200 for 1000g). Used to
// upgrade legacy sizeOptions-only docs on read and to prefill new variant
// rows in the form; the admin can always override it.
export function scalePriceToSize(
  basePrice: number,
  unitValue: number,
  sizeValue: number,
): number {
  if (unitValue <= 0 || sizeValue <= 0) return basePrice;
  return Math.round((basePrice * sizeValue) / unitValue * 100) / 100;
}

export type ResolvedLinePricing = {
  price: number;
  originalPrice: number;
  // The pack size actually sold — sizeValue when one was selected, the
  // product's own unitValue otherwise. What an order line's weight label
  // formats.
  packSize: number;
};

// The single price authority for a cart/order line — the cart join, the
// payment intent, and the order transaction all resolve a (product,
// sizeValue) through here, so what the shopper sees, is charged, and is
// recorded can never disagree. No sizeValue = the base pack; a sizeValue
// with no matching variant (admin removed the size after it was carted)
// degrades to the linearly-scaled price rather than failing the line.
export function resolveLinePricing(
  product: Pick<
    Product,
    "price" | "originalPrice" | "unitValue" | "sizeVariants"
  >,
  sizeValue?: number,
): ResolvedLinePricing {
  if (!sizeValue || sizeValue <= 0) {
    return {
      price: product.price,
      originalPrice: product.originalPrice,
      packSize: product.unitValue,
    };
  }
  const variant = product.sizeVariants.find((v) => v.value === sizeValue);
  if (variant) {
    return {
      price: variant.price,
      originalPrice: variant.originalPrice,
      packSize: variant.value,
    };
  }
  return {
    price: scalePriceToSize(product.price, product.unitValue, sizeValue),
    originalPrice: scalePriceToSize(
      product.originalPrice,
      product.unitValue,
      sizeValue,
    ),
    packSize: sizeValue,
  };
}

function mapProductDoc(d: QueryDocumentSnapshot): Product {
  const data = d.data();
  const price = (data.price as number) ?? 0;
  const originalPrice = (data.originalPrice as number) ?? 0;
  const unitValue = (data.unitValue as number) ?? 0;
  const sizeOptions = (data.sizeOptions as number[]) ?? [];
  // Docs written before per-size pricing carry only sizeOptions — surface
  // them as variants at the linearly-scaled price so the form (and later the
  // storefront) sees one shape; the upgrade persists on the next save.
  const sizeVariants =
    (data.sizeVariants as SizeVariant[]) ??
    sizeOptions.map((value) => ({
      value,
      price: scalePriceToSize(price, unitValue, value),
      originalPrice: scalePriceToSize(originalPrice, unitValue, value),
    }));
  return {
    id: d.id,
    name: (data.name as string) ?? "",
    imageUrl: (data.imageUrl as string) ?? "",
    price,
    originalPrice,
    discountPercentage: (data.discountPercentage as number) ?? 0,
    unitValue,
    unitType: (data.unitType as UnitType) ?? "g",
    prepTime: (data.prepTime as string) ?? "",
    description: (data.description as string) ?? "",
    stock: (data.stock as number) ?? 0,
    categoryIds: (data.categoryIds as string[]) ?? [],
    brandId: (data.brandId as string) ?? "",
    sizeOptions,
    sizeVariants,
    isPopular: (data.isPopular as boolean) ?? false,
    // A product with no reviews yet (or one created before reviews existed)
    // carries no aggregate fields — zeros here, and every surface renders
    // "no ratings" from count 0 rather than a misleading 0.0 stars.
    ratingAverage: (data.ratingAverage as number) ?? 0,
    reviewCount: (data.reviewCount as number) ?? 0,
    ratingBuckets: (data.ratingBuckets as RatingBuckets) ?? EMPTY_RATING_BUCKETS,
    createdAtMs:
      (data.createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
  };
}

// Derived, not admin-entered — keeps price/originalPrice/discountPercentage
// from ever disagreeing with each other in Firestore.
export function computeDiscountPercentage(
  price: number,
  originalPrice: number,
): number {
  if (originalPrice <= 0 || price >= originalPrice) return 0;
  return Math.round(((originalPrice - price) / originalPrice) * 100);
}

export function watchProducts(
  storeId: string,
  onChange: (products: Product[]) => void,
  onError?: (error: FirestoreError) => void,
) {
  return watchQuery(productsRef(storeId), (snap) => snap.docs.map(mapProductDoc), onChange, onError);
}

// One-shot fetches for server contexts (API routes) — no live listener held open.
export async function getProducts(storeId: string): Promise<Product[]> {
  const snap = await getDocs(productsRef(storeId));
  return snap.docs.map(mapProductDoc);
}

// An aggregation query — one read, whatever the catalog's size. For callers
// that only need to know whether the store is empty (the seeder's
// already-has-data warning), not what is in it.
export async function countProducts(storeId: string): Promise<number> {
  const snap = await getCountFromServer(productsRef(storeId));
  return snap.data().count;
}

export async function getPopularProducts(storeId: string): Promise<Product[]> {
  const q = query(productsRef(storeId), where("isPopular", "==", true));
  const snap = await getDocs(q);
  return snap.docs.map(mapProductDoc);
}

export async function getProductsByCategory(
  storeId: string,
  categoryId: string,
): Promise<Product[]> {
  const q = query(
    productsRef(storeId),
    where("categoryIds", "array-contains", categoryId),
  );
  const snap = await getDocs(q);
  return snap.docs.map(mapProductDoc);
}

export async function getProduct(
  storeId: string,
  productId: string,
): Promise<Product | null> {
  const snap = await getDoc(doc(db, "stores", storeId, "products", productId));
  if (!snap.exists()) return null;
  return mapProductDoc(snap as QueryDocumentSnapshot);
}

// The rating aggregates are deliberately not accepted here — they belong to
// the review transaction (Admin SDK), never the dashboard form, exactly as
// CouponInput excludes usedCount. addProduct omits them entirely so a new
// product starts unrated by absence, and mapProductDoc's defaults answer.
export type ProductInput = Omit<
  Product,
  "id" | "ratingAverage" | "reviewCount" | "ratingBuckets" | "createdAtMs"
>;

export async function addProduct(storeId: string, data: ProductInput) {
  await addDoc(productsRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateProduct(
  storeId: string,
  id: string,
  data: ProductInput,
) {
  await updateDoc(doc(db, "stores", storeId, "products", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteProduct(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "products", id));
}
