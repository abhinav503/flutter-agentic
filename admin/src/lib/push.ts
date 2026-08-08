import { FieldValue } from "firebase-admin/firestore";
import { adminDb, adminMessaging } from "./firebase-admin";
import type { NotificationKind } from "./types";

/**
 * Sending a notification is one operation with two halves: the **push** the
 * shopper's device shows now, and the **document** that keeps it in the
 * notification centre afterwards. Both live here so no caller can do one and
 * forget the other — which is why the console composes through an API route
 * instead of writing Firestore from the client SDK. Only the Admin SDK can
 * talk to FCM.
 *
 * Addressed by topic, never by device token: no registry to maintain, no
 * fan-out, no stale-token cleanup, and a reinstall re-subscribes itself.
 * Topic names are derived exactly as cordelia's FirebaseMessagingService
 * derives them — change one and you must change both.
 */

export const platformTopic = "platform";
export const storeTopic = (storeId: string) => `store_${storeId}`;
export const userTopic = (uid: string) => `user_${uid}`;

export type PushInput = {
  kind: NotificationKind;
  title: string;
  message: string;
  /** Empty string when the sender attached no artwork. */
  imageUrl: string;
};

type Destination =
  | { scope: "store"; storeId: string }
  | { scope: "platform" }
  | { scope: "user"; uid: string; storeId: string };

// Where a tap lands.
//
// A store-scoped message opens that store's notification centre: cordelia
// takes the `storeId` sent below, fetches the store, mounts its storefront
// and pushes this route over it (see cordelia's NotificationRouter). A
// platform message belongs to no store and so has no storefront to open —
// it lands on Discovery, where a store gets chosen.
const tapRoute = (destination: Destination) =>
  destination.scope === "platform" ? "discovery" : "notifications";

function collectionFor(destination: Destination) {
  switch (destination.scope) {
    case "store":
      return adminDb
        .collection("stores")
        .doc(destination.storeId)
        .collection("notifications");
    case "platform":
      return adminDb.collection("notifications");
    case "user":
      return adminDb
        .collection("users")
        .doc(destination.uid)
        .collection("notifications");
  }
}

function topicFor(destination: Destination) {
  switch (destination.scope) {
    case "store":
      return storeTopic(destination.storeId);
    case "platform":
      return platformTopic;
    case "user":
      return userTopic(destination.uid);
  }
}

/**
 * Writes the notification, then pushes it.
 *
 * **The write comes first, and only its failure fails the call.** A saved
 * notification with no push is a notification the shopper still finds on
 * their next visit; a push with no record is a banner that vanishes and
 * leaves nothing behind. So a dead FCM path degrades to in-app-only rather
 * than losing the message, and the caller learns about it through
 * `pushed: false` rather than an error.
 */
export async function sendNotification(
  destination: Destination,
  input: PushInput,
  authorUid: string,
): Promise<{ id: string; pushed: boolean }> {
  const doc = await collectionFor(destination).add({
    ...input,
    // A user notification records the store it came from, so the feed can
    // show it in that storefront and nowhere else.
    ...(destination.scope === "user" ? { storeId: destination.storeId } : {}),
    createdBy: authorUid,
    createdAt: FieldValue.serverTimestamp(),
  });

  let pushed = false;
  try {
    await adminMessaging.send({
      topic: topicFor(destination),
      notification: {
        title: input.title,
        body: input.message,
        // The OS fetches and renders this itself on a backgrounded or
        // terminated device — no client code involved. A foreground message
        // is drawn by our own code instead, which is why the URL also rides
        // in `data` below.
        ...(input.imageUrl ? { imageUrl: input.imageUrl } : {}),
      },
      // Read by cordelia's NotificationPayload.fromData. FCM requires every
      // data value to be a string.
      data: {
        notificationType: "routeToPage",
        route: tapRoute(destination),
        notificationId: doc.id,
        kind: input.kind,
        ...(input.imageUrl ? { imageUrl: input.imageUrl } : {}),
        ...(destination.scope !== "platform"
          ? { storeId: destination.storeId }
          : {}),
      },
      android: { priority: "high" },
    });
    pushed = true;
  } catch (error) {
    // Most often "topic has no subscribers yet" or a missing APNs key —
    // neither is a reason to fail the send or to lose the record.
    console.error("FCM push failed", error);
  }

  return { id: doc.id, pushed };
}
