import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/categories_entity.dart';

abstract interface class CategoriesRepository {
  Future<Either<Failure, CategoriesEntity>> getCategories();
}
