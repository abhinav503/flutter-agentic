import { adminDb } from "@/lib/firebase-admin";
import { getStorePaymentStatus } from "@/lib/payments";
import { isSupportEmail, mapStoreSupport } from "@/lib/support";

// What a store must have before it can be seen, and before it can go live.
//
// Two tiers on purpose:
//
//   previewReady  — logo + at least one category + at least one product.
//                   Enough that the owner's own storefront actually renders
//                   something. An unpublished store that clears this bar
//                   shows up in discovery FOR ITS OWNER, so they can walk
//                   their real app while they finish setting up.
//   publishReady  — previewReady AND a payment account connected AND a
//                   support email AND a trading address. None of these is
//                   something a shopper can work around on their own — one to
//                   pay, one to ask when the order goes wrong, one to know who
//                   they bought from — so they gate going live but
//                   deliberately not the owner preview.
//
// Computed with the Admin SDK (bypasses rules) and always server-side: the
// submit route re-runs it rather than trusting whatever the dashboard last
// rendered, so a stale browser tab can't submit an empty store.

export type StoreReadinessCheck = {
  id:
    | "logo"
    | "categories"
    | "products"
    | "payments"
    | "support"
    | "address";
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
  const support = mapStoreSupport(storeSnap.data()?.support);
  const address = ((storeSnap.data()?.address as string | undefined) ?? "").trim();

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
      id: "address",
      label: "Store address",
      hint: "Add your trading address in Settings — a marketplace has to say who is selling and from where.",
      passed: address.length > 0,
      // Not a preview blocker, same as payments and support: it is a
      // disclosure a shopper needs, not something the storefront renders
      // from.
      blocksPreview: false,
    },
    {
      id: "support",
      label: "Support email",
      hint: "Add a support email in Settings → Store so shoppers can reach you about an order.",
      // The email specifically, not "any contact": the app writes the order
      // id, store and account into the message it opens, and none of that
      // survives a phone call. Phone and opening hours stay optional beside
      // it. Validated rather than merely non-empty, so a doc holding junk
      // reads as "not done" instead of quietly passing.
      passed: isSupportEmail(support.email),
      // Not a preview blocker, same reasoning as payments: the owner can
      // walk their own storefront without one.
      blocksPreview: false,
    },
    {
      id: "payments",
      label: "Payments connected",
      hint: "Connect Razorpay or Stripe in Settings so shoppers can pay you.",
      // `configured` is the ACTIVE provider's slot having both a key and an
      // encrypted secret — a store with credentials saved for the other
      // provider still can't charge anyone.
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
