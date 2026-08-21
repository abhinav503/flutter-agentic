// The provider-neutral vocabulary every payment call site speaks. Only the
// two adapter modules beside this file (razorpay.ts, stripe.ts) and the
// facade that dispatches between them (../payments.ts) know which provider is
// actually being talked to; routes, refunds.ts and the dashboard see these
// types only.

export type PaymentProvider = "razorpay" | "stripe";

// Per-store credentials. `keyId` is the *public* key — it ships to the
// shopper's device to open the checkout sheet (Razorpay key id / Stripe
// publishable key). `keySecret` is encrypted at rest (../crypto.ts) and only
// ever decrypted server-side; it is never serialized to a client.
export type StorePaymentConfig = {
  provider: PaymentProvider;
  keyId: string;
  keySecret: string;
  // Derived from the key prefix, never stored — the prefix is the source of
  // truth for test-vs-live, so a config can't claim to be one and be the
  // other. A live store must always present a verified payment before an
  // order is placed; a test store may take the payment-less path (the web
  // preview, which can't run a native checkout SDK) — see the orders route.
  isTest: boolean;
  // The provider's *webhook* signing secret — distinct from keySecret. Null
  // until the owner configures a webhook in their provider dashboard.
  webhookSecret: string | null;
};

// The result of creating the thing the shopper's checkout sheet is opened
// against: a Razorpay Order, or a Stripe PaymentIntent.
//
// `clientSecret` is Stripe-only and is what its PaymentSheet is initialised
// with; Razorpay has no equivalent and leaves it null. That asymmetry is the
// reason this is one struct with an optional field rather than two types —
// the app receives whichever fields its provider needs and ignores the rest.
export type ProviderIntent = {
  id: string;
  clientSecret: string | null;
  // Smallest currency unit (paise, cents) — already multiplied up.
  amount: number;
  currency: string;
};

// What the app hands back after the sheet closes successfully, for the server
// to verify before an order is placed. Razorpay fills all three; Stripe fills
// only `orderId` (the PaymentIntent id) and `paymentId` (the same id — its
// confirmation carries no separate charge reference the client can be
// trusted with) and leaves `signature` empty, because Stripe has no
// client-side signature: verification is a server-side re-fetch instead.
export type PaymentReceipt = {
  orderId: string;
  paymentId: string;
  signature: string;
};

// A refund as the provider reports it, normalised to our RefundStatus by the
// facade. `status` is the provider's own raw string.
// `amount`/`currency` are optional because nothing in the refund *flow* needs
// them — both providers return them on every refund object, and they are typed
// here so a caller with somewhere to put them (the orphaned-payment record,
// which has no order to read a total from) doesn't have to re-fetch.
export type ProviderRefund = {
  id: string;
  status: string;
  amount?: number;
  currency?: string;
};

export class PaymentProviderError extends Error {}

// Which provider a key belongs to, read off its prefix. Razorpay key ids are
// `rzp_test_`/`rzp_live_`; Stripe publishable keys are `pk_test_`/`pk_live_`.
// Returns null for anything else so callers can reject it with a useful
// message rather than guessing.
export function providerForKeyId(keyId: string): PaymentProvider | null {
  if (keyId.startsWith("rzp_test_") || keyId.startsWith("rzp_live_")) {
    return "razorpay";
  }
  if (keyId.startsWith("pk_test_") || keyId.startsWith("pk_live_")) {
    return "stripe";
  }
  return null;
}

// Test-vs-live, again from the prefix — both providers encode the mode in the
// same position, so one helper covers them.
export function isTestKeyId(keyId: string): boolean {
  return keyId.startsWith("rzp_test_") || keyId.startsWith("pk_test_");
}
