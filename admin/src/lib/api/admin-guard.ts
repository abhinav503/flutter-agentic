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
