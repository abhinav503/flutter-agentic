import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/category_details_entity.dart';

abstract interface class CategoryDetailsRepository {
  Future<Either<Failure, CategoryDetailsEntity>> getCategoryDetails(String categoryId);
}
