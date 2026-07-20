import '../constants/core_const.dart';
import '../extensions/string_extensions.dart';

/// Shared field-level validation for forms — each `validate*` returns the
/// user-facing error message (`null` when the value is valid), so it plugs
/// straight into `AppTextField.errorText` / form state.
///
/// Messages default to the generic copy in [CoreConst]; an app with its own
/// wording overrides the method, keeping the predicate:
///
/// ```dart
/// class _LoginScreenState extends BaseScreenState<LoginScreen>
///     with TextfieldValidations {
///   @override
///   String? validateEmail(String value) =>
///       super.validateEmail(value) == null ? null : ValueConst.myEmailCopy;
/// }
/// ```
mixin TextfieldValidations {
  String? validateName(String value) {
    if (value.trim().isEmpty) return CoreConst.nameRequiredErrorMessage;
    return null;
  }

  String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return CoreConst.emailRequiredErrorMessage;
    if (!trimmed.isValidEmail) return CoreConst.emailInvalidErrorMessage;
    return null;
  }

  String? validateMobile(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return CoreConst.mobileRequiredErrorMessage;
    if (trimmed.digitCount < 10) return CoreConst.mobileInvalidErrorMessage;
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return CoreConst.passwordRequiredErrorMessage;
    if (value.length < 6) return CoreConst.weakPasswordErrorMessage;
    return null;
  }

  String? validateConfirmPassword(String value, String original) {
    if (value.isEmpty) return CoreConst.confirmPasswordRequiredErrorMessage;
    if (value != original) return CoreConst.passwordsDontMatchErrorMessage;
    return null;
  }
}
