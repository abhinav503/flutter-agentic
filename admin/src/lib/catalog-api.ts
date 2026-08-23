import { auth } from "@/lib/firebase";
import type { CatalogEntity } from "@/lib/api/v1/catalog";
import type { ImportFormatOrAuto, ImportReport } from "@/lib/api/v1/import";
import type { ProductInput } from "@/lib/products";
import type { Banner, Brand, Category } from "@/lib/types";
import type { CouponInput } from "@/lib/coupons";

export type { CatalogEntity } from "@/lib/api/v1/catalog";
export type { ImportFormat, ImportFormatOrAuto, ImportReport } from "@/lib/api/v1/import";

// The console's client for the v1 catalog routes — the same ones the CLI
// and a merchant's scripts use, so the console can't write anything they
// couldn't. Every call carries the owner's Firebase ID token; the server
// does all validation and answers with its own message, which these
// helpers surface unchanged.

export class CatalogApiError extends Error {
  constructor(
    message: string,
    public readonly status: number,
    public readonly errors: string[] = [],
  ) {
    super(message);
  }
}

// The signed-in owner, read at call time: the dialogs are only reachable
// signed in, and a session that expired mid-edit should fail the write
// loudly rather than fall back to anything.
function currentUser() {
  const user = auth.currentUser;
  if (!user) throw new CatalogApiError("You are signed out — sign in again to save.", 401);
  return user;
}

async function request<T>(
  method: "GET" | "POST" | "PUT" | "PATCH" | "DELETE",
  path: string,
  body?: unknown,
  contentType = "application/json",
): Promise<T> {
  const token = await currentUser().getIdToken();
  const res = await fetch(`/api/v1${path}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      ...(body === undefined ? {} : { "Content-Type": contentType }),
    },
    body:
      body === undefined
        ? undefined
        : contentType === "application/json"
          ? JSON.stringify(body)
          : (body as string),
  });
  if (res.status === 204) return undefined as T;
  const payload = await res.json().catch(() => ({}));
  if (!res.ok) {
    throw new CatalogApiError(
      (payload as { error?: string }).error ?? `Request failed (${res.status})`,
      res.status,
      (payload as { errors?: string[] }).errors ?? [],
    );
  }
  return payload as T;
}

type WriteResponse = { id: string; action: "created" | "updated" };

export function createRecord(
  storeId: string,
  entity: CatalogEntity,
  body: Record<string, unknown>,
) {
  return request<WriteResponse>("POST", `/stores/${storeId}/${entity}`, body);
}

export function updateRecord(
  storeId: string,
  entity: CatalogEntity,
  id: string,
  body: Record<string, unknown>,
) {
  return request<WriteResponse>("PATCH", `/stores/${storeId}/${entity}/${id}`, body);
}

export function deleteRecord(
  storeId: string,
  entity: CatalogEntity,
  id: string,
) {
  return request<void>("DELETE", `/stores/${storeId}/${entity}/${id}`);
}

export function importCsv(
  storeId: string,
  opts: {
    csv: string;
    entity: CatalogEntity;
    format: ImportFormatOrAuto;
    commit: boolean;
    createMissing?: boolean;
  },
) {
  const params = new URLSearchParams({
    entity: opts.entity,
    format: opts.format,
    commit: String(opts.commit),
  });
  if (opts.createMissing !== undefined) params.set("create_missing", String(opts.createMissing));
  return request<ImportReport>(
    "POST",
    `/stores/${storeId}/import?${params}`,
    opts.csv,
    "text/csv",
  );
}

export type SeedResult = {
  market: string;
  categories: number;
  brands: number;
  products: number;
  coupons: number;
  banners: number;
  total: number;
};

export function seedStore(storeId: string, market: string) {
  return request<SeedResult>("POST", `/stores/${storeId}/seed`, { market });
}

// --- form → wire --------------------------------------------------------------
// The dialogs still build the camelCase *Input the rest of the console types
// against; these turn one into the snake_case body the API takes. A field
// the form always sends is sent even when empty, so clearing it clears it.

export function productBody(data: ProductInput): Record<string, unknown> {
  return {
    name: data.name,
    description: data.description,
    images: data.images,
    external_id: data.externalId,
    sku: data.sku,
    barcode: data.barcode,
    price: data.price,
    original_price: data.originalPrice,
    stock: data.stock,
    unit_value: data.unitValue,
    unit_type: data.unitType,
    prep_time: data.prepTime,
    category_ids: data.categoryIds,
    brand_id: data.brandId,
    is_popular: data.isPopular,
    option_names: data.optionNames,
    variants: data.variants.map((v) => ({
      id: v.id,
      external_id: v.externalId,
      sku: v.sku,
      barcode: v.barcode,
      options: v.options,
      price: v.price,
      original_price: v.originalPrice,
      stock: v.stock,
      sell_when_out_of_stock: v.sellWhenOutOfStock,
      image: v.imageUrl,
      pack_size: v.packSize,
    })),
    attributes: data.attributes,
  };
}

export function categoryBody(data: Omit<Category, "id" | "createdAtMs">) {
  return {
    name: data.name,
    image: data.imageUrl,
    group_name: data.groupName,
    parent_id: data.parentId,
    external_id: data.externalId,
  };
}

export function brandBody(data: Omit<Brand, "id" | "createdAtMs">) {
  return { name: data.name, image: data.logoUrl, external_id: data.externalId };
}

export function couponBody(data: CouponInput) {
  return {
    code: data.code,
    type: data.type,
    value: data.value,
    scope: data.scope,
    target_ids: data.targetIds,
    min_order_value: data.minOrderValue,
    max_discount: data.maxDiscount,
    valid_from: data.validFrom,
    valid_until: data.validUntil,
    usage_limit: data.usageLimit,
    per_user_limit: data.perUserLimit,
    is_active: data.isActive,
  };
}

export function bannerBody(data: Omit<Banner, "id">) {
  return {
    title: data.title,
    subtitle: data.subtitle,
    image: data.imageUrl,
    target_type: data.targetType,
    target_id: data.targetId,
    sort_order: data.sortOrder,
    is_active: data.isActive,
    background_color: data.backgroundColor,
  };
}
