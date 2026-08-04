import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/brand_entity.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

@freezed
abstract class BrandModel with _$BrandModel {
  const BrandModel._();

  const factory BrandModel({
    required String id,
    required String name,
    // `image` not `imageUrl` — same wire convention as every other
    // serializer (category/product/store).
    required String image,
  }) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  factory BrandModel.fromEntity(BrandEntity e) =>
      BrandModel(id: e.id, name: e.name, image: e.imageUrl);

  BrandEntity toEntity() => BrandEntity(id: id, name: name, imageUrl: image);
}
