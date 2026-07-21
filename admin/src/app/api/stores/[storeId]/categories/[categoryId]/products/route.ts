import { NextResponse } from "next/server";
import { getProductsByCategory } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";

// Matches CategoryDetailsEntity in gravia — the product list shown when a
// shopper opens a category.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string; categoryId: string }> },
) {
  const { storeId, categoryId } = await params;
  const products = await getProductsByCategory(storeId, categoryId);
  return NextResponse.json({ products: products.map((p) => serializeProduct(p)) });
}
