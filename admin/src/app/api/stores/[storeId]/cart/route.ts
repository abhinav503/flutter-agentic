import { NextResponse } from "next/server";
import { getCartItems, saveCartItems } from "@/lib/cart";
import { getProduct } from "@/lib/products";
import { availableFor, resolveLine, variantLabel } from "@/lib/product-model";
import { serializeProduct } from "@/lib/api/serializers";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { CartItem, Product } from "@/lib/types";

// One joined line of the GET/PUT response. Every line carries what it
// resolved to: the variant (id + label, or none for a simple product), the
// per-unit prices the cart will charge, and `available` — the units this
// line can still buy (the variant's own stock on a v2 product, the
// product's otherwise; null = unlimited). size_value rides along for app
// builds that still identify a line by pack size.
function serializeCartLine(product: Product, item: CartItem) {
  const pricing = resolveLine(product, {
    variantId: item.variantId,
    sizeValue: item.sizeValue,
  });
  // A selection the product no longer offers: the line shows the product at
  // its own price and no variant — the checkout refusal, not the cart join,
  // is where "this option is gone" is reported with a code.
  const variant = pricing?.variant ?? null;
  const line: Record<string, unknown> = {
    product: serializeProduct(product),
    quantity: item.quantity,
    variant_id: variant?.id ?? "",
    variant_label: variant ? variantLabel(variant) : "",
    available: availableFor(product, variant),
  };
  if (pricing && variant) {
    line.unit_price = pricing.price;
    line.original_unit_price = pricing.originalPrice;
    if (variant.packSize > 0) line.size_value = variant.packSize;
  }
  return line;
}

// Only the selection and the count are stored — never a price, never a
// label; those are re-resolved from the live catalog on every read.
function normaliseCartItems(raw: unknown): CartItem[] | null {
  if (!Array.isArray(raw)) return null;
  const items: CartItem[] = [];
  for (const entry of raw) {
    if (!entry || typeof entry !== "object") return null;
    const e = entry as Record<string, unknown>;
    const productId = typeof e.productId === "string" ? e.productId : "";
    const quantity = Math.trunc(Number(e.quantity));
    if (!productId || !Number.isFinite(quantity) || quantity <= 0) return null;
    const item: CartItem = { productId, quantity };
    if (typeof e.variantId === "string" && e.variantId !== "") item.variantId = e.variantId;
    const sizeValue = Number(e.sizeValue);
    if (!item.variantId && Number.isFinite(sizeValue) && sizeValue > 0) item.sizeValue = sizeValue;
    items.push(item);
  }
  return items;
}

// The shopper's own cart. The uid always comes off a verified Firebase ID
// token (gravia sends `Authorization: Bearer <idToken>`), never a
// client-supplied `userId` — so one shopper can never read or overwrite
// another's cart.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const cartItems = await getCartItems(uid, storeId);
  const resolved = await Promise.all(
    cartItems.map(async (item) => {
      const product = await getProduct(storeId, item.productId);
      return product ? serializeCartLine(product, item) : null;
    }),
  );

  // A product deleted from the catalog after being added to a cart
  // silently drops out here rather than surfacing a broken line item.
  return NextResponse.json({ items: resolved.filter((i) => i !== null) });
}

export async function PUT(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json();
  const items = normaliseCartItems(body.items);

  if (!items) {
    return NextResponse.json(
      { error: "items must be an array of { productId, quantity, variantId? }" },
      { status: 400 },
    );
  }

  await saveCartItems(uid, storeId, items);

  const resolved = await Promise.all(
    items.map(async (item) => {
      const product = await getProduct(storeId, item.productId);
      return product ? serializeCartLine(product, item) : null;
    }),
  );
  return NextResponse.json({ items: resolved.filter((i) => i !== null) });
}
