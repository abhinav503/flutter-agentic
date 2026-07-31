import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/services/image_picker/image_picker_service.dart';

import 'package:cordelia/enums/avatar_source.dart';

import '../domain/entities/profile_entity.dart';
import 'bloc/edit_profile_bloc.dart';

/// Which form field an error message belongs to.
enum ProfileField { name, email, phone }

/// Everything Edit Profile does that isn't pack chrome — controllers seeded
/// from the incoming profile, per-field validation errors, the web-guarded
/// avatar pick, the validated submit, and the success-pop/error-snackbar
/// listener. Both templates' Edit Profile screens mix this in and render
/// only their own layout, so the form behaviour can't drift between packs
/// (same shape as `QuantitySelection`).
///
/// Typed values and the picked avatar stay screen-local UI state (the same
/// carve-out the Add/Edit Address form uses); only the actual submit goes
/// through [EditProfileBloc], which owns the real network call.
mixin EditProfileForm<T extends BaseScreen>
    on BaseScreenState<T>, TextfieldValidations {
  /// The profile being edited — implemented by the screen as
  /// `widget.profile`.
  ProfileEntity get profile;

  /// The pack's own sheet chrome for the camera/gallery choice.
  Future<AvatarSource?> showAvatarSourceSheet();

  /// The pack's copy for the web no-capture snackbar.
  String get avatarPickerMobileOnlyMessage;

  late final nameController = TextEditingController(text: profile.name);
  late final emailController = TextEditingController(text: profile.email);
  late final phoneController = TextEditingController(text: profile.phone);

  /// A photo picked this session, previewed immediately and carried into the
  /// popped result — null until the user picks one, in which case it wins
  /// over the existing `avatarUrl` (see `CordeliaAvatarImage`).
  Uint8List? pickedAvatarBytes;

  final Map<ProfileField, String> fieldErrors = {};

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void clearFieldError(ProfileField field) {
    if (fieldErrors.containsKey(field)) {
      setState(() => fieldErrors.remove(field));
    }
  }

  // Camera/gallery capture is mobile-only; on the web preview there's no
  // capture pipeline, so surface a snackbar and skip the picker instead of
  // opening a browser file dialog that goes nowhere (same guard doc_scanner
  // uses around its own ImagePickerService calls).
  Future<void> pickAvatar() async {
    if (kIsWeb) {
      showSnackBar(avatarPickerMobileOnlyMessage);
      return;
    }

    final source = await showAvatarSourceSheet();
    if (source == null) return;

    final files = source == AvatarSource.camera
        ? await ImagePickerService.instance.fromCamera()
        : await ImagePickerService.instance.fromGallery();
    if (files.isEmpty || !mounted) return;

    final bytes = await files.first.readAsBytes();
    if (!mounted) return;
    setState(() => pickedAvatarBytes = bytes);
  }

  void submitProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    final errors = <ProfileField, String>{
      ProfileField.name: ?validateName(name),
      ProfileField.phone: ?validateMobile(phone),
    };

    if (errors.isNotEmpty) {
      setState(() {
        fieldErrors
          ..clear()
          ..addAll(errors);
      });
      return;
    }

    context.read<EditProfileBloc>().add(
      EditProfileEvent.submitted(
        name: name,
        mobile: phone,
        avatarBytes: pickedAvatarBytes,
      ),
    );
  }

  /// The `BlocConsumer` listener body: success pops the merged profile back
  /// to the caller, an error toasts.
  void handleEditProfileState(BuildContext context, EditProfileState state) =>
      switch (state) {
        EditProfileSuccess(:final user) => context.pop(
          ProfileEntity(
            name: user.name,
            email: user.email,
            phone: user.mobile,
            // Server's copy — the URL of the photo just uploaded, or the
            // existing one when this save didn't touch the avatar.
            avatarUrl: user.avatarUrl,
            // Kept alongside it so the new photo paints immediately;
            // fetching the fresh URL would flash the placeholder first.
            avatarBytes: pickedAvatarBytes ?? profile.avatarBytes,
          ),
        ),
        EditProfileError(:final message) => showSnackBar(message),
        _ => null,
      };
}
