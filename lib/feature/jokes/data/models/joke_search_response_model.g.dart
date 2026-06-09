// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JokeSearchResultModel _$JokeSearchResultModelFromJson(
  Map<String, dynamic> json,
) => _JokeSearchResultModel(
  id: json['id'] as String,
  joke: json['joke'] as String,
);

Map<String, dynamic> _$JokeSearchResultModelToJson(
  _JokeSearchResultModel instance,
) => <String, dynamic>{'id': instance.id, 'joke': instance.joke};

_JokeSearchResponseModel _$JokeSearchResponseModelFromJson(
  Map<String, dynamic> json,
) => _JokeSearchResponseModel(
  currentPage: (json['current_page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  nextPage: (json['next_page'] as num).toInt(),
  previousPage: (json['previous_page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => JokeSearchResultModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  searchTerm: json['search_term'] as String,
  status: (json['status'] as num).toInt(),
  totalJokes: (json['total_jokes'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$JokeSearchResponseModelToJson(
  _JokeSearchResponseModel instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'limit': instance.limit,
  'next_page': instance.nextPage,
  'previous_page': instance.previousPage,
  'results': instance.results,
  'search_term': instance.searchTerm,
  'status': instance.status,
  'total_jokes': instance.totalJokes,
  'total_pages': instance.totalPages,
};
