import { createHmac, timingSafeEqual } from "node:crypto";
import {
  PaymentProviderError,
  type ProviderIntent,
  type ProviderRefund,
  type StorePaymentConfig,
} from "./types";

// Stripe adapter, the sibling of razorpay.ts. Same per-store credential model:
// every call authenticates as the store's own account, so money settles there.
//
// Two things differ from Razorpay in ways the rest of the code has to respect:
//
//  1. The client needs a `client_secret`. Stripe's PaymentSheet runs on the
//     device and sends card details straight to Stripe (which is what keeps us
//     out of PCI scope) — it is initialised with the PaymentIntent's
//     client_secret plus the store's *publishable* key.
//  2. There is no client-supplied signature to check. Razorpay hands back an
//     HMAC we verify locally; Stripe's equivalent is a server-side re-fetch of
//     the PaymentIntent, asserting it really reached `succeeded` for the
//     amount we intended. See verifyPayment.
//
// Raw fetch rather than the `stripe` npm SDK, for the same reason as
// razorpay.ts: this is six endpoints, and the SDK's only job would be building
// these requests. Note Stripe's API is form-encoded, not JSON.

const API = "https://api.stripe.com/v1";

// Every StoreCurrency we support (INR, EUR, GBP, USD) is a two-decimal
// currency, so "smallest unit" is always amount*100 — the same convention
// Razorpay uses for paise. Zero-decimal currencies (JPY, KRW) would need a
// per-currency exponent here; none are in StoreCurrency today.
function form(params: Record<string, string | number | undefined>): string {
  const body = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined) body.set(key, String(value));
  }
  return body.toString();
}

async function call<T>(
  config: StorePaymentConfig,
  path: string,
  init?: { body: string; idempotencyKey?: string },
): Promise<T> {
  const response = await fetch(`${API}${path}`, {
    method: init ? "POST" : "GET",
    headers: {
      Authorization: `Bearer ${config.keySecret}`,
      ...(init
        ? {
            "Content-Type": "application/x-www-form-urlencoded",
            // Stripe dedupes retries of the same key for 24h, so a network
            // retry can't double-charge or double-refund. Razorpay has no
            // equivalent header, which is why it needs findExistingRefund.
            ...(init.idempotencyKey
              ? { "Idempotency-Key": init.idempotencyKey }
              : {}),
          }
        : {}),
    },
    ...(init ? { body: init.body } : {}),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new PaymentProviderError(
      `Stripe ${path} failed (${response.status}): ${detail}`,
    );
  }
  return (await response.json()) as T;
}

type StripePaymentIntent = {
  id: string;
  client_secret: string | null;
  amount: number;
  currency: string;
  status: string;
};

// Creates the PaymentIntent the PaymentSheet is opened against.
// `automatic_payment_methods` lets Stripe decide which methods to offer for the
// store's country and currency, rather than us hardcoding a list here.
//
// `receipt` rides along as metadata: unlike Razorpay's first-class `receipt`
// field there's no dedicated slot, but it's what ties a Stripe-side record back
// to the shopper who created it. It doubles as the idempotency key, so a
// retried create returns the same intent instead of a second one.
export async function createIntent(
  config: StorePaymentConfig,
  amountMinor: number,
  currency: string,
  receipt: string,
): Promise<ProviderIntent> {
  const data = await call<StripePaymentIntent>(config, "/payment_intents", {
    body: form({
      amount: amountMinor,
      // Stripe expects a lowercase ISO-4217 code; StoreCurrency serializes
      // uppercase (and Razorpay wants it that way).
      currency: currency.toLowerCase(),
      "automatic_payment_methods[enabled]": "true",
      "metadata[receipt]": receipt,
    }),
    idempotencyKey: receipt,
  });
  return {
    id: data.id,
    clientSecret: data.client_secret,
    amount: data.amount,
    currency: data.currency.toUpperCase(),
  };
}

// Stripe's answer to Razorpay's signature check. There is nothing to verify
// locally — the client can claim any PaymentIntent id — so we ask Stripe
// directly and require three things to line up:
//
//   1. the intent actually reached `succeeded` (money captured), and
//   2. its amount is the one we created it for, and
//   3. its currency matches.
//
// (2) and (3) are what stop a shopper from pointing checkout at some other,
// cheaper PaymentIntent of their own — the id alone proves nothing.
//
// Deliberately strict about `succeeded`: `processing` means an async method
// (bank debit) that may still fail, and placing an order against it would ship
// goods for money that never arrives. Razorpay's flow captures before we're
// called, so requiring the terminal state here keeps the two providers'
// guarantees identical.
export async function verifyPayment(
  config: StorePaymentConfig,
  paymentIntentId: string,
  expectedAmountMinor: number,
  expectedCurrency: string,
): Promise<boolean> {
  let intent: StripePaymentIntent;
  try {
    intent = await call<StripePaymentIntent>(
      config,
      `/payment_intents/${encodeURIComponent(paymentIntentId)}`,
    );
  } catch {
    // An unknown id (or a key that can't read it) is a failed verification,
    // not a server error — the caller turns it into a rejected checkout.
    return false;
  }
  return (
    intent.status === "succeeded" &&
    intent.amount === expectedAmountMinor &&
    intent.currency.toUpperCase() === expectedCurrency.toUpperCase()
  );
}

// Refunds are created against the PaymentIntent (not a charge), so the id we
// already store on the order is enough. `amountMinor` omitted = full refund.
// The idempotency key is derived from the intent id, so the "already refunded"
// race Razorpay needs a lookup for is handled by Stripe itself.
export async function createRefund(
  config: StorePaymentConfig,
  paymentIntentId: string,
  amountMinor?: number,
): Promise<ProviderRefund> {
  return call<ProviderRefund>(config, "/refunds", {
    body: form({ payment_intent: paymentIntentId, amount: amountMinor }),
    idempotencyKey: `refund_${paymentIntentId}`,
  });
}

export async function getRefund(
  config: StorePaymentConfig,
  refundId: string,
): Promise<ProviderRefund> {
  return call<ProviderRefund>(
    config,
    `/refunds/${encodeURIComponent(refundId)}`,
  );
}

// Kept for interface parity with razorpay.ts (the facade calls it the same way
// for both). Stripe's idempotency key already prevents duplicates, but this
// still matters on the *other* path: a refund created by someone in the Stripe
// dashboard, outside our idempotency scope, should be adopted rather than
// duplicated.
export async function findExistingRefund(
  config: StorePaymentConfig,
  paymentIntentId: string,
): Promise<ProviderRefund | null> {
  const data = await call<{ data?: ProviderRefund[] }>(
    config,
    `/refunds?payment_intent=${encodeURIComponent(paymentIntentId)}&limit=1`,
  );
  const items = data.data ?? [];
  if (items.length === 0) return null;
  return { id: items[0].id, status: items[0].status };
}

// Verifies an inbound Stripe webhook. The scheme is more involved than
// Razorpay's plain body HMAC: the `Stripe-Signature` header carries a
// timestamp and one or more v1 signatures,
//
//   t=1737000000,v1=abc…,v1=def…
//
// and the signed payload is `${t}.${rawBody}`. The timestamp is part of what's
// signed specifically so a captured request can't be replayed later, so we
// also enforce a tolerance window — without that check the signature alone
// would still verify years afterwards.
const WEBHOOK_TOLERANCE_SECONDS = 300;

export function verifyWebhookSignature(
  webhookSecret: string,
  rawBody: string,
  signatureHeader: string,
  nowSeconds: number = Math.floor(Date.now() / 1000),
): boolean {
  let timestamp = "";
  const signatures: string[] = [];
  for (const part of signatureHeader.split(",")) {
    const [key, value] = part.trim().split("=", 2);
    if (key === "t") timestamp = value ?? "";
    if (key === "v1" && value) signatures.push(value);
  }
  if (!timestamp || signatures.length === 0) return false;

  const age = nowSeconds - Number(timestamp);
  if (!Number.isFinite(age) || Math.abs(age) > WEBHOOK_TOLERANCE_SECONDS) {
    return false;
  }

  const expected = createHmac("sha256", webhookSecret)
    .update(`${timestamp}.${rawBody}`)
    .digest("hex");
  // Any listed v1 matching is a pass — Stripe sends two during a secret roll.
  return signatures.some((candidate) => constantTimeEquals(expected, candidate));
}

function constantTimeEquals(expected: string, actual: string): boolean {
  const expectedBuf = Buffer.from(expected, "utf8");
  const actualBuf = Buffer.from(actual, "utf8");
  if (expectedBuf.length !== actualBuf.length) return false;
  return timingSafeEqual(expectedBuf, actualBuf);
}

// Stripe refund statuses: pending | succeeded | failed | canceled |
// requires_action. Only `succeeded` is settled; failed/canceled are terminal
// failures; everything else is still in flight.
export const REFUND_STATUS_PROCESSED = "succeeded";
export const REFUND_STATUS_FAILED = new Set(["failed", "canceled"]);
