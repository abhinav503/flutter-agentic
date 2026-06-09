// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JokeModel _$JokeModelFromJson(Map<String, dynamic> json) => _JokeModel(
  id: json['id'] as String,
  joke: json['joke'] as String,
  status: (json['status'] as num).toInt(),
);

Map<String, dynamic> _$JokeModelToJson(_JokeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'joke': instance.joke,
      'status': instance.status,
    };
