class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String mobile;
  final bool emailVerified;

  /// The shopper's avatar in Firebase Storage, as returned by the admin API.
  /// Empty until Edit Profile uploads one — every consumer treats empty as
  /// "no photo" and falls back to the placeholder glyph.
  final String avatarUrl;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobile,
    required this.emailVerified,
    this.avatarUrl = '',
  });
}
