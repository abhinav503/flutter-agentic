import { NextResponse } from "next/server";
import { API_TOKEN_SCOPES } from "@/lib/api-token-scopes";
import { publicOrigin } from "@/lib/oauth-urls";

// RFC 9728 — what /api/mcp's 401 points an MCP host at: which
// authorization server protects this resource.
export async function GET(request: Request) {
  const o = publicOrigin(request);
  return NextResponse.json(
    {
      resource: `${o}/api/mcp`,
      authorization_servers: [o],
      scopes_supported: [...API_TOKEN_SCOPES],
      bearer_methods_supported: ["header"],
    },
    { headers: { "Cache-Control": "public, max-age=3600" } },
  );
}
