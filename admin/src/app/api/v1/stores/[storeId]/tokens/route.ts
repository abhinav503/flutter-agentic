import { NextResponse } from "next/server";
import {
  guardErrorResponse,
  requireStoreOwner,
} from "@/lib/api/admin-guard";
import {
  consumeSharedRateLimit,
  RateLimitError,
  rateLimitResponse,
  TOKEN_MINT_LIMIT,
} from "@/lib/api/rate-limit";
import {
  ApiTokenError,
  createApiToken,
  listApiTokens,
  normaliseScopes,
  serializeApiToken,
} from "@/lib/api-tokens";

// Owner-only, by Firebase ID token — deliberately NOT requireStoreAccess:
// an API token must never be able to mint another, or a leaked
// catalog:write token would be a leaked everything.
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
  const tokens = await listApiTokens(storeId);
  return NextResponse.json({ tokens: tokens.map(serializeApiToken) });
}

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  let uid: string;
  try {
    uid = await requireStoreOwner(request, storeId);
  } catch (e) {
    return guardErrorResponse(e);
  }
  try {
    await consumeSharedRateLimit(TOKEN_MINT_LIMIT, uid);
  } catch (e) {
    if (e instanceof RateLimitError) return rateLimitResponse(e);
    throw e;
  }
  const body = await request.json().catch(() => ({}));
  const scopes = normaliseScopes(body.scopes);
  if (!scopes) {
    return NextResponse.json(
      { error: "scopes must be a non-empty array of known scopes" },
      { status: 400 },
    );
  }
  try {
    const { token, record } = await createApiToken(storeId, uid, {
      label: String(body.label ?? ""),
      scopes,
    });
    // The only response that ever carries the plaintext.
    return NextResponse.json(
      { token, record: serializeApiToken(record) },
      { status: 201 },
    );
  } catch (e) {
    if (e instanceof ApiTokenError) {
      return NextResponse.json({ error: e.message }, { status: e.status });
    }
    throw e;
  }
}
