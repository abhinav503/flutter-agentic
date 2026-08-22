import 'package:core/core/mixins/textfield_validations.dart';

import 'package:cordelia/l10n/l10n.dart';

/// Core's [TextfieldValidations] with arb-backed copy — core stays free of
/// intl/arb, so the localization happens through the [messageFor] seam the
/// core mixin documents. The predicates stay core's; only the words change.
///
/// One exhaustive `switch` over [FieldValidationError], not five methods
/// matching on what `super` returned. The previous shape compared the
/// English string against `CoreConst` to work out which failure had
/// occurred, so rewording a default there would have silently started
/// showing the *wrong* translated message — "that email isn't valid" for an
/// empty field — with nothing to catch it. Now the compiler requires every
/// case, and a new one in core breaks the build here until it is translated.
mixin LocalizedValidations on TextfieldValidations {
  @override
  String messageFor(FieldValidationError error) => switch (error) {
    FieldValidationError.nameRequired => L10n.current.validationNameRequired,
    FieldValidationError.emailRequired => L10n.current.validationEmailRequired,
    FieldValidationError.emailInvalid => L10n.current.validationEmailInvalid,
    FieldValidationError.mobileRequired =>
      L10n.current.validationMobileRequired,
    FieldValidationError.mobileInvalid => L10n.current.validationMobileInvalid,
    FieldValidationError.passwordRequired =>
      L10n.current.validationPasswordRequired,
    FieldValidationError.passwordWeak => L10n.current.validationWeakPassword,
    FieldValidationError.confirmPasswordRequired =>
      L10n.current.validationConfirmPasswordRequired,
    FieldValidationError.passwordsDontMatch =>
      L10n.current.validationPasswordsDontMatch,
  };
}
