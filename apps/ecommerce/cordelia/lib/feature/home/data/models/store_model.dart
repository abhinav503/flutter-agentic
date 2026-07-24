import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  factory StoreModel.fromEntity(StoreEntity e) => StoreModel(
    id: e.id,
    name: e.name,
    image: e.logoUrl,
    description: e.description,
  );

  StoreEntity toEntity() =>
      StoreEntity(id: id, name: name, logoUrl: image, description: description);
}
