import { NextResponse } from "next/server";
import { getBrands } from "@/lib/brands";
import { getCategories } from "@/lib/categories";
import { getProduct, getProducts } from "@/lib/products";
import { getReviews } from "@/lib/reviews";
import {
  serializeBrand,
  serializeCategory,
  serializeProduct,
  serializeRatingSummary,
  serializeReview,
  serializeSizeVariant,
} from "@/lib/api/serializers";

// Enough to fill a product page's Reviews tab on arrival without paying for
// a long tail nobody scrolls to — the full list comes from the product's
// dedicated reviews route.
const REVIEW_PREVIEW_LIMIT = 10;

// Matches product_details.json's per-product shape in gravia — { product,
// images, description, size_options, similar_products }. This schema doesn't
// model a photo carousel yet, so `images` falls back to the single imageUrl;
// `size_options` (the "Select QTY" row) and `similar_products` (other products
// sharing a category) are both real, admin-driven data now, not stubs.
//
// `category` is this route's own addition (grofast draws a category badge
// under the product title): a product can carry several categoryIds, so it
// resolves the first one that still exists and returns null otherwise —
// nothing else in the payload names a category.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string; productId: string }> },
) {
  const { storeId, productId } = await params;
  const product = await getProduct(storeId, productId);
  if (!product) {
    return NextResponse.json({ error: "Product not found" }, { status: 404 });
  }

  const [allProducts, categories, brands, reviews] = await Promise.all([
    getProducts(storeId),
    getCategories(storeId),
    getBrands(storeId),
    getReviews(storeId, productId, REVIEW_PREVIEW_LIMIT),
  ]);
  const similarProducts = allProducts
    .filter(
      (p) =>
        p.id !== product.id &&
        p.categoryIds.some((id) => product.categoryIds.includes(id)),
    )
    .slice(0, 4);

  const category = categories.find((c) => product.categoryIds.includes(c.id));
  const brand = brands.find((b) => b.id === product.brandId);

  return NextResponse.json({
    product: serializeProduct(product),
    images: product.imageUrl ? [product.imageUrl] : [],
    description: product.description,
    // size_options stays alongside size_variants until every template's
    // "Select QTY" row reads per-variant pricing — same values, old shape.
    size_options: product.sizeOptions,
    size_variants: product.sizeVariants.map(serializeSizeVariant),
    similar_products: similarProducts.map((p) => serializeProduct(p)),
    category: category ? serializeCategory(category) : null,
    // null for unbranded (or a dangling brandId after a brand delete) —
    // resolved here like `category` above, never denormalized onto the doc.
    brand: brand ? serializeBrand(brand) : null,
    // The rating header plus the first page of reviews, so a details screen
    // opens its Reviews tab with no second round trip. `rating.count` 0 is
    // an unrated product — clients render an empty state, not 0.0 stars.
    rating: serializeRatingSummary(product),
    reviews: reviews.map(serializeReview),
  });
}
