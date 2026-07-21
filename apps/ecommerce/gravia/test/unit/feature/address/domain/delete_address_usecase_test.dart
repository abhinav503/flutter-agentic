import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/feature/address/domain/entities/address_entity.dart';
import 'package:gravia/feature/address/domain/usecase/delete_address_usecase.dart';

import '../../../../helpers/fake_address_repository.dart';

void main() {
  late FakeAddressRepository repository;
  late DeleteAddressUseCase useCase;

  const address = AddressEntity(
    id: 'a1',
    name: 'Home',
    phone: '5550100',
    addressLine1: '1 Main St',
    city: 'Mumbai',
    country: 'India',
    postalCode: '400001',
    tag: 'Home',
    isDefault: true,
  );

  setUp(() {
    repository = FakeAddressRepository()..result = right([address]);
    useCase = DeleteAddressUseCase(repository);
  });

  test('passes the address id through and returns the remaining list',
      () async {
    final result = await useCase('a1');

    expect(repository.lastDeletedId, 'a1');
    result.fold(
      (failure) => fail('expected success, got $failure'),
      (addresses) => expect(addresses, isEmpty),
    );
  });
}
