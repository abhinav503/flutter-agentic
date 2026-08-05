/// What a 6-digit pincode resolves to — the city/state autofill for the
/// address form.
class PincodeInfoEntity {
  final String city;
  final String state;
  final String country;

  const PincodeInfoEntity({
    required this.city,
    required this.state,
    required this.country,
  });
}
