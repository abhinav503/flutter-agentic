import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/place_suggestion_entity.dart';

part 'place_suggestion_model.freezed.dart';
part 'place_suggestion_model.g.dart';

@freezed
abstract class PlaceSuggestionModel with _$PlaceSuggestionModel {
  const PlaceSuggestionModel._();

  const factory PlaceSuggestionModel({
    @Default('') String description,
    @JsonKey(name: 'place_id') @Default('') String placeId,
    double? latitude,
    double? longitude,
  }) = _PlaceSuggestionModel;

  factory PlaceSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceSuggestionModelFromJson(json);

  factory PlaceSuggestionModel.fromEntity(PlaceSuggestionEntity e) =>
      PlaceSuggestionModel(
        description: e.description,
        placeId: e.placeId,
        latitude: e.latitude,
        longitude: e.longitude,
      );

  PlaceSuggestionEntity toEntity() => PlaceSuggestionEntity(
    description: description,
    placeId: placeId,
    latitude: latitude,
    longitude: longitude,
  );
}
