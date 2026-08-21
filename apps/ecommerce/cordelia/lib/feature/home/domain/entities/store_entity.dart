import 'package:cordelia/enums/store_status.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import 'store_delivery_entity.dart';
import 'store_support_entity.dart';

class StoreEntity {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final StorefrontTemplate templateId;
  final StoreLanguage language;
  final StoreCurrency currency;

  /// Publication state. Presentation only — the API has already decided
  /// whether this caller may see the store, and hands back an unpublished
  /// one solely to its owner.
  final StoreStatus status;

  /// What this store charges to deliver, and where it delivers at all.
  /// Defaults to [StoreDeliveryEntity.free] — the honest reading of a store
  /// that has never set a policy.
  final StoreDeliveryEntity delivery;

  /// How a shopper reaches this store when an order goes wrong. Defaults to
  /// [StoreSupportEntity.none] — a store that publishes no contact of its
  /// own, whose shoppers reach CordeliaApps instead.
  final StoreSupportEntity support;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.templateId,
    required this.language,
    required this.currency,
    this.status = StoreStatus.published,
    this.delivery = StoreDeliveryEntity.free,
    this.support = StoreSupportEntity.none,
  });
}
