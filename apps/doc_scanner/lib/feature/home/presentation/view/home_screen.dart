import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:doc_scanner/enums/extraction_status.dart';
import 'package:doc_scanner/services/notification/firebase_messaging_service.dart';
import '../bloc/doc_scanner_bloc.dart';
import '../widgets/doc_scanner_action_bar.dart';
import '../widgets/doc_scanner_empty_state.dart';
import '../widgets/ledger_content.dart';
import '../widgets/receipt_edit_sheet.dart';
import '../widgets/receipt_preview_card.dart';
import '../widgets/total_summary_bar.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // First frame, not main(): guarantees the router is mounted and lets iOS
    // surface the terminated-state launch notification (see add-notification-feature A2).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FCM is mobile-only; skipping it on web keeps the preview from crashing
      // (this is the sole entry point to the Firebase/local-notification stack).
      if (!kIsWeb) FirebaseMessagingService.instance.init();
    });
  }

  // Camera/gallery capture is mobile-only; on the web preview there's no
  // capture pipeline, so surface a snackbar and skip the picker instead of
  // opening a browser file dialog that goes nowhere.
  void _requestImages(BuildContext context, DocScannerEvent event) {
    if (kIsWeb) {
      showSnackBar(ValueConst.docScannerMobileOnly);
      return;
    }
    context.read<DocScannerBloc>().add(event);
  }

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<DocScannerBloc, DocScannerState>(
      listener: (context, state) {
        if (state case DocScannerPdfReady(:final pdfPath)) {
          Share.shareXFiles([XFile(pdfPath)]);
          showSnackBar(ValueConst.docScannerPdfSuccess);
        }
        if (state case DocScannerPdfFailed(:final message)) {
          showSnackBar(message);
        }
        if (state case DocScannerIdle(:final skippedDuplicates)
            when skippedDuplicates > 0) {
          showSnackBar(ValueConst.docScannerDuplicatesSkipped(skippedDuplicates));
        }
        if (state case DocScannerExtracting(:final skippedDuplicates)
            when skippedDuplicates > 0) {
          showSnackBar(ValueConst.docScannerDuplicatesSkipped(skippedDuplicates));
        }
      },
      builder: (context, state) {
        final receipts = switch (state) {
          DocScannerIdle(:final receipts) => receipts,
          DocScannerExtracting(:final receipts) => receipts,
          DocScannerGeneratingPdf(:final receipts) => receipts,
          DocScannerPdfReady(:final receipts) => receipts,
          DocScannerPdfFailed(:final receipts) => receipts,
        };

        final selectedIds = switch (state) {
          DocScannerIdle(:final selectedIds) => selectedIds,
          DocScannerExtracting(:final selectedIds) => selectedIds,
          DocScannerGeneratingPdf(:final selectedIds) => selectedIds,
          DocScannerPdfReady(:final selectedIds) => selectedIds,
          DocScannerPdfFailed(:final selectedIds) => selectedIds,
        };

        final isGenerating = state is DocScannerGeneratingPdf;

        final selectedCount = selectedIds.length;
        final selectedDoneCount = receipts
            .where((r) =>
                selectedIds.contains(r.id) &&
                r.status == ExtractionStatus.done)
            .length;

        return Column(
          children: [
            if (receipts.isNotEmpty)
              TotalSummaryBar(receipts: receipts, selectedIds: selectedIds),
            Expanded(
              child: receipts.isEmpty
                  ? DocScannerEmptyState(
                      onCamera: () => _requestImages(
                          context, const DocScannerEvent.cameraRequested()),
                      onGallery: () => _requestImages(
                          context, const DocScannerEvent.galleryRequested()),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: receipts.length,
                      itemBuilder: (_, i) {
                        final receipt = receipts[i];
                        return ReceiptPreviewCard(
                          key: ValueKey(receipt.id),
                          receipt: receipt,
                          isSelected: selectedIds.contains(receipt.id),
                          onSelectionToggled: () => context
                              .read<DocScannerBloc>()
                              .add(DocScannerEvent.selectionToggled(
                                  id: receipt.id)),
                          onRetry: () => context
                              .read<DocScannerBloc>()
                              .add(DocScannerEvent.extractionRetried(
                                  id: receipt.id)),
                          onRemove: () => context
                              .read<DocScannerBloc>()
                              .add(DocScannerEvent.receiptRemoved(
                                  id: receipt.id)),
                          onEdit: () {
                            final bloc = context.read<DocScannerBloc>();
                            showAppBottomSheet(
                              title: ValueConst.docScannerEditTitle,
                              child: ReceiptEditSheetContent(
                                receipt: receipt,
                                onSave: ({
                                  required restaurantName,
                                  required amount,
                                  required date,
                                }) {
                                  bloc.add(DocScannerEvent.receiptEdited(
                                    id: receipt.id,
                                    restaurantName: restaurantName,
                                    amount: amount,
                                    date: date,
                                  ));
                                  showSnackBar(ValueConst.docScannerEditSaved);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            if (receipts.isNotEmpty)
              DocScannerActionBar(
                isGenerating: isGenerating,
                canGenerate: selectedCount > 0,
                canShowLedger: selectedDoneCount > 0,
                onCamera: () => _requestImages(
                    context, const DocScannerEvent.cameraRequested()),
                onGallery: () => _requestImages(
                    context, const DocScannerEvent.galleryRequested()),
                onGeneratePdf: () => context
                    .read<DocScannerBloc>()
                    .add(const DocScannerEvent.pdfRequested()),
                onShowLedger: () {
                  final selectedDone = receipts
                      .where((r) =>
                          selectedIds.contains(r.id) &&
                          r.status == ExtractionStatus.done)
                      .toList();
                  showAppBottomSheet(
                    title: ValueConst.docScannerLedgerTitle,
                    child: LedgerContent(receipts: selectedDone),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
