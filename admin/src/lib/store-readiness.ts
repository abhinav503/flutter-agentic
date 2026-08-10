import { adminDb } from "@/lib/firebase-admin";
import { getStorePaymentStatus } from "@/lib/payments";

// What a store must have before it can be seen, and before it can go live.
//
// Two tiers on purpose:
//
//   previewReady  — logo + at least one category + at least one product.
//                   Enough that the owner's own storefront actually renders
//                   something. An unpublished store that clears this bar
//                   shows up in discovery FOR ITS OWNER, so they can walk
//                   their real app while they finish setting up.
//   publishReady  — previewReady AND a Razorpay account connected. Payments
//                   are the one thing a shopper cannot work around, so it
//                   gates going live but deliberately not the owner preview.
//
// Computed with the Admin SDK (bypasses rules) and always server-side: the
// submit route re-runs it rather than trusting whatever the dashboard last
// rendered, so a stale browser tab can't submit an empty store.

export type StoreReadinessCheck = {
  id: "logo" | "categories" | "products" | "payments";
  label: string;
  /// Why it isn't satisfied. Empty when [passed].
  hint: string;
  passed: boolean;
  /// False for checks that only block publishing, not owner preview.
  blocksPreview: boolean;
};

export type StoreReadiness = {
  checks: StoreReadinessCheck[];
  previewReady: boolean;
  publishReady: boolean;
};

// count() aggregations, not full document reads: a store with 90 products
// would otherwise pull the whole catalog just to learn it isn't empty.
async function countIn(storeId: string, sub: string): Promise<number> {
  const snap = await adminDb
    .collection("stores")
    .doc(storeId)
    .collection(sub)
    .count()
    .get();
  return snap.data().count;
}

export async function getStoreReadiness(
  storeId: string,
): Promise<StoreReadiness> {
  const storeSnap = await adminDb.collection("stores").doc(storeId).get();
  const logoUrl = (storeSnap.data()?.logoUrl as string | undefined) ?? "";

  const [categories, products, payment] = await Promise.all([
    countIn(storeId, "categories"),
    countIn(storeId, "products"),
    getStorePaymentStatus(storeId),
  ]);

  const checks: StoreReadinessCheck[] = [
    {
      id: "logo",
      label: "Store logo",
      hint: "Add a logo in Settings — it's the store's face in discovery.",
      passed: logoUrl.trim().length > 0,
      blocksPreview: true,
    },
    {
      id: "categories",
      label: "At least one category",
      hint: "Add a category — the storefront's home and browse tabs are built from these.",
      passed: categories > 0,
      blocksPreview: true,
    },
    {
      id: "products",
      label: "At least one product",
      hint: "Add a product — a store with an empty catalog has nothing to sell.",
      passed: products > 0,
      blocksPreview: true,
    },
    {
      id: "payments",
      label: "Razorpay connected",
      hint: "Connect a Razorpay account in Settings so shoppers can pay you.",
      // `configured`, not just a keyId: it also requires the encrypted
      // secret, without which no order can actually be charged.
      passed: payment.configured,
      // Deliberately not a preview blocker: the owner can walk their own
      // storefront and reach checkout before payments are wired.
      blocksPreview: false,
    },
  ];

  const previewReady = checks
    .filter((c) => c.blocksPreview)
    .every((c) => c.passed);

  return {
    checks,
    previewReady,
    publishReady: previewReady && checks.every((c) => c.passed),
  };
}
