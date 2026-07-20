import { NextResponse } from "next/server";
import { getProducts, getPopularProducts } from "@/lib/products";
import { getCategories } from "@/lib/categories";
import { getRecentSearches } from "@/lib/recent-searches";
import { serializeCategory, serializeProduct } from "@/lib/api/serializers";

// No `q` param: matches SearchEntity's initial/empty-state shape in gravia
// (recent_searches + popular_products shown before the shopper types
// anything). recent_searches is per-shopper (`userId`, trusted as-is —
// same gap as the cart routes until gravia sends a verified token); without
// a userId there's nothing to look up, so it's empty.
//
// With `q`: returns matching products AND categories by case-insensitive
// name search — Firestore has no native text search, and the catalog is
// small enough that fetch-all-then-filter is the right tradeoff over
// standing up a dedicated search index (Algolia/Typesense) this early.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const searchParams = new URL(request.url).searchParams;
  const q = searchParams.get("q")?.trim();

  if (!q) {
    const userId = searchParams.get("userId");
    const [recents, popular] = await Promise.all([
      userId ? getRecentSearches(userId, storeId) : Promise.resolve([]),
      getPopularProducts(storeId),
    ]);
    return NextResponse.json({
      recent_searches: recents,
      popular_products: popular.map(serializeProduct),
    });
  }

  const needle = q.toLowerCase();
  const [allProducts, allCategories] = await Promise.all([
    getProducts(storeId),
    getCategories(storeId),
  ]);
  return NextResponse.json({
    products: allProducts
      .filter((p) => p.name.toLowerCase().includes(needle))
      .map(serializeProduct),
    categories: allCategories
      .filter((c) => c.name.toLowerCase().includes(needle))
      .map(serializeCategory),
  });
}
