import 'package:core/core/formatting/app_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/cart/data/data_source/coupons_remote_data_source_impl.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';

/// The coupon "minimum order" rejection is the one server message that names
/// an amount, and it used to hardcode a rupee sign — so a euro store's shopper
/// was told their order was below "₹20". The server now sends the bare number
/// with a `min_order` code and the client writes the sentence, which is the
/// only place that knows the store's currency *and* the shopper's language.
void main() {
  setUpAll(AppFormat.init);

  final controller = ActiveLocaleController();
  tearDown(controller.resetToAppDefault);

  /// The 400 the validate route returns for an under-minimum coupon.
  DioException minOrderResponse(num minimum) => DioException(
    requestOptions: RequestOptions(path: '/coupons/validate'),
    response: Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/coupons/validate'),
      statusCode: 400,
      data: {
        'error': "Your order is below this coupon's minimum of $minimum",
        'code': 'min_order',
        'minOrderValue': minimum,
      },
    ),
  );

  // Calling the translation directly: going through validateCoupon would need
  // a live HTTP call, and the translation is the part that regressed.
  const source = CouponsRemoteDataSourceImpl();

  group('minimum-order rejection', () {
    test('formats the amount in the store currency, not rupees', () {
      controller.apply(StoreLanguage.de.asLocale, currency: StoreCurrency.eur);
      final rejection = source.rejectionFrom(minOrderResponse(20));

      expect(rejection, isNotNull);
      expect(rejection!.message, contains('20'));
      expect(rejection.message, contains('€'));
      expect(
        rejection.message,
        isNot(contains('₹')),
        reason: 'the bug this exists to prevent',
      );
    });

    test('renders in the shopper language, not the server default', () {
      controller.apply(StoreLanguage.fr.asLocale, currency: StoreCurrency.eur);
      final french = source.rejectionFrom(minOrderResponse(20))!.message;

      controller.apply(StoreLanguage.en.asLocale, currency: StoreCurrency.gbp);
      final english = source.rejectionFrom(minOrderResponse(20))!.message;

      expect(french, isNot(english));
      expect(english, contains('£'));
    });

    test('a rupee store still reads in rupees', () {
      controller.apply(StoreLanguage.en.asLocale, currency: StoreCurrency.inr);
      expect(source.rejectionFrom(minOrderResponse(500))!.message,
          contains('₹500'));
    });
  });

  group('everything else falls through', () {
    // Only the tagged rejection is rewritten. Any other failure keeps the
    // server's own text, which is what the generic Dio→Failure mapping shows.
    DioException plain(Map<String, dynamic>? body, {int status = 400}) =>
        DioException(
          requestOptions: RequestOptions(path: '/coupons/validate'),
          response: Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/coupons/validate'),
            statusCode: status,
            data: body,
          ),
        );

    test('an untagged coupon error is left alone', () {
      expect(source.rejectionFrom(plain({'error': 'This coupon has expired'})),
          isNull);
    });

    test('a different code is left alone', () {
      expect(
        source.rejectionFrom(plain({'error': 'nope', 'code': 'something_else'})),
        isNull,
      );
    });

    test('a tagged body missing the amount is left alone', () {
      // Rather than printing "minimum of null" — the fallback text the server
      // already sent is better than a broken sentence.
      expect(
        source.rejectionFrom(plain({'error': 'x', 'code': 'min_order'})),
        isNull,
      );
    });

    test('a bodyless network error is left alone', () {
      expect(
        source.rejectionFrom(
          DioException(
            requestOptions: RequestOptions(path: '/coupons/validate'),
            type: DioExceptionType.connectionError,
          ),
        ),
        isNull,
      );
    });
  });
}
