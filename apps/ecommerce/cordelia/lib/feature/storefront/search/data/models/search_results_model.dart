import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/entities/search_results_entity.dart';

part 'search_results_model.freezed.dart';
part 'search_results_model.g.dart';

@freezed
abstract class SearchResultsModel with _$SearchResultsModel {
  const SearchResultsModel._();

  const factory SearchResultsModel({
    required List<ProductModel> products,
    required List<CategoryModel> categories,
  }) = _SearchResultsModel;

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsModelFromJson(json);

  factory SearchResultsModel.fromEntity(SearchResultsEntity e) =>
      SearchResultsModel(
        products: e.products.map(ProductModel.fromEntity).toList(),
        categories: e.categories.map(CategoryModel.fromEntity).toList(),
      );

  SearchResultsEntity toEntity() => SearchResultsEntity(
    products: products.map((p) => p.toEntity()).toList(),
    categories: categories.map((c) => c.toEntity()).toList(),
  );
}
