import { NextResponse } from "next/server";
import { FieldValue } from "firebase-admin/firestore";
import { adminAuth, adminDb } from "@/lib/firebase-admin";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { getStores } from "@/lib/stores";
import { getTemplates } from "@/lib/templates";
import { serializeStore } from "@/lib/api/serializers";

// Store discovery for the CordeliaApps super app — world-readable, no auth
// (stores/{storeId} is `allow read: if true` in firestore.rules, same
// reasoning the existing unauthenticated storefront search branch uses).
// Optional `?q=` filters by name/searchKeywords (see getStores).
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q") ?? undefined;
  const stores = await getStores(q);
  return NextResponse.json({ stores: stores.map(serializeStore) });
}

// Store creation moved server-side so ownership can be stamped into the
// caller's `storeIds` custom claim — a client can't grant itself a claim,
// and firestore.rules no longer lets it write `admins/{uid}.storeIds`
// either, making the claim (not the client-reachable doc) the authority
// requireStoreOwner trusts. The admins doc keeps a mirror of storeIds only
// because the dashboard's StoreProvider watches it via onSnapshot.
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

  const body = await request.json().catch(() => ({}));
  const name = typeof body.name === "string" ? body.name.trim() : "";
  if (!name) {
    return NextResponse.json({ error: "name is required" }, { status: 400 });
  }
  // Validated against the seeded `templates` collection when provided —
  // cordelia's StorefrontTemplateParse silently falls back to gravia on an
  // unknown id (a hand-backfilled "dialymart" typo proved exactly that), so
  // the write side fails loud instead. Absent → default 'gravia'.
  let templateId = "gravia";
  if (body.templateId !== undefined) {
    templateId =
      typeof body.templateId === "string" ? body.templateId.trim() : "";
    const templates = await getTemplates();
    if (!templates.some((t) => t.id === templateId)) {
      return NextResponse.json(
        {
          error: `Unknown templateId "${templateId}" — valid: ${templates
            .map((t) => t.id)
            .join(", ")}`,
        },
        { status: 400 },
      );
    }
  }

  const storeRef = adminDb.collection("stores").doc();
  await storeRef.set({
    name,
    templateId,
    ownerUid: auth.uid,
    status: "active",
    createdAt: FieldValue.serverTimestamp(),
  });

  const adminRef = adminDb.collection("admins").doc(auth.uid);
  await adminRef.set(
    { storeIds: FieldValue.arrayUnion(storeRef.id) },
    { merge: true },
  );

  // setCustomUserClaims replaces the whole claims object — merge with any
  // existing claims (e.g. a future `role`) instead of clobbering them.
  const storeIds =
    ((await adminRef.get()).data()?.storeIds as string[] | undefined) ?? [];
  const user = await adminAuth.getUser(auth.uid);
  await adminAuth.setCustomUserClaims(auth.uid, {
    ...(user.customClaims ?? {}),
    storeIds,
  });

  return NextResponse.json({ storeId: storeRef.id }, { status: 201 });
}
