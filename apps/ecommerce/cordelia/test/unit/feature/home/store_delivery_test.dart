import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/home/domain/entities/store_delivery_entity.dart';

/// The Dart half of the delivery policy, checked against the *same* cases as
/// the server's `admin/scripts/verify-delivery.ts`.
///
/// The two implementations exist because the cart has to print a fee before
/// any request is made, while the server has to charge one it can trust. They
/// are only allowed to exist as long as they agree: if this file and that
/// script ever disagree, the cart quotes a total the payment sheet then
/// contradicts. Change one, change both.
void main() {
  group('feeFor', () {
    test('no fee configured is free at any basket', () {
      expect(StoreDeliveryEntity.free.feeFor(100), 0);
    });

    test('a flat fee with no threshold is always charged', () {
      const delivery = StoreDeliveryEntity(fee: 40);
      expect(delivery.feeFor(5000), 40);
    });

    test('the threshold is inclusive of its own value', () {
      const delivery = StoreDeliveryEntity(fee: 40, freeAbove: 500);
      expect(delivery.feeFor(499.99), 40);
      expect(delivery.feeFor(500), 0);
      expect(delivery.feeFor(500.01), 0);
    });

    test(
      'a coupon that drops the basket under the threshold restores the fee',
      () {
        const delivery = StoreDeliveryEntity(fee: 40, freeAbove: 500);
        expect(delivery.feeFor(520 - 60), 40);
      },
    );

    test('isAlwaysFree distinguishes a free store from a waived basket', () {
      expect(StoreDeliveryEntity.free.isAlwaysFree, isTrue);
      expect(const StoreDeliveryEntity(fee: 40).isAlwaysFree, isFalse);
    });
  });

  group('serves', () {
    test('no areas means everywhere', () {
      expect(StoreDeliveryEntity.free.serves('560001'), isTrue);
    });

    test('a prefix covers the codes beneath it but nothing shorter', () {
      const delivery = StoreDeliveryEntity(areas: ['5600']);
      expect(delivery.serves('560042'), isTrue);
      expect(delivery.serves('560'), isFalse);
      expect(delivery.serves('110001'), isFalse);
    });

    test('case and spacing do not decide serviceability', () {
      const delivery = StoreDeliveryEntity(areas: ['SW1A']);
      expect(delivery.serves('sw1a 1aa'), isTrue);
    });

    test('an address with no postal code is never blocked', () {
      // The field is optional in the address form and absent entirely from
      // addresses saved before it existed — refusing those would break
      // checkout for accounts that did nothing wrong.
      const delivery = StoreDeliveryEntity(areas: ['560']);
      expect(delivery.serves(''), isTrue);
    });

    test('any one matching prefix is enough', () {
      const delivery = StoreDeliveryEntity(areas: ['110', '560']);
      expect(delivery.serves('560001'), isTrue);
    });
  });
}
