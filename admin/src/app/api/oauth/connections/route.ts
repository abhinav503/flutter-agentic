import { NextResponse } from "next/server";
import { guardErrorResponse, requireAuthedUser } from "@/lib/api/admin-guard";
import { listConnectedApps, revokeGrantsFor } from "@/lib/oauth";

// The signed-in owner's connected apps (by Firebase ID token — an OAuth
// grant can't list or revoke grants). DELETE ?client_id=… disconnects one.
export async function GET(request: Request) {
  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    return guardErrorResponse(e);
  }
  const apps = await listConnectedApps(uid);
  return NextResponse.json({
    connections: apps.map((a) => ({
      client_id: a.clientId,
      client_name: a.clientName,
      scopes: a.scopes,
      store_ids: a.storeIds,
      connected_at: a.connectedAtMs ? new Date(a.connectedAtMs).toISOString() : "",
      last_used_at: a.lastUsedAtMs ? new Date(a.lastUsedAtMs).toISOString() : "",
    })),
  });
}

export async function DELETE(request: Request) {
  let uid: string;
  try {
    uid = (await requireAuthedUser(request)).uid;
  } catch (e) {
    return guardErrorResponse(e);
  }
  const clientId = new URL(request.url).searchParams.get("client_id") ?? "";
  if (!clientId) return NextResponse.json({ error: "client_id is required" }, { status: 400 });
  const revoked = await revokeGrantsFor(uid, clientId);
  return NextResponse.json({ revoked });
}
