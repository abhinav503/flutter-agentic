import '../constants/core_const.dart';
import '../extensions/string_extensions.dart';

/// Why a field failed validation — the *reason*, separate from the words.
///
/// An app that ships its own copy (a localized one, or a different tone)
/// maps these to messages by overriding [TextfieldValidations.messageFor].
/// Matching on the returned English string instead is how a reworded
/// default silently starts showing the wrong error, since a `switch` on a
/// literal has no way to complain.
enum FieldValidationError {
  nameRequired,
  emailRequired,
  emailInvalid,
  mobileRequired,
  mobileInvalid,
  passwordRequired,
  passwordWeak,
  confirmPasswordRequired,
  passwordsDontMatch,
}

/// Shared field-level validation for forms — each `validate*` returns the
/// user-facing error message (`null` when the value is valid), so it plugs
/// straight into `AppTextField.errorText` / form state.
///
/// The predicates and the copy are separate on purpose: `*Error` decides
/// *whether* and *why* a value is bad, [messageFor] turns that into words.
/// An app with its own wording overrides [messageFor] alone and inherits
/// every predicate:
///
/// ```dart
/// mixin LocalizedValidations on TextfieldValidations {
///   @override
///   String messageFor(FieldValidationError error) => switch (error) {
///     FieldValidationError.emailRequired => L10n.current.emailRequired,
///     // … the compiler requires every case
///   };
/// }
/// ```
///
/// Because that override is an exhaustive `switch`, adding a case here
/// breaks every app that hasn't translated it — which is the point.
mixin TextfieldValidations {
  /// The words for [error]. Defaults to [CoreConst]'s generic English.
  String messageFor(FieldValidationError error) => switch (error) {
    FieldValidationError.nameRequired => CoreConst.nameRequiredErrorMessage,
    FieldValidationError.emailRequired => CoreConst.emailRequiredErrorMessage,
    FieldValidationError.emailInvalid => CoreConst.emailInvalidErrorMessage,
    FieldValidationError.mobileRequired => CoreConst.mobileRequiredErrorMessage,
    FieldValidationError.mobileInvalid => CoreConst.mobileInvalidErrorMessage,
    FieldValidationError.passwordRequired =>
      CoreConst.passwordRequiredErrorMessage,
    FieldValidationError.passwordWeak => CoreConst.weakPasswordErrorMessage,
    FieldValidationError.confirmPasswordRequired =>
      CoreConst.confirmPasswordRequiredErrorMessage,
    FieldValidationError.passwordsDontMatch =>
      CoreConst.passwordsDontMatchErrorMessage,
  };

  FieldValidationError? nameError(String value) =>
      value.trim().isEmpty ? FieldValidationError.nameRequired : null;

  FieldValidationError? emailError(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return FieldValidationError.emailRequired;
    if (!trimmed.isValidEmail) return FieldValidationError.emailInvalid;
    return null;
  }

  FieldValidationError? mobileError(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return FieldValidationError.mobileRequired;
    if (trimmed.digitCount < 10) return FieldValidationError.mobileInvalid;
    return null;
  }

  FieldValidationError? passwordError(String value) {
    if (value.isEmpty) return FieldValidationError.passwordRequired;
    if (value.length < 6) return FieldValidationError.passwordWeak;
    return null;
  }

  FieldValidationError? confirmPasswordError(String value, String original) {
    if (value.isEmpty) return FieldValidationError.confirmPasswordRequired;
    if (value != original) return FieldValidationError.passwordsDontMatch;
    return null;
  }

  String? validateName(String value) => _message(nameError(value));

  String? validateEmail(String value) => _message(emailError(value));

  String? validateMobile(String value) => _message(mobileError(value));

  String? validatePassword(String value) => _message(passwordError(value));

  String? validateConfirmPassword(String value, String original) =>
      _message(confirmPasswordError(value, original));

  String? _message(FieldValidationError? error) =>
      error == null ? null : messageFor(error);
}
