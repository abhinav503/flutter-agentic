import { createHmac, timingSafeEqual } from "node:crypto";
import { adminDb } from "./firebase-admin";
import { decryptSecret, encryptSecret } from "./crypto";

// Per-store Razorpay credentials. Each store settles into its own Razorpay
// account, so the money for an order routes to that store's admin purely by
// which store the order belongs to — no marketplace/split-payment layer
// needed, because an order is always single-store (see orders.ts).
//
// The keyId is public (it ships to the shopper's checkout sheet); the
// keySecret is encrypted at rest (crypto.ts) and only ever decrypted
// server-side here, to sign order-creation calls and verify payment
// signatures. It is never serialized to a client.

// The Razorpay key prefix is the source of truth for test-vs-live. A live
// store must always present a verified payment before an order is placed; a
// test store may place a payment-less order (the web preview path, which
// can't run the native checkout SDK) — see the orders route.
export type StorePaymentConfig = {
  keyId: string;
  keySecret: string;
  isTest: boolean;
  // The store's Razorpay *webhook* signing secret — distinct from keySecret.
  // Set when the owner creates a webhook in their Razorpay dashboard; used to
  // verify inbound webhook signatures. Null until they configure one.
  webhookSecret: string | null;
};

// Non-secret view for the admin dashboard — enough to show "configured, test
// mode, key rzp_test_…Zbh" without ever returning the secret.
export type StorePaymentStatus = {
  configured: boolean;
  keyId: string | null;
  isTest: boolean;
  webhookConfigured: boolean;
};

type StorePaymentDoc = {
  keyId: string;
  keySecretEnc: string;
  webhookSecretEnc?: string;
};

// The store doc itself is world-readable (catalog discovery), and Firestore
// reads are all-or-nothing per document — so payment credentials must NOT
// live on it. They go in a `private` subcollection doc locked to `read,
// write: if false` in firestore.rules; only the Admin SDK (which bypasses
// rules) reaches it here.
function paymentConfigRef(storeId: string) {
  return adminDb
    .collection("stores")
    .doc(storeId)
    .collection("private")
    .doc("payment");
}

function isTestKey(keyId: string): boolean {
  return keyId.startsWith("rzp_test_");
}

export async function getStorePaymentConfig(
  storeId: string,
): Promise<StorePaymentConfig | null> {
  const snap = await paymentConfigRef(storeId).get();
  const payment = snap.data() as StorePaymentDoc | undefined;
  if (!payment?.keyId || !payment?.keySecretEnc) return null;
  return {
    keyId: payment.keyId,
    keySecret: decryptSecret(payment.keySecretEnc),
    isTest: isTestKey(payment.keyId),
    webhookSecret: payment.webhookSecretEnc
      ? decryptSecret(payment.webhookSecretEnc)
      : null,
  };
}

export async function getStorePaymentStatus(
  storeId: string,
): Promise<StorePaymentStatus> {
  const snap = await paymentConfigRef(storeId).get();
  const payment = snap.data() as StorePaymentDoc | undefined;
  if (!payment?.keyId) {
    return {
      configured: false,
      keyId: null,
      isTest: false,
      webhookConfigured: false,
    };
  }
  return {
    configured: Boolean(payment.keySecretEnc),
    keyId: payment.keyId,
    isTest: isTestKey(payment.keyId),
    webhookConfigured: Boolean(payment.webhookSecretEnc),
  };
}

export async function setStorePaymentConfig(
  storeId: string,
  keyId: string,
  keySecret: string,
): Promise<void> {
  // merge so a later webhook-secret write (or vice versa) isn't clobbered —
  // keys and webhook secret are set in separate Settings actions.
  await paymentConfigRef(storeId).set(
    { keyId, keySecretEnc: encryptSecret(keySecret) },
    { merge: true },
  );
}

export async function setStoreWebhookSecret(
  storeId: string,
  webhookSecret: string,
): Promise<void> {
  await paymentConfigRef(storeId).set(
    { webhookSecretEnc: encryptSecret(webhookSecret) },
    { merge: true },
  );
}

// Razorpay Orders API — creates the order the checkout sheet is opened
// against. `amount` is in the smallest currency unit (paise for INR).
// Authenticated with HTTP Basic (keyId:keySecret), so this must run
// server-side only.
export class RazorpayError extends Error {}

export async function createRazorpayOrder(
  config: StorePaymentConfig,
  amountPaise: number,
  receipt: string,
): Promise<{ id: string; amount: number; currency: string }> {
  const auth = Buffer.from(`${config.keyId}:${config.keySecret}`).toString(
    "base64",
  );
  const response = await fetch("https://api.razorpay.com/v1/orders", {
    method: "POST",
    headers: {
      Authorization: `Basic ${auth}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      amount: amountPaise,
      currency: "INR",
      receipt,
    }),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new RazorpayError(
      `Razorpay order creation failed (${response.status}): ${detail}`,
    );
  }

  const data = (await response.json()) as {
    id: string;
    amount: number;
    currency: string;
  };
  return { id: data.id, amount: data.amount, currency: data.currency };
}

// Razorpay Refunds API — returns a captured payment's money to the shopper.
// `amountPaise` omitted issues a full refund (the only case today: a whole
// order is cancelled). Authenticated with the store's own HTTP Basic
// credentials, so it settles out of the same account the payment landed in.
// Razorpay's `status` is "pending" (accepted, still settling — a webhook
// finalizes it) or "processed" (done); the caller maps that onto RefundStatus.
export async function refundPayment(
  config: StorePaymentConfig,
  paymentId: string,
  amountPaise?: number,
): Promise<{ id: string; status: string }> {
  const auth = Buffer.from(`${config.keyId}:${config.keySecret}`).toString(
    "base64",
  );
  const response = await fetch(
    `https://api.razorpay.com/v1/payments/${paymentId}/refund`,
    {
      method: "POST",
      headers: {
        Authorization: `Basic ${auth}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(amountPaise === undefined ? {} : { amount: amountPaise }),
    },
  );

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new RazorpayError(
      `Razorpay refund failed (${response.status}): ${detail}`,
    );
  }

  const data = (await response.json()) as { id: string; status: string };
  return { id: data.id, status: data.status };
}

// Reads a refund's current status by id — used to reconcile a refund that
// Razorpay accepted as "pending" (refunds settle asynchronously) without
// creating a second one. Same store credentials as everything else here.
export async function getRefund(
  config: StorePaymentConfig,
  refundId: string,
): Promise<{ id: string; status: string }> {
  const auth = Buffer.from(`${config.keyId}:${config.keySecret}`).toString(
    "base64",
  );
  const response = await fetch(
    `https://api.razorpay.com/v1/refunds/${refundId}`,
    { headers: { Authorization: `Basic ${auth}` } },
  );

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new RazorpayError(
      `Razorpay refund lookup failed (${response.status}): ${detail}`,
    );
  }

  const data = (await response.json()) as { id: string; status: string };
  return { id: data.id, status: data.status };
}

// Lists refunds already created against a payment. The Refund create API has
// no idempotency-key header, so this is how we avoid a duplicate: before
// creating a refund we check whether one already exists for the payment and
// adopt it instead. Returns the most recent refund, or null if none.
export async function getExistingRefund(
  config: StorePaymentConfig,
  paymentId: string,
): Promise<{ id: string; status: string } | null> {
  const auth = Buffer.from(`${config.keyId}:${config.keySecret}`).toString(
    "base64",
  );
  const response = await fetch(
    `https://api.razorpay.com/v1/payments/${paymentId}/refunds`,
    { headers: { Authorization: `Basic ${auth}` } },
  );

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new RazorpayError(
      `Razorpay refund lookup failed (${response.status}): ${detail}`,
    );
  }

  const data = (await response.json()) as {
    items?: { id: string; status: string }[];
  };
  const items = data.items ?? [];
  if (items.length === 0) return null;
  // The API returns newest first; a full-order refund only ever produces one.
  return { id: items[0].id, status: items[0].status };
}

// Razorpay's post-payment signature: HMAC_SHA256(orderId|paymentId) keyed by
// the store's secret, compared in constant time. A mismatch means the
// success callback the client reported was forged or tampered — the order
// must not be placed.
export function verifyPaymentSignature(
  config: StorePaymentConfig,
  razorpayOrderId: string,
  razorpayPaymentId: string,
  signature: string,
): boolean {
  const expected = createHmac("sha256", config.keySecret)
    .update(`${razorpayOrderId}|${razorpayPaymentId}`)
    .digest("hex");
  const expectedBuf = Buffer.from(expected, "utf8");
  const actualBuf = Buffer.from(signature, "utf8");
  if (expectedBuf.length !== actualBuf.length) return false;
  return timingSafeEqual(expectedBuf, actualBuf);
}

// Verifies an inbound Razorpay *webhook*: HMAC_SHA256 of the raw request body
// keyed by the store's *webhook* secret (not keySecret), compared constant-time
// to the `X-Razorpay-Signature` header. Must run against the exact raw bytes,
// so the route reads request.text() before any JSON parse.
export function verifyWebhookSignature(
  webhookSecret: string,
  rawBody: string,
  signature: string,
): boolean {
  const expected = createHmac("sha256", webhookSecret)
    .update(rawBody)
    .digest("hex");
  const expectedBuf = Buffer.from(expected, "utf8");
  const actualBuf = Buffer.from(signature, "utf8");
  if (expectedBuf.length !== actualBuf.length) return false;
  return timingSafeEqual(expectedBuf, actualBuf);
}
