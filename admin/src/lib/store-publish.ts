import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";
import { getStoreReadiness, type StoreReadiness } from "@/lib/store-readiness";
import { normalizeStoreStatus, type StoreStatus } from "@/lib/store-status";

// The owner's half of the publication state machine, shared by the console
// route (/api/stores/{id}/publish) and the v1 route a token or CLI calls.
// Superadmin transitions stay in the console route only.

export class SubmitError extends Error {
  constructor(
    message: string,
    public readonly status: 404 | 409 | 422,
    public readonly checks: StoreReadiness["checks"] = [],
  ) {
    super(message);
  }
}

const SUBMITTABLE_FROM: StoreStatus[] = ["draft", "rejected"];

export async function submitStoreForReview(
  storeId: string,
): Promise<{ status: StoreStatus; readiness: StoreReadiness }> {
  const ref = adminDb.collection("stores").doc(storeId);
  const snap = await ref.get();
  if (!snap.exists) throw new SubmitError("Store not found", 404);

  const current = normalizeStoreStatus(snap.data()?.status);
  if (!SUBMITTABLE_FROM.includes(current)) {
    throw new SubmitError(
      `Cannot submit a store that is "${current}" — expected ${SUBMITTABLE_FROM.join(" or ")}.`,
      409,
    );
  }

  const readiness = await getStoreReadiness(storeId);
  if (!readiness.publishReady) {
    throw new SubmitError(
      "This store isn't ready to publish yet.",
      422,
      readiness.checks.filter((c) => !c.passed),
    );
  }

  await ref.set(
    {
      status: "pending",
      previewReady: readiness.previewReady,
      statusUpdatedAt: FieldValue.serverTimestamp(),
      // A fresh submission clears the last rejection so the owner's
      // dashboard doesn't keep showing feedback they've already acted on.
      rejectionReason: "",
    },
    { merge: true },
  );
  return { status: "pending", readiness };
}

// Readiness, with the previewReady flag cached onto the doc the way the
// console's GET does — discovery reads the flag, not the checks.
export async function readinessWithPreviewFlag(storeId: string) {
  const ref = adminDb.collection("stores").doc(storeId);
  const snap = await ref.get();
  if (!snap.exists) throw new SubmitError("Store not found", 404);
  const readiness = await getStoreReadiness(storeId);
  await ref.set({ previewReady: readiness.previewReady }, { merge: true });
  return {
    status: normalizeStoreStatus(snap.data()?.status),
    rejectionReason: (snap.data()?.rejectionReason as string) ?? "",
    readiness,
  };
}
