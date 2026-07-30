import 'dart:typed_data';

class ProfileEntity {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  /// A photo picked from the device this session (Edit Profile's camera
  /// picker). It *is* uploaded on save — [avatarUrl] then points at it in
  /// Firebase Storage — but the bytes ride along so the new photo paints
  /// immediately instead of flashing the placeholder while the fresh URL
  /// downloads. `Uint8List` rather than a `File`/path so every avatar
  /// consumer stays web-safe (`dart:io` doesn't compile for web;
  /// `image_picker`'s `XFile.readAsBytes()` works on every platform).
  /// Never round-trips through `ProfileModel` — a profile loaded from the
  /// repository has only [avatarUrl]; only a screen-local pick has bytes.
  final Uint8List? avatarBytes;

  const ProfileEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    this.avatarBytes,
  });
}
