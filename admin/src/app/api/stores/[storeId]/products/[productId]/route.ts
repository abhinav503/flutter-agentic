import { NextResponse } from "next/server";
import { getProduct, getProducts } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";

// Matches product_details.json's per-product shape in gravia — { product,
// images, description, size_options, similar_products }. This schema
// doesn't model a photo carousel or selectable sizes yet, so `images` falls
// back to the single imageUrl and `size_options` is empty; `similar_products`
// is a real computation (other products sharing a category), not a stub.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string; productId: string }> },
) {
  const { storeId, productId } = await params;
  const product = await getProduct(storeId, productId);
  if (!product) {
    return NextResponse.json({ error: "Product not found" }, { status: 404 });
  }

  const allProducts = await getProducts(storeId);
  const similarProducts = allProducts
    .filter(
      (p) =>
        p.id !== product.id &&
        p.categoryIds.some((id) => product.categoryIds.includes(id)),
    )
    .slice(0, 4);

  return NextResponse.json({
    product: serializeProduct(product),
    images: product.imageUrl ? [product.imageUrl] : [],
    description: product.description,
    size_options: [],
    similar_products: similarProducts.map(serializeProduct),
  });
}
