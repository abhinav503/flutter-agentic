import { NextResponse } from "next/server";
import { getBrands } from "@/lib/brands";
import { serializeBrand } from "@/lib/api/serializers";

// Public like the categories route — brands are catalog data a storefront
// needs for labelling and filtering, not shopper-scoped state.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const brands = await getBrands(storeId);
  return NextResponse.json({ brands: brands.map(serializeBrand) });
}
