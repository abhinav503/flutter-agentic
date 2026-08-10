// Verifies the per-provider payment-config storage against real Firestore,
// on a throwaway store id — the behaviour that matters is:
//
//   1. a legacy flat doc (every store predating the provider split) still
//      reads back correctly, with no backfill;
//   2. saving one provider's keys NEVER disturbs the other's — the whole
//      reason refunds for an old provider keep working after a switch;
//   3. the active provider is an explicit pointer, moved only on purpose;
//   4. you cannot activate a provider with no credentials, or disconnect the
//      one currently taking payments.
//
// Run:  npx tsx --env-file=.env.local scripts/verify-payment-config.ts

import { adminDb } from "../src/lib/firebase-admin";
import {
  clearStorePaymentConfig,
  getStorePaymentConfig,
  getStorePaymentStatus,
  setActiveProvider,
  setStorePaymentConfig,
  setStoreWebhookSecret,
} from "../src/lib/payments";
import { encryptSecret } from "../src/lib/crypto";

const STORE = `__verify_payment_config_${Date.now()}`;
const ref = adminDb
  .collection("stores")
  .doc(STORE)
  .collection("private")
  .doc("payment");

const RZP_KEY = "rzp_test_VerifyKey123456";
const RZP_SECRET = "razorpaySecretValue";
const STRIPE_KEY = "pk_test_VerifyKey123456";
const STRIPE_SECRET = "rk_test_stripeSecretValue";

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

async function main() {
  console.log(`\nPayment config storage (scratch store ${STORE})\n`);

  // ---- 1. legacy flat doc, exactly as pre-split deployments wrote it ------
  console.log("Legacy flat doc migrates on read");
  await ref.set({
    keyId: RZP_KEY,
    keySecretEnc: encryptSecret(RZP_SECRET),
    webhookSecretEnc: encryptSecret("whsec_legacy"),
  });

  let cfg = await getStorePaymentConfig(STORE);
  check("reads back as razorpay", cfg?.provider === "razorpay", cfg?.provider);
  check("key id preserved", cfg?.keyId === RZP_KEY);
  check("secret decrypts", cfg?.keySecret === RZP_SECRET);
  check("webhook secret decrypts", cfg?.webhookSecret === "whsec_legacy");
  check("recognised as test mode", cfg?.isTest === true);

  let status = await getStorePaymentStatus(STORE);
  check("active provider inferred", status.activeProvider === "razorpay");
  check("razorpay slot reported configured", status.razorpay.configured);
  check("stripe slot reported empty", !status.stripe.configured);
  check("store counts as configured", status.configured);

  // ---- 2. adding Stripe must not touch Razorpay --------------------------
  console.log("\nAdding Stripe preserves Razorpay");
  await setStorePaymentConfig(STORE, STRIPE_KEY, STRIPE_SECRET);

  const rzp = await getStorePaymentConfig(STORE, "razorpay");
  check("razorpay key still present", rzp?.keyId === RZP_KEY);
  check("razorpay secret still decrypts", rzp?.keySecret === RZP_SECRET);
  check(
    "razorpay webhook secret survived",
    rzp?.webhookSecret === "whsec_legacy",
  );

  const stripe = await getStorePaymentConfig(STORE, "stripe");
  check("stripe key stored", stripe?.keyId === STRIPE_KEY);
  check("stripe secret decrypts", stripe?.keySecret === STRIPE_SECRET);
  check("stripe has no webhook secret yet", stripe?.webhookSecret === null);

  status = await getStorePaymentStatus(STORE);
  check(
    "active provider did NOT silently move",
    status.activeProvider === "razorpay",
    String(status.activeProvider),
  );
  check(
    "both slots reported configured",
    status.razorpay.configured && status.stripe.configured,
  );

  // ---- 3. switching is explicit ------------------------------------------
  console.log("\nSwitching the active provider");
  await setActiveProvider(STORE, "stripe");
  status = await getStorePaymentStatus(STORE);
  check("active provider is stripe", status.activeProvider === "stripe");

  cfg = await getStorePaymentConfig(STORE);
  check("default config now resolves to stripe", cfg?.provider === "stripe");
  check(
    "razorpay still reachable by name (refunds)",
    (await getStorePaymentConfig(STORE, "razorpay"))?.keySecret === RZP_SECRET,
  );

  // ---- 4. per-provider webhook secrets stay separate ---------------------
  console.log("\nWebhook secrets are per provider");
  await setStoreWebhookSecret(STORE, "stripe", "whsec_stripe");
  check(
    "stripe webhook secret set",
    (await getStorePaymentConfig(STORE, "stripe"))?.webhookSecret ===
      "whsec_stripe",
  );
  check(
    "razorpay webhook secret untouched",
    (await getStorePaymentConfig(STORE, "razorpay"))?.webhookSecret ===
      "whsec_legacy",
  );

  // ---- 5. guardrails ------------------------------------------------------
  console.log("\nGuardrails");
  await clearStorePaymentConfig(STORE, "razorpay");
  status = await getStorePaymentStatus(STORE);
  check("razorpay disconnected", !status.razorpay.configured);
  check(
    "legacy flat fields cleared too",
    (await ref.get()).data()?.keyId === undefined,
  );
  check("stripe unaffected", status.stripe.configured);

  let threw = false;
  try {
    await setActiveProvider(STORE, "razorpay");
  } catch {
    threw = true;
  }
  check("cannot activate a provider with no credentials", threw);

  threw = false;
  try {
    await clearStorePaymentConfig(STORE, "stripe");
  } catch {
    threw = true;
  }
  check("cannot disconnect the active provider", threw);

  await ref.delete();
  await adminDb.collection("stores").doc(STORE).delete();
  console.log(
    `\n${failed === 0 ? "✓ all" : "✗"} ${passed} passed, ${failed} failed\n`,
  );
  process.exit(failed === 0 ? 0 : 1);
}

main().catch(async (err) => {
  console.error("\n✗ threw:", err instanceof Error ? err.message : err);
  await ref.delete().catch(() => {});
  await adminDb
    .collection("stores")
    .doc(STORE)
    .delete()
    .catch(() => {});
  process.exit(1);
});
