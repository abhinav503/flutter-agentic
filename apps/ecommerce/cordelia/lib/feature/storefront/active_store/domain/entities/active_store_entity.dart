import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

class ActiveStoreEntity {
  final String storeId;
  final String storeName;
  final StorefrontTemplate templateId;

  /// The admin-picked storefront language — the *default*; a shopper's
  /// on-device override (see `StoreLocalePrefs`) wins over it.
  final StoreLanguage language;

  const ActiveStoreEntity({
    required this.storeId,
    required this.storeName,
    required this.templateId,
    required this.language,
  });
}
