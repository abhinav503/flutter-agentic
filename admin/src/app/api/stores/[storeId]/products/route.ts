import { NextResponse } from "next/server";
import { getProducts } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const products = await getProducts(storeId);
  return NextResponse.json({ products: products.map(serializeProduct) });
}
