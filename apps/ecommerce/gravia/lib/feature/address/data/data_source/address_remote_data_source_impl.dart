import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/address_model.dart';
import 'address_remote_data_source.dart';

/// Backed by a bundled JSON asset — same pattern as the other mocked data
/// sources in this app (a flat array, no paging needed for a handful of
/// saved addresses).
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  const AddressRemoteDataSourceImpl();

  @override
  Future<List<AddressModel>> getAddresses() async {
    final raw = await rootBundle.loadString('assets/data/addresses.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
