import 'package:cordelia/feature/home/domain/entities/store_delivery_entity.dart';
import 'package:cordelia/feature/home/domain/entities/store_support_entity.dart';
import 'package:cordelia/feature/home/domain/entities/store_entity.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

class ActiveStoreEntity {
  final String storeId;
  final String storeName;
  final StorefrontTemplate templateId;

  /// The admin-picked storefront language — the *default*; a shopper's
  /// on-device override (see `StoreLocalePrefs`) wins over it.
  final StoreLanguage language;

  /// What this store charges in. Unlike [language] a shopper cannot override
  /// it — the store settles into one account, so the displayed currency is
  /// the store's alone.
  final StoreCurrency currency;

  /// This store's delivery policy, carried into the storefront so a cart can
  /// print the fee — and refuse an address the store doesn't reach — without
  /// re-fetching the store doc it was opened from.
  final StoreDeliveryEntity delivery;

  /// This store's published support contact, carried in for the same reason
  /// as [delivery]: Help & Support and every order's "need help" entry are
  /// inside the storefront, and neither should re-fetch the store doc to
  /// print an address the session was opened with.
  final StoreSupportEntity support;

  const ActiveStoreEntity({
    required this.storeId,
    required this.storeName,
    required this.templateId,
    required this.language,
    required this.currency,
    this.delivery = StoreDeliveryEntity.free,
    this.support = StoreSupportEntity.none,
  });

  /// The storefront-session view of a discovered store. Both entry points —
  /// tapping a store in Discovery, and a notification tap resolving one by id
  /// — turn the same [StoreEntity] into the same subset, so it lives here
  /// rather than being spelled out twice.
  factory ActiveStoreEntity.fromStore(StoreEntity store) => ActiveStoreEntity(
    storeId: store.id,
    storeName: store.name,
    templateId: store.templateId,
    language: store.language,
    currency: store.currency,
    delivery: store.delivery,
    support: store.support,
  );
}
