import { NextResponse } from "next/server";
import { getPopularProducts } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";

// Filters on the admin-curated `isPopular` flag — matches home_page.json's
// `popular_products` key in gravia's mock data.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const products = await getPopularProducts(storeId);
  return NextResponse.json({ popular_products: products.map((p) => serializeProduct(p)) });
}
