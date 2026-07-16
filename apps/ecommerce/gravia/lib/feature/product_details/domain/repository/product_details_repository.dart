import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/product_detail_entity.dart';

abstract interface class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(
    String productId,
  );
}
