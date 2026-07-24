class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String mobile;
  final bool emailVerified;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobile,
    required this.emailVerified,
  });
}
