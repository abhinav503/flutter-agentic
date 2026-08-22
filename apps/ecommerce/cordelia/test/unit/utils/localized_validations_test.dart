import 'package:core/core/constants/core_const.dart';
import 'package:core/core/formatting/app_format.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/utils/localized_validations.dart';

class _Validator with TextfieldValidations, LocalizedValidations {}

/// The override used to work out *which* failure had happened by comparing
/// the English string `super` returned against `CoreConst`. Reword a default
/// there and the case silently stopped matching, so an empty email field
/// would have been told "that email isn't valid" — in the right language,
/// with the wrong meaning, and nothing to catch it.
void main() {
  setUpAll(AppFormat.init);

  final controller = ActiveLocaleController();
  tearDown(controller.resetToAppDefault);

  final v = _Validator();

  test('a missing field and a malformed one say different things', () {
    expect(v.validateEmail(''), isNot(v.validateEmail('nope')));
    expect(v.validateMobile(''), isNot(v.validateMobile('123')));
    expect(v.validatePassword(''), isNot(v.validatePassword('abc')));
    expect(
      v.validateConfirmPassword('', 'abcdef'),
      isNot(v.validateConfirmPassword('abcdeg', 'abcdef')),
    );
  });

  test('every reason is translated, none falls back to core English', () {
    controller.apply(StoreLanguage.hi.asLocale);
    const coreCopy = {
      CoreConst.nameRequiredErrorMessage,
      CoreConst.emailRequiredErrorMessage,
      CoreConst.emailInvalidErrorMessage,
      CoreConst.mobileRequiredErrorMessage,
      CoreConst.mobileInvalidErrorMessage,
      CoreConst.passwordRequiredErrorMessage,
      CoreConst.weakPasswordErrorMessage,
      CoreConst.confirmPasswordRequiredErrorMessage,
      CoreConst.passwordsDontMatchErrorMessage,
    };

    for (final error in FieldValidationError.values) {
      expect(
        coreCopy,
        isNot(contains(v.messageFor(error))),
        reason: '$error is still showing core\'s English in Hindi',
      );
    }
  });

  test('the copy follows the storefront language', () {
    controller.apply(StoreLanguage.en.asLocale);
    final english = v.validateEmail('');
    controller.apply(StoreLanguage.de.asLocale);

    expect(v.validateEmail(''), isNot(english));
  });
}
