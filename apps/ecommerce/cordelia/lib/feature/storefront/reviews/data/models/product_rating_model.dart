import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_rating_entity.dart';

part 'product_rating_model.freezed.dart';
part 'product_rating_model.g.dart';

@freezed
abstract class ProductRatingModel with _$ProductRatingModel {
  const ProductRatingModel._();

  const factory ProductRatingModel({
    @Default(0.0) double average,
    @Default(0) int count,
    // Fixed 1★→5★ order, as sent. Defaulted because a store whose products
    // predate reviews answers without the key.
    @Default(<int>[0, 0, 0, 0, 0]) List<int> buckets,
  }) = _ProductRatingModel;

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingModelFromJson(json);

  factory ProductRatingModel.fromEntity(ProductRatingEntity e) =>
      ProductRatingModel(
        average: e.average,
        count: e.count,
        buckets: e.buckets,
      );

  ProductRatingEntity toEntity() => ProductRatingEntity(
    average: average,
    count: count,
    // Guard the length rather than trusting it: every consumer indexes this
    // by star, so a short list from an older backend would throw at paint.
    buckets: buckets.length == 5 ? buckets : const [0, 0, 0, 0, 0],
  );
}
