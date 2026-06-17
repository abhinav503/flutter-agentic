import 'dart:convert';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import '../models/scanned_receipt_model.dart';
import 'doc_scanner_local_data_source.dart';

class DocScannerLocalDataSourceImpl implements DocScannerLocalDataSource {
  static const _key = 'doc_scanner_receipts';

  const DocScannerLocalDataSourceImpl();

  @override
  Future<List<ScannedReceiptModel>> loadAll() async {
    final json = SharedPreferenceService.instance.getString(_key);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => ScannedReceiptModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(ScannedReceiptModel receipt) async {
    final all = await loadAll();
    final idx = all.indexWhere((r) => r.imagePath == receipt.imagePath);
    final updated =
        idx >= 0 ? ([...all]..[idx] = receipt) : [...all, receipt];
    await SharedPreferenceService.instance.setString(
      _key,
      jsonEncode(updated.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteByImagePath(String imagePath) async {
    final all = await loadAll();
    final filtered = all.where((r) => r.imagePath != imagePath).toList();
    await SharedPreferenceService.instance.setString(
      _key,
      jsonEncode(filtered.map((r) => r.toJson()).toList()),
    );
  }
}
