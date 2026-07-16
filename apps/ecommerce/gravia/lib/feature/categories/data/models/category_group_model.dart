import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/category_model.dart';
import '../../domain/entities/category_group_entity.dart';

part 'category_group_model.freezed.dart';
part 'category_group_model.g.dart';

@freezed
abstract class CategoryGroupModel with _$CategoryGroupModel {
  const CategoryGroupModel._();

  const factory CategoryGroupModel({
    required String name,
    required List<CategoryModel> categories,
  }) = _CategoryGroupModel;

  factory CategoryGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupModelFromJson(json);

  factory CategoryGroupModel.fromEntity(CategoryGroupEntity e) =>
      CategoryGroupModel(
        name: e.name,
        categories: e.categories.map(CategoryModel.fromEntity).toList(),
      );

  CategoryGroupEntity toEntity() => CategoryGroupEntity(
    name: name,
    categories: categories.map((c) => c.toEntity()).toList(),
  );
}
