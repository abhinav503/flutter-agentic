class AddressEntity {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;

  /// Empty on addresses saved before the location feature (and optional in
  /// the form) — same posture as [latitude]/[longitude].
  final String state;
  final String country;
  final String postalCode;
  final String tag;
  final bool isDefault;

  /// Set when the address came from GPS/autocomplete prefill; null for
  /// hand-typed addresses and for everything saved before the location
  /// feature.
  final double? latitude;
  final double? longitude;

  const AddressEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    this.landmark = '',
    required this.city,
    this.state = '',
    required this.country,
    required this.postalCode,
    required this.tag,
    required this.isDefault,
    this.latitude,
    this.longitude,
  });
}

/// AddressCard's secondary line and the Home delivery-location label are a
/// single line of text, but the Add/Edit Address form edits the structured
/// fields — this composes the display line from them rather than storing it
/// as its own field, which would let it drift out of sync on edit.
extension AddressEntityX on AddressEntity {
  String get displayLine {
    final line = [
      addressLine1,
      if (addressLine2.isNotEmpty) addressLine2,
      city,
    ].where((part) => part.isNotEmpty).join(', ');
    return postalCode.isEmpty ? line : '$line $postalCode';
  }
}
