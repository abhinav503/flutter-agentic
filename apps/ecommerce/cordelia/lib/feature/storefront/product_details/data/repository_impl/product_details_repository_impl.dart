import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/size_variant_entity.dart';
import '../../domain/repository/product_details_repository.dart';
import '../data_source/product_details_remote_data_source.dart';

class ProductDetailsRepositoryImpl
    with BaseRepository
    implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource _dataSource;

  const ProductDetailsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(
    String storeId,
    String productId,
  ) => handleRequest(() async {
    final model = await _dataSource.getProductDetails(storeId, productId);
    final entity = model.toEntity();
    // A backend that predates per-size pricing sends size_options only —
    // upgrade them to priced variants at the platform's implied price (base
    // price scaled linearly by size, the same rule the backend applies), so
    // screens always see one shape and never price a size themselves.
    if (entity.sizeVariants.isNotEmpty || model.sizeOptions.isEmpty) {
      return right(entity);
    }
    final product = entity.product;
    double scaled(double base, double value) => product.unitValue <= 0
        ? base
        : ((base * value / product.unitValue) * 100).roundToDouble() / 100;
    return right(
      ProductDetailEntity(
        product: product,
        images: entity.images,
        description: entity.description,
        sizeVariants: [
          for (final value in model.sizeOptions)
            SizeVariantEntity(
              value: value,
              price: scaled(product.price, value),
              originalPrice: scaled(product.originalPrice, value),
              discountPercentage: product.discountPercentage,
            ),
        ],
        similarProducts: entity.similarProducts,
        category: entity.category,
        brand: entity.brand,
      ),
    );
  });
}
