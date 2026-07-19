import 'package:gravia/constants/value_const.dart';

/// Shared field-level validation for gravia's forms — each `validate*`
/// returns the user-facing error message (`null` when the value is valid).
/// Started in `feature/auth`'s Login/Signup screens, which previously all
/// shared one generic "This field is required" message regardless of which
/// field failed or why; every check here names the actual problem instead.
mixin TextfieldValidations {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _nonDigit = RegExp(r'[^0-9]');

  String? validateName(String value) {
    if (value.trim().isEmpty) return ValueConst.nameRequiredErrorMessage;
    return null;
  }

  String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ValueConst.emailRequiredErrorMessage;
    if (!_emailPattern.hasMatch(trimmed)) {
      return ValueConst.emailInvalidErrorMessage;
    }
    return null;
  }

  String? validateMobile(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ValueConst.mobileRequiredErrorMessage;
    if (trimmed.replaceAll(_nonDigit, '').length < 10) {
      return ValueConst.mobileInvalidErrorMessage;
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return ValueConst.passwordRequiredErrorMessage;
    if (value.length < 6) return ValueConst.weakPasswordErrorMessage;
    return null;
  }

  String? validateConfirmPassword(String value, String original) {
    if (value.isEmpty) return ValueConst.confirmPasswordRequiredErrorMessage;
    if (value != original) return ValueConst.passwordsDontMatchErrorMessage;
    return null;
  }
}
