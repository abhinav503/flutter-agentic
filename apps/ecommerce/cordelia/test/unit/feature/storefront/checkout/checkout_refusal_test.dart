import 'package:core/core/formatting/app_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/orders/data/data_source/orders_remote_data_source_impl.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';

/// The server can only refuse a checkout in English, so it tags the refusal
/// with a `code` and the app writes the sentence — the same contract as the
/// coupon rejection. The refund half matters just as much: once the payment
/// sheet has closed, "why it failed" and "your money is coming back" are one
/// message, not two.
void main() {
  setUpAll(AppFormat.init);

  final controller = ActiveLocaleController();
  tearDown(controller.resetToAppDefault);

  const source = OrdersRemoteDataSourceImpl();

  final apples = CartItemEntity(
    product: const ProductEntity(
      id: 'p1',
      name: 'Apples',
      imageUrl: '',
      price: 10,
      originalPrice: 12,
      discountPercentage: 0,
      unitValue: 500,
      unitType: ProductUnitType.grams,
      prepTime: '10 Min',
      isFavourite: false,
      stock: 2,
    ),
    quantity: 3,
  );

  DioException refusal(Map<String, dynamic> body, int status) => DioException(
    requestOptions: RequestOptions(path: '/orders'),
    response: Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/orders'),
      statusCode: status,
      data: body,
    ),
  );

  test('names the product instead of printing the server English', () {
    final result = source.refusalFrom(
      refusal({
        'error': 'Insufficient stock for Apples',
        'code': 'insufficient_stock',
        'productId': 'p1',
        'available': 2,
      }, 409),
      [apples],
    );

    expect(result, isNotNull);
    expect(result!.message, contains('Apples'));
    expect(result.message, isNot(contains('Insufficient stock for')));
  });

  test('sold out and merely short are different sentences', () {
    String messageFor(int available) => source.refusalFrom(
      refusal({
        'code': 'insufficient_stock',
        'productId': 'p1',
        'available': available,
      }, 409),
      [apples],
    )!.message;

    expect(messageFor(0), isNot(messageFor(2)));
  });

  test('a refunded refusal says so, in the same message', () {
    final reason = source.refusalFrom(
      refusal({
        'code': 'insufficient_stock',
        'productId': 'p1',
        'available': 0,
      }, 409),
      [apples],
    )!.message;
    final refunded = source.refusalFrom(
      refusal({
        'code': 'insufficient_stock',
        'productId': 'p1',
        'available': 0,
        'refunded': true,
      }, 409),
      [apples],
    )!.message;

    expect(refunded, startsWith(reason));
    expect(refunded.length, greaterThan(reason.length));
  });

  test('a refunded failure with no code still explains itself', () {
    // A coupon or an address that lost its race — no stock code, money taken.
    final result = source.refusalFrom(
      refusal({'error': 'Coupon expired', 'refunded': true}, 400),
      [apples],
    );

    expect(result, isNotNull);
    expect(result!.message, isNot(contains('Coupon expired')));
  });

  test('an ordinary error falls through to the usual Dio mapping', () {
    expect(
      source.refusalFrom(refusal({'error': 'Server error'}, 500), [apples]),
      isNull,
    );
  });

  test('the sentence follows the storefront language', () {
    Map<String, dynamic> body() => {
      'code': 'insufficient_stock',
      'productId': 'p1',
      'available': 0,
    };

    controller.apply(StoreLanguage.en.asLocale);
    final english = source.refusalFrom(refusal(body(), 409), [apples])!.message;
    controller.apply(StoreLanguage.de.asLocale);
    final german = source.refusalFrom(refusal(body(), 409), [apples])!.message;

    expect(german, isNot(english));
  });
}
