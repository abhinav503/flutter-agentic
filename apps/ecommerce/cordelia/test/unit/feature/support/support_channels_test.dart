import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/home/domain/entities/store_support_entity.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';
import 'package:cordelia/feature/support/presentation/view/support_channels.dart';
import 'package:cordelia/feature/support/presentation/view/support_message.dart';

/// The rule the three packs must not each re-decide: which channels a shopper
/// is offered, and what the message they open already says.
///
/// The screens are three; this is one. If a pack ever renders a section this
/// file does not produce, the support surface has forked.
ActiveStoreEntity _store({StoreSupportEntity support = StoreSupportEntity.none}) =>
    ActiveStoreEntity(
      storeId: 'store-1',
      storeName: 'Fresh Mart',
      templateId: StorefrontTemplate.gravia,
      language: StoreLanguage.en,
      currency: StoreCurrency.inr,
      support: support,
    );

void main() {
  group('sections', () {
    test('a store with no published contact still offers the platform', () {
      final channels = SupportChannels.build(store: _store());

      // Platform + policies, no store section — never zero channels.
      expect(channels.sections.length, 2);
      expect(
        channels.sections.first.channels.single.value,
        'support@cordeliaapps.com',
      );
    });

    test('the platform subtitle broadens when the store publishes nothing', () {
      final withContact = SupportChannels.build(
        store: _store(support: const StoreSupportEntity(email: 'a@b.com')),
      );
      final without = SupportChannels.build(store: _store());

      final platformWith = withContact.sections[1].subtitle;
      final platformWithout = without.sections[0].subtitle;

      // Different copy, because the promise is different: with a store
      // contact the platform handles account problems only; without one it
      // has to say it will pass an order problem on.
      expect(platformWith, isNot(platformWithout));
    });

    test('email and phone each appear only when published', () {
      final emailOnly = SupportChannels.build(
        store: _store(support: const StoreSupportEntity(email: 'a@b.com')),
      );
      expect(emailOnly.sections.first.channels.map((c) => c.kind), [
        SupportChannelKind.email,
      ]);

      final both = SupportChannels.build(
        store: _store(
          support: const StoreSupportEntity(
            email: 'a@b.com',
            phone: '+91 98765 43210',
          ),
        ),
      );
      expect(both.sections.first.channels.map((c) => c.kind), [
        SupportChannelKind.email,
        SupportChannelKind.phone,
      ]);
    });

    test('opening hours become a note only when the store set them', () {
      expect(
        SupportChannels.build(
          store: _store(support: const StoreSupportEntity(email: 'a@b.com')),
        ).sections.first.note,
        isEmpty,
      );
      expect(
        SupportChannels.build(
          store: _store(
            support: const StoreSupportEntity(
              email: 'a@b.com',
              hours: 'Mon–Sat, 9am–7pm',
            ),
          ),
        ).sections.first.note,
        contains('Mon–Sat, 9am–7pm'),
      );
    });

    test('outside a storefront there is no store section to render', () {
      final channels = SupportChannels.build(store: null);
      expect(channels.sections.length, 2);
    });
  });

  group('message', () {
    SupportMessage message({String orderId = ''}) => SupportMessage(
      store: _store(),
      accountEmail: 'shopper@example.com',
      orderId: orderId,
      version: '1.0.4 (4)',
    );

    String bodyOf(Uri uri) =>
        Uri.decodeComponent(uri.query.split('&body=').last);

    String subjectOf(Uri uri) => Uri.decodeComponent(
      uri.query.split('&body=').first.replaceFirst('subject=', ''),
    );

    test('the store and account travel in the body', () {
      final body = bodyOf(message().mailtoStore('help@freshmart.com'));
      expect(body, contains('Fresh Mart (store-1)'));
      expect(body, contains('shopper@example.com'));
      expect(body, contains('1.0.4 (4)'));
    });

    test('an order id changes the subject and adds a line', () {
      final withOrder = message(orderId: 'ORD-9').mailtoStore('h@f.com');
      expect(subjectOf(withOrder), contains('ORD-9'));
      expect(bodyOf(withOrder), contains('ORD-9'));

      final without = message().mailtoStore('h@f.com');
      expect(subjectOf(without), contains('Fresh Mart'));
      expect(bodyOf(without), isNot(contains('ORD-9')));
    });

    test('the platform mail carries the same order context', () {
      // A store that published no address must not cost the shopper the
      // order number — this is the case where the fallback earns its name.
      final body = bodyOf(message(orderId: 'ORD-9').mailtoPlatform());
      expect(body, contains('ORD-9'));
      expect(body, contains('Fresh Mart (store-1)'));
    });

    test('a space is encoded as %20, not +', () {
      // `Uri.queryParameters` would use `+` here, which several mail clients
      // render literally in the subject line.
      final uri = message().mailtoStore('help@freshmart.com');
      expect(uri.toString(), contains('%20'));
      expect(uri.toString(), isNot(contains('+')));
    });

    test('a dialable tel: keeps only + and digits', () {
      expect(SupportMessage.tel('+91 98765-43210').toString(), 'tel:+919876543210');
    });

    test('a missing account email drops its line rather than printing blank', () {
      final body = bodyOf(
        SupportMessage(
          store: _store(),
          accountEmail: '',
          orderId: '',
          version: '',
        ).mailtoPlatform(),
      );
      expect(body, isNot(contains('Account:')));
    });
  });
}
