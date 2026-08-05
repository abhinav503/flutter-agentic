// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaceSuggestionModel _$PlaceSuggestionModelFromJson(
  Map<String, dynamic> json,
) => _PlaceSuggestionModel(
  description: json['description'] as String? ?? '',
  placeId: json['place_id'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PlaceSuggestionModelToJson(
  _PlaceSuggestionModel instance,
) => <String, dynamic>{
  'description': instance.description,
  'place_id': instance.placeId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
