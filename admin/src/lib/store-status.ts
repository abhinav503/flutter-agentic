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

/// Stores predating the lifecycle carry the old `"active"` marker, which
/// meant "visible in discovery". Read as `published` so a store that was
/// live stays live even if the backfill script hasn't run against it.
export function normalizeStoreStatus(value: unknown): StoreStatus {
  if (value === "active") return "published";
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
