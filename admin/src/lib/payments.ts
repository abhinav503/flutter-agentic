import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import { decryptSecret, encryptSecret } from "./crypto";
import * as razorpay from "./payment-providers/razorpay";
import * as stripe from "./payment-providers/stripe";
import {
  isTestKeyId,
  PaymentProviderError,
  providerForKeyId,
  type PaymentProvider,
  type PaymentReceipt,
  type ProviderIntent,
  type ProviderRefund,
  type StorePaymentConfig,
} from "./payment-providers/types";
import type { RefundStatus } from "./types";

// The provider-neutral payments facade. Every route, refunds.ts and the
// dashboard import from here; only the two adapter modules under
// payment-providers/ know which provider is really being called.
//
// Per-store credentials. Each store settles into its *own* provider account,
// so the money for an order routes to that store's admin purely by which store
// the order belongs to — no marketplace/split-payment layer needed, because an
// order is always single-store (see orders.ts).
//
// Which provider a store uses is decided by the key it configured, not a
// separate setting that could disagree with it — see providerForKeyId.

export { PaymentProviderError };
export type {
  PaymentProvider,
  PaymentReceipt,
  StorePaymentConfig,
} from "./payment-providers/types";

// Non-secret view of ONE provider's slot, for the dashboard — enough to show
// "connected, test mode, key pk_test_…HZoK" without returning the secret.
export type ProviderStatus = {
  configured: boolean;
  keyId: string | null;
  isTest: boolean;
  webhookConfigured: boolean;
};

// Both slots plus which one checkout actually uses. A store can keep
// credentials for both providers configured and flip between them without
// re-entering either.
export type StorePaymentStatus = {
  activeProvider: PaymentProvider | null;
  razorpay: ProviderStatus;
  stripe: ProviderStatus;
  // True when the active provider has usable credentials — the single
  // question store-readiness and checkout care about.
  configured: boolean;
};

type ProviderCredsDoc = {
  keyId?: string;
  keySecretEnc?: string;
  webhookSecretEnc?: string;
};

// Credentials live in a per-provider slot so configuring one never disturbs
// the other: a store that has been on Razorpay and moves to Stripe keeps its
// Razorpay keys, which is not a nicety — refunding an order that was paid
// through Razorpay REQUIRES them, however the store takes payment today.
type StorePaymentDoc = {
  activeProvider?: PaymentProvider;
  razorpay?: ProviderCredsDoc;
  stripe?: ProviderCredsDoc;

  // The original single-provider shape, kept readable rather than migrated:
  // every store that predates the split has one of these and nothing else.
  // normalise() folds it into the matching slot on read, so no backfill runs
  // and a doc written by an older deployment still works.
  provider?: PaymentProvider;
  keyId?: string;
  keySecretEnc?: string;
  webhookSecretEnc?: string;
};

// Legacy flat doc -> per-provider slots. A flat doc's provider comes from its
// stored `provider` when present, else its key prefix (pre-Stripe docs have
// neither field and are all Razorpay, which their rzp_ prefix confirms).
function normalise(doc: StorePaymentDoc | undefined): {
  activeProvider: PaymentProvider | null;
  slots: Partial<Record<PaymentProvider, ProviderCredsDoc>>;
} {
  if (!doc) return { activeProvider: null, slots: {} };

  const slots: Partial<Record<PaymentProvider, ProviderCredsDoc>> = {};
  if (doc.razorpay?.keyId) slots.razorpay = doc.razorpay;
  if (doc.stripe?.keyId) slots.stripe = doc.stripe;

  // Fold the legacy fields in, but never over a real slot — if both shapes
  // are present the slot is the newer write.
  const legacyProvider = doc.keyId
    ? (doc.provider ?? providerForKeyId(doc.keyId) ?? "razorpay")
    : null;
  if (doc.keyId && legacyProvider) {
    slots[legacyProvider] ??= {
      keyId: doc.keyId,
      keySecretEnc: doc.keySecretEnc,
      webhookSecretEnc: doc.webhookSecretEnc,
    };
  }

  const configured = (["razorpay", "stripe"] as PaymentProvider[]).filter(
    (p) => slots[p]?.keyId && slots[p]?.keySecretEnc,
  );

  // An explicit activeProvider wins, but only if that slot is actually usable
  // — a stale pointer must not leave a store unable to charge.
  //
  // With no pointer the doc predates the switch feature, so the provider it
  // was charging through is the legacy one. Preferring it matters the moment a
  // second provider is configured: without this, adding Stripe to a Razorpay
  // store would silently redirect live payments, which is exactly what the
  // separate Activate action exists to prevent.
  let active: PaymentProvider | null = null;
  if (doc.activeProvider && configured.includes(doc.activeProvider)) {
    active = doc.activeProvider;
  } else if (legacyProvider && configured.includes(legacyProvider)) {
    active = legacyProvider;
  } else {
    active = configured[0] ?? null;
  }

  return { activeProvider: active, slots };
}

function statusOf(creds: ProviderCredsDoc | undefined): ProviderStatus {
  if (!creds?.keyId) {
    return {
      configured: false,
      keyId: null,
      isTest: false,
      webhookConfigured: false,
    };
  }
  return {
    configured: Boolean(creds.keySecretEnc),
    keyId: creds.keyId,
    isTest: isTestKeyId(creds.keyId),
    webhookConfigured: Boolean(creds.webhookSecretEnc),
  };
}

// The store doc itself is world-readable (catalog discovery), and Firestore
// reads are all-or-nothing per document — so payment credentials must NOT live
// on it. They go in a `private` subcollection doc locked to `read, write: if
// false` in firestore.rules; only the Admin SDK (which bypasses rules) reaches
// it here.
function paymentConfigRef(storeId: string) {
  return adminDb
    .collection("stores")
    .doc(storeId)
    .collection("private")
    .doc("payment");
}

// The credentials checkout should use — the store's active provider.
//
// Pass `provider` to reach a specific slot instead. That is what refunds and
// webhooks do: an order paid through Razorpay must be refunded with Razorpay's
// credentials even after the store has moved to Stripe, and each provider's
// webhook endpoint must verify against its own secret regardless of which one
// is currently taking payments.
export async function getStorePaymentConfig(
  storeId: string,
  provider?: PaymentProvider,
): Promise<StorePaymentConfig | null> {
  const snap = await paymentConfigRef(storeId).get();
  const { activeProvider, slots } = normalise(
    snap.data() as StorePaymentDoc | undefined,
  );
  const wanted = provider ?? activeProvider;
  if (!wanted) return null;

  const creds = slots[wanted];
  if (!creds?.keyId || !creds?.keySecretEnc) return null;

  return {
    provider: wanted,
    keyId: creds.keyId,
    keySecret: decryptSecret(creds.keySecretEnc),
    isTest: isTestKeyId(creds.keyId),
    webhookSecret: creds.webhookSecretEnc
      ? decryptSecret(creds.webhookSecretEnc)
      : null,
  };
}

export async function getStorePaymentStatus(
  storeId: string,
): Promise<StorePaymentStatus> {
  const snap = await paymentConfigRef(storeId).get();
  const { activeProvider, slots } = normalise(
    snap.data() as StorePaymentDoc | undefined,
  );
  const razorpay = statusOf(slots.razorpay);
  const stripe = statusOf(slots.stripe);
  return {
    activeProvider,
    razorpay,
    stripe,
    configured: activeProvider
      ? (activeProvider === "stripe" ? stripe : razorpay).configured
      : false,
  };
}

// Writes into the slot for the provider the key belongs to, leaving the other
// provider's credentials completely alone. merge:true also keeps this
// provider's own webhook secret, which is set by a separate Settings action.
//
// Becomes the active provider only when nothing was usable before. Saving a
// second provider's keys is a setup step, not a decision to start charging
// through it — that is `setActiveProvider`, so an owner can get Stripe ready
// while Razorpay keeps taking live money.
export async function setStorePaymentConfig(
  storeId: string,
  keyId: string,
  keySecret: string,
): Promise<PaymentProvider> {
  const provider = providerForKeyId(keyId);
  if (!provider) {
    throw new PaymentProviderError(`Unrecognised key id: ${keyId}`);
  }
  const { activeProvider } = normalise(
    (await paymentConfigRef(storeId).get()).data() as
      | StorePaymentDoc
      | undefined,
  );

  await paymentConfigRef(storeId).set(
    {
      [provider]: { keyId, keySecretEnc: encryptSecret(keySecret) },
      // Always stamped, even when it isn't changing: a legacy doc has only an
      // *implied* active provider, and writing it makes the doc self-describing
      // from here on rather than leaving the answer to inference.
      activeProvider: activeProvider ?? provider,
    },
    { merge: true },
  );
  return provider;
}

// Each provider has its own webhook endpoint and therefore its own signing
// secret; they are never interchangeable.
export async function setStoreWebhookSecret(
  storeId: string,
  provider: PaymentProvider,
  webhookSecret: string,
): Promise<void> {
  await paymentConfigRef(storeId).set(
    { [provider]: { webhookSecretEnc: encryptSecret(webhookSecret) } },
    { merge: true },
  );
}

// Flips which provider checkout uses. Refuses to point at a slot with no
// usable credentials — that would take the store's checkout offline in one
// click, with the failure only surfacing at a shopper's payment attempt.
export async function setActiveProvider(
  storeId: string,
  provider: PaymentProvider,
): Promise<void> {
  const { slots } = normalise(
    (await paymentConfigRef(storeId).get()).data() as
      | StorePaymentDoc
      | undefined,
  );
  const creds = slots[provider];
  if (!creds?.keyId || !creds?.keySecretEnc) {
    throw new PaymentProviderError(
      `No ${provider} credentials are configured for this store`,
    );
  }
  await paymentConfigRef(storeId).set({ activeProvider: provider }, { merge: true });
}

// Removes one provider's credentials outright. The active provider can't be
// disconnected — there would be nothing left to charge with.
export async function clearStorePaymentConfig(
  storeId: string,
  provider: PaymentProvider,
): Promise<void> {
  const doc = (await paymentConfigRef(storeId).get()).data() as
    | StorePaymentDoc
    | undefined;
  const { activeProvider } = normalise(doc);
  if (activeProvider === provider) {
    throw new PaymentProviderError(
      `${provider} is currently taking payments — switch to the other provider first`,
    );
  }

  // A legacy flat doc keeps its credentials in top-level fields, and they
  // belong to whichever provider that doc named. Clear them alongside the slot
  // when they're the ones being removed, or normalise() would fold them
  // straight back into the slot we just deleted.
  const legacyProvider = doc?.keyId
    ? (doc.provider ?? providerForKeyId(doc.keyId) ?? "razorpay")
    : null;

  await paymentConfigRef(storeId).set(
    {
      [provider]: FieldValue.delete(),
      ...(legacyProvider === provider
        ? {
            keyId: FieldValue.delete(),
            keySecretEnc: FieldValue.delete(),
            webhookSecretEnc: FieldValue.delete(),
            provider: FieldValue.delete(),
          }
        : {}),
    },
    { merge: true },
  );
}

// ---------------------------------------------------------------------------
// Provider dispatch
// ---------------------------------------------------------------------------

// Creates the thing the shopper's checkout sheet is opened against — a
// Razorpay Order or a Stripe PaymentIntent. `amountMinor` is the smallest
// currency unit (paise, cents), already multiplied up by the caller.
export function createPaymentIntent(
  config: StorePaymentConfig,
  amountMinor: number,
  currency: string,
  receipt: string,
): Promise<ProviderIntent> {
  return config.provider === "stripe"
    ? stripe.createIntent(config, amountMinor, currency, receipt)
    : razorpay.createIntent(config, amountMinor, currency, receipt);
}

// Confirms the payment the client reported is real, captured, and for the
// amount we intended — before any order is placed.
//
// The two providers prove this differently and both are handled here so no
// route has to care: Razorpay signs (orderId|paymentId) with the store secret
// and we check that HMAC locally; Stripe has no client signature, so we
// re-fetch the PaymentIntent and assert it reached `succeeded` for
// `expectedAmountMinor`. That amount check is what makes a stolen or replayed
// Stripe intent id useless.
export function verifyPayment(
  config: StorePaymentConfig,
  receipt: PaymentReceipt,
  expectedAmountMinor: number,
  expectedCurrency: string,
): Promise<boolean> {
  if (config.provider === "stripe") {
    return stripe.verifyPayment(
      config,
      receipt.orderId,
      expectedAmountMinor,
      expectedCurrency,
    );
  }
  return Promise.resolve(
    razorpay.verifyPayment(
      config,
      receipt.orderId,
      receipt.paymentId,
      receipt.signature,
    ),
  );
}

export function createRefund(
  config: StorePaymentConfig,
  paymentId: string,
  amountMinor?: number,
): Promise<ProviderRefund> {
  return config.provider === "stripe"
    ? stripe.createRefund(config, paymentId, amountMinor)
    : razorpay.createRefund(config, paymentId, amountMinor);
}

export function getRefund(
  config: StorePaymentConfig,
  refundId: string,
): Promise<ProviderRefund> {
  return config.provider === "stripe"
    ? stripe.getRefund(config, refundId)
    : razorpay.getRefund(config, refundId);
}

export function findExistingRefund(
  config: StorePaymentConfig,
  paymentId: string,
): Promise<ProviderRefund | null> {
  return config.provider === "stripe"
    ? stripe.findExistingRefund(config, paymentId)
    : razorpay.findExistingRefund(config, paymentId);
}

// Normalises each provider's own refund vocabulary onto our RefundStatus.
// Razorpay: "pending" | "processed". Stripe: "pending" | "succeeded" |
// "failed" | "canceled" | "requires_action". Anything not terminal is PENDING,
// so a refund still in flight is never reported as settled.
export function toRefundStatus(
  provider: PaymentProvider,
  raw: string,
): RefundStatus {
  if (provider === "stripe") {
    if (raw === stripe.REFUND_STATUS_PROCESSED) return "PROCESSED";
    if (stripe.REFUND_STATUS_FAILED.has(raw)) return "FAILED";
    return "PENDING";
  }
  return raw === razorpay.REFUND_STATUS_PROCESSED ? "PROCESSED" : "PENDING";
}

// Verifies an inbound webhook against the store's *webhook* secret (distinct
// from keySecret). Both providers HMAC-SHA256 the raw request bytes, so the
// route must read request.text() before any JSON parse — but Stripe folds a
// timestamp into the signed payload to block replays, which is why this can't
// be one shared implementation.
export function verifyWebhookSignature(
  provider: PaymentProvider,
  webhookSecret: string,
  rawBody: string,
  signatureHeader: string,
): boolean {
  return provider === "stripe"
    ? stripe.verifyWebhookSignature(webhookSecret, rawBody, signatureHeader)
    : razorpay.verifyWebhookSignature(webhookSecret, rawBody, signatureHeader);
}
