import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String name,
    required String email,
    required String mobile,
    required bool emailVerified,
    @JsonKey(name: 'avatar_url', defaultValue: '') required String avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity e) => UserModel(
    uid: e.uid,
    name: e.name,
    email: e.email,
    mobile: e.mobile,
    emailVerified: e.emailVerified,
    avatarUrl: e.avatarUrl,
  );

  UserEntity toEntity() => UserEntity(
    uid: uid,
    name: name,
    email: email,
    mobile: mobile,
    emailVerified: emailVerified,
    avatarUrl: avatarUrl,
  );
}
