import 'package:freezed_annotation/freezed_annotation.dart';

part 'joke_model.freezed.dart';
part 'joke_model.g.dart';

@freezed
abstract class JokeModel with _$JokeModel {
  const factory JokeModel({
    required String id,
    required String joke,
    required int status,
  }) = _JokeModel;

  factory JokeModel.fromJson(Map<String, dynamic> json) => _$JokeModelFromJson(json);
}
