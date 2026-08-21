// Integration-tests the Razorpay adapter against the real Razorpay API, by
// importing the shipped modules rather than reimplementing them — so a
// regression in src/lib/payment-providers/razorpay.ts fails this script.
//
// Everything runs against test keys: no real money moves.
//
// Run:
//   RAZORPAY_KEY_ID=rzp_test_… RAZORPAY_KEY_SECRET=… npx tsx scripts/verify-razorpay.ts
//
// Covers what can be checked without a human paying: that the signature is
// really verified (a tampered one, a wrong order id and a wrong secret are all
// rejected), that verification refuses a payment id that isn't real, and that
// an order is created for the exact amount asked for.
//
// What it CANNOT cover, and what a device has to: the amount comparison
// against a genuinely paid payment, and the capture of an authorized one.
// Razorpay has no API to pay an order — that only happens in checkout. See
// docs/payments/payment-flows for the manual passes.

import { createHmac } from "node:crypto";

import {
  createIntent,
  verifyPayment,
  verifySignature,
  verifyWebhookSignature,
} from "../src/lib/payment-providers/razorpay";
import {
  isTestKeyId,
  type StorePaymentConfig,
} from "../src/lib/payment-providers/types";

const KEY_ID = process.env.RAZORPAY_KEY_ID;
const KEY_SECRET = process.env.RAZORPAY_KEY_SECRET;
if (!KEY_ID || !KEY_SECRET) {
  console.error("✗ RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET are required");
  process.exit(1);
}

const config: StorePaymentConfig = {
  provider: "razorpay",
  keyId: KEY_ID,
  keySecret: KEY_SECRET,
  isTest: isTestKeyId(KEY_ID),
  webhookSecret: null,
};

const AMOUNT = 49900; // ₹499.00

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

function sign(orderId: string, paymentId: string, secret = KEY_SECRET!) {
  return createHmac("sha256", secret)
    .update(`${orderId}|${paymentId}`)
    .digest("hex");
}

async function main() {
  if (!config.isTest) {
    console.error("✗ refusing to run against live keys");
    process.exit(1);
  }

  console.log("\nOrder creation");
  const intent = await createIntent(config, AMOUNT, "INR", `verify_${Date.now()}`);
  check("creates an order", Boolean(intent.id), intent.id);
  check("for the exact amount asked", intent.amount === AMOUNT);
  check("in the currency asked", intent.currency === "INR");
  check("with no client secret (Razorpay has none)", intent.clientSecret === null);

  console.log("\nSignature verification");
  const paymentId = "pay_verifyscript";
  check(
    "accepts a correctly signed confirmation",
    verifySignature(config, intent.id, paymentId, sign(intent.id, paymentId)),
  );
  check(
    "rejects a tampered signature",
    !verifySignature(config, intent.id, paymentId, `${sign(intent.id, paymentId)}00`),
  );
  check(
    "rejects a signature for a different order",
    !verifySignature(config, intent.id, paymentId, sign("order_other", paymentId)),
  );
  check(
    "rejects a signature made with the wrong secret",
    !verifySignature(config, intent.id, paymentId, sign(intent.id, paymentId, "wrong")),
  );

  console.log("\nFull verification");
  check(
    "rejects an unsigned confirmation without calling the API",
    (await verifyPayment(config, intent.id, paymentId, "nonsense", AMOUNT, "INR")) === false,
  );
  check(
    "rejects a payment id that does not exist",
    (await verifyPayment(
      config,
      intent.id,
      paymentId,
      sign(intent.id, paymentId),
      AMOUNT,
      "INR",
    )) === false,
  );

  console.log("\nWebhook signatures");
  const body = JSON.stringify({ event: "refund.processed" });
  const secret = "whsec_verify";
  const valid = createHmac("sha256", secret).update(body).digest("hex");
  check("accepts a correct webhook signature", verifyWebhookSignature(secret, body, valid));
  check("rejects a tampered body", !verifyWebhookSignature(secret, `${body} `, valid));
  check("rejects a wrong secret", !verifyWebhookSignature("whsec_other", body, valid));

  console.log(`\n${passed} passed, ${failed} failed\n`);
  console.log(
    "Not covered here — verify on a device: a real payment's amount is compared\n" +
      "against the cart, and an authorized (held) card payment is captured.\n",
  );
  process.exit(failed === 0 ? 0 : 1);
}

main().catch((err) => {
  console.error("✗ verification threw:", err);
  process.exit(1);
});
