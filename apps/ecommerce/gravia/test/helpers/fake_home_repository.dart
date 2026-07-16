import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';
import 'package:gravia/feature/home/domain/entities/home_entity.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/home/domain/repository/home_repository.dart';

class FakeHomeRepository implements HomeRepository {
  /// Set per test to control what [getHome] resolves to.
  Either<Failure, HomeEntity> result = right(
    const HomeEntity(
      categories: [
        CategoryEntity(
          id: '1',
          name: 'Fresh',
          imageUrl: 'https://example.com/fresh.png',
        ),
      ],
      popularProducts: [
        ProductEntity(
          id: '1',
          name: 'Washington Red Apple',
          imageUrl: 'https://example.com/apple.png',
          price: 6.30,
          originalPrice: 8.00,
          discountPercentage: 20,
          unitValue: 300,
          unitType: ProductUnitType.grams,
          prepTime: '10 Min',
          isFavourite: false,
        ),
      ],
    ),
  );

  @override
  Future<Either<Failure, HomeEntity>> getHome() async => result;
}
