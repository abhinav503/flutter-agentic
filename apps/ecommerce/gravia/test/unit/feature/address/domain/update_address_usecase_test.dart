import 'package:flutter_test/flutter_test.dart';

import 'package:gravia/feature/address/domain/entities/address_entity.dart';
import 'package:gravia/feature/address/domain/usecase/update_address_usecase.dart';

import '../../../../helpers/fake_address_repository.dart';

void main() {
  late FakeAddressRepository repository;
  late UpdateAddressUseCase useCase;

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
    repository = FakeAddressRepository();
    useCase = UpdateAddressUseCase(repository);
  });

  test('passes the address through and returns the repository result',
      () async {
    final result = await useCase(address);

    expect(repository.lastUpdated, address);
    expect(result, repository.saveResult);
  });
}
