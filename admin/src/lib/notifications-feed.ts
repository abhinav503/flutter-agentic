import { FieldValue, type Timestamp } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import type { NotificationKind, StoreNotification } from "./types";

/**
 * The shopper-facing read of the two notification collections.
 *
 * Admin SDK, unlike lib/notifications.ts (client SDK, for the console): the
 * feeds are not world-readable — a store's notifications are gated to its
 * owner and the platform feed to a superadmin — so this is the only path that
 * can serve them to a shopper. It is also what stamps read state, which no
 * client is allowed to write.
 */

// Enough to fill the Notifications screen well past a scroll without paging.
// Split per source so a chatty store can't push every platform message off
// the end of a shopper's list, or vice versa.
const PER_SOURCE_LIMIT = 50;

export type FeedNotification = StoreNotification & { isRead: boolean };

function mapDoc(
  id: string,
  data: FirebaseFirestore.DocumentData,
  source: StoreNotification["source"],
): StoreNotification {
  return {
    id,
    kind: (data.kind as NotificationKind) ?? "account",
    title: (data.title as string) ?? "",
    message: (data.message as string) ?? "",
    source,
    createdAtMs: (data.createdAt as Timestamp | undefined)?.toMillis() ?? 0,
  };
}

/**
 * Both feeds merged, newest first, with each item's read state for [uid].
 *
 * [uid] is null for a signed-out shopper, who sees the same list with
 * everything unread — the notification centre is not gated behind sign-in,
 * and a store's offer is worth showing to someone who hasn't made an account.
 */
export async function getNotificationFeed(
  storeId: string,
  uid: string | null,
): Promise<FeedNotification[]> {
  const [storeSnap, platformSnap] = await Promise.all([
    adminDb
      .collection("stores")
      .doc(storeId)
      .collection("notifications")
      .orderBy("createdAt", "desc")
      .limit(PER_SOURCE_LIMIT)
      .get(),
    adminDb
      .collection("notifications")
      .orderBy("createdAt", "desc")
      .limit(PER_SOURCE_LIMIT)
      .get(),
  ]);

  const merged = [
    ...storeSnap.docs.map((d) => mapDoc(d.id, d.data(), "store")),
    ...platformSnap.docs.map((d) => mapDoc(d.id, d.data(), "platform")),
  ].sort((a, b) => b.createdAtMs - a.createdAtMs);

  if (!uid) return merged.map((n) => ({ ...n, isRead: false }));

  // One collection read rather than a get-per-notification: the receipts are
  // tiny and a shopper accumulates at most PER_SOURCE_LIMIT * 2 of them.
  const readsSnap = await adminDb
    .collection("users")
    .doc(uid)
    .collection("notificationReads")
    .get();
  const readIds = new Set(readsSnap.docs.map((d) => d.id));

  return merged.map((n) => ({ ...n, isRead: readIds.has(n.id) }));
}

/**
 * Marks [notificationIds] read for [uid]. Idempotent — re-marking an already
 * read notification rewrites the same receipt rather than failing, so the app
 * can fire this on every screen open without tracking what it sent before.
 *
 * Receipts are keyed by notification id alone, not by store: Firestore auto-ids
 * are unique across both collections, and a platform notification read in one
 * store should stay read when the shopper opens another.
 */
export async function markNotificationsRead(
  uid: string,
  notificationIds: string[],
): Promise<void> {
  if (notificationIds.length === 0) return;

  const batch = adminDb.batch();
  const reads = adminDb.collection("users").doc(uid).collection("notificationReads");
  // A batch caps at 500 writes; the feed itself caps at 100, so the whole
  // list always fits in one.
  for (const id of notificationIds.slice(0, PER_SOURCE_LIMIT * 2)) {
    batch.set(reads.doc(id), { readAt: FieldValue.serverTimestamp() });
  }
  await batch.commit();
}
