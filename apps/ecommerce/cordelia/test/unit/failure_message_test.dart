import 'package:core/core/error/failure.dart';
import 'package:core/core/formatting/app_format.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/utils/failure_message.dart';

/// A shopper who turned their wifi off was shown Dio's own sentence —
/// "Failed host lookup: 'admin-…vercel.app'. This indicates an error which
/// most likely cannot be solved by the library." — in English, whatever
/// their store's language.
void main() {
  setUpAll(AppFormat.init);

  final controller = ActiveLocaleController();
  tearDown(controller.resetToAppDefault);

  test('a network failure never shows what the HTTP client said', () {
    const dio = Failure.network(
      message: "Failed host lookup: 'admin-beryl-kappa-44.vercel.app'",
    );

    expect(dio.shopperMessage, isNot(contains('host lookup')));
    expect(dio.shopperMessage, isNot(contains('vercel')));
  });

  test('and says it in the storefront language', () {
    const dio = Failure.network(message: 'SocketException');

    controller.apply(StoreLanguage.en.asLocale);
    final english = dio.shopperMessage;
    controller.apply(StoreLanguage.de.asLocale);

    expect(dio.shopperMessage, isNot(english));
  });

  test('everything already written for a person passes through', () {
    // Each of these carries copy the app or the server composed on purpose;
    // replacing them with a generic line would lose the specific reason.
    const refused = Failure.refused(
      code: 'insufficient_stock',
      message: 'Only 2 left of Apples.',
    );
    const payment = Failure.payment(message: 'Payment was cancelled.');
    const server = Failure.server(statusCode: 409, message: 'Coupon expired.');

    expect(refused.shopperMessage, 'Only 2 left of Apples.');
    expect(payment.shopperMessage, 'Payment was cancelled.');
    expect(server.shopperMessage, 'Coupon expired.');
  });
}
