import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import '../../constants/core_const.dart';

class ImagePickerService {
  ImagePickerService._() {
    // Opt into the Android Photo Picker. `image_picker_android` still defaults
    // this to false, which leaves it on the legacy ACTION_GET_CONTENT path —
    // and that path is what forces an app to declare READ_MEDIA_IMAGES.
    //
    // Google Play's Photo and Video Permissions policy only grants that
    // permission to apps with a *frequent* need; picking an avatar is the
    // textbook "one-time or infrequent" case the policy tells you to serve
    // with the photo picker instead, so declaring it gets a listing flagged.
    // The picker also needs no runtime permission and no permission prompt.
    //
    // Guarded by a type check rather than Platform.isAndroid so this stays
    // web-safe: on every other platform `instance` is simply not the Android
    // implementation.
    final platform = ImagePickerPlatform.instance;
    if (platform is ImagePickerAndroid) {
      platform.useAndroidPhotoPicker = true;
    }
  }

  static final ImagePickerService instance = ImagePickerService._();

  final _picker = ImagePicker();
  bool _isOpen = false;

  Future<List<XFile>> fromCamera() => _pick(() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: CoreConst.imagePickerQuality,
      maxWidth: CoreConst.imagePickerMaxWidth.toDouble(),
      maxHeight: CoreConst.imagePickerMaxHeight.toDouble(),
    );
    return image == null ? [] : [image];
  });

  Future<List<XFile>> fromGallery() => _pick(
    () => _picker.pickMultiImage(
      imageQuality: CoreConst.imagePickerQuality,
      maxWidth: CoreConst.imagePickerMaxWidth.toDouble(),
      maxHeight: CoreConst.imagePickerMaxHeight.toDouble(),
    ),
  );

  Future<List<XFile>> _pick(Future<List<XFile>> Function() fn) async {
    if (_isOpen) return [];
    _isOpen = true;
    try {
      return await fn();
    } on PlatformException catch (e) {
      if (e.code == 'already_active') return [];
      rethrow;
    } finally {
      _isOpen = false;
    }
  }
}
