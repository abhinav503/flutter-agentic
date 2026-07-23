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
};

// Non-secret view for the admin dashboard — enough to show "configured, test
// mode, key rzp_test_…Zbh" without ever returning the secret.
export type StorePaymentStatus = {
  configured: boolean;
  keyId: string | null;
  isTest: boolean;
};

type StorePaymentDoc = {
  keyId: string;
  keySecretEnc: string;
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
  };
}

export async function getStorePaymentStatus(
  storeId: string,
): Promise<StorePaymentStatus> {
  const snap = await paymentConfigRef(storeId).get();
  const payment = snap.data() as StorePaymentDoc | undefined;
  if (!payment?.keyId) {
    return { configured: false, keyId: null, isTest: false };
  }
  return {
    configured: Boolean(payment.keySecretEnc),
    keyId: payment.keyId,
    isTest: isTestKey(payment.keyId),
  };
}

export async function setStorePaymentConfig(
  storeId: string,
  keyId: string,
  keySecret: string,
): Promise<void> {
  await paymentConfigRef(storeId).set({
    keyId,
    keySecretEnc: encryptSecret(keySecret),
  });
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
