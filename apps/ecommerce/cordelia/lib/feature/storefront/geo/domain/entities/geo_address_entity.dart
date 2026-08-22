/// A structured address resolved from coordinates — exactly the fields the
/// Add/Edit Address form can prefill, nothing more.
///
/// Deliberately has no `*Model` pair, unlike every entity that crosses the
/// wire: this one is built on the device, from the platform's own geocoder
/// (`LocationService`). There is no JSON to parse and no payload to send, so
/// a DTO would exist only to satisfy the shape.
class GeoAddressEntity {
  final String addressLine;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;

  const GeoAddressEntity({
    required this.addressLine,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
  });
}
