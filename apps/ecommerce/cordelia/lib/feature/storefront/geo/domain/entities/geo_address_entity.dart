/// A structured address resolved from coordinates or a picked suggestion —
/// exactly the fields the Add/Edit Address form can prefill, nothing more.
class GeoAddressEntity {
  final String formatted;
  final String addressLine;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;

  const GeoAddressEntity({
    required this.formatted,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
  });
}
