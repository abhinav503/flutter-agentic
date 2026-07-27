import 'package:cordelia/feature/storefront/template/storefront_template.dart';

class ActiveStoreEntity {
  final String storeId;
  final String storeName;
  final StorefrontTemplate templateId;

  const ActiveStoreEntity({
    required this.storeId,
    required this.storeName,
    required this.templateId,
  });
}
