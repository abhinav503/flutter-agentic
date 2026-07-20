import { NextResponse } from "next/server";
import { addRecentSearch, removeRecentSearch } from "@/lib/recent-searches";
import type { RecentSearch, RecentSearchType } from "@/lib/types";

// Recent searches for the Search screen. `userId` is trusted as-is — the
// same shopper-auth gap as the cart routes, closed together when gravia
// sends a verified ID token. Both verbs return the updated list so the
// client can sync state from the response instead of refetching.

function isRecentSearchType(value: unknown): value is RecentSearchType {
  return value === "product" || value === "category";
}

// Body: { userId, item: {id, name, type} } — records the tapped search
// result; the server prepends, dedupes, and caps the list.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const body = await request.json().catch(() => ({}));
  const userId = body.userId as string | undefined;
  const item = body.item as Partial<RecentSearch> | undefined;

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }
  if (
    !item ||
    typeof item.id !== "string" ||
    !item.id ||
    typeof item.name !== "string" ||
    !item.name ||
    !isRecentSearchType(item.type)
  ) {
    return NextResponse.json(
      { error: "item must have id, name, and type ('product' | 'category')" },
      { status: 400 },
    );
  }

  const items = await addRecentSearch(userId, storeId, {
    id: item.id,
    name: item.name,
    type: item.type,
  });
  return NextResponse.json({ recent_searches: items });
}

export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const searchParams = new URL(request.url).searchParams;
  const userId = searchParams.get("userId");
  const id = searchParams.get("id");
  const type = searchParams.get("type");

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }
  if (!id || !isRecentSearchType(type)) {
    return NextResponse.json(
      { error: "id and type ('product' | 'category') are required" },
      { status: 400 },
    );
  }

  const items = await removeRecentSearch(userId, storeId, type, id);
  return NextResponse.json({ recent_searches: items });
}
