import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../../domain/entities/store_entity.dart';

part 'store_model.freezed.dart';
part 'store_model.g.dart';

@freezed
abstract class StoreModel with _$StoreModel {
  const StoreModel._();

  const factory StoreModel({
    required String id,
    required String name,
    // Matches admin's serializeStore() — `image` not `logoUrl`, same
    // snake_case-avoidant convention as gravia's CategoryModel/ProductModel
    // (these particular keys have no snake_case form to begin with).
    required String image,
    required String description,
    // Defaulted, not required — the admin backend sends template_id now,
    // but the still-deployed older API build may not, so this must parse
    // cleanly either way. Empty, not 'gravia': the wire→enum fallback lives
    // in one place (`StorefrontTemplateParse.toStorefrontTemplate`, which
    // maps ''/unknown → gravia), so this DTO doesn't hold a second copy of
    // that policy.
    @JsonKey(name: 'template_id') @Default('') String templateId,
    // Same defaulted-not-required reasoning as template_id: the wire→enum
    // fallback (''/unknown → en) lives in StoreLanguageParse alone.
    @Default('') String language,
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  factory StoreModel.fromEntity(StoreEntity e) => StoreModel(
    id: e.id,
    name: e.name,
    image: e.logoUrl,
    description: e.description,
    templateId: e.templateId.wireValue,
    language: e.language.wireValue,
  );

  StoreEntity toEntity() => StoreEntity(
    id: id,
    name: name,
    logoUrl: image,
    description: description,
    templateId: templateId.toStorefrontTemplate(),
    language: language.toStoreLanguage(),
  );
}
