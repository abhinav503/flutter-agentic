import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/enums/store_filter.dart';
import 'package:cordelia/enums/store_status.dart';
import 'package:cordelia/feature/home/data/models/store_model.dart';
import 'package:cordelia/feature/home/domain/entities/store_entity.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

StoreEntity _store(String id, StoreStatus status) => StoreEntity(
  id: id,
  name: id,
  logoUrl: '',
  description: '',
  templateId: StorefrontTemplate.gravia,
  language: StoreLanguage.en,
  currency: StoreCurrency.inr,
  status: status,
);

void main() {
  group('status parsing', () {
    // An older API build sends no status at all, and stores predating the
    // lifecycle carry the legacy "active" marker. Both must read as
    // published: the server only ever returns a store this caller may see,
    // so the safe default is "nothing special to say", not a false draft
    // badge on a store that is actually live.
    test('unknown, empty and legacy values read as published', () {
      expect(''.toStoreStatus(), StoreStatus.published);
      expect('active'.toStoreStatus(), StoreStatus.published);
      expect('something-new'.toStoreStatus(), StoreStatus.published);
    });

    test('the real lifecycle values parse', () {
      expect('draft'.toStoreStatus(), StoreStatus.draft);
      expect('pending'.toStoreStatus(), StoreStatus.pending);
      expect('rejected'.toStoreStatus(), StoreStatus.rejected);
      expect('published'.toStoreStatus(), StoreStatus.published);
    });

    test('a store doc with no status field parses as published', () {
      final model = StoreModel.fromJson(const {
        'id': 's1',
        'name': 'Corner Shop',
        'image': '',
        'description': '',
      });
      expect(model.toEntity().status, StoreStatus.published);
    });
  });

  group('filtering', () {
    final stores = [
      _store('live', StoreStatus.published),
      _store('drafted', StoreStatus.draft),
      _store('in-review', StoreStatus.pending),
      _store('sent-back', StoreStatus.rejected),
    ];

    test('all keeps everything', () {
      expect(StoreFilter.all.apply(stores), hasLength(4));
    });

    // Only `published` is live. A store awaiting review or sent back for
    // changes is just as much "not live" as a draft, so neither survives
    // this tab — the mistake would be treating `pending` as nearly-live.
    test('live keeps only published stores', () {
      expect(StoreFilter.live.apply(stores).map((s) => s.id), ['live']);
    });

    test('the tabs render Live first, then All', () {
      expect(StoreFilter.values, [StoreFilter.live, StoreFilter.all]);
    });

    // The rule behind hiding the tabs entirely: for an ordinary shopper the
    // API returns published stores only, so both tabs would show the same
    // list and the control would be dead on arrival.
    test('a shopper-visible list has nothing unpublished to filter', () {
      final published = [_store('a', StoreStatus.published)];
      expect(published.any((s) => s.status.isUnpublished), isFalse);
      expect(stores.any((s) => s.status.isUnpublished), isTrue);
    });
  });
}
