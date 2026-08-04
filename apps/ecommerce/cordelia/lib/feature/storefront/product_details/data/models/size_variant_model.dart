import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/size_variant_entity.dart';

part 'size_variant_model.freezed.dart';
part 'size_variant_model.g.dart';

@freezed
abstract class SizeVariantModel with _$SizeVariantModel {
  const SizeVariantModel._();

  const factory SizeVariantModel({
    required double value,
    required double price,
    @JsonKey(name: 'original_price') required double originalPrice,
    @JsonKey(name: 'discount_percentage') required double discountPercentage,
  }) = _SizeVariantModel;

  factory SizeVariantModel.fromJson(Map<String, dynamic> json) =>
      _$SizeVariantModelFromJson(json);

  factory SizeVariantModel.fromEntity(SizeVariantEntity e) => SizeVariantModel(
    value: e.value,
    price: e.price,
    originalPrice: e.originalPrice,
    discountPercentage: e.discountPercentage,
  );

  SizeVariantEntity toEntity() => SizeVariantEntity(
    value: value,
    price: price,
    originalPrice: originalPrice,
    discountPercentage: discountPercentage,
  );
}
