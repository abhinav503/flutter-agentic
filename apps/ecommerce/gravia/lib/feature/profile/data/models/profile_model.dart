import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromEntity(ProfileEntity e) =>
      ProfileModel(name: e.name, email: e.email, avatarUrl: e.avatarUrl);

  ProfileEntity toEntity() =>
      ProfileEntity(name: name, email: email, avatarUrl: avatarUrl);
}
