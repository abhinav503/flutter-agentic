import { NextResponse } from "next/server";
import {
  requireStoreOwner,
  ForbiddenError,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import {
  getStorePaymentStatus,
  setStorePaymentConfig,
} from "@/lib/payments";

// Store-owner-only. GET returns a non-secret status (configured?, keyId,
// test-vs-live) for the dashboard Settings screen; the key secret is never
// serialized. PUT accepts a fresh { keyId, keySecret } pair and stores it
// with the secret encrypted at rest.

function handleGuardError(e: unknown): NextResponse | null {
  if (e instanceof UnauthorizedError) {
    return NextResponse.json({ error: e.message }, { status: 401 });
  }
  if (e instanceof ForbiddenError) {
    return NextResponse.json({ error: e.message }, { status: 403 });
  }
  return null;
}

export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    const res = handleGuardError(e);
    if (res) return res;
    throw e;
  }
  return NextResponse.json(await getStorePaymentStatus(storeId));
}

export async function PUT(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    const res = handleGuardError(e);
    if (res) return res;
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const keyId = typeof body.keyId === "string" ? body.keyId.trim() : "";
  const keySecret =
    typeof body.keySecret === "string" ? body.keySecret.trim() : "";

  if (!keyId || !keySecret) {
    return NextResponse.json(
      { error: "keyId and keySecret are required" },
      { status: 400 },
    );
  }
  if (!keyId.startsWith("rzp_test_") && !keyId.startsWith("rzp_live_")) {
    return NextResponse.json(
      { error: "keyId must start with rzp_test_ or rzp_live_" },
      { status: 400 },
    );
  }

  await setStorePaymentConfig(storeId, keyId, keySecret);
  return NextResponse.json(await getStorePaymentStatus(storeId));
}
