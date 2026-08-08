import {
  collection,
  doc,
  deleteDoc,
  onSnapshot,
  orderBy,
  query,
  type CollectionReference,
  type QueryDocumentSnapshot,
  type Timestamp,
} from "firebase/firestore";
import { auth, db } from "./firebase";
import type { NotificationKind, StoreNotification } from "./types";

/**
 * Two collections, one shape.
 *
 * `stores/{storeId}/notifications` — written by that store's owner, read only
 * by shoppers in that store. `notifications` (top-level) — written by a
 * superadmin, read by shoppers in *every* store. They are separate
 * collections rather than one with an `audience` field so authority is a
 * path, not a predicate: firestore.rules can grant a store owner its own
 * subcollection without ever letting them reach the platform feed.
 *
 * `source` is therefore derived from which reader produced the doc, never
 * stored — a store notification cannot be mislabelled as a platform one.
 */

function storeNotificationsRef(storeId: string) {
  return collection(db, "stores", storeId, "notifications");
}

function platformNotificationsRef() {
  return collection(db, "notifications");
}

function mapNotificationDoc(
  d: QueryDocumentSnapshot,
  source: StoreNotification["source"],
): StoreNotification {
  const data = d.data();
  return {
    id: d.id,
    kind: (data.kind as NotificationKind) ?? "account",
    title: (data.title as string) ?? "",
    message: (data.message as string) ?? "",
    imageUrl: (data.imageUrl as string) ?? "",
    source,
    createdAtMs:
      (data.createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
  };
}

// Newest first, which is the only order a notification list is ever read in.
// Ordered in the query rather than client-side so a store with a long history
// can grow a `limit()` later without the callers changing.
function watch(
  ref: CollectionReference,
  source: StoreNotification["source"],
  onChange: (items: StoreNotification[]) => void,
) {
  return onSnapshot(query(ref, orderBy("createdAt", "desc")), (snap) => {
    onChange(snap.docs.map((d) => mapNotificationDoc(d, source)));
  });
}

export function watchStoreNotifications(
  storeId: string,
  onChange: (items: StoreNotification[]) => void,
) {
  return watch(storeNotificationsRef(storeId), "store", onChange);
}

export function watchPlatformNotifications(
  onChange: (items: StoreNotification[]) => void,
) {
  return watch(platformNotificationsRef(), "platform", onChange);
}

export type NotificationInput = {
  kind: NotificationKind;
  title: string;
  message: string;
  imageUrl: string;
};

// Sending goes through the API, not addDoc, because sending *is* pushing:
// only the Admin SDK can reach FCM, so the push and the record are made
// together server-side (see lib/push.ts). The author is taken from the
// verified token rather than passed, so a client can't attribute a
// notification to someone else.
async function postSend(path: string, data: NotificationInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not signed in");

  const response = await fetch(path, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${await user.getIdToken()}`,
    },
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const body = (await response.json().catch(() => null)) as {
      error?: string;
    } | null;
    throw new Error(body?.error ?? "Could not send the notification");
  }

  // `pushed: false` means the record saved but FCM refused it — most often
  // no subscribers yet, or a missing APNs key. Surfaced so the caller can
  // say so rather than claiming a delivery that didn't happen.
  return (await response.json()) as { id: string; pushed: boolean };
}

export function sendStoreNotification(
  storeId: string,
  data: NotificationInput,
) {
  return postSend(`/api/stores/${storeId}/notifications/send`, data);
}

export function sendPlatformNotification(data: NotificationInput) {
  return postSend("/api/notifications/send", data);
}

// No update counterpart, deliberately: a notification is a thing that was
// *sent*. Editing the text after shoppers have read it would rewrite history
// rather than correct it — send a new one, delete the wrong one.
export async function deleteStoreNotification(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "notifications", id));
}

export async function deletePlatformNotification(id: string) {
  await deleteDoc(doc(db, "notifications", id));
}
