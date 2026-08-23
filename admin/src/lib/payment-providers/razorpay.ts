import { createHmac, timingSafeEqual } from "node:crypto";
import {
  PaymentProviderError,
  type ProviderIntent,
  type ProviderRefund,
  type StorePaymentConfig,
} from "./types";

// Razorpay adapter. Every call authenticates with HTTP Basic (keyId:keySecret)
// using the *store's* own credentials, so money settles into that store's
// Razorpay account — which is the whole reason an order is always single-store
// (see orders.ts) and needs no marketplace/split layer.
//
// Raw fetch rather than the razorpay npm SDK, matching how this codebase talks
// to every other HTTP service: the surface we use is five endpoints, and the
// SDK would add a dependency whose only job is building these same requests.

const API = "https://api.razorpay.com/v1";

function authHeader(config: StorePaymentConfig): string {
  const auth = Buffer.from(`${config.keyId}:${config.keySecret}`).toString(
    "base64",
  );
  return `Basic ${auth}`;
}

async function call<T>(
  config: StorePaymentConfig,
  path: string,
  init?: { method: "POST"; body: unknown },
): Promise<T> {
  const response = await fetch(`${API}${path}`, {
    method: init?.method ?? "GET",
    headers: {
      Authorization: authHeader(config),
      ...(init ? { "Content-Type": "application/json" } : {}),
    },
    ...(init ? { body: JSON.stringify(init.body) } : {}),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new PaymentProviderError(
      `Razorpay ${path} failed (${response.status}): ${detail}`,
    );
  }
  return (await response.json()) as T;
}

// Creates the Razorpay Order the checkout sheet is opened against. `amount` is
// in the smallest currency unit (paise for INR). Razorpay has no client-secret
// concept, so ProviderIntent.clientSecret is null.
export async function createIntent(
  config: StorePaymentConfig,
  amountMinor: number,
  currency: string,
  receipt: string,
): Promise<ProviderIntent> {
  const data = await call<{ id: string; amount: number; currency: string }>(
    config,
    "/orders",
    { method: "POST", body: { amount: amountMinor, currency, receipt } },
  );
  return {
    id: data.id,
    clientSecret: null,
    amount: data.amount,
    currency: data.currency,
  };
}

// Razorpay's post-payment signature: HMAC_SHA256(orderId|paymentId) keyed by
// the store's secret, compared in constant time. A mismatch means the success
// callback the client reported was forged or tampered — the order must not be
// placed. Purely local, so it needs no network round trip.
//
// This proves the client really paid *this* Razorpay order. It proves nothing
// about what that order was FOR, which is why verifyPayment below re-fetches
// the amount — see the comment there.
export function verifySignature(
  config: StorePaymentConfig,
  orderId: string,
  paymentId: string,
  signature: string,
): boolean {
  const expected = createHmac("sha256", config.keySecret)
    .update(`${orderId}|${paymentId}`)
    .digest("hex");
  return constantTimeEquals(expected, signature);
}

// Full verification: the signature, AND what was actually paid.
//
// The signature alone is not enough. It binds (orderId|paymentId), so it
// proves the shopper paid that Razorpay order — but the order id comes from
// the client, and a shopper can hold a *genuinely paid* order from an earlier,
// smaller cart they never placed. Presenting it against a bigger cart passes
// every local check: the signature is real, and the replay guard only rejects
// a payment that already has an order behind it. So the amount is re-read from
// Razorpay and compared to what this cart costs — the same thing Stripe's
// verification does by re-fetching the intent.
//
// The payment is read rather than the order, because it answers all three
// questions at once: which order it belongs to (belt and braces with the
// signature), what it was for, and whether the money actually moved.
export async function verifyPayment(
  config: StorePaymentConfig,
  orderId: string,
  paymentId: string,
  signature: string,
  expectedAmountMinor: number,
  expectedCurrency: string,
): Promise<boolean> {
  if (!verifySignature(config, orderId, paymentId, signature)) return false;

  let payment: RazorpayPayment;
  try {
    payment = await call<RazorpayPayment>(
      config,
      `/payments/${encodeURIComponent(paymentId)}`,
    );
  } catch {
    // An unknown id (or a key that can't read it) is a failed verification,
    // not a server error — same rule as Stripe's.
    return false;
  }

  // Everything about *what was paid* is settled before anything about
  // whether it was collected — a payment for the wrong basket must never
  // reach the capture below.
  const matchesCart =
    payment.order_id === orderId &&
    payment.amount === expectedAmountMinor &&
    payment.currency.toUpperCase() === expectedCurrency.toUpperCase();
  if (!matchesCart) return false;

  if (payment.status === "captured") return true;
  if (payment.status !== "authorized") return false;

  return capture(config, paymentId, expectedAmountMinor, expectedCurrency);
}

// An `authorized` payment is a hold, not a payment: the bank has reserved the
// money and nobody has claimed it. Left alone it expires and the shopper gets
// it back, while the store has already handed over the goods — so an order
// must never be written against one.
//
// Whether that state is even reachable depends on a setting in the *store's*
// own Razorpay dashboard (Payment Capture: automatic or manual), which no
// amount of care on our side controls. Rather than refuse those checkouts and
// send every affected owner to their dashboard, the capture is done here: the
// storefront has already told the shopper they are paying now, so claiming
// the money now is what both sides already believe happened.
//
// Only ever called for a payment that has just been proved to be for this
// exact cart.
async function capture(
  config: StorePaymentConfig,
  paymentId: string,
  amountMinor: number,
  currency: string,
): Promise<boolean> {
  try {
    const captured = await call<RazorpayPayment>(
      config,
      `/payments/${encodeURIComponent(paymentId)}/capture`,
      { method: "POST", body: { amount: amountMinor, currency } },
    );
    return captured.status === "captured";
  } catch {
    // Razorpay rejects a second capture, so a retried checkout (or a capture
    // from the dashboard in between) lands here with the money in fact
    // taken. Re-read before refusing an order that is genuinely paid for.
    try {
      const payment = await call<RazorpayPayment>(
        config,
        `/payments/${encodeURIComponent(paymentId)}`,
      );
      return payment.status === "captured";
    } catch {
      return false;
    }
  }
}

type RazorpayPayment = {
  id: string;
  amount: number;
  currency: string;
  status: string;
  order_id: string;
};

// `amountMinor` omitted issues a full refund (the only case today: a whole
// order is cancelled). Settles out of the same account the payment landed in.
// Razorpay's `status` is "pending" (accepted, still settling — a webhook
// finalizes it) or "processed" (done); the facade maps that onto RefundStatus.
export async function createRefund(
  config: StorePaymentConfig,
  paymentId: string,
  amountMinor?: number,
): Promise<ProviderRefund> {
  return call<ProviderRefund>(config, `/payments/${paymentId}/refund`, {
    method: "POST",
    body: amountMinor === undefined ? {} : { amount: amountMinor },
  });
}

// Reads a refund's current status by id — used to reconcile a refund Razorpay
// accepted as "pending" (refunds settle asynchronously, over days) without
// creating a second one.
export async function getRefund(
  config: StorePaymentConfig,
  refundId: string,
): Promise<ProviderRefund> {
  return call<ProviderRefund>(config, `/refunds/${refundId}`);
}

// Lists refunds already created against a payment. Razorpay's Refund create
// API has no idempotency-key header, so this is how a duplicate is avoided:
// before creating we check whether one already exists and adopt it instead.
// (Stripe needs no equivalent — it takes an Idempotency-Key directly.)
export async function findExistingRefund(
  config: StorePaymentConfig,
  paymentId: string,
): Promise<ProviderRefund | null> {
  const data = await call<{ items?: ProviderRefund[] }>(
    config,
    `/payments/${paymentId}/refunds`,
  );
  const items = data.items ?? [];
  if (items.length === 0) return null;
  // Newest first; a full-order refund only ever produces one.
  return { id: items[0].id, status: items[0].status };
}

// Verifies an inbound Razorpay webhook: HMAC_SHA256 of the raw request body
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
  return constantTimeEquals(expected, signature);
}

function constantTimeEquals(expected: string, actual: string): boolean {
  const expectedBuf = Buffer.from(expected, "utf8");
  const actualBuf = Buffer.from(actual, "utf8");
  if (expectedBuf.length !== actualBuf.length) return false;
  return timingSafeEqual(expectedBuf, actualBuf);
}

// Razorpay reports a refund as "pending" (accepted, settling) or "processed".
export const REFUND_STATUS_PROCESSED = "processed";

// Proves a key pair works before it is stored: the cheapest authenticated
// read Razorpay offers. A wrong secret answers 401, a wrong key id 400/401 —
// either way the pair is refused at save time instead of at a shopper's
// checkout. Network failure is reported as such, not as "invalid".
export async function verifyCredentials(
  config: StorePaymentConfig,
): Promise<{ ok: true } | { ok: false; reason: string }> {
  let response: Response;
  try {
    response = await fetch(`${API}/payments?count=1`, {
      headers: { Authorization: authHeader(config) },
    });
  } catch {
    return { ok: false, reason: "Could not reach Razorpay to check the keys — try again." };
  }
  if (response.status === 401 || response.status === 400) {
    return { ok: false, reason: "Razorpay rejected this key id + secret. Copy both again from Razorpay → Settings → API Keys." };
  }
  if (!response.ok) {
    return { ok: false, reason: `Razorpay answered ${response.status} while checking the keys.` };
  }
  return { ok: true };
}
