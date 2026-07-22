import { NextResponse } from "next/server";
import { getProducts, getPopularProducts } from "@/lib/products";
import { getCategories } from "@/lib/categories";
import { getRecentSearches } from "@/lib/recent-searches";
import { serializeCategory, serializeProduct } from "@/lib/api/serializers";
import { optionalAuthedUser } from "@/lib/api/admin-guard";

// No `q` param: matches SearchEntity's initial/empty-state shape in gravia
// (recent_searches + popular_products shown before the shopper types
// anything). recent_searches is per-shopper, keyed on the verified token's
// uid (optional here — a signed-out shopper can still open Search, they
// just have no recents); the catalog search itself needs no auth.
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
    const uid = await optionalAuthedUser(request);
    const [recents, popular] = await Promise.all([
      uid ? getRecentSearches(uid, storeId) : Promise.resolve([]),
      getPopularProducts(storeId),
    ]);
    return NextResponse.json({
      recent_searches: recents,
      popular_products: popular.map((p) => serializeProduct(p)),
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
      .map((p) => serializeProduct(p)),
    categories: allCategories
      .filter((c) => c.name.toLowerCase().includes(needle))
      .map(serializeCategory),
  });
}
