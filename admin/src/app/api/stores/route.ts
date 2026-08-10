import { NextResponse } from "next/server";
import { FieldValue } from "firebase-admin/firestore";
import { adminAuth, adminDb } from "@/lib/firebase-admin";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { getStores } from "@/lib/stores";
import { getTemplates } from "@/lib/templates";
import { serializeStore } from "@/lib/api/serializers";
import { STORE_CURRENCIES, STORE_LANGUAGES } from "@/lib/types";

// Store discovery for the CordeliaApps super app. Published stores are
// world-readable with no auth (stores/{storeId} is `allow read: if true` in
// firestore.rules, same reasoning the unauthenticated storefront search
// branch uses). Optional `?q=` filters by name/searchKeywords (see getStores).
//
// The Authorization header is OPTIONAL and only ever *widens* the result: a
// verified token lets a store owner also see their own not-yet-published
// stores, so they can walk their real storefront while setting it up. An
// absent, expired or forged token simply falls back to the anonymous list —
// it can never fail the request, because discovery must keep working for
// signed-out shoppers.
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q") ?? undefined;

  let viewerUid: string | undefined;
  let superAdmin = false;
  const match = (request.headers.get("authorization") ?? "").match(
    /^Bearer (.+)$/,
  );
  if (match) {
    try {
      const decoded = await adminAuth.verifyIdToken(match[1]);
      viewerUid = decoded.uid;
      superAdmin = decoded.role === "superAdmin";
    } catch {
      // Anonymous fallback — see the note above.
    }
  }

  const stores = await getStores(q, { viewerUid, superAdmin });
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

  // Same fail-loud reasoning as templateId: cordelia's parse falls back to
  // English on an unknown value, so reject bad writes here. Absent → 'en'.
  let language = "en";
  if (body.language !== undefined) {
    language = typeof body.language === "string" ? body.language.trim() : "";
    if (!(STORE_LANGUAGES as readonly string[]).includes(language)) {
      return NextResponse.json(
        {
          error: `Unknown language "${language}" — valid: ${STORE_LANGUAGES.join(", ")}`,
        },
        { status: 400 },
      );
    }
  }

  // Ditto — an unknown code would silently fall back to rupees on the client
  // and misprice the whole catalog. Absent → 'INR'.
  let currency = "INR";
  if (body.currency !== undefined) {
    currency =
      typeof body.currency === "string" ? body.currency.trim().toUpperCase() : "";
    if (!(STORE_CURRENCIES as readonly string[]).includes(currency)) {
      return NextResponse.json(
        {
          error: `Unknown currency "${currency}" — valid: ${STORE_CURRENCIES.join(", ")}`,
        },
        { status: 400 },
      );
    }
  }

  const storeRef = adminDb.collection("stores").doc();
  await storeRef.set({
    name,
    templateId,
    language,
    currency,
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
