import { NextResponse } from "next/server";
import { adminDb } from "@/lib/firebase-admin";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";

// Shopper profile — created/updated from gravia's feature/auth. Every write
// authenticates as the caller's own uid via a verified Firebase ID token;
// there is no "write someone else's profile" path here.
function serializeUser(uid: string, data: FirebaseFirestore.DocumentData) {
  return {
    uid,
    name: (data.name as string | undefined) ?? "",
    email: (data.email as string | undefined) ?? "",
    mobile: (data.mobile as string | undefined) ?? "",
    emailVerified: (data.emailVerified as boolean | undefined) ?? false,
  };
}

// Body is `{ name?, mobile? }` — both optional. `uid`/`email`/`emailVerified`
// always come from the verified token, never the request body. Called with
// {name, mobile} right after signup, and with NO body (just a freshly
// force-refreshed token) once the client's verification poll succeeds, so
// `emailVerified` flips to true server-side without re-sending the rest of
// the profile — that's why name/mobile can't be required here.
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
  const name = typeof body.name === "string" ? body.name : undefined;
  const mobile = typeof body.mobile === "string" ? body.mobile : undefined;

  const ref = adminDb.collection("users").doc(auth.uid);
  const existing = await ref.get();
  const now = new Date().toISOString();

  await ref.set(
    {
      uid: auth.uid,
      email: auth.email,
      emailVerified: auth.emailVerified,
      ...(name !== undefined ? { name } : {}),
      ...(mobile !== undefined ? { mobile } : {}),
      updatedAt: now,
      ...(existing.exists ? {} : { createdAt: now }),
    },
    { merge: true },
  );

  const saved = (await ref.get()).data()!;
  return NextResponse.json(serializeUser(auth.uid, saved));
}

export async function GET(request: Request) {
  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const snap = await adminDb.collection("users").doc(auth.uid).get();
  if (!snap.exists) {
    return NextResponse.json({ error: "Profile not found" }, { status: 404 });
  }
  return NextResponse.json(serializeUser(auth.uid, snap.data()!));
}
