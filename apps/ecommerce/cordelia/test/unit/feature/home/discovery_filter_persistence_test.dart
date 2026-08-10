import 'package:bloc_test/bloc_test.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cordelia/enums/store_filter.dart';
import 'package:cordelia/enums/store_status.dart';
import 'package:cordelia/feature/home/domain/entities/store_entity.dart';
import 'package:cordelia/feature/home/domain/repository/stores_repository.dart';
import 'package:cordelia/feature/home/domain/usecase/get_stores_usecase.dart';
import 'package:cordelia/feature/home/presentation/bloc/discovery_bloc.dart';
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

final _stores = [
  _store('live-one', StoreStatus.published),
  _store('my-draft', StoreStatus.draft),
];

class _FakeStoresRepository implements StoresRepository {
  @override
  Future<Either<Failure, List<StoreEntity>>> getStores({String? query}) async =>
      right(_stores);

  @override
  Future<Either<Failure, StoreEntity>> getStore({required String storeId}) =>
      throw UnimplementedError();
}

/// The shopper's chosen tab has to survive everything that re-emits the
/// loaded state. It did not: `storeOpened` rebuilt `DiscoveryState.loaded`
/// field-by-field and simply omitted `filter`, so it fell back to the
/// default — meaning tapping a store while viewing "All" silently switched
/// the list to "Live", and coming back from that store showed a different
/// set of stores than the one just left.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
  });

  DiscoveryBloc build() => DiscoveryBloc(
    getStoresUseCase: GetStoresUseCase(_FakeStoresRepository()),
  );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'opening a store keeps the chosen tab',
    build: build,
    act: (bloc) async {
      bloc.add(const DiscoveryEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DiscoveryEvent.filterChanged(filter: StoreFilter.all));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DiscoveryEvent.storeOpened(storeId: 'my-draft'));
    },
    verify: (bloc) {
      final state = bloc.state as DiscoveryLoaded;
      expect(state.filter, StoreFilter.all);
      // And the visit was still recorded — the fix must not cost the recents.
      expect(state.recentStores.map((s) => s.id), ['my-draft']);
    },
  );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'searching and clearing keeps the chosen tab',
    build: build,
    act: (bloc) async {
      bloc.add(const DiscoveryEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DiscoveryEvent.filterChanged(filter: StoreFilter.all));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DiscoveryEvent.queryChanged(query: 'dr'));
      await Future<void>.delayed(const Duration(milliseconds: 400));
      bloc.add(const DiscoveryEvent.queryChanged(query: ''));
      await Future<void>.delayed(const Duration(milliseconds: 400));
    },
    verify: (bloc) =>
        expect((bloc.state as DiscoveryLoaded).filter, StoreFilter.all),
  );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'a cold load opens on Live',
    build: build,
    act: (bloc) => bloc.add(const DiscoveryEvent.started()),
    verify: (bloc) =>
        expect((bloc.state as DiscoveryLoaded).filter, StoreFilter.live),
  );
}
