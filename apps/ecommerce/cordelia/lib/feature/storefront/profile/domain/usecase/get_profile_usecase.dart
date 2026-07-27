import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class GetProfileUseCase
    extends UseCase<Either<Failure, ProfileEntity>, NoParams> {
  final ProfileRepository _repository;

  const GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) =>
      _repository.getProfile();
}
