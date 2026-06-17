import 'package:flutter/material.dart';

import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/constants/core_const.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/badge.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/atoms/file_thumbnail.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:doc_scanner/enums/extraction_status.dart';
import '../../domain/entities/scanned_receipt_entity.dart';

class ReceiptPreviewCard extends StatelessWidget {
  final ScannedReceiptEntity receipt;
  final bool isSelected;
  final VoidCallback onSelectionToggled;
  final VoidCallback onRemove;
  final VoidCallback onRetry;
  final VoidCallback onEdit;

  const ReceiptPreviewCard({
    super.key,
    required this.receipt,
    required this.isSelected,
    required this.onSelectionToggled,
    required this.onRemove,
    required this.onRetry,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onSelectionToggled,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: AppSpacing.base),
        decoration: BoxDecoration(
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? cs.primary.withValues(alpha: 0.04)
              : cs.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(value: isSelected),
              const SizedBox(width: AppSpacing.sm),
              AppFileThumbnail(path: receipt.imagePath),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _StatusBadge(status: receipt.status),
                        const Spacer(),
                        GestureDetector(
                          onTap: onEdit,
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        GestureDetector(
                          onTap: onRemove,
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (receipt.status == ExtractionStatus.pending)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            label: ValueConst.docScannerExtractButton,
                            variant: AppButtonVariant.text,
                            size: AppButtonSize.small,
                            onTap: onRetry,
                          ),
                        ],
                      )
                    else if (receipt.status == ExtractionStatus.processing)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: LoadingIndicator(size: 20),
                      )
                    else if (receipt.status == ExtractionStatus.done) ...[
                      if (receipt.restaurantName != null)
                        Text(
                          receipt.restaurantName!,
                          style: tt.bodyMedium!.copyWith(color: cs.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (receipt.date != null)
                        Text(
                          receipt.date!,
                          style:
                              tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
                        ),
                      if (receipt.amount != null)
                        Text(
                          receipt.formattedAmount,
                          style: tt.titleSmall!.copyWith(color: cs.primary),
                        ),
                    ] else if (receipt.status == ExtractionStatus.failed) ...[
                      Text(
                        receipt.errorMessage ?? ValueConst.docScannerExtractFailed,
                        style: tt.bodySmall!.copyWith(color: cs.error),
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppSpacing.xs3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            label: CoreConst.retryButton,
                            variant: AppButtonVariant.text,
                            size: AppButtonSize.small,
                            onTap: onRetry,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _StatusBadge extends StatelessWidget {
  final ExtractionStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ExtractionStatus.pending => const AppBadge(
          text: ValueConst.docScannerStatusPending,
          intent: AppBadgeIntent.neutral,
          size: AppBadgeSize.small,
        ),
      ExtractionStatus.processing => const AppBadge(
          text: ValueConst.docScannerStatusReading,
          intent: AppBadgeIntent.info,
          size: AppBadgeSize.small,
        ),
      ExtractionStatus.done => const AppBadge(
          text: ValueConst.docScannerStatusDone,
          intent: AppBadgeIntent.success,
          size: AppBadgeSize.small,
        ),
      ExtractionStatus.failed => const AppBadge(
          text: ValueConst.docScannerStatusFailed,
          intent: AppBadgeIntent.error,
          size: AppBadgeSize.small,
        ),
    };
  }
}
