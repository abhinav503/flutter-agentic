import '../models/address_model.dart';

abstract interface class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
}
