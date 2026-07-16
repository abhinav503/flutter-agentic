import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../../domain/repository/product_details_repository.dart';
import '../data_source/product_details_remote_data_source.dart';

class ProductDetailsRepositoryImpl
    with BaseRepository
    implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource _dataSource;

  const ProductDetailsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(
    String productId,
  ) => handleRequest(() async {
    final model = await _dataSource.getProductDetails(productId);
    return right(model.toEntity());
  });
}
