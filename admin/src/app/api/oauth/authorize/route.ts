import { NextResponse } from "next/server";
import { issueAuthorizationCode, OAuthError, validateAuthorizeRequest } from "@/lib/oauth";
import {
  clientIp,
  consumeSharedRateLimit,
  OAUTH_CONSENT_LIMIT,
  RateLimitError,
  rateLimitResponse,
} from "@/lib/api/rate-limit";

// Hosts whose consent screen gets a "verified" mark. Anyone may register a
// client named "Claude"; only a redirect back to one of these is actually
// Claude. The page shows the host either way, so an owner can tell.
const KNOWN_REDIRECT_HOSTS = [
  "claude.ai",
  "claude.com",
  "anthropic.com",
  "chatgpt.com",
  "openai.com",
  "cursor.com",
  "cursor.sh",
  "windsurf.com",
];

function redirectHostInfo(redirectUri: string) {
  const host = new URL(redirectUri).hostname;
  const known = KNOWN_REDIRECT_HOSTS.some((h) => host === h || host.endsWith(`.${h}`));
  const local = host === "localhost" || host === "127.0.0.1";
  return { redirect_host: host, known_host: known || local };
}

// The consent page's two calls. GET validates the host's query and tells
// the page what to show (client name, scopes); POST records the owner's
// decision and answers with the redirect the page should navigate to.
// The owner's identity is their Firebase ID token in the body — the page
// is signed in the same way every other console page is.
export async function GET(request: Request) {
  try {
    const req = await validateAuthorizeRequest(new URL(request.url).searchParams);
    return NextResponse.json({
      client_name: req.client.clientName,
      scopes: req.scopes,
      ...redirectHostInfo(req.redirectUri),
    });
  } catch (e) {
    if (e instanceof OAuthError) {
      return NextResponse.json({ error: e.code, error_description: e.message }, { status: e.status });
    }
    throw e;
  }
}

export async function POST(request: Request) {
  try {
    await consumeSharedRateLimit(OAUTH_CONSENT_LIMIT, clientIp(request));
  } catch (e) {
    if (e instanceof RateLimitError) return rateLimitResponse(e);
    throw e;
  }
  const body = await request.json().catch(() => ({}));
  const params = new URLSearchParams(typeof body.query === "string" ? body.query : "");
  try {
    const req = await validateAuthorizeRequest(params);
    const redirect = new URL(req.redirectUri);
    if (body.decision !== "allow") {
      redirect.searchParams.set("error", "access_denied");
      if (req.state) redirect.searchParams.set("state", req.state);
      return NextResponse.json({ redirect: redirect.toString() });
    }
    const code = await issueAuthorizationCode(
      req,
      String(body.id_token ?? ""),
      Array.isArray(body.store_ids) ? body.store_ids.map(String) : [],
    );
    redirect.searchParams.set("code", code);
    if (req.state) redirect.searchParams.set("state", req.state);
    return NextResponse.json({ redirect: redirect.toString() });
  } catch (e) {
    if (e instanceof OAuthError) {
      return NextResponse.json({ error: e.code, error_description: e.message }, { status: e.status });
    }
    throw e;
  }
}
