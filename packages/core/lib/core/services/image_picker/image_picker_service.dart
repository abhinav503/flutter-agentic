import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/core_const.dart';

class ImagePickerService {
  ImagePickerService._();
  static final ImagePickerService instance = ImagePickerService._();

  final _picker = ImagePicker();
  bool _isOpen = false;

  Future<List<XFile>> fromCamera() => _pick(
        () async {
          final image = await _picker.pickImage(
            source: ImageSource.camera,
            imageQuality: CoreConst.imagePickerQuality,
            maxWidth: CoreConst.imagePickerMaxWidth.toDouble(),
            maxHeight: CoreConst.imagePickerMaxHeight.toDouble(),
          );
          return image == null ? [] : [image];
        },
      );

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
