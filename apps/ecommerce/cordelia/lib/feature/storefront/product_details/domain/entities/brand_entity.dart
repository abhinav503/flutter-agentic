/// The product's brand ("Amul", "Tata"), resolved by the backend from the
/// store's brand catalog — products carry only a brand id on the wire, so a
/// rename in the admin can never leave a stale name here.
class BrandEntity {
  final String id;
  final String name;
  final String imageUrl;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
