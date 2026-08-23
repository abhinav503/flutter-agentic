import { NextResponse } from "next/server";
import { API_TOKEN_SCOPES } from "@/lib/api-token-scopes";
import { publicOrigin } from "@/lib/oauth-urls";

// RFC 8414 — how an MCP host finds the endpoints below. Public clients
// only (PKCE is the secret), code + refresh grants, our three scopes.
export async function GET(request: Request) {
  const o = publicOrigin(request);
  return NextResponse.json(
    {
      issuer: o,
      authorization_endpoint: `${o}/oauth/authorize`,
      token_endpoint: `${o}/api/oauth/token`,
      registration_endpoint: `${o}/api/oauth/register`,
      response_types_supported: ["code"],
      grant_types_supported: ["authorization_code", "refresh_token"],
      code_challenge_methods_supported: ["S256"],
      token_endpoint_auth_methods_supported: ["none"],
      scopes_supported: [...API_TOKEN_SCOPES],
    },
    { headers: { "Cache-Control": "public, max-age=3600" } },
  );
}
