import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/place_suggestion_entity.dart';
import '../repository/geo_repository.dart';

class SearchPlacesParams {
  final String query;
  const SearchPlacesParams({required this.query});
}

class SearchPlacesUseCase
    extends
        UseCase<
          Either<Failure, List<PlaceSuggestionEntity>>,
          SearchPlacesParams
        > {
  final GeoRepository _repository;
  const SearchPlacesUseCase(this._repository);

  @override
  Future<Either<Failure, List<PlaceSuggestionEntity>>> call(
    SearchPlacesParams params,
  ) => _repository.searchPlaces(params.query);
}
