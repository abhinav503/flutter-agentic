/// The outcome of a successful Razorpay checkout, handed back to the server
/// so it can verify the signature (HMAC of orderId|paymentId keyed by the
/// store secret) before actually placing the order. A forged or tampered
/// result fails that check server-side and no order is created.
class PaymentResultEntity {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  const PaymentResultEntity({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });
}
