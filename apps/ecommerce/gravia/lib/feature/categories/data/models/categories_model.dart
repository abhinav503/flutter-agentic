import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/categories_entity.dart';
import 'category_group_model.dart';

part 'categories_model.freezed.dart';
part 'categories_model.g.dart';

@freezed
abstract class CategoriesModel with _$CategoriesModel {
  const CategoriesModel._();

  const factory CategoriesModel({
    required List<CategoryGroupModel> groups,
  }) = _CategoriesModel;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesModelFromJson(json);

  factory CategoriesModel.fromEntity(CategoriesEntity e) => CategoriesModel(
        groups: e.groups.map(CategoryGroupModel.fromEntity).toList(),
      );

  CategoriesEntity toEntity() =>
      CategoriesEntity(groups: groups.map((g) => g.toEntity()).toList());
}
