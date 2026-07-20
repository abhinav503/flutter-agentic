import 'package:flutter_test/flutter_test.dart';

import 'package:gravia/feature/address/domain/entities/address_entity.dart';
import 'package:gravia/feature/address/domain/usecase/create_address_usecase.dart';

import '../../../../helpers/fake_address_repository.dart';

void main() {
  late FakeAddressRepository repository;
  late CreateAddressUseCase useCase;

  const address = AddressEntity(
    id: '',
    name: 'Home',
    phone: '5550100',
    addressLine1: '1 Main St',
    city: 'Mumbai',
    country: 'India',
    postalCode: '400001',
    tag: 'Home',
    isDefault: false,
  );

  setUp(() {
    repository = FakeAddressRepository();
    useCase = CreateAddressUseCase(repository);
  });

  test('passes the address through and returns the repository result',
      () async {
    final result = await useCase(address);

    expect(repository.lastCreated, address);
    expect(result, repository.saveResult);
  });
}
