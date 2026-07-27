import 'dart:typed_data';

class ProfileEntity {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  /// A photo picked from the device this session (Edit Profile's camera
  /// picker) but never uploaded anywhere — there's no backend for this
  /// mocked app to host it at a URL. `Uint8List` rather than a `File`/path
  /// so every avatar consumer stays web-safe (`dart:io` doesn't compile for
  /// web; `image_picker`'s `XFile.readAsBytes()` works on every platform).
  /// Never round-trips through `ProfileModel` — a profile loaded from the
  /// repository never has one, only a screen-local pick does.
  final Uint8List? avatarBytes;

  const ProfileEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    this.avatarBytes,
  });
}
