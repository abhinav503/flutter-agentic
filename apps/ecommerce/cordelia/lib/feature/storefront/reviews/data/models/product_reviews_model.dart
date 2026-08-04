import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_reviews_entity.dart';
import 'product_rating_model.dart';
import 'review_model.dart';

part 'product_reviews_model.freezed.dart';
part 'product_reviews_model.g.dart';

/// The reviews endpoint's `{ rating, reviews }` payload — the same `rating`
/// shape the product-details payload carries, so both parse through
/// [ProductRatingModel].
@freezed
abstract class ProductReviewsModel with _$ProductReviewsModel {
  const ProductReviewsModel._();

  const factory ProductReviewsModel({
    @Default(ProductRatingModel()) ProductRatingModel rating,
    @Default(<ReviewModel>[]) List<ReviewModel> reviews,
  }) = _ProductReviewsModel;

  factory ProductReviewsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewsModelFromJson(json);

  factory ProductReviewsModel.fromEntity(ProductReviewsEntity e) =>
      ProductReviewsModel(
        rating: ProductRatingModel.fromEntity(e.rating),
        reviews: e.reviews.map(ReviewModel.fromEntity).toList(),
      );

  ProductReviewsEntity toEntity() => ProductReviewsEntity(
    rating: rating.toEntity(),
    reviews: reviews.map((r) => r.toEntity()).toList(),
  );
}
