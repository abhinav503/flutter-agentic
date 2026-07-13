import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/home_entity.dart';
import '../repository/home_repository.dart';

class GetHomeUseCase extends UseCase<Either<Failure, HomeEntity>, NoParams> {
  final HomeRepository _repository;

  const GetHomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeEntity>> call(NoParams params) =>
      _repository.getHome();
}
