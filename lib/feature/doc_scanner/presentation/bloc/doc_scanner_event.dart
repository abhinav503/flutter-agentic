part of 'doc_scanner_bloc.dart';

@freezed
sealed class DocScannerEvent with _$DocScannerEvent {
  const factory DocScannerEvent.started() = DocScannerStarted;
  const factory DocScannerEvent.cameraRequested() = DocScannerCameraRequested;
  const factory DocScannerEvent.galleryRequested() = DocScannerGalleryRequested;
  const factory DocScannerEvent.receiptRemoved({required String id}) =
      DocScannerReceiptRemoved;
  const factory DocScannerEvent.extractionRetried({required String id}) =
      DocScannerExtractionRetried;
  const factory DocScannerEvent.selectionToggled({required String id}) =
      DocScannerSelectionToggled;
  const factory DocScannerEvent.pdfRequested() = DocScannerPdfRequested;
  const factory DocScannerEvent.receiptEdited({
    required String id,
    required String? restaurantName,
    required double? amount,
    required String? date,
  }) = DocScannerReceiptEdited;
}
