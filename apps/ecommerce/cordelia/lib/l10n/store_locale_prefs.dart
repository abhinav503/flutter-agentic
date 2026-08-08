import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

import 'package:cordelia/feature/storefront/template/store_language.dart';

/// The shopper's on-device language override, kept per store — it wins over
/// the store doc's admin-picked default (see `StorefrontPage`'s
/// `_applyStoreLocale`). Per store, not global: a shopper can keep one
/// store in Hindi and another in English.
abstract final class StoreLocalePrefs {
  static String _key(String storeId) => 'store_language_$storeId';

  static StoreLanguage? overrideFor(String storeId) => SharedPreferenceService
      .instance
      .getString(_key(storeId))
      ?.toStoreLanguage();

  static Future<void> saveOverride(String storeId, StoreLanguage language) =>
      SharedPreferenceService.instance.setString(
        _key(storeId),
        language.wireValue,
      );
}
