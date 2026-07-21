import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/favourites_repository.dart';

class RemoveFavouriteUseCase extends UseCase<Either<Failure, void>, String> {
  final FavouritesRepository _repository;

  const RemoveFavouriteUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.removeFavourite(params);
}
