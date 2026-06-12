import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/joke_entity.dart';
import '../../domain/entities/joke_search_page_entity.dart';

part 'joke_search_response_model.freezed.dart';
part 'joke_search_response_model.g.dart';

@freezed
abstract class JokeSearchResultModel with _$JokeSearchResultModel {
  const JokeSearchResultModel._();

  const factory JokeSearchResultModel({
    required String id,
    required String joke,
  }) = _JokeSearchResultModel;

  factory JokeSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$JokeSearchResultModelFromJson(json);

  factory JokeSearchResultModel.fromEntity(JokeEntity e) =>
      JokeSearchResultModel(id: e.id, joke: e.content);

  JokeEntity toEntity() => JokeEntity(id: id, content: joke);
}

@freezed
abstract class JokeSearchResponseModel with _$JokeSearchResponseModel {
  const JokeSearchResponseModel._();

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

  factory JokeSearchResponseModel.fromEntity(JokeSearchPageEntity e) =>
      JokeSearchResponseModel(
        currentPage: e.currentPage,
        limit: 20,
        nextPage: e.nextPage,
        previousPage: 0,
        results: e.results.map(JokeSearchResultModel.fromEntity).toList(),
        searchTerm: e.searchTerm,
        status: 200,
        totalJokes: e.totalJokes,
        totalPages: e.totalPages,
      );

  JokeSearchPageEntity toEntity() => JokeSearchPageEntity(
        currentPage: currentPage,
        totalJokes: totalJokes,
        totalPages: totalPages,
        nextPage: nextPage,
        searchTerm: searchTerm,
        results: results.map((r) => r.toEntity()).toList(),
      );
}
