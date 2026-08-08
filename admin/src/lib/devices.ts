import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";

/**
 * Registered FCM device tokens.
 *
 * Topics (see lib/push.ts) address *audiences* and need no registry; these
 * address a **device**, which topics can't do — and they're also the record
 * of who accepted the notification permission and on what.
 *
 * **Keyed by token at the top level, with the owner as a field.** The token
 * is unique per app install, so the document *is* the handset: signing in
 * takes ownership by writing `uid`, and one phone can never be filed under
 * two accounts at once. Filing devices under `users/{uid}/devices` instead
 * would encode ownership in the path — exactly the thing that changes when a
 * second shopper signs in on a borrowed or resold phone — and would leave the
 * previous owner's row behind every time a sign-out failed to reach the
 * server, which is often (no network, app killed, crash).
 *
 * That makes unregistration hygiene rather than correctness, which matters
 * because it is unreliable by nature.
 */

function deviceRef(token: string) {
  return adminDb.collection("devices").doc(token);
}

export type DevicePlatform = "android" | "ios";

/**
 * Records (or refreshes) a device, taking ownership for [uid].
 *
 * `updatedAt` moves on every call, which is what makes an abandoned row
 * identifiable later: the app re-registers on every launch, so a timestamp
 * that stops moving means nobody has opened the app on that install since.
 *
 * [granted] is whether the OS is currently allowing notifications. It is
 * recorded rather than gating the write, so a muted-but-alive device is
 * distinguishable from a gone one — without it, revoking permission in
 * Settings freezes `updatedAt` and looks identical to an uninstall.
 */
export async function registerDevice(
  uid: string,
  token: string,
  platform: DevicePlatform,
  granted: boolean,
): Promise<void> {
  await deviceRef(token).set(
    { uid, platform, granted, updatedAt: FieldValue.serverTimestamp() },
    // Merge rather than replace: a later field added here (app version,
    // locale) shouldn't be wiped by the next plain refresh. The four fields
    // named above are still overwritten, which is what transfers ownership.
    { merge: true },
  );
}

/**
 * Drops a device on sign-out — but only while [uid] still owns it.
 *
 * The guard is the point: a release is fired just before sign-out and may
 * arrive late, after the next shopper has already signed in on the same
 * handset and claimed the row. Deleting unconditionally would silently
 * unregister *them*.
 */
export async function unregisterDevice(
  uid: string,
  token: string,
): Promise<void> {
  const ref = deviceRef(token);
  await adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists || snap.get("uid") !== uid) return;
    tx.delete(ref);
  });
}

/**
 * Every device belonging to [uid] — used when an account is closed. A query,
 * not a subcollection listing, which is the one thing the top-level layout
 * costs.
 */
export async function deleteDevicesForUser(uid: string): Promise<void> {
  const snap = await adminDb
    .collection("devices")
    .where("uid", "==", uid)
    .get();
  await Promise.all(snap.docs.map((d) => d.ref.delete()));
}

/**
 * FCM's own staleness horizon. A token whose app instance hasn't connected
 * in this long is one FCM itself stops considering deliverable, so pruning
 * at this age can't discard a device that would still have received
 * anything. A shorter sweep would only reclaim storage, at the cost of
 * dropping rows for handsets that were merely quiet.
 */
export const STALE_DEVICE_DAYS = 270;

/** One batch's worth; Firestore caps a write batch at 500. */
const PRUNE_BATCH = 400;

/**
 * Deletes device rows untouched for [maxAgeDays], returning how many went.
 *
 * A timestamp-based sweep is a backstop, not the primary reaper: the
 * authoritative signal that a token is dead is FCM answering
 * `messaging/registration-token-not-registered` to a send, and that is where
 * removal should happen once anything sends by token. Until then, and for
 * installs that are simply gone, this is what keeps the collection from
 * growing without bound.
 *
 * Loops rather than taking one page: a sweep that silently stops at 400 rows
 * would look like it worked.
 */
export async function pruneStaleDevices(
  maxAgeDays: number = STALE_DEVICE_DAYS,
): Promise<number> {
  const cutoff = Timestamp.fromMillis(
    Date.now() - maxAgeDays * 24 * 60 * 60 * 1000,
  );

  let deleted = 0;
  for (;;) {
    const snap = await adminDb
      .collection("devices")
      .where("updatedAt", "<", cutoff)
      .limit(PRUNE_BATCH)
      .get();
    if (snap.empty) return deleted;

    const batch = adminDb.batch();
    for (const doc of snap.docs) batch.delete(doc.ref);
    await batch.commit();
    deleted += snap.size;

    // A short page means the query is drained — the next round would only
    // re-run the same read to find nothing.
    if (snap.size < PRUNE_BATCH) return deleted;
  }
}
