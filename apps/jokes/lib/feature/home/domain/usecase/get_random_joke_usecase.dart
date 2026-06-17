import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import '../entities/joke_entity.dart';
import '../repository/jokes_repository.dart';

class GetRandomJokeUseCase extends UseCase<Either<Failure, JokeEntity>, NoParams> {
  final JokesRepository _repository;

  const GetRandomJokeUseCase(this._repository);

  @override
  Future<Either<Failure, JokeEntity>> call(NoParams params) =>
      _repository.getRandomJoke();
}
