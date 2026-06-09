import 'package:freezed_annotation/freezed_annotation.dart';

part 'joke_search_response_model.freezed.dart';
part 'joke_search_response_model.g.dart';

@freezed
abstract class JokeSearchResultModel with _$JokeSearchResultModel {
  const factory JokeSearchResultModel({
    required String id,
    required String joke,
  }) = _JokeSearchResultModel;

  factory JokeSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$JokeSearchResultModelFromJson(json);
}

@freezed
abstract class JokeSearchResponseModel with _$JokeSearchResponseModel {
  const factory JokeSearchResponseModel({
    @JsonKey(name: 'current_page')  required int currentPage,
    required int limit,
    @JsonKey(name: 'next_page')     required int nextPage,
    @JsonKey(name: 'previous_page') required int previousPage,
    required List<JokeSearchResultModel> results,
    @JsonKey(name: 'search_term')   required String searchTerm,
    required int status,
    @JsonKey(name: 'total_jokes')   required int totalJokes,
    @JsonKey(name: 'total_pages')   required int totalPages,
  }) = _JokeSearchResponseModel;

  factory JokeSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$JokeSearchResponseModelFromJson(json);
}
