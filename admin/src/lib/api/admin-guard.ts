import { isApiToken, verifyApiToken } from "@/lib/api-tokens";
import { isOAuthAccessToken, verifyOAuthAccessToken } from "@/lib/oauth";
import type { ApiTokenScope } from "@/lib/api-token-scopes";
import { adminAuth, adminDb } from "@/lib/firebase-admin";

export class UnauthorizedError extends Error {}
export class ForbiddenError extends Error {}

// Guards the admin-only order-management endpoints (list all orders for a
// store, change an order's status). Verifies the bearer token is a real,
// signed Firebase ID token (cryptographic — cannot be forged or guessed,
// unlike the shopper-side `userId` these same routes' other branches
// accept as a plain string until gravia grows real auth), then checks the
// resulting uid actually owns `storeId` via the `storeIds` custom claim
// stamped by POST /api/stores — verifyIdToken is local signature checking
// (certs cached ~6h), so the claims path costs zero network per request.
// Throws UnauthorizedError (401 — missing/invalid token) or ForbiddenError
// (403 — valid token, wrong store); callers map these to HTTP responses.
export async function requireStoreOwner(
  request: Request,
  storeId: string,
): Promise<string> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");

  let decoded;
  try {
    decoded = await adminAuth.verifyIdToken(match[1]);
  } catch {
    throw new UnauthorizedError("Invalid or expired token");
  }

  let storeIds = decoded.storeIds as string[] | undefined;
  if (storeIds === undefined) {
    // Legacy admin provisioned before claims existed — fall back to the
    // Firestore doc once and backfill the claim, so the read disappears
    // after their next token refresh (≤1h, or a client force-refresh).
    const adminSnap = await adminDb.collection("admins").doc(decoded.uid).get();
    storeIds = (adminSnap.data()?.storeIds as string[] | undefined) ?? [];
    const user = await adminAuth.getUser(decoded.uid);
    await adminAuth.setCustomUserClaims(decoded.uid, {
      ...(user.customClaims ?? {}),
      storeIds,
    });
  }

  if (!storeIds.includes(storeId)) {
    throw new ForbiddenError("Not an owner of this store");
  }

  return decoded.uid;
}

// Guards the platform-wide surfaces (today: writing the CordeliaApps
// notification feed every store's shoppers see). Trusts the `role`
// custom claim, which only scripts/grant-superadmin.mjs can set — the
// mirrored `admins/{uid}.role` field is for the console's rendering and is
// deliberately NOT consulted here, because that doc is client-creatable at
// sign-up. Reading it as authority would let anyone sign up as a superadmin.
export async function requireSuperAdmin(request: Request): Promise<string> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");

  let decoded;
  try {
    decoded = await adminAuth.verifyIdToken(match[1]);
  } catch {
    throw new UnauthorizedError("Invalid or expired token");
  }

  if (decoded.role !== "superAdmin") {
    throw new ForbiddenError("Not a superadmin");
  }

  return decoded.uid;
}

// Guards the shopper profile endpoint (/api/users) — any signed-in Firebase
// user, no store-ownership check. `emailVerified` comes off the token's own
// `email_verified` claim, which only reflects reality once the client has
// force-refreshed the token after actually verifying (see gravia's
// FirebaseAuthService.idToken(forceRefresh: true)) — a stale token still
// reports `false` right after the user clicks the email link.
export async function requireAuthedUser(
  request: Request,
): Promise<{ uid: string; email: string; emailVerified: boolean }> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");

  try {
    const decoded = await adminAuth.verifyIdToken(match[1]);
    return {
      uid: decoded.uid,
      email: decoded.email ?? "",
      emailVerified: decoded.email_verified ?? false,
    };
  } catch {
    throw new UnauthorizedError("Invalid or expired token");
  }
}

// The uid behind an OPTIONAL bearer token, or null. For routes that are
// public but render differently for a signed-in caller — today, hiding the
// reviews of shoppers the reader has blocked. A missing, malformed or
// expired token is null rather than a 401: the response is still valid
// without one, and failing the whole read because a token aged out would
// blank a product page.
export async function optionalAuthedUid(
  request: Request,
): Promise<string | null> {
  const match = (request.headers.get("authorization") ?? "").match(
    /^Bearer (.+)$/,
  );
  if (!match) return null;
  try {
    return (await adminAuth.verifyIdToken(match[1])).uid;
  } catch {
    return null;
  }
}

// Verifies the bearer token and returns the uid plus its `storeIds` custom
// claim (empty array when absent) — for routes that must branch on role
// WITHOUT the legacy-admin Firestore backfill `requireStoreOwner` does.
// Used by the dual-mode order-list route: a plain shopper (no `storeIds`)
// must not get an empty `storeIds` claim silently stamped onto their token
// just for reading their own order history.
export async function verifyIdToken(
  request: Request,
): Promise<{ uid: string; storeIds: string[] }> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");

  try {
    const decoded = await adminAuth.verifyIdToken(match[1]);
    return {
      uid: decoded.uid,
      storeIds: (decoded.storeIds as string[] | undefined) ?? [],
    };
  } catch {
    throw new UnauthorizedError("Invalid or expired token");
  }
}

// Soft variant of requireAuthedUser: returns the uid when a valid bearer
// token is present, or null when the caller is anonymous (no token) or the
// token doesn't verify — never throws. For per-user reads that must still
// succeed for a signed-out shopper (the Search screen's recent-searches
// list: an anonymous user simply has none).
export async function optionalAuthedUser(
  request: Request,
): Promise<string | null> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) return null;

  try {
    const decoded = await adminAuth.verifyIdToken(match[1]);
    return decoded.uid;
  } catch {
    return null;
  }
}

// Who is acting on a store through a v1 route: its owner (a Firebase ID
// token with the store in its `storeIds` claim) or a machine holding one of
// the store's API tokens with the scope the route needs. `uid` is the
// owner's, or the uid that minted the token — what an audit field records.
export type StoreActor =
  | { kind: "owner"; uid: string }
  | { kind: "token"; uid: string; tokenId: string; scopes: ApiTokenScope[] }
  // An OAuth grant an MCP host holds for an owner — account-wide, listing
  // the stores the owner consented to.
  | { kind: "oauth"; uid: string; tokenId: string; scopes: ApiTokenScope[]; storeIds: string[] };

// The one guard every v1 store route uses. A bearer that looks like an API
// token (`cord_live_…`) is checked as one — hash lookup, store match, scope
// — and is never tried as a Firebase token, so a malformed API token can't
// fall through to a 401 that reads as "sign in". Anything else is an owner's
// ID token, verified exactly as requireStoreOwner does.
export async function requireStoreAccess(
  request: Request,
  storeId: string,
  scope: ApiTokenScope,
): Promise<StoreActor> {
  const bearer = (request.headers.get("authorization") ?? "").match(
    /^Bearer (.+)$/,
  )?.[1];
  if (bearer && isOAuthAccessToken(bearer)) {
    const grant = await verifyOAuthAccessToken(bearer);
    if (!grant) throw new UnauthorizedError("Expired or revoked access token");
    if (!grant.storeIds.includes(storeId)) {
      throw new ForbiddenError("This connection was not granted access to that store");
    }
    if (!grant.scopes.includes(scope)) {
      throw new ForbiddenError(`This connection lacks the ${scope} scope`);
    }
    return { kind: "oauth", uid: grant.uid, tokenId: grant.tokenId, scopes: grant.scopes, storeIds: grant.storeIds };
  }
  if (bearer && isApiToken(bearer)) {
    const token = await verifyApiToken(bearer);
    if (!token) throw new UnauthorizedError("Unknown or revoked API token");
    if (token.storeId !== storeId) {
      throw new ForbiddenError("This API token belongs to another store");
    }
    if (!token.scopes.includes(scope)) {
      throw new ForbiddenError(`This API token lacks the ${scope} scope`);
    }
    return { kind: "token", uid: token.createdBy, tokenId: token.id, scopes: token.scopes };
  }
  const uid = await requireStoreOwner(request, storeId);
  return { kind: "owner", uid };
}

// The 401/403 a route answers with when a guard above throws, so every v1
// route maps the two errors the same way. Rethrows anything else.
export function guardErrorResponse(e: unknown): Response {
  if (e instanceof UnauthorizedError) {
    return Response.json({ error: e.message }, { status: 401 });
  }
  if (e instanceof ForbiddenError) {
    return Response.json({ error: e.message }, { status: 403 });
  }
  throw e;
}
