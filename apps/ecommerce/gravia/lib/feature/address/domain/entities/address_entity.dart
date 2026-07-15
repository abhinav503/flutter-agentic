class AddressEntity {
  final String id;
  final String name;
  final String phone;
  final String addressLine;
  final String tag;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.tag,
    required this.isDefault,
  });
}
