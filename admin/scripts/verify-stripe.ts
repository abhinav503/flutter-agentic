// Integration-tests the Stripe adapter against the real Stripe API, by
// importing the shipped modules rather than reimplementing them — so a
// regression in src/lib/payment-providers/stripe.ts fails this script.
//
// Everything runs in a sandbox (test) account: no real money moves, and the
// PaymentIntents/refunds it creates are inert test objects.
//
// Run:
//   STRIPE_PK=pk_test_… STRIPE_SK=rk_test_… npx tsx scripts/verify-stripe.ts
//
// Covers the parts that are easy to get subtly wrong and expensive to get
// wrong in production: that verification actually rejects a wrong amount or
// currency (the only thing standing between us and a replayed cheap intent),
// that refund statuses map onto RefundStatus correctly, and that webhook
// signature checking rejects tampering, a stale timestamp and a wrong secret.

import {
  createIntent,
  createRefund,
  findExistingRefund,
  getRefund,
  verifyPayment,
  verifyWebhookSignature,
} from "../src/lib/payment-providers/stripe";
import {
  isTestKeyId,
  providerForKeyId,
  type StorePaymentConfig,
} from "../src/lib/payment-providers/types";
import { createHmac } from "node:crypto";

const PK = process.env.STRIPE_PK;
const SK = process.env.STRIPE_SK;
if (!PK || !SK) {
  console.error("✗ STRIPE_PK and STRIPE_SK are required");
  process.exit(1);
}

const config: StorePaymentConfig = {
  provider: "stripe",
  keyId: PK,
  keySecret: SK,
  isTest: isTestKeyId(PK),
  webhookSecret: null,
};

let passed = 0;
let failed = 0;

function check(label: string, ok: boolean, detail = "") {
  if (ok) {
    passed++;
    console.log(`  ✓ ${label}${detail ? `  ${detail}` : ""}`);
  } else {
    failed++;
    console.log(`  ✗ ${label}${detail ? `  ${detail}` : ""}`);
  }
}

// Confirms a PaymentIntent the way a real device would, using Stripe's
// always-succeeds test payment method. return_url is required because
// createIntent enables automatic payment methods, some of which redirect.
async function confirmWithTestCard(intentId: string): Promise<string> {
  const res = await fetch(
    `https://api.stripe.com/v1/payment_intents/${intentId}/confirm`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${SK}`,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: new URLSearchParams({
        payment_method: "pm_card_visa",
        return_url: "https://cordeliaapps.com/checkout/return",
      }).toString(),
    },
  );
  const body = (await res.json()) as { status?: string; error?: { message?: string } };
  if (!res.ok) throw new Error(body.error?.message ?? `confirm failed ${res.status}`);
  return body.status ?? "";
}

async function main() {
  console.log(`\nStripe adapter verification (${config.isTest ? "TEST" : "LIVE"} keys)\n`);

  console.log("Key classification");
  check("publishable key -> stripe", providerForKeyId(PK!) === "stripe");
  check("razorpay key id -> razorpay", providerForKeyId("rzp_test_abc") === "razorpay");
  check("garbage key -> null", providerForKeyId("nonsense") === null);
  check("pk_test_ is test mode", isTestKeyId(PK!));

  console.log("\nIntent creation");
  const AMOUNT = 25000; // ₹250 — above Stripe's ~$0.50 equivalent minimum
  const intent = await createIntent(config, AMOUNT, "INR", `verify_${Date.now()}`);
  check("returns a pi_ id", intent.id.startsWith("pi_"), intent.id);
  check("returns a client_secret", Boolean(intent.clientSecret));
  check("amount round-trips", intent.amount === AMOUNT, String(intent.amount));
  check("currency normalised to upper", intent.currency === "INR", intent.currency);

  console.log("\nVerification BEFORE payment (must all reject)");
  check(
    "unconfirmed intent rejected",
    (await verifyPayment(config, intent.id, AMOUNT, "INR")) === false,
  );

  console.log("\nConfirming with test card pm_card_visa");
  const status = await confirmWithTestCard(intent.id);
  check("intent reached succeeded", status === "succeeded", status);

  console.log("\nVerification AFTER payment");
  check(
    "correct amount + currency accepted",
    (await verifyPayment(config, intent.id, AMOUNT, "INR")) === true,
  );
  check(
    "wrong amount rejected",
    (await verifyPayment(config, intent.id, AMOUNT - 100, "INR")) === false,
  );
  check(
    "wrong currency rejected",
    (await verifyPayment(config, intent.id, AMOUNT, "USD")) === false,
  );
  check(
    "unknown intent id rejected",
    (await verifyPayment(config, "pi_does_not_exist", AMOUNT, "INR")) === false,
  );

  console.log("\nRefunds");
  const refund = await createRefund(config, intent.id);
  check("refund created", refund.id.startsWith("re_"), `${refund.id} (${refund.status})`);
  const { toRefundStatus } = await import("../src/lib/payments");
  check(
    "status maps to PROCESSED/PENDING",
    ["PROCESSED", "PENDING"].includes(toRefundStatus("stripe", refund.status)),
    toRefundStatus("stripe", refund.status),
  );
  check("failed -> FAILED", toRefundStatus("stripe", "failed") === "FAILED");
  check("canceled -> FAILED", toRefundStatus("stripe", "canceled") === "FAILED");
  check("pending -> PENDING", toRefundStatus("stripe", "pending") === "PENDING");
  check(
    "razorpay processed -> PROCESSED",
    toRefundStatus("razorpay", "processed") === "PROCESSED",
  );

  const existing = await findExistingRefund(config, intent.id);
  check("existing refund is adopted, not duplicated", existing?.id === refund.id);
  const fetched = await getRefund(config, refund.id);
  check("refund retrievable by id", fetched.id === refund.id);

  console.log("\nWebhook signature");
  const secret = "whsec_test_only_not_a_real_secret";
  const body = JSON.stringify({ type: "refund.updated", data: { object: { id: "re_1" } } });
  const now = Math.floor(Date.now() / 1000);
  const sign = (ts: number, payload: string, key = secret) =>
    createHmac("sha256", key).update(`${ts}.${payload}`).digest("hex");

  check(
    "valid signature accepted",
    verifyWebhookSignature(secret, body, `t=${now},v1=${sign(now, body)}`, now),
  );
  check(
    "tampered body rejected",
    !verifyWebhookSignature(secret, `${body} `, `t=${now},v1=${sign(now, body)}`, now),
  );
  check(
    "wrong secret rejected",
    !verifyWebhookSignature(secret, body, `t=${now},v1=${sign(now, body, "whsec_other")}`, now),
  );
  check(
    "stale timestamp rejected (replay)",
    !verifyWebhookSignature(
      secret,
      body,
      `t=${now - 4000},v1=${sign(now - 4000, body)}`,
      now,
    ),
  );
  check(
    "second v1 during secret roll accepted",
    verifyWebhookSignature(
      secret,
      body,
      `t=${now},v1=${sign(now, body, "whsec_old")},v1=${sign(now, body)}`,
      now,
    ),
  );
  check("missing v1 rejected", !verifyWebhookSignature(secret, body, `t=${now}`, now));

  console.log(`\n${failed === 0 ? "✓ all" : "✗"} ${passed} passed, ${failed} failed\n`);
  process.exit(failed === 0 ? 0 : 1);
}

main().catch((err) => {
  console.error("\n✗ threw:", err instanceof Error ? err.message : err);
  process.exit(1);
});
