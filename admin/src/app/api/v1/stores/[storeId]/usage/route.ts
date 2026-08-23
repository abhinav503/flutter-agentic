import { NextResponse } from "next/server";
import { guardErrorResponse, requireStoreOwner } from "@/lib/api/admin-guard";
import { getApiUsage } from "@/lib/api/telemetry";

// Owner-only: what the programmable surface did to this store lately.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    return guardErrorResponse(e);
  }
  const days = Math.min(90, Math.max(1, Number(new URL(request.url).searchParams.get("days")) || 30));
  return NextResponse.json(await getApiUsage(storeId, days));
}
