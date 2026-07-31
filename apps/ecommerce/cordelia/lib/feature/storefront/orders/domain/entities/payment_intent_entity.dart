/// A server-created Razorpay order the checkout sheet is opened against. The
/// server computes [amount] from the live catalog and creates the Razorpay
/// order with the store's own credentials, so payment settles into that
/// store's account. [razorpayKeyId] is the store's public key (safe on the
/// client); the secret never leaves the server.
class PaymentIntentEntity {
  final String razorpayOrderId;
  final String razorpayKeyId;

  /// Amount in the smallest currency unit (paise for INR) — what Razorpay's
  /// checkout expects, and what the server already multiplied up.
  final int amount;
  final String currency;

  /// The merchant name the checkout sheet shows, straight from the store doc.
  /// It comes from the server rather than the client's active store so it
  /// can't disagree with the account the money actually settles into. Empty
  /// when the store has no name (or the server predates this field) — the
  /// gateway falls back to the app name rather than opening a nameless sheet.
  final String storeName;

  const PaymentIntentEntity({
    required this.razorpayOrderId,
    required this.razorpayKeyId,
    required this.amount,
    required this.currency,
    this.storeName = '',
  });
}
