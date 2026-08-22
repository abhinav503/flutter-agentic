import { adminAuth, adminDb } from "./firebase-admin";
import { deleteDevicesForUser } from "./devices";
import { deleteReview } from "./reviews";

// Closing a shopper account. Deletes the personal data Cordelia holds and
// the Firebase Auth user itself; **orders are deliberately kept**.
//
// Why orders survive: they are the *store's* business record, not only the
// shopper's — a store needs its sales history for its own books and for any
// dispute or refund still in flight, and a shopper cannot unilaterally erase
// a merchant's transaction record by closing an account. Everything that
// makes the account usable (profile, addresses, cart, favourites, recent
// searches) and everything published under the shopper's name (product
// reviews) does go.
//
// Not transactional: it spans subcollections, a collection-group query and
// Firebase Auth, which no single Firestore transaction covers. It is
// ordered so a partial failure is recoverable instead of destructive — data
// first, the auth user last, so a half-finished delete leaves an account
// that can sign in and try again rather than an orphaned data set nobody
// can reach.

// The per-user subcollections written by the shopper-facing APIs
// (addresses.ts, cart.ts, favourites.ts, recent-searches.ts, push.ts and
// notifications-feed.ts).
const USER_SUBCOLLECTIONS = [
  "addresses",
  "carts",
  "favourites",
  "recentSearches",
  // Order updates addressed to this shopper, and the receipts for what they
  // had seen. Both are personal data about someone who is leaving; the
  // store's copy of the order itself is what survives, not their inbox.
  "notifications",
  "notificationReads",
  // Who this shopper chose not to see reviews from. Their list, about them,
  // and meaningless once the account is gone.
  "blockedShoppers",
];

async function deleteSubcollection(
  uid: string,
  name: string,
): Promise<void> {
  const snap = await adminDb
    .collection("users")
    .doc(uid)
    .collection(name)
    .get();
  await Promise.all(snap.docs.map((d) => d.ref.delete()));
}

// Every product review the shopper wrote, across every store. Each goes
// through `deleteReview` rather than a raw delete so the product's rating
// aggregates are corrected in the same transaction — otherwise closing an
// account would leave every product they reviewed permanently
// over-counted. Needs the collection-group index on `reviews.uid`
// (firestore.indexes.json).
async function deleteAuthoredReviews(uid: string): Promise<void> {
  const snap = await adminDb
    .collectionGroup("reviews")
    .where("uid", "==", uid)
    .get();

  for (const doc of snap.docs) {
    const storeId = doc.get("storeId") as string | undefined;
    const productId = doc.get("productId") as string | undefined;
    // Both are denormalized onto every review; a doc missing them predates
    // that and can be removed directly, with no aggregate to correct.
    if (storeId && productId) {
      await deleteReview(storeId, productId, uid);
    } else {
      await doc.ref.delete();
    }
  }
}

export async function deleteShopperAccount(uid: string): Promise<void> {
  await deleteAuthoredReviews(uid);
  await Promise.all(
    USER_SUBCOLLECTIONS.map((name) => deleteSubcollection(uid, name)),
  );
  // Lives outside `users/{uid}` (see lib/devices.ts — a device row is keyed
  // by its token, not by its owner), so it doesn't come along with the
  // subcollections above and has to be swept by uid.
  await deleteDevicesForUser(uid);
  await adminDb.collection("users").doc(uid).delete();

  // Last: once this succeeds the caller's token is dead and there is no way
  // back into the account, so everything above must already be done.
  await adminAuth.deleteUser(uid);
}
