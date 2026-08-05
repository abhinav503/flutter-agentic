import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

class StoreEntity {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final StorefrontTemplate templateId;
  final StoreLanguage language;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.templateId,
    required this.language,
  });
}
