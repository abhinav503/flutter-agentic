import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../../domain/entities/address_entity.dart';
import '../models/address_model.dart';
import 'address_remote_data_source.dart';

/// Backed by the admin API's token-authed `/api/users/addresses` — the same
/// verified-uid surface as the profile, replacing the earlier bundled-JSON
/// mock now that addresses persist per shopper.
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  const AddressRemoteDataSourceImpl();

  Future<Options> _authOptions() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.addressesPath,
      options: await _authOptions(),
    );
    return _parseAddresses(response.data!);
  }

  @override
  Future<AddressModel> createAddress(AddressEntity address) async {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.addressesPath,
      data: _payload(address),
      options: await _authOptions(),
    );
    return _parseAddress(response.data!);
  }

  @override
  Future<AddressModel> updateAddress(AddressEntity address) async {
    final response = await HttpService.instance.put<Map<String, dynamic>>(
      ApiConstants.addressPath(address.id),
      data: _payload(address),
      options: await _authOptions(),
    );
    return _parseAddress(response.data!);
  }

  // Returns the addresses remaining after the delete — the server re-derives
  // the default if the deleted address held it, so the client syncs from
  // this response rather than filtering its own copy of the list.
  @override
  Future<List<AddressModel>> deleteAddress(String addressId) async {
    final response = await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.addressPath(addressId),
      options: await _authOptions(),
    );
    return _parseAddresses(response.data!);
  }

  // The id travels in the URL (update) or is server-assigned (create) —
  // never in the body.
  Map<String, dynamic> _payload(AddressEntity address) =>
      AddressModel.fromEntity(address).toJson()..remove('id');

  AddressModel _parseAddress(Map<String, dynamic> json) =>
      AddressModel.fromJson(json['address'] as Map<String, dynamic>);

  List<AddressModel> _parseAddresses(Map<String, dynamic> json) =>
      (json['addresses'] as List<dynamic>)
          .map((a) => AddressModel.fromJson(a as Map<String, dynamic>))
          .toList();
}
