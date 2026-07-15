import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/search/domain/entities/search_entity.dart';
import 'package:gravia/feature/search/domain/repository/search_repository.dart';

class FakeSearchRepository implements SearchRepository {
  /// Set per test to control what [getSearch] resolves to.
  Either<Failure, SearchEntity> result = right(
    const SearchEntity(
      recentSearches: [
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
        ProductEntity(
          id: '4',
          name: 'Cabbage',
          imageUrl: 'https://example.com/cabbage.png',
          price: 2.40,
          originalPrice: 3.00,
          discountPercentage: 20,
          unitValue: 500,
          unitType: ProductUnitType.grams,
          prepTime: '10 Min',
          isFavourite: false,
        ),
      ],
      popularProducts: [
        ProductEntity(
          id: '2',
          name: 'Green Grapes',
          imageUrl: 'https://example.com/grapes.png',
          price: 4.00,
          originalPrice: 5.00,
          discountPercentage: 20,
          unitValue: 500,
          unitType: ProductUnitType.grams,
          prepTime: '10 Min',
          isFavourite: false,
        ),
      ],
    ),
  );

  @override
  Future<Either<Failure, SearchEntity>> getSearch() async => result;
}
