import { adminAuth, adminDb } from "@/lib/firebase-admin";

export class UnauthorizedError extends Error {}
export class ForbiddenError extends Error {}

// Guards the admin-only order-management endpoints (list all orders for a
// store, change an order's status). Verifies the bearer token is a real,
// signed Firebase ID token (cryptographic — cannot be forged or guessed,
// unlike the shopper-side `userId` these same routes' other branches
// accept as a plain string until gravia grows real auth), then checks the
// resulting uid actually owns `storeId` via `admins/{uid}.storeIds`.
// Throws UnauthorizedError (401 — missing/invalid token) or ForbiddenError
// (403 — valid token, wrong store); callers map these to HTTP responses.
export async function requireStoreOwner(
  request: Request,
  storeId: string,
): Promise<string> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");

  let uid: string;
  try {
    uid = (await adminAuth.verifyIdToken(match[1])).uid;
  } catch {
    throw new UnauthorizedError("Invalid or expired token");
  }

  const adminSnap = await adminDb.collection("admins").doc(uid).get();
  const storeIds = (adminSnap.data()?.storeIds as string[] | undefined) ?? [];
  if (!storeIds.includes(storeId)) {
    throw new ForbiddenError("Not an owner of this store");
  }

  return uid;
}
