/// Which payment provider a store settles through. Chosen per store by the
/// admin (Settings → Payments) and told to the app by the server on every
/// payment intent — the app never decides it, and never needs to know a
/// store's provider before checkout starts.
enum PaymentProvider { razorpay, stripe }

/// Wire value → enum. Tolerates unknown/missing values by defaulting to
/// Razorpay, which is what every store used before Stripe support landed and
/// what a server predating the field implies.
extension PaymentProviderParse on String {
  PaymentProvider toPaymentProvider() => switch (toLowerCase()) {
    'stripe' => PaymentProvider.stripe,
    _ => PaymentProvider.razorpay,
  };
}
