import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/product_reviews_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repository/reviews_repository.dart';
import '../data_source/reviews_remote_data_source.dart';

class ReviewsRepositoryImpl with BaseRepository implements ReviewsRepository {
  final ReviewsRemoteDataSource _dataSource;

  const ReviewsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ProductReviewsEntity>> getProductReviews(
    String storeId,
    String productId,
  ) => handleRequest(() async {
    final model = await _dataSource.getProductReviews(storeId, productId);
    return right(model.toEntity());
  });

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String storeId,
    required String productId,
    required int rating,
    required String text,
  }) => handleRequest(() async {
    final model = await _dataSource.submitReview(
      storeId: storeId,
      productId: productId,
      rating: rating,
      text: text,
    );
    return right(model.toEntity());
  });

  @override
  Future<Either<Failure, void>> deleteMyReview(
    String storeId,
    String productId,
  ) => handleRequest(() async {
    await _dataSource.deleteMyReview(storeId, productId);
    return right(null);
  });
}
