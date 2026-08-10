import { NextResponse } from "next/server";
import {
  requireStoreOwner,
  ForbiddenError,
  UnauthorizedError,
} from "@/lib/api/admin-guard";
import {
  clearStorePaymentConfig,
  getStorePaymentStatus,
  PaymentProviderError,
  setActiveProvider,
  setStorePaymentConfig,
  setStoreWebhookSecret,
} from "@/lib/payments";
import { providerForKeyId } from "@/lib/payment-providers/types";

// Store-owner-only. GET returns a non-secret status for the dashboard Settings
// screen — both providers' slots plus which one is active; no secret is ever
// serialized.
//
// PUT does one of four things, by body shape:
//   { keyId, keySecret }                 save that provider's credentials
//                                        (which provider is read off the key)
//   { provider, webhookSecret }          save that provider's webhook secret
//   { provider, activate: true }         switch which provider takes payments
//   { provider, disconnect: true }       remove that provider's credentials
//
// Saving one provider never touches the other: a store keeps both sets, which
// is required for refunding orders paid through a provider it has since
// switched away from.

function handleGuardError(e: unknown): NextResponse | null {
  if (e instanceof UnauthorizedError) {
    return NextResponse.json({ error: e.message }, { status: 401 });
  }
  if (e instanceof ForbiddenError) {
    return NextResponse.json({ error: e.message }, { status: 403 });
  }
  return null;
}

export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    const res = handleGuardError(e);
    if (res) return res;
    throw e;
  }
  return NextResponse.json(await getStorePaymentStatus(storeId));
}

export async function PUT(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreOwner(request, storeId);
  } catch (e) {
    const res = handleGuardError(e);
    if (res) return res;
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const keyId = typeof body.keyId === "string" ? body.keyId.trim() : "";
  const keySecret =
    typeof body.keySecret === "string" ? body.keySecret.trim() : "";
  const webhookSecret =
    typeof body.webhookSecret === "string" ? body.webhookSecret.trim() : "";
  const targetProvider =
    body.provider === "razorpay" || body.provider === "stripe"
      ? (body.provider as "razorpay" | "stripe")
      : null;

  // Switch which provider takes payments. Both providers' credentials are kept
  // side by side, so this is a pointer move, not a re-entry of any secret.
  if (body.activate === true) {
    if (!targetProvider) {
      return NextResponse.json(
        { error: "provider must be 'razorpay' or 'stripe'" },
        { status: 400 },
      );
    }
    try {
      await setActiveProvider(storeId, targetProvider);
    } catch (e) {
      if (e instanceof PaymentProviderError) {
        return NextResponse.json({ error: e.message }, { status: 400 });
      }
      throw e;
    }
    return NextResponse.json(await getStorePaymentStatus(storeId));
  }

  // Disconnect one provider entirely. Refused for the active one — that would
  // silently take checkout offline.
  if (body.disconnect === true) {
    if (!targetProvider) {
      return NextResponse.json(
        { error: "provider must be 'razorpay' or 'stripe'" },
        { status: 400 },
      );
    }
    try {
      await clearStorePaymentConfig(storeId, targetProvider);
    } catch (e) {
      if (e instanceof PaymentProviderError) {
        return NextResponse.json({ error: e.message }, { status: 400 });
      }
      throw e;
    }
    return NextResponse.json(await getStorePaymentStatus(storeId));
  }

  // Webhook-secret-only update — the owner sets it separately, after creating
  // the webhook in the provider's dashboard, without re-entering the
  // (write-only) key secret. `provider` says which endpoint's secret it is;
  // the two are never interchangeable.
  if (webhookSecret && !keyId && !keySecret) {
    if (!targetProvider) {
      return NextResponse.json(
        { error: "provider must be 'razorpay' or 'stripe'" },
        { status: 400 },
      );
    }
    await setStoreWebhookSecret(storeId, targetProvider, webhookSecret);
    return NextResponse.json(await getStorePaymentStatus(storeId));
  }

  if (!keyId || !keySecret) {
    return NextResponse.json(
      { error: "keyId and keySecret are required" },
      { status: 400 },
    );
  }

  // The key id decides the provider — there's no separate provider setting
  // that could disagree with the credentials actually stored.
  const provider = providerForKeyId(keyId);
  if (!provider) {
    return NextResponse.json(
      {
        error:
          "keyId must be a Razorpay key id (rzp_test_/rzp_live_) or a Stripe publishable key (pk_test_/pk_live_)",
      },
      { status: 400 },
    );
  }

  // Catch the most common paste error early — swapping the two fields, or
  // pasting a Stripe *publishable* key into the secret box — since otherwise
  // it only surfaces as a 401 from the provider at the shopper's checkout.
  const secretError = validateSecretShape(provider, keyId, keySecret);
  if (secretError) {
    return NextResponse.json({ error: secretError }, { status: 400 });
  }

  await setStorePaymentConfig(storeId, keyId, keySecret);
  return NextResponse.json(await getStorePaymentStatus(storeId));
}

// Razorpay secrets are opaque (no prefix to check), so only the obvious
// mistakes are caught. Stripe's are prefixed, and both a full secret key
// (sk_) and a scoped restricted key (rk_) are valid — restricted is the
// better practice, so it's accepted rather than steered away from.
function validateSecretShape(
  provider: "razorpay" | "stripe",
  keyId: string,
  keySecret: string,
): string | null {
  if (provider === "stripe") {
    if (!/^(sk|rk)_(test|live)_/.test(keySecret)) {
      return "The Stripe secret must be a secret key (sk_test_/sk_live_) or a restricted key (rk_test_/rk_live_)";
    }
    // A live publishable key with a test secret (or vice versa) creates
    // intents the client can never confirm — the SDK rejects the mismatch at
    // runtime with a message that doesn't point here.
    const keyIsTest = keyId.startsWith("pk_test_");
    const secretIsTest = keySecret.startsWith("sk_test_") || keySecret.startsWith("rk_test_");
    if (keyIsTest !== secretIsTest) {
      return "Both keys must be from the same mode — either both test or both live";
    }
    return null;
  }
  if (keySecret.startsWith("rzp_")) {
    return "That looks like a Razorpay key id, not a key secret";
  }
  return null;
}
