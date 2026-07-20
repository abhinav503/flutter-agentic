import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/categories/domain/entities/categories_entity.dart';
import 'package:gravia/feature/categories/domain/entities/category_group_entity.dart';
import 'package:gravia/feature/categories/domain/repository/categories_repository.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';

class FakeCategoriesRepository implements CategoriesRepository {
  /// Set per test to control what [getCategories] resolves to.
  Either<Failure, CategoriesEntity> result = right(
    const CategoriesEntity(
      groups: [
        CategoryGroupEntity(
          name: 'Fresh',
          categories: [
            CategoryEntity(
              id: '1',
              name: 'Fruits',
              imageUrl: 'https://example.com/fruits.png',
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Future<Either<Failure, CategoriesEntity>> getCategories() async => result;
}
