import { adminDb } from "./firebase-admin";

// One shopper's list of shoppers whose reviews they no longer want to see.
//
// The other half of App Store Review Guideline 1.2: an app carrying
// user-generated content must let a reader report content AND block the
// person who wrote it. Reporting is a request to the store owner and may
// take a day; blocking is the reader's own switch and takes effect on the
// next screen.
//
// Deliberately one-directional and invisible. Nothing tells the blocked
// shopper, nothing stops them shopping, and the store owner's moderation
// list is unaffected — this hides reviews from ONE reader, it does not
// remove them. Removing a review is the owner's decision, made on the
// reports.
//
// Stored server-side rather than in device preferences so a block survives
// a reinstall and follows the shopper to a second device, which is what a
// reader who blocked someone for a reason expects.

function blockedRef(uid: string) {
  return adminDb.collection("users").doc(uid).collection("blockedShoppers");
}

export async function blockShopper(
  uid: string,
  blockedUid: string,
): Promise<void> {
  // Blocking yourself is meaningless and would hide your own reviews from
  // you, which reads as data loss.
  if (uid === blockedUid) return;
  await blockedRef(uid)
    .doc(blockedUid)
    .set({ createdAt: new Date().toISOString() });
}

export async function unblockShopper(
  uid: string,
  blockedUid: string,
): Promise<void> {
  await blockedRef(uid).doc(blockedUid).delete();
}

/// The uids this shopper has blocked. A Set because every caller is asking
/// "is this author blocked?" once per rendered review.
export async function getBlockedShoppers(uid: string): Promise<Set<string>> {
  const snap = await blockedRef(uid).get();
  return new Set(snap.docs.map((d) => d.id));
}

/// The blocked-author filter every shopper-facing review read runs through.
///
/// Reads the caller's list only when there is a caller — the reviews on a
/// product page are public, and a signed-out reader has blocked nobody, so
/// the common case costs no extra query.
export async function filterBlockedAuthors<T extends { uid: string }>(
  reviews: T[],
  viewerUid: string | null,
): Promise<T[]> {
  if (!viewerUid || reviews.length === 0) return reviews;
  const blocked = await getBlockedShoppers(viewerUid);
  if (blocked.size === 0) return reviews;
  return reviews.filter((r) => !blocked.has(r.uid));
}
