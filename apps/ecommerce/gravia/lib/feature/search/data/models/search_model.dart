import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/product_model.dart';
import '../../domain/entities/search_entity.dart';

part 'search_model.freezed.dart';
part 'search_model.g.dart';

@freezed
abstract class SearchModel with _$SearchModel {
  const SearchModel._();

  const factory SearchModel({
    @JsonKey(name: 'recent_searches')
    required List<ProductModel> recentSearches,
    @JsonKey(name: 'popular_products')
    required List<ProductModel> popularProducts,
  }) = _SearchModel;

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);

  factory SearchModel.fromEntity(SearchEntity e) => SearchModel(
    recentSearches: e.recentSearches.map(ProductModel.fromEntity).toList(),
    popularProducts: e.popularProducts.map(ProductModel.fromEntity).toList(),
  );

  SearchEntity toEntity() => SearchEntity(
    recentSearches: recentSearches.map((p) => p.toEntity()).toList(),
    popularProducts: popularProducts.map((p) => p.toEntity()).toList(),
  );
}
