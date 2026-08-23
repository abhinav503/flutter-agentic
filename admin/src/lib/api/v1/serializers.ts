import {
  serializeBrand,
  serializeCategory,
  serializeProduct,
} from "@/lib/api/serializers";
import type { Banner, Brand, Category, Coupon, Product } from "@/lib/types";
import type { CatalogEntity } from "./catalog";

// The v1 read shape of each entity — the storefront's serializer plus the
// fields an owner or a machine caller needs that a shopper never sees
// (external ids, inactive flags, group names). Round-trips into PUT.

export function serializeCatalogRecord(
  entity: CatalogEntity,
  record: Product | Category | Brand | Coupon | Banner,
) {
  switch (entity) {
    case "products": {
      const p = record as Product;
      return {
        ...serializeProduct(p),
        description: p.description,
        category_ids: p.categoryIds,
        is_popular: p.isPopular,
        unit_value: p.unitValue,
        unit_type: p.unitType,
      };
    }
    case "categories": {
      const c = record as Category;
      return { ...serializeCategory(c), group_name: c.groupName, external_id: c.externalId };
    }
    case "brands": {
      const b = record as Brand;
      return { ...serializeBrand(b), external_id: b.externalId };
    }
    case "coupons": {
      const k = record as Coupon;
      return {
        id: k.id,
        code: k.code,
        type: k.type,
        value: k.value,
        scope: k.scope,
        target_ids: k.targetIds,
        min_order_value: k.minOrderValue,
        max_discount: k.maxDiscount,
        valid_from: k.validFrom,
        valid_until: k.validUntil,
        usage_limit: k.usageLimit,
        per_user_limit: k.perUserLimit,
        used_count: k.usedCount,
        is_active: k.isActive,
      };
    }
    case "banners": {
      const n = record as Banner;
      return {
        id: n.id,
        title: n.title,
        subtitle: n.subtitle,
        image: n.imageUrl,
        target_type: n.targetType,
        target_id: n.targetId,
        sort_order: n.sortOrder,
        is_active: n.isActive,
        background_color: n.backgroundColor,
      };
    }
  }
}
