import { NextResponse } from "next/server";
import { exchangeCode, OAuthError, refreshTokens } from "@/lib/oauth";
import {
  clientIp,
  consumeSharedRateLimit,
  OAUTH_TOKEN_LIMIT,
  RateLimitError,
  rateLimitResponse,
} from "@/lib/api/rate-limit";

// RFC 6749 token endpoint, form-encoded as the spec requires (JSON is
// accepted too — some hosts send it). No client secret: PKCE binds the
// code to the host that started the flow.
export async function POST(request: Request) {
  try {
    await consumeSharedRateLimit(OAUTH_TOKEN_LIMIT, clientIp(request));
  } catch (e) {
    if (e instanceof RateLimitError) return rateLimitResponse(e);
    throw e;
  }
  const contentType = (request.headers.get("content-type") ?? "").split(";")[0].trim();
  let form: URLSearchParams;
  if (contentType === "application/json") {
    const body = await request.json().catch(() => ({}));
    form = new URLSearchParams(Object.entries(body).map(([k, v]) => [k, String(v)]));
  } else {
    form = new URLSearchParams(await request.text());
  }
  const noStore = { "Cache-Control": "no-store", Pragma: "no-cache" };
  try {
    const grant = form.get("grant_type");
    if (grant === "authorization_code") {
      return NextResponse.json(await exchangeCode(form), { headers: noStore });
    }
    if (grant === "refresh_token") {
      return NextResponse.json(await refreshTokens(form), { headers: noStore });
    }
    throw new OAuthError("unsupported_grant_type", "grant_type must be authorization_code or refresh_token");
  } catch (e) {
    if (e instanceof OAuthError) {
      return NextResponse.json(
        { error: e.code, error_description: e.message },
        { status: e.status, headers: noStore },
      );
    }
    throw e;
  }
}
