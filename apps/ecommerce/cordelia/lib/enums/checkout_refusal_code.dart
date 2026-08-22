/// Why the server turned a checkout down, as it named it. The wire strings
/// are `admin/src/app/api/stores/[storeId]/{payments,orders}/route.ts`'s
/// `code` field — both endpoints refuse for the same reasons, so both are
/// parsed here.
enum CheckoutRefusalCode { insufficientStock, unserviceableAddress, other }

extension CheckoutRefusalCodeX on CheckoutRefusalCode {
  /// Back to the server's vocabulary. The code makes a second string trip —
  /// `Failure.refused` carries a plain `code` so `core` stays free of this
  /// app's enum — and it travels as the same word both times rather than
  /// as the Dart case name.
  String get wireValue => switch (this) {
    CheckoutRefusalCode.insufficientStock => 'insufficient_stock',
    CheckoutRefusalCode.unserviceableAddress => 'unserviceable_address',
    CheckoutRefusalCode.other => 'other',
  };
}

extension CheckoutRefusalCodeParse on String? {
  /// Anything the server names that this app has no specific handling for
  /// falls to [CheckoutRefusalCode.other] — a new server code must never
  /// crash a checkout, it just loses the tailored reaction.
  CheckoutRefusalCode toCheckoutRefusalCode() => switch (this) {
    'insufficient_stock' => CheckoutRefusalCode.insufficientStock,
    'unserviceable_address' => CheckoutRefusalCode.unserviceableAddress,
    _ => CheckoutRefusalCode.other,
  };
}
