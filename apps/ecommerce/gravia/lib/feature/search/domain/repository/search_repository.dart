import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/search_entity.dart';

abstract interface class SearchRepository {
  Future<Either<Failure, SearchEntity>> getSearch();
}
