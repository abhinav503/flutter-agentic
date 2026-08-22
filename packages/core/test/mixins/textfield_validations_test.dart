import 'package:core/core/constants/core_const.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:flutter_test/flutter_test.dart';

class _Validator with TextfieldValidations {}

/// The predicates and the copy are separate so an app can translate one
/// without matching on the other. These pin the predicate half.
void main() {
  final v = _Validator();

  test('an empty field and a malformed one are different reasons', () {
    expect(v.emailError(''), FieldValidationError.emailRequired);
    expect(v.emailError('   '), FieldValidationError.emailRequired);
    expect(v.emailError('nope'), FieldValidationError.emailInvalid);
    expect(v.emailError('sam@example.com'), isNull);
  });

  test('mobile counts digits, not characters', () {
    expect(v.mobileError(''), FieldValidationError.mobileRequired);
    expect(v.mobileError('12345'), FieldValidationError.mobileInvalid);
    expect(v.mobileError('+91 98765-43210'), isNull);
  });

  test('password distinguishes missing from weak', () {
    expect(v.passwordError(''), FieldValidationError.passwordRequired);
    expect(v.passwordError('abc'), FieldValidationError.passwordWeak);
    expect(v.passwordError('abcdef'), isNull);
  });

  test('confirm-password distinguishes missing from mismatched', () {
    expect(
      v.confirmPasswordError('', 'abcdef'),
      FieldValidationError.confirmPasswordRequired,
    );
    expect(
      v.confirmPasswordError('abcdeg', 'abcdef'),
      FieldValidationError.passwordsDontMatch,
    );
    expect(v.confirmPasswordError('abcdef', 'abcdef'), isNull);
  });

  test('validate* speaks CoreConst until an app says otherwise', () {
    expect(v.validateEmail(''), CoreConst.emailRequiredErrorMessage);
    expect(v.validateEmail('nope'), CoreConst.emailInvalidErrorMessage);
    expect(v.validateEmail('sam@example.com'), isNull);
  });

  test('every reason has words', () {
    for (final error in FieldValidationError.values) {
      expect(v.messageFor(error), isNotEmpty, reason: '$error has no message');
    }
  });
}
