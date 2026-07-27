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

  const PaymentIntentEntity({
    required this.razorpayOrderId,
    required this.razorpayKeyId,
    required this.amount,
    required this.currency,
  });
}
