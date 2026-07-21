import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/favourites_repository.dart';

class AddFavouriteUseCase extends UseCase<Either<Failure, void>, String> {
  final FavouritesRepository _repository;

  const AddFavouriteUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.addFavourite(params);
}
