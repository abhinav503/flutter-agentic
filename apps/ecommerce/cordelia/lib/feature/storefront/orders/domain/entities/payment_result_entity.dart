/// The outcome of a successful checkout, handed back to the server so it can
/// verify the payment before actually placing the order. A forged or tampered
/// result fails that check server-side and no order is created.
///
/// How the server verifies differs by provider, which is why [signature] is
/// optional: Razorpay signs `orderId|paymentId` with the store secret and the
/// server re-computes that HMAC locally, while Stripe has no client-side
/// signature at all — the server re-fetches the PaymentIntent and asserts it
/// really reached `succeeded` for the amount it was created with. Neither
/// provider is trusted on the client's word; they just prove it differently.
class PaymentResultEntity {
  /// The intent the payment was made against — a Razorpay `order_…` or a
  /// Stripe `pi_…`.
  final String paymentOrderId;

  /// The payment itself — a Razorpay `pay_…`. Stripe has no separate charge
  /// reference the client is trusted with, so it repeats the PaymentIntent id.
  final String paymentId;

  /// Razorpay's HMAC over `orderId|paymentId`. Empty for Stripe.
  final String signature;

  const PaymentResultEntity({
    required this.paymentOrderId,
    required this.paymentId,
    this.signature = '',
  });
}
