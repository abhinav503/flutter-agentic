import { NextResponse } from "next/server";
import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";

/**
 * Repairs the caller's own `admins/{uid}` record.
 *
 * Sign-up is two steps — create the Firebase Auth account, then write the
 * admins doc — and only the first is atomic. A network blip between them left
 * an account that can sign in against a record that says nothing about them.
 * `POST /api/stores` already `merge`s `storeIds` in, so such an account could
 * still create a store; what it could never regain was `email` and `role`,
 * because firestore.rules denies client updates to an existing admins doc
 * (`allow update: if false`). Only the Admin SDK can close that hole, which is
 * why this is a route and not a client write.
 *
 * Always the caller's own uid — there is no admin branch and no uid param, so
 * this cannot be pointed at anyone else's record.
 *
 * Fills only what is absent; never overwrites a field that already has a
 * value. `createdAt` is stamped solely when the doc doesn't exist at all —
 * backfilling it onto an older doc would record today as the sign-up date,
 * and a missing timestamp is better than a wrong one. It is deliberately not
 * part of the completeness check for the same reason (see store-context.tsx),
 * or a doc that legitimately lacks it would ask to be healed on every load.
 */
export async function POST(request: Request) {
  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const ref = adminDb.collection("admins").doc(auth.uid);
  const snap = await ref.get();
  const data = snap.data() ?? {};

  const patch: Record<string, unknown> = {};
  if (!data.email && auth.email) patch.email = auth.email;
  if (!data.role) patch.role = "storeAdmin";
  if (!Array.isArray(data.storeIds)) patch.storeIds = [];
  if (!snap.exists) patch.createdAt = FieldValue.serverTimestamp();

  if (Object.keys(patch).length === 0) {
    return NextResponse.json({ healed: false, fields: [] });
  }

  await ref.set(patch, { merge: true });
  return NextResponse.json({ healed: true, fields: Object.keys(patch) });
}
