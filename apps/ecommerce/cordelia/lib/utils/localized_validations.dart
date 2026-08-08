import 'package:core/core/constants/core_const.dart';
import 'package:core/core/mixins/textfield_validations.dart';

import 'package:cordelia/l10n/l10n.dart';

/// Core's [TextfieldValidations] with arb-backed copy — core stays free of
/// intl/arb, so the localization happens through the mixin-override seam the
/// core mixin documents. The predicates stay core's; only the returned
/// message is swapped, keyed off which [CoreConst] default `super` picked.
///
/// English arb copy matches [CoreConst] verbatim, so mixing this in changes
/// nothing outside a Hindi storefront.
mixin LocalizedValidations on TextfieldValidations {
  @override
  String? validateName(String value) => switch (super.validateName(value)) {
    null => null,
    _ => L10n.current.validationNameRequired,
  };

  @override
  String? validateEmail(String value) => switch (super.validateEmail(value)) {
    null => null,
    CoreConst.emailRequiredErrorMessage => L10n.current.validationEmailRequired,
    _ => L10n.current.validationEmailInvalid,
  };

  @override
  String? validateMobile(String value) => switch (super.validateMobile(value)) {
    null => null,
    CoreConst.mobileRequiredErrorMessage =>
      L10n.current.validationMobileRequired,
    _ => L10n.current.validationMobileInvalid,
  };

  @override
  String? validatePassword(String value) =>
      switch (super.validatePassword(value)) {
        null => null,
        CoreConst.passwordRequiredErrorMessage =>
          L10n.current.validationPasswordRequired,
        _ => L10n.current.validationWeakPassword,
      };

  @override
  String? validateConfirmPassword(String value, String original) =>
      switch (super.validateConfirmPassword(value, original)) {
        null => null,
        CoreConst.confirmPasswordRequiredErrorMessage =>
          L10n.current.validationConfirmPasswordRequired,
        _ => L10n.current.validationPasswordsDontMatch,
      };
}
