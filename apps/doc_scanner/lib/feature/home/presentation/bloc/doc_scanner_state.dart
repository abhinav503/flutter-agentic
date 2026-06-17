part of 'doc_scanner_bloc.dart';

@freezed
sealed class DocScannerState with _$DocScannerState {
  const factory DocScannerState.idle({
    @Default([]) List<ScannedReceiptEntity> receipts,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(0) int skippedDuplicates,
  }) = DocScannerIdle;

  const factory DocScannerState.extracting({
    required List<ScannedReceiptEntity> receipts,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(0) int skippedDuplicates,
  }) = DocScannerExtracting;

  const factory DocScannerState.generatingPdf({
    required List<ScannedReceiptEntity> receipts,
    @Default(<String>{}) Set<String> selectedIds,
  }) = DocScannerGeneratingPdf;

  const factory DocScannerState.pdfReady({
    required List<ScannedReceiptEntity> receipts,
    required String pdfPath,
    @Default(<String>{}) Set<String> selectedIds,
  }) = DocScannerPdfReady;

  const factory DocScannerState.pdfFailed({
    required List<ScannedReceiptEntity> receipts,
    required String message,
    @Default(<String>{}) Set<String> selectedIds,
  }) = DocScannerPdfFailed;
}
