import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/joke_entity.dart';

part 'joke_model.freezed.dart';
part 'joke_model.g.dart';

@freezed
abstract class JokeModel with _$JokeModel {
  const JokeModel._();

  const factory JokeModel({
    required String id,
    required String joke,
    required int status,
  }) = _JokeModel;

  factory JokeModel.fromJson(Map<String, dynamic> json) => _$JokeModelFromJson(json);

  factory JokeModel.fromEntity(JokeEntity e) =>
      JokeModel(id: e.id, joke: e.content, status: 200);

  JokeEntity toEntity() => JokeEntity(id: id, content: joke);
}
