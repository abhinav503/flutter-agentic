// The store publication lifecycle.
//
//   draft ──submit──► pending ──approve──► published
//     ▲                  │                     │
//     └──reject(reason)──┘                unpublish──┐
//     └───────────────────────────────────────────────┘
//
// Only the server moves a store between these (see the /submit and /review
// routes): firestore.rules lets a store owner write their own store doc, so
// a client-writable status would let any admin publish themselves.
export const STORE_STATUSES = [
  "draft",
  "pending",
  "published",
  "rejected",
] as const;

export type StoreStatus = (typeof STORE_STATUSES)[number];

export function isStoreStatus(value: unknown): value is StoreStatus {
  return (
    typeof value === "string" &&
    (STORE_STATUSES as readonly string[]).includes(value)
  );
}

/// Anything that isn't one of the four is a store still being set up.
///
/// A pre-lifecycle `"active"` marker used to be read here as `published`.
/// That mapping is gone: no store doc carries it (checked against the live
/// collection — 12 `draft`, 2 `published`, no `"active"`), and nothing writes
/// it any more, so the only thing it could still do is quietly resurrect a
/// value the lifecycle has no transition into. `"published"` is now the one
/// string that means live, everywhere.
export function normalizeStoreStatus(value: unknown): StoreStatus {
  return isStoreStatus(value) ? value : "draft";
}

/// Shown to shoppers who don't own the store. Everything else is visible
/// only to its owner (and superadmins) — see `getStores`.
export function isPubliclyVisible(status: StoreStatus): boolean {
  return status === "published";
}

export const STORE_STATUS_LABELS: Record<StoreStatus, string> = {
  draft: "Draft",
  pending: "In review",
  published: "Published",
  rejected: "Changes requested",
};
