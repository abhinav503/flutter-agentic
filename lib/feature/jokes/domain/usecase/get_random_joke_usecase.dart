import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/joke_entity.dart';
import '../repository/jokes_repository.dart';

class GetRandomJokeUseCase extends UseCase<Either<Failure, JokeEntity>, NoParams> {
  final JokesRepository _repository;

  const GetRandomJokeUseCase(this._repository);

  @override
  Future<Either<Failure, JokeEntity>> call(NoParams params) =>
      _repository.getRandomJoke();
}
