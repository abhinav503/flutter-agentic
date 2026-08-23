import { WebStandardStreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/webStandardStreamableHttp.js";
import { isApiToken, verifyApiToken } from "@/lib/api-tokens";
import { getClient, isOAuthAccessToken, verifyOAuthAccessToken } from "@/lib/oauth";
import { publicOrigin } from "@/lib/oauth-urls";
import { buildMcpServer, type McpActor } from "@/lib/mcp/server";

// The remote MCP endpoint — Streamable HTTP, stateless: every request
// carries its bearer, gets its own server instance, and nothing is held
// between calls, which is what lets it run on serverless. A request with
// no usable bearer answers 401 with the RFC 9728 pointer an MCP host
// follows to start the OAuth flow (claude.ai's "Add custom connector").
// A store token (cord_live_) is accepted too, for the stdio wrapper and
// scripts that would rather not do OAuth.

export const maxDuration = 60;

async function resolveActor(request: Request): Promise<McpActor | null> {
  const bearer = (request.headers.get("authorization") ?? "").match(/^Bearer (.+)$/)?.[1];
  if (!bearer) return null;
  if (isOAuthAccessToken(bearer)) {
    const grant = await verifyOAuthAccessToken(bearer);
    if (!grant) return null;
    const client = (await getClient(grant.clientId))?.clientName ?? grant.clientId;
    return { kind: "oauth", uid: grant.uid, email: grant.email, client, storeIds: grant.storeIds, scopes: grant.scopes };
  }
  if (isApiToken(bearer)) {
    const token = await verifyApiToken(bearer);
    return token
      ? { kind: "token", uid: token.createdBy, client: token.prefix, storeIds: [token.storeId], scopes: token.scopes }
      : null;
  }
  return null;
}

function unauthorized(request: Request): Response {
  const metadata = `${publicOrigin(request)}/.well-known/oauth-protected-resource`;
  return Response.json(
    { error: "unauthorized", error_description: "Connect with OAuth or send a store API token" },
    {
      status: 401,
      headers: {
        "WWW-Authenticate": `Bearer resource_metadata="${metadata}"`,
      },
    },
  );
}

async function handle(request: Request): Promise<Response> {
  const actor = await resolveActor(request);
  if (!actor) return unauthorized(request);
  const transport = new WebStandardStreamableHTTPServerTransport({
    // Stateless: no session id, so a host never has to resume one on a
    // different serverless instance.
    sessionIdGenerator: undefined,
    enableJsonResponse: true,
  });
  const server = buildMcpServer(actor);
  await server.connect(transport);
  return transport.handleRequest(request);
}

export async function POST(request: Request) {
  return handle(request);
}

export async function GET(request: Request) {
  return handle(request);
}

export async function DELETE(request: Request) {
  return handle(request);
}
