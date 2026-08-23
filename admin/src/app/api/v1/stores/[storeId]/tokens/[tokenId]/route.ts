import { NextResponse } from "next/server";
import {
  guardErrorResponse,
  requireStoreOwner,
} from "@/lib/api/admin-guard";
import { revokeApiToken } from "@/lib/api-tokens";

export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ storeId: string; tokenId: string }> },
) {
  const { storeId, tokenId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    return guardErrorResponse(e);
  }
  const found = await revokeApiToken(storeId, tokenId);
  if (!found) {
    return NextResponse.json({ error: "Token not found" }, { status: 404 });
  }
  return new NextResponse(null, { status: 204 });
}
