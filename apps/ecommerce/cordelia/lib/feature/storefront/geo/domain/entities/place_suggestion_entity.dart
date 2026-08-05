/// One row of the address-search type-ahead. Picking it resolves the full
/// structured address by reverse-geocoding its coordinates.
class PlaceSuggestionEntity {
  final String description;
  final String placeId;
  final double? latitude;
  final double? longitude;

  const PlaceSuggestionEntity({
    required this.description,
    required this.placeId,
    this.latitude,
    this.longitude,
  });
}
