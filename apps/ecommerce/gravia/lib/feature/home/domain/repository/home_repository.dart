import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/home_entity.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, HomeEntity>> getHome();
}
