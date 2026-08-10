import { NextResponse } from "next/server";
import { adminDb } from "@/lib/firebase-admin";
import { requireSuperAdmin, UnauthorizedError, ForbiddenError } from "@/lib/api/admin-guard";
import { normalizeStoreStatus } from "@/lib/store-status";

// The review queue: every store on the platform with its publication state,
// for the superadmin Stores page.
//
// Separate from GET /api/stores rather than a flag on it. That route is the
// shoppers' world-readable discovery feed and must never grow a parameter
// that widens it — a bug there leaks unpublished stores to everyone,
// whereas a bug here can only 403.
export async function GET(request: Request) {
  try {
    await requireSuperAdmin(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    if (e instanceof ForbiddenError) {
      return NextResponse.json({ error: e.message }, { status: 403 });
    }
    throw e;
  }

  const snap = await adminDb.collection("stores").get();
  const stores = snap.docs.map((d) => {
    const data = d.data();
    return {
      id: d.id,
      name: (data.name as string) ?? "",
      logoUrl: (data.logoUrl as string) ?? "",
      description: (data.description as string) ?? "",
      ownerUid: (data.ownerUid as string) ?? "",
      status: normalizeStoreStatus(data.status),
      rejectionReason: (data.rejectionReason as string) ?? "",
      previewReady: (data.previewReady as boolean | undefined) ?? false,
    };
  });

  // Pending first — the queue exists to be worked through, and anything
  // waiting on a human should not be below 13 published stores.
  const order = { pending: 0, rejected: 1, draft: 2, published: 3 } as const;
  stores.sort(
    (a, b) =>
      order[a.status] - order[b.status] || a.name.localeCompare(b.name),
  );

  return NextResponse.json({ stores });
}
