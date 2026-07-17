import type { Category, Product } from "@/lib/types";

// Shapes match gravia's existing mock JSON / *Model.fromJson() wire format
// exactly (apps/ecommerce/gravia/lib/feature/*/data/models/) — snake_case,
// `image` not `imageUrl` — so a future gravia data source pointed at this
// API needs zero model changes, only a data-source-impl swap.

export function serializeCategory(c: Category) {
  return { id: c.id, name: c.name, image: c.imageUrl };
}

export function serializeProduct(p: Product) {
  return {
    id: p.id,
    name: p.name,
    image: p.imageUrl,
    price: p.price,
    original_price: p.originalPrice,
    discount_percentage: p.discountPercentage,
    unit_value: p.unitValue,
    unit_type: p.unitType,
    prep_time: p.prepTime,
    // Per-shopper state, not a catalog property — no favorites model yet,
    // so this is always false from a catalog-read endpoint.
    is_favourite: false,
  };
}

export function groupCategories(categories: Category[]) {
  const groups = new Map<string, Category[]>();
  for (const category of categories) {
    const key = category.groupName || "Uncategorized";
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key)!.push(category);
  }
  return Array.from(groups.entries()).map(([name, categoriesInGroup]) => ({
    name,
    categories: categoriesInGroup.map(serializeCategory),
  }));
}
