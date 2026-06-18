import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:core/core/base/base_repository.dart';
import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:doc_scanner/enums/extraction_status.dart';
import '../../domain/entities/ai_scan_model.dart';
import '../../domain/entities/scanned_receipt_entity.dart';
import '../../domain/repository/receipt_scan_repository.dart';
import '../data_source/doc_scanner_local_data_source.dart';
import '../data_source/doc_scanner_remote_data_source.dart';
import '../models/receipt_extraction_model.dart';
import '../models/scanned_receipt_model.dart';

class ReceiptScanRepositoryImpl
    with BaseRepository
    implements ReceiptScanRepository {
  final DocScannerRemoteDataSource _remote;
  final DocScannerLocalDataSource _local;

  const ReceiptScanRepositoryImpl(this._remote, this._local);

  // ── Image resolution ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, ({String id, String imagePath})>> resolveImage({
    required String tempPath,
  }) async {
    try {
      final bytes = await File(tempPath).readAsBytes();
      final hash = md5.convert(bytes).toString();

      final docsDir = await getApplicationDocumentsDirectory();
      final receiptsDir = Directory('${docsDir.path}/receipts');
      if (!receiptsDir.existsSync()) receiptsDir.createSync(recursive: true);

      final ext = tempPath.split('.').last.toLowerCase();
      final permanentPath = '${receiptsDir.path}/$hash.$ext';

      if (!File(permanentPath).existsSync()) {
        await File(tempPath).copy(permanentPath);
      }

      return right((id: hash, imagePath: permanentPath));
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  // ── Cache helpers ────────────────────────────────────────────────────────────

  Future<ScannedReceiptEntity?> _getCached(String id) async {
    final all = await _local.loadAll();
    final docsPath = await _documentsPath();
    for (final m in all) {
      if (m.id == id && m.status == ExtractionStatus.done) {
        return _fromModel(m, docsPath);
      }
    }
    return null;
  }

  Future<void> _saveToCache(ScannedReceiptEntity entity) async {
    await _local.save(_toModel(entity));
  }

  // ── Repository methods ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, ScannedReceiptEntity>> scanReceipt({
    required ScannedReceiptEntity receipt,
    required AiScanModel model,
    required String apiKey,
  }) =>
      handleRequest(() async {
        final cached = await _getCached(receipt.id);
        if (cached != null) {
          debugPrint('[Cache] hit: ${receipt.imagePath}');
          return right(cached);
        }

        final bytes = await File(receipt.imagePath).readAsBytes();
        final base64Image = base64Encode(bytes);
        final ext = receipt.imagePath.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

        final extraction = await _remote.extractReceiptData(
          base64Image: base64Image,
          mimeType: mimeType,
          modelId: model.modelId,
          apiKey: apiKey,
        );

        final updated = _toEntity(receipt, extraction);

        await _saveToCache(updated);
        return right(updated);
      });

  @override
  Future<Either<Failure, List<ScannedReceiptEntity>>> loadReceipts() async {
    try {
      final all = await _local.loadAll();
      final docsPath = await _documentsPath();
      return right(all.map((m) => _fromModel(m, docsPath)).toList());
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveReceipt({
    required ScannedReceiptEntity receipt,
  }) async {
    try {
      await _local.save(_toModel(receipt));
      return right(unit);
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteReceipt({
    required String id,
  }) async {
    try {
      await _deleteImageFile(id);
      await _local.deleteById(id);
      return right(unit);
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  /// Best-effort removal of the copied image file backing [id]. Files are
  /// content-addressed (named by the same MD5 hash as the id), so no other
  /// record can reference this file — deleting it is safe. Failures here never
  /// block record deletion: a leftover file is harmless, a stuck record is not.
  Future<void> _deleteImageFile(String id) async {
    try {
      final all = await _local.loadAll();
      final matches = all.where((m) => m.id == id);
      if (matches.isEmpty) return;
      final docsPath = await _documentsPath();
      final file = File(_toAbsolutePath(matches.first.imagePath, docsPath));
      if (file.existsSync()) await file.delete();
    } catch (_) {
      // Ignore — orphaned file cleanup is non-critical.
    }
  }

  // ── PDF generation ───────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> generatePdf({
    required List<ScannedReceiptEntity> receipts,
  }) async {
    try {
      final doc = pw.Document();

      for (final receipt in receipts) {
        final file = File(receipt.imagePath);
        if (!file.existsSync()) continue;

        final pdfImage = pw.MemoryImage(await file.readAsBytes());

        doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Image(pdfImage, fit: pw.BoxFit.contain),
        ));
      }

      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/receipts_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await File(path).writeAsBytes(await doc.save());

      return right(path);
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  // ── Model selection ──────────────────────────────────────────────────────────

  @override
  Future<AiScanModel> getSelectedModel() async {
    final saved = SharedPreferenceService.instance
        .getString(ValueConst.docScannerSelectedModelKey);
    return AiScanModel.all.firstWhere(
      (m) => m.id == saved,
      orElse: () => AiScanModel.defaultModel,
    );
  }

  @override
  Future<void> selectModel({required AiScanModel model}) =>
      SharedPreferenceService.instance
          .setString(ValueConst.docScannerSelectedModelKey, model.id);

  @override
  Future<Map<String, String>> getApiKeys() async {
    final keys = <String, String>{};
    for (final model in AiScanModel.all) {
      final key = SharedPreferenceService.instance
          .getString('${ValueConst.docScannerApiKeyPrefix}${model.id}');
      if (key != null && key.isNotEmpty) keys[model.id] = key;
    }
    return keys;
  }

  @override
  Future<void> saveApiKey({
    required AiScanModel model,
    required String apiKey,
  }) {
    final trimmed = apiKey.trim();
    final prefKey = '${ValueConst.docScannerApiKeyPrefix}${model.id}';
    if (trimmed.isEmpty) {
      return SharedPreferenceService.instance.remove(prefKey);
    }
    return SharedPreferenceService.instance.setString(prefKey, trimmed);
  }

  // ── Image path persistence ───────────────────────────────────────────────────
  //
  // The OS may relocate the app's documents directory between launches (on iOS
  // the container UUID changes on every reinstall), so an absolute path saved in
  // one run is invalid in the next. We persist only the path *relative* to the
  // documents directory and re-anchor it to the current absolute path on load.
  // Resolution is by file name, so legacy absolute paths from older builds also
  // migrate transparently (the file always lives in <docs>/receipts/<name>).

  Future<String> _documentsPath() async =>
      (await getApplicationDocumentsDirectory()).path;

  static String _toStoredPath(String absolutePath) =>
      'receipts/${absolutePath.split('/').last}';

  static String _toAbsolutePath(String storedPath, String docsPath) =>
      '$docsPath/receipts/${storedPath.split('/').last}';

  // ── Model ↔ Entity conversion ────────────────────────────────────────────────

  ScannedReceiptModel _toModel(ScannedReceiptEntity e) =>
      ScannedReceiptModel.fromEntity(e)
          .copyWith(imagePath: _toStoredPath(e.imagePath));

  ScannedReceiptEntity _fromModel(ScannedReceiptModel m, String docsPath) {
    final entity = m
        .toEntity()
        .copyWith(imagePath: _toAbsolutePath(m.imagePath, docsPath));
    // Never resume mid-processing state after an app restart.
    if (entity.status == ExtractionStatus.processing) {
      return entity.copyWith(status: ExtractionStatus.pending);
    }
    return entity;
  }

  ScannedReceiptEntity _toEntity(
    ScannedReceiptEntity receipt,
    ReceiptExtractionModel? extraction,
  ) {
    final extracted = extraction?.toEntity();
    final date = extracted?.date;

    // Reject partial dates: all three parts (year, month, day) must be present.
    // The prompt instructs the AI to return null for incomplete dates, but this
    // catches any non-compliance before it reaches the entity.
    if (date != null && !_isFullDate(date)) {
      return ScannedReceiptEntity(
        id: receipt.id,
        imagePath: receipt.imagePath,
        status: ExtractionStatus.failed,
        errorMessage: ValueConst.docScannerDateIncomplete,
      );
    }

    return ScannedReceiptEntity(
      id: receipt.id,
      imagePath: receipt.imagePath,
      restaurantName: extracted?.restaurantName,
      date: date,
      amount: extracted?.amount,
      currency: extracted?.currency,
      status: ExtractionStatus.done,
    );
  }

  static final _fullDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  static bool _isFullDate(String date) => _fullDatePattern.hasMatch(date);
}
