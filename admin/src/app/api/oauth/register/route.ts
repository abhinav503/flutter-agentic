import { NextResponse } from "next/server";
import { OAuthError, registerClient } from "@/lib/oauth";

// RFC 7591 dynamic client registration. Open, as the MCP spec expects —
// a client id is not a secret here; the redirect allow-list and PKCE are
// what bind a grant to the host that asked for it.
export async function POST(request: Request) {
  const body = await request.json().catch(() => null);
  if (!body || typeof body !== "object") {
    return NextResponse.json({ error: "invalid_request", error_description: "JSON body required" }, { status: 400 });
  }
  try {
    const client = await registerClient(body as Record<string, unknown>);
    return NextResponse.json(
      {
        client_id: client.clientId,
        client_name: client.clientName,
        redirect_uris: client.redirectUris,
        token_endpoint_auth_method: "none",
        grant_types: ["authorization_code", "refresh_token"],
        response_types: ["code"],
      },
      { status: 201 },
    );
  } catch (e) {
    if (e instanceof OAuthError) {
      return NextResponse.json({ error: e.code, error_description: e.message }, { status: e.status });
    }
    throw e;
  }
}
