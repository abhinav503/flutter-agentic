import {
  collection,
  doc,
  addDoc,
  deleteDoc,
  onSnapshot,
  orderBy,
  query,
  serverTimestamp,
  type CollectionReference,
  type QueryDocumentSnapshot,
  type Timestamp,
} from "firebase/firestore";
import { db } from "./firebase";
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
};

// `createdBy` is recorded on both kinds: a platform notification reaching
// every store in the product is worth being able to attribute later.
export async function addStoreNotification(
  storeId: string,
  data: NotificationInput,
  authorUid: string,
) {
  await addDoc(storeNotificationsRef(storeId), {
    ...data,
    createdBy: authorUid,
    createdAt: serverTimestamp(),
  });
}

export async function addPlatformNotification(
  data: NotificationInput,
  authorUid: string,
) {
  await addDoc(platformNotificationsRef(), {
    ...data,
    createdBy: authorUid,
    createdAt: serverTimestamp(),
  });
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
