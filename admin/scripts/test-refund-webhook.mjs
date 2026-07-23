// Verifies the Razorpay refund webhook end-to-end against a running admin
// server — specifically the security-critical signature handshake, which is
// the easy part to get subtly wrong (wrong bytes signed, wrong secret source,
// non-constant-time compare). It signs sample payloads the way Razorpay does
// (HMAC-SHA256 of the raw body, keyed by the store's WEBHOOK secret) and POSTs
// them to the live route, asserting valid signatures are accepted and every
// tampered/missing/wrong-secret case is rejected.
//
// Prerequisites:
//   1. Admin server running            (npm run dev  → http://localhost:4100)
//   2. The store's webhook secret set on Settings → Razorpay → Webhook
//      (this must match WEBHOOK_SECRET below — the route reads it from
//       Firestore and verifies against it).
//
// Run:
//   WEBHOOK_SECRET=whsec_xxx node scripts/test-refund-webhook.mjs
//
// Optional env:
//   ADMIN_BASE_URL   default http://localhost:4100
//   STORE_ID         default the seeded "Gravia" store
//   PAYMENT_ID       a REAL cancelled+paid order's razorpayPaymentId — makes
//                    the first check assert the order actually flips to
//                    PROCESSED. ⚠ This mutates that order's refund state
//                    (refundId becomes the fake test id). Omit for a fully
//                    non-destructive run (unknown payment → acked, no writes).

import { createHmac } from "node:crypto";

const BASE = process.env.ADMIN_BASE_URL ?? "http://localhost:4100";
const STORE_ID = process.env.STORE_ID ?? "4116e313-a173-4f9f-b471-8bc92ab8437d";
const SECRET = process.env.WEBHOOK_SECRET;
const PAYMENT_ID = process.env.PAYMENT_ID ?? "pay_TEST_UNKNOWN_PAYMENT";
const DESTRUCTIVE = Boolean(process.env.PAYMENT_ID);

const URL = `${BASE}/api/stores/${STORE_ID}/webhooks/razorpay`;

if (!SECRET) {
  console.error(
    "✗ WEBHOOK_SECRET is required.\n" +
      "  Set the same secret you configured on Settings → Razorpay → Webhook.\n" +
      "  e.g. WEBHOOK_SECRET=whsec_xxx node scripts/test-refund-webhook.mjs",
  );
  process.exit(2);
}

function sign(rawBody, secret) {
  return createHmac("sha256", secret).update(rawBody).digest("hex");
}

function refundEvent(event, { refundId = "rfnd_TEST123", status } = {}) {
  return {
    entity: "event",
    event,
    payload: {
      refund: {
        entity: {
          id: refundId,
          entity: "refund",
          payment_id: PAYMENT_ID,
          status: status ?? (event === "refund.processed" ? "processed" : "failed"),
          amount: 1000,
        },
      },
      payment: { entity: { id: PAYMENT_ID } },
    },
  };
}

// POST a raw body + explicit signature header (null = omit the header).
async function post(rawBody, signature) {
  const headers = { "Content-Type": "application/json" };
  if (signature !== null) headers["X-Razorpay-Signature"] = signature;
  let res;
  try {
    res = await fetch(URL, { method: "POST", headers, body: rawBody });
  } catch (err) {
    console.error(
      `\n✗ Could not reach ${URL}\n  Is the admin server running? (npm run dev)\n  ${err.message}`,
    );
    process.exit(2);
  }
  const body = await res.json().catch(() => ({}));
  return { status: res.status, body };
}

let passed = 0;
let failed = 0;

function check(name, ok, detail) {
  if (ok) {
    passed++;
    console.log(`  ✓ ${name}`);
  } else {
    failed++;
    console.log(`  ✗ ${name}${detail ? ` — ${detail}` : ""}`);
  }
}

console.log(`\nRefund webhook check → ${URL}`);
console.log(DESTRUCTIVE
  ? `  PAYMENT_ID=${PAYMENT_ID} (will assert the real order flips to PROCESSED)\n`
  : `  non-destructive run (synthetic payment id — no order is modified)\n`);

// 1. Valid signature + refund.processed → accepted (200). If a real PAYMENT_ID
//    was given, the matching order must flip to PROCESSED; otherwise the route
//    acks the unknown payment. A 400 here means the secret isn't configured.
{
  const raw = JSON.stringify(refundEvent("refund.processed"));
  const { status, body } = await post(raw, sign(raw, SECRET));
  if (status === 400) {
    check(
      "valid signature accepted",
      false,
      `route returned 400 "${body.error ?? ""}". Configure the webhook secret ` +
        `on the dashboard (it must equal WEBHOOK_SECRET).`,
    );
  } else if (DESTRUCTIVE) {
    check(
      "valid signature → order flips to PROCESSED",
      status === 200 && body.refundStatus === "PROCESSED",
      `status ${status}, body ${JSON.stringify(body)}`,
    );
  } else {
    check(
      "valid signature accepted (unknown payment acked)",
      status === 200 && body.ok === true,
      `status ${status}, body ${JSON.stringify(body)}`,
    );
  }
}

// 2. Tampered body (signature computed over a DIFFERENT body) → 401.
{
  const signedRaw = JSON.stringify(refundEvent("refund.processed"));
  const sentRaw = JSON.stringify(
    refundEvent("refund.processed", { refundId: "rfnd_TAMPERED" }),
  );
  const { status } = await post(sentRaw, sign(signedRaw, SECRET));
  check("tampered body rejected (401)", status === 401, `got ${status}`);
}

// 3. Signature made with the wrong secret → 401.
{
  const raw = JSON.stringify(refundEvent("refund.processed"));
  const { status } = await post(raw, sign(raw, "the-wrong-secret"));
  check("wrong-secret signature rejected (401)", status === 401, `got ${status}`);
}

// 4. Missing signature header → 401.
{
  const raw = JSON.stringify(refundEvent("refund.processed"));
  const { status } = await post(raw, null);
  check("missing signature rejected (401)", status === 401, `got ${status}`);
}

// 5. Valid signature but an event we don't act on → 200, acknowledged/ignored.
{
  const payload = { entity: "event", event: "payment.captured", payload: {} };
  const raw = JSON.stringify(payload);
  const { status, body } = await post(raw, sign(raw, SECRET));
  check(
    "irrelevant event acknowledged (200 ignored)",
    status === 200 && body.ok === true,
    `status ${status}, body ${JSON.stringify(body)}`,
  );
}

console.log(`\n${failed === 0 ? "✓ all" : "✗"} ${passed} passed, ${failed} failed\n`);
process.exit(failed === 0 ? 0 : 1);
