import { NextResponse } from "next/server";
import { addRecentSearch, removeRecentSearch } from "@/lib/recent-searches";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import type { RecentSearch, RecentSearchType } from "@/lib/types";

// Recent searches for the Search screen. The uid comes off a verified
// Firebase ID token, never a client-supplied `userId`. Both verbs return
// the updated list so the client can sync state from the response instead
// of refetching.

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
  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const item = body.item as Partial<RecentSearch> | undefined;

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

  const items = await addRecentSearch(uid, storeId, {
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
  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const searchParams = new URL(request.url).searchParams;
  const id = searchParams.get("id");
  const type = searchParams.get("type");

  if (!id || !isRecentSearchType(type)) {
    return NextResponse.json(
      { error: "id and type ('product' | 'category') are required" },
      { status: 400 },
    );
  }

  const items = await removeRecentSearch(uid, storeId, type, id);
  return NextResponse.json({ recent_searches: items });
}
