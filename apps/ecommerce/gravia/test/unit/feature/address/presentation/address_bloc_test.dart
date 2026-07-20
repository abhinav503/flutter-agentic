import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/core/error/failure.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:gravia/feature/address/domain/entities/address_entity.dart';
import 'package:gravia/feature/address/domain/usecase/create_address_usecase.dart';
import 'package:gravia/feature/address/domain/usecase/get_addresses_usecase.dart';
import 'package:gravia/feature/address/domain/usecase/update_address_usecase.dart';
import 'package:gravia/feature/address/presentation/bloc/address_bloc.dart';

import '../../../../helpers/fake_address_repository.dart';

void main() {
  late FakeAddressRepository repository;

  AddressEntity address(String id, {String name = 'Home', bool isDefault = false}) =>
      AddressEntity(
        id: id,
        name: name,
        phone: '5550100',
        addressLine1: '1 Main St',
        city: 'Mumbai',
        country: 'India',
        postalCode: '400001',
        tag: 'Home',
        isDefault: isDefault,
      );

  AddressBloc buildBloc() => AddressBloc(
    getAddressesUseCase: GetAddressesUseCase(repository),
    createAddressUseCase: CreateAddressUseCase(repository),
    updateAddressUseCase: UpdateAddressUseCase(repository),
  );

  setUp(() async {
    AddressBloc.resetCache();
    // The bloc reads the last-selected address id from prefs on started.
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    repository = FakeAddressRepository();
  });

  test('a second bloc warm-starts loaded from the cache', () async {
    repository.result = right([address('a1', isDefault: true)]);
    final first = buildBloc()..add(const AddressEvent.started());
    await Future<void>.delayed(Duration.zero);
    await first.close();

    final second = buildBloc();
    final state = second.state as AddressLoaded;
    expect(state.addresses.map((a) => a.id), ['a1']);
    expect(state.selectedAddressId, 'a1');
    await second.close();
  });

  blocTest<AddressBloc, AddressState>(
    'started selects the default address',
    setUp: () => repository.result = right([
      address('a1'),
      address('a2', isDefault: true),
    ]),
    build: buildBloc,
    act: (bloc) => bloc.add(const AddressEvent.started()),
    verify: (bloc) {
      final state = bloc.state as AddressLoaded;
      expect(state.selectedAddressId, 'a2');
    },
  );

  blocTest<AddressBloc, AddressState>(
    'started with no addresses loads an empty list',
    build: buildBloc,
    act: (bloc) => bloc.add(const AddressEvent.started()),
    expect: () => [
      const AddressState.loaded(addresses: [], selectedAddressId: ''),
    ],
  );

  blocTest<AddressBloc, AddressState>(
    'saving a new address (empty id) creates it and selects the server id',
    setUp: () {
      repository
        ..result = right([address('a1', isDefault: true)])
        ..saveResult = right(address('srv_9', name: 'Office'));
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const AddressEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(AddressEvent.saved(address: address('', name: 'Office')));
    },
    verify: (bloc) {
      final state = bloc.state as AddressLoaded;
      expect(repository.lastCreated!.id, isEmpty);
      expect(state.addresses.map((a) => a.id), ['a1', 'srv_9']);
      expect(state.selectedAddressId, 'srv_9');
    },
  );

  blocTest<AddressBloc, AddressState>(
    'saving an existing address updates it in place',
    setUp: () {
      repository
        ..result = right([address('a1', isDefault: true), address('a2')])
        ..saveResult = right(address('a2', name: 'Renamed'));
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const AddressEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(AddressEvent.saved(address: address('a2', name: 'Renamed')));
    },
    verify: (bloc) {
      final state = bloc.state as AddressLoaded;
      expect(repository.lastUpdated!.id, 'a2');
      expect(state.addresses.map((a) => a.name), ['Home', 'Renamed']);
      expect(state.addresses.length, 2);
    },
  );

  blocTest<AddressBloc, AddressState>(
    'a failed save keeps the list and raises saveFailed',
    setUp: () {
      repository
        ..result = right([address('a1', isDefault: true)])
        ..saveResult = left(const Failure.unexpected(message: 'boom'));
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const AddressEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(AddressEvent.saved(address: address('', name: 'Office')));
    },
    verify: (bloc) {
      final state = bloc.state as AddressLoaded;
      expect(state.saveFailed, isTrue);
      expect(state.addresses.map((a) => a.id), ['a1']);
    },
  );
}
