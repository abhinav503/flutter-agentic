import '../../domain/entities/address_entity.dart';
import '../models/address_model.dart';

abstract interface class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();

  /// [address].id is empty — the server assigns the id (and makes the
  /// shopper's first address the default); the returned model carries both.
  Future<AddressModel> createAddress(AddressEntity address);
  Future<AddressModel> updateAddress(AddressEntity address);

  /// Resolves to the addresses remaining after the delete.
  Future<List<AddressModel>> deleteAddress(String addressId);
}
