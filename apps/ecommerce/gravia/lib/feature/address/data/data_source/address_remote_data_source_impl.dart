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
    final list = response.data!['addresses'] as List<dynamic>;
    return list
        .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
        .toList();
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

  // The id travels in the URL (update) or is server-assigned (create) —
  // never in the body.
  Map<String, dynamic> _payload(AddressEntity address) =>
      AddressModel.fromEntity(address).toJson()..remove('id');

  AddressModel _parseAddress(Map<String, dynamic> json) =>
      AddressModel.fromJson(json['address'] as Map<String, dynamic>);
}
