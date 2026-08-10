import 'package:cordelia/enums/payment_provider.dart';

/// A server-created payment intent the checkout sheet is opened against — a
/// Razorpay Order or a Stripe PaymentIntent, depending on what the store
/// configured. The server computes [amount] from the live catalog and creates
/// it with the store's own credentials, so payment settles into that store's
/// account. [publishableKey] is the store's public key (safe on the client);
/// the secret never leaves the server.
class PaymentIntentEntity {
  /// Which gateway to open. The app dispatches on this alone — it is never
  /// inferred from the store or hardcoded per template.
  final PaymentProvider provider;

  /// The provider's id for this intent: a Razorpay `order_…` or a Stripe
  /// `pi_…`. Echoed back to the server on order placement.
  final String paymentOrderId;

  /// Razorpay key id / Stripe publishable key — public either way, and what
  /// the client SDK is initialised with.
  final String publishableKey;

  /// Stripe only: scopes the client to confirm this one intent, and is what
  /// its PaymentSheet is initialised with. Empty for Razorpay, which has no
  /// equivalent concept.
  final String clientSecret;

  /// Amount in the smallest currency unit (paise, cents) — what both
  /// providers' checkout SDKs expect, and what the server already multiplied
  /// up.
  final int amount;
  final String currency;

  /// The merchant name the checkout sheet shows, straight from the store doc.
  /// It comes from the server rather than the client's active store so it
  /// can't disagree with the account the money actually settles into. Empty
  /// when the store has no name (or the server predates this field) — the
  /// gateway falls back to the app name rather than opening a nameless sheet.
  final String storeName;

  const PaymentIntentEntity({
    required this.provider,
    required this.paymentOrderId,
    required this.publishableKey,
    required this.amount,
    required this.currency,
    this.clientSecret = '',
    this.storeName = '',
  });
}
