import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/image_picker/image_picker_service.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/enums/extraction_status.dart';
import '../../domain/entities/scanned_receipt_entity.dart';
import '../../domain/usecase/delete_receipt_usecase.dart';
import '../../domain/usecase/edit_receipt_usecase.dart';
import '../../domain/usecase/generate_pdf_usecase.dart';
import '../../domain/usecase/load_receipts_usecase.dart';
import '../../domain/usecase/resolve_image_usecase.dart';
import '../../domain/usecase/save_receipt_usecase.dart';
import '../../domain/usecase/scan_receipt_usecase.dart';
import 'model_selector_cubit.dart';

part 'doc_scanner_bloc.freezed.dart';
part 'doc_scanner_event.dart';
part 'doc_scanner_state.dart';

class DocScannerBloc extends Bloc<DocScannerEvent, DocScannerState> {
  final ResolveImageUseCase _resolveImage;
  final ScanReceiptUseCase _scanReceipt;
  final GeneratePdfUseCase _generatePdf;
  final LoadReceiptsUseCase _loadReceipts;
  final SaveReceiptUseCase _saveReceipt;
  final EditReceiptUseCase _editReceipt;
  final DeleteReceiptUseCase _deleteReceipt;
  final ModelSelectorCubit _modelSelector;

  DocScannerBloc({
    required ResolveImageUseCase resolveImageUseCase,
    required ScanReceiptUseCase scanReceiptUseCase,
    required GeneratePdfUseCase generatePdfUseCase,
    required LoadReceiptsUseCase loadReceiptsUseCase,
    required SaveReceiptUseCase saveReceiptUseCase,
    required EditReceiptUseCase editReceiptUseCase,
    required DeleteReceiptUseCase deleteReceiptUseCase,
    required ModelSelectorCubit modelSelectorCubit,
  })  : _resolveImage = resolveImageUseCase,
        _scanReceipt = scanReceiptUseCase,
        _generatePdf = generatePdfUseCase,
        _loadReceipts = loadReceiptsUseCase,
        _saveReceipt = saveReceiptUseCase,
        _editReceipt = editReceiptUseCase,
        _deleteReceipt = deleteReceiptUseCase,
        _modelSelector = modelSelectorCubit,
        super(const DocScannerState.idle()) {
    on<DocScannerStarted>(_onStarted);
    on<DocScannerCameraRequested>(_onCameraRequested);
    on<DocScannerGalleryRequested>(_onGalleryRequested);
    on<DocScannerReceiptRemoved>(_onReceiptRemoved);
    on<DocScannerSelectionToggled>(_onSelectionToggled);
    on<DocScannerExtractionRetried>(_onExtractionRetried);
    on<DocScannerPdfRequested>(_onPdfRequested);
    on<DocScannerReceiptEdited>(_onReceiptEdited);
  }

  // ── State accessors ──────────────────────────────────────────────────────────

  List<ScannedReceiptEntity> get _currentReceipts => switch (state) {
        DocScannerIdle(:final receipts) => receipts,
        DocScannerExtracting(:final receipts) => receipts,
        DocScannerGeneratingPdf(:final receipts) => receipts,
        DocScannerPdfReady(:final receipts) => receipts,
        DocScannerPdfFailed(:final receipts) => receipts,
      };

  Set<String> get _currentSelectedIds => switch (state) {
        DocScannerIdle(:final selectedIds) => selectedIds,
        DocScannerExtracting(:final selectedIds) => selectedIds,
        DocScannerGeneratingPdf(:final selectedIds) => selectedIds,
        DocScannerPdfReady(:final selectedIds) => selectedIds,
        DocScannerPdfFailed(:final selectedIds) => selectedIds,
      };

  // Returns a new state of the same variant with updated selectedIds, preserving
  // all other fields — used by selection toggle to avoid promoting to idle.
  DocScannerState _withSelectedIds(Set<String> ids) => switch (state) {
        // skippedDuplicates intentionally resets to 0 — selection toggle is not a pick event.
        DocScannerIdle(:final receipts) =>
          DocScannerState.idle(receipts: receipts, selectedIds: ids),
        DocScannerExtracting(:final receipts) =>
          DocScannerState.extracting(receipts: receipts, selectedIds: ids),
        DocScannerGeneratingPdf(:final receipts) =>
          DocScannerState.generatingPdf(receipts: receipts, selectedIds: ids),
        // Transition back to idle — PDF flow is complete; re-emitting pdfReady
        // would re-trigger the share sheet listener on every selection toggle.
        DocScannerPdfReady(:final receipts) =>
          DocScannerState.idle(receipts: receipts, selectedIds: ids),
        DocScannerPdfFailed(:final receipts) =>
          DocScannerState.idle(receipts: receipts, selectedIds: ids),
      };

  // ── Event handlers ───────────────────────────────────────────────────────────

  Future<void> _onStarted(
    DocScannerStarted _,
    Emitter<DocScannerState> emit,
  ) async {
    final result = await _loadReceipts(const NoParams());
    result.fold(
      (_) {},
      (receipts) {
        if (receipts.isNotEmpty) {
          // Loaded receipts start unselected — user picks which to include.
          emit(DocScannerState.idle(receipts: _sortReceipts(receipts)));
        }
      },
    );
  }

  Future<void> _onCameraRequested(
    DocScannerCameraRequested _,
    Emitter<DocScannerState> emit,
  ) async {
    final images = await ImagePickerService.instance.fromCamera();
    if (images.isEmpty) return;
    await _processPickedImages(images, emit);
  }

  Future<void> _onGalleryRequested(
    DocScannerGalleryRequested _,
    Emitter<DocScannerState> emit,
  ) async {
    final images = await ImagePickerService.instance.fromGallery();
    if (images.isEmpty) return;
    await _processPickedImages(images, emit);
  }

  Future<void> _processPickedImages(
    List<XFile> images,
    Emitter<DocScannerState> emit,
  ) async {
    final existingIds = _currentReceipts.map((r) => r.id).toSet();
    final newReceipts = <ScannedReceiptEntity>[];
    var skippedDuplicates = 0;

    for (final img in images) {
      final result =
          await _resolveImage(ResolveImageParams(tempPath: img.path));
      result.fold(
        (_) {}, // skip images that can't be resolved (e.g. file read error)
        (resolved) {
          if (existingIds.contains(resolved.id)) {
            skippedDuplicates++;
            return;
          }
          existingIds.add(resolved.id);
          newReceipts.add(ScannedReceiptEntity(
            id: resolved.id,
            imagePath: resolved.imagePath,
            status: ExtractionStatus.pending,
          ));
        },
      );
    }

    // All picks were duplicates — emit idle with count so the listener can notify.
    if (newReceipts.isEmpty) {
      if (skippedDuplicates > 0) {
        emit(DocScannerState.idle(
          receipts: _currentReceipts,
          selectedIds: _currentSelectedIds,
          skippedDuplicates: skippedDuplicates,
        ));
      }
      return;
    }

    // Persist each new image immediately so it survives an app restart.
    for (final r in newReceipts) {
      await _saveReceipt(SaveReceiptParams(receipt: r));
    }

    // Auto-select newly picked images; keep existing selections.
    // Extraction is NOT triggered automatically — user taps Extract Data on each card.
    final newIds = newReceipts.map((r) => r.id).toSet();
    emit(DocScannerState.idle(
      receipts: _sortReceipts([..._currentReceipts, ...newReceipts]),
      selectedIds: {..._currentSelectedIds, ...newIds},
      skippedDuplicates: skippedDuplicates,
    ));
  }

  Future<void> _extractSingle(
    ScannedReceiptEntity receipt,
    Emitter<DocScannerState> emit,
  ) async {
    final processing = receipt.copyWith(status: ExtractionStatus.processing);
    emit(DocScannerState.extracting(
      receipts: _replaceInList(_currentReceipts, processing),
      selectedIds: _currentSelectedIds,
    ));

    final model = _modelSelector.state.selectedModel;
    final apiKey = _modelSelector.state.apiKeyFor(model) ?? '';

    final result = await _scanReceipt(
      ScanReceiptParams(receipt: processing, model: model, apiKey: apiKey),
    );

    final updated = result.fold(
      (failure) => processing.copyWith(
        status: ExtractionStatus.failed,
        errorMessage: switch (failure) {
          ServerFailure(:final statusCode)
              when statusCode == 401 || statusCode == 403 =>
            ValueConst.docScannerApiKeyInvalid,
          _ => failure.message,
        },
      ),
      (entity) => entity,
    );

    // Persist failed state so it's visible on next launch.
    if (updated.status == ExtractionStatus.failed) {
      await _saveReceipt(SaveReceiptParams(receipt: updated));
    }

    final afterExtraction = _sortReceipts(_replaceInList(_currentReceipts, updated));
    final stillBusy = afterExtraction.any(
      (r) =>
          r.status == ExtractionStatus.pending ||
          r.status == ExtractionStatus.processing,
    );

    emit(
      stillBusy
          ? DocScannerState.extracting(
              receipts: afterExtraction,
              selectedIds: _currentSelectedIds,
            )
          : DocScannerState.idle(
              receipts: afterExtraction,
              selectedIds: _currentSelectedIds,
            ),
    );
  }

  void _onSelectionToggled(
    DocScannerSelectionToggled event,
    Emitter<DocScannerState> emit,
  ) {
    final ids = Set<String>.from(_currentSelectedIds);
    if (ids.contains(event.id)) {
      ids.remove(event.id);
    } else {
      ids.add(event.id);
    }
    emit(_withSelectedIds(ids));
  }

  Future<void> _onExtractionRetried(
    DocScannerExtractionRetried event,
    Emitter<DocScannerState> emit,
  ) async {
    final matching = _currentReceipts.where((r) => r.id == event.id);
    if (matching.isEmpty) return;
    await _extractSingle(matching.first, emit);
  }

  Future<void> _onReceiptRemoved(
    DocScannerReceiptRemoved event,
    Emitter<DocScannerState> emit,
  ) async {
    final removing =
        _currentReceipts.where((r) => r.id == event.id).firstOrNull;
    final updatedReceipts =
        _currentReceipts.where((r) => r.id != event.id).toList();
    final updatedIds = Set<String>.from(_currentSelectedIds)..remove(event.id);
    emit(DocScannerState.idle(
        receipts: _sortReceipts(updatedReceipts), selectedIds: updatedIds));
    if (removing != null) {
      await _deleteReceipt(DeleteReceiptParams(imagePath: removing.imagePath));
    }
  }

  Future<void> _onPdfRequested(
    DocScannerPdfRequested _,
    Emitter<DocScannerState> emit,
  ) async {
    // Include all selected images — image path is valid even if extraction failed.
    final selected = _currentReceipts
        .where((r) => _currentSelectedIds.contains(r.id))
        .toList();
    if (selected.isEmpty) return;

    final receipts = _currentReceipts;
    final selectedIds = _currentSelectedIds;
    emit(DocScannerState.generatingPdf(
        receipts: receipts, selectedIds: selectedIds));

    final result = await _generatePdf(GeneratePdfParams(receipts: selected));

    result.fold(
      (failure) => emit(DocScannerState.pdfFailed(
          receipts: receipts, message: failure.message, selectedIds: selectedIds)),
      (path) => emit(DocScannerState.pdfReady(
          receipts: receipts, pdfPath: path, selectedIds: selectedIds)),
    );
  }

  Future<void> _onReceiptEdited(
    DocScannerReceiptEdited event,
    Emitter<DocScannerState> emit,
  ) async {
    final original =
        _currentReceipts.where((r) => r.id == event.id).firstOrNull;
    if (original == null) return;

    final result = await _editReceipt(EditReceiptParams(
      original: original,
      restaurantName: event.restaurantName,
      amount: event.amount,
      date: event.date,
    ));

    result.fold(
      (_) {},
      (updated) => emit(DocScannerState.idle(
        receipts: _sortReceipts(_replaceInList(_currentReceipts, updated)),
        selectedIds: _currentSelectedIds,
      )),
    );
  }

  // Non-done items first (insertion order preserved), then done items sorted by
  // date descending. Null dates sort last within the done group.
  List<ScannedReceiptEntity> _sortReceipts(List<ScannedReceiptEntity> receipts) {
    final pending = receipts.where((r) => r.status != ExtractionStatus.done).toList();
    final done = receipts.where((r) => r.status == ExtractionStatus.done).toList()
      ..sort((a, b) {
        if (a.date == null && b.date == null) return 0;
        if (a.date == null) return 1;
        if (b.date == null) return -1;
        return b.date!.compareTo(a.date!);
      });
    return [...pending, ...done];
  }

  List<ScannedReceiptEntity> _replaceInList(
    List<ScannedReceiptEntity> list,
    ScannedReceiptEntity updated,
  ) =>
      list.map((r) => r.id == updated.id ? updated : r).toList();
}
