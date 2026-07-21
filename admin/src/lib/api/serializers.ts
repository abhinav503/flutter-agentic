import type { Address, Category, Order, Product } from "@/lib/types";

// Shapes match gravia's existing mock JSON / *Model.fromJson() wire format
// exactly (apps/ecommerce/gravia/lib/feature/*/data/models/) — snake_case,
// `image` not `imageUrl` — so a future gravia data source pointed at this
// API needs zero model changes, only a data-source-impl swap.

export function serializeCategory(c: Category) {
  return { id: c.id, name: c.name, image: c.imageUrl };
}

// Matches AddressModel.fromJson() in gravia (feature/address/data/models/).
export function serializeAddress(a: Address) {
  return {
    id: a.id,
    name: a.name,
    phone: a.phone,
    address_line1: a.addressLine1,
    address_line2: a.addressLine2,
    landmark: a.landmark,
    city: a.city,
    country: a.country,
    postal_code: a.postalCode,
    tag: a.tag,
    is_default: a.isDefault,
  };
}

// isFavourite defaults false: it's per-shopper state, not a catalog
// property, and most callers of this serializer (home, categories, search,
// product details) don't resolve it per-uid — gravia cross-references its
// own FavouritesCubit instead of trusting this field there. Only the
// favourites endpoint itself passes a real value, since every item it
// returns is a favourite by definition.
export function serializeProduct(p: Product, isFavourite = false) {
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
    is_favourite: isFavourite,
  };
}

// Matches OrderModel.fromJson() in gravia (data/models/order_model.dart)
// exactly — status/placed_at/delivery_otp/items[] with product_name/weight/
// image/price/quantity — so a future OrdersRemoteDataSourceImpl swap needs
// no model changes, same intent as serializeProduct above. `status` is
// already one of gravia's OrderStatusParse wire strings, except PENDING,
// which that parser doesn't recognize yet and falls back to `inProcess`
// for — a safe degrade, not a crash, until gravia's enum grows a case for it.
export function serializeOrder(o: Order) {
  return {
    id: o.id,
    status: o.status,
    placed_at: o.placedAt,
    delivery_otp: o.deliveryOtp,
    total: o.total,
    items: o.items.map((item) => ({
      product_name: item.productName,
      weight: item.weight,
      image: item.image,
      price: item.price,
      quantity: item.quantity,
    })),
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
