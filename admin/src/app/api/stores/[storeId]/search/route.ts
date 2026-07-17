import { NextResponse } from "next/server";
import { getProducts, getPopularProducts } from "@/lib/products";
import { serializeProduct } from "@/lib/api/serializers";

// No `q` param: matches SearchEntity's initial/empty-state shape in gravia
// (recent_searches + popular_products shown before the shopper types
// anything). recent_searches is inherently per-shopper session state, not
// catalog data, so it's always empty from this stateless endpoint.
//
// With `q`: returns matching products by case-insensitive name search —
// Firestore has no native text search, and the catalog is small enough
// that fetch-all-then-filter is the right tradeoff over standing up a
// dedicated search index (Algolia/Typesense) this early.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const q = new URL(request.url).searchParams.get("q")?.trim();

  if (!q) {
    const popular = await getPopularProducts(storeId);
    return NextResponse.json({
      recent_searches: [],
      popular_products: popular.map(serializeProduct),
    });
  }

  const allProducts = await getProducts(storeId);
  const matches = allProducts.filter((p) =>
    p.name.toLowerCase().includes(q.toLowerCase()),
  );
  return NextResponse.json({ products: matches.map(serializeProduct) });
}
