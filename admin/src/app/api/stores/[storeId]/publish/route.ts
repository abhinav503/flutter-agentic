import { NextResponse } from "next/server";
import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";
import {
  ForbiddenError,
  requireStoreOwner,
  requireSuperAdmin,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import { getStoreReadiness } from "@/lib/store-readiness";
import {
  readinessWithPreviewFlag,
  submitStoreForReview,
  SubmitError,
} from "@/lib/store-publish";
import { normalizeStoreStatus, type StoreStatus } from "@/lib/store-status";

// The store publication lifecycle, as one route with two audiences —
// mirroring the dual-role cancel route, and for the same reason: the state
// machine is one thing, and splitting it across two files is how the two
// halves drift into disagreeing about which transitions are legal.
//
//   POST { action: "submit"  }  — store owner. draft|rejected -> pending
//   POST { action: "approve" }  — superadmin.  pending        -> published
//   POST { action: "reject", reason } — superadmin. pending   -> rejected
//   POST { action: "unpublish" }— superadmin.  published      -> draft
//
// Status is server-only in firestore.rules precisely because this exists:
// a store owner can write their own store doc, so a client-writable status
// would let any admin publish themselves without review.

type Action = "submit" | "approve" | "reject" | "unpublish";

const SUPERADMIN_ACTIONS: Action[] = ["approve", "reject", "unpublish"];

// Which statuses each action may be applied to. Enforced server-side so a
// double-clicked button or a stale tab can't approve an already-published
// store or resurrect a draft straight to live.
const LEGAL_FROM: Record<Action, StoreStatus[]> = {
  submit: ["draft", "rejected"],
  approve: ["pending"],
  reject: ["pending"],
  unpublish: ["published"],
};

const NEXT: Record<Action, StoreStatus> = {
  submit: "pending",
  approve: "published",
  reject: "rejected",
  unpublish: "draft",
};

// The publish card's checklist. Owner-only — the checks name what's missing
// from a store's setup, which isn't public information. Recomputes on every
// call and caches `previewReady` back onto the doc, so simply opening the
// card is what keeps discovery's owner-preview flag fresh.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    if (e instanceof ForbiddenError) {
      return NextResponse.json({ error: e.message }, { status: 403 });
    }
    throw e;
  }

  try {
    return NextResponse.json(await readinessWithPreviewFlag(storeId));
  } catch (e) {
    if (e instanceof SubmitError) {
      return NextResponse.json({ error: e.message }, { status: e.status });
    }
    throw e;
  }
}

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const body = await request.json().catch(() => ({}));
  const action = body.action as Action | undefined;

  if (!action || !(action in LEGAL_FROM)) {
    return NextResponse.json(
      { error: `action must be one of ${Object.keys(LEGAL_FROM).join(", ")}` },
      { status: 400 },
    );
  }

  try {
    if (SUPERADMIN_ACTIONS.includes(action)) {
      await requireSuperAdmin(request);
    } else {
      await requireStoreOwner(request, storeId);
    }
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    if (e instanceof ForbiddenError) {
      return NextResponse.json({ error: e.message }, { status: 403 });
    }
    throw e;
  }

  // The owner's transition shares its implementation with the v1 route a
  // token calls, so the two can't drift on readiness or legal states.
  if (action === "submit") {
    try {
      return NextResponse.json(await submitStoreForReview(storeId));
    } catch (e) {
      if (e instanceof SubmitError) {
        return NextResponse.json(
          { error: e.message, ...(e.checks.length ? { checks: e.checks } : {}) },
          { status: e.status },
        );
      }
      throw e;
    }
  }

  const ref = adminDb.collection("stores").doc(storeId);
  const snap = await ref.get();
  if (!snap.exists) {
    return NextResponse.json({ error: "Store not found" }, { status: 404 });
  }

  const current = normalizeStoreStatus(snap.data()?.status);
  if (!LEGAL_FROM[action].includes(current)) {
    return NextResponse.json(
      {
        error: `Cannot ${action} a store that is "${current}" — expected ${LEGAL_FROM[
          action
        ].join(" or ")}.`,
      },
      { status: 409 },
    );
  }

  const readiness = await getStoreReadiness(storeId);

  const patch: Record<string, unknown> = {
    status: NEXT[action],
    previewReady: readiness.previewReady,
    statusUpdatedAt: FieldValue.serverTimestamp(),
  };

  if (action === "reject") {
    const reason = typeof body.reason === "string" ? body.reason.trim() : "";
    if (!reason) {
      return NextResponse.json(
        { error: "A rejection needs a reason — the owner has to know what to fix." },
        { status: 400 },
      );
    }
    patch.rejectionReason = reason;
  }
  if (action === "approve") {
    patch.rejectionReason = "";
    patch.publishedAt = FieldValue.serverTimestamp();
  }

  await ref.set(patch, { merge: true });

  return NextResponse.json({ status: NEXT[action], readiness });
}
