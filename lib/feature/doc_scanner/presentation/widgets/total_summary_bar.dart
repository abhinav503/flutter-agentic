import 'package:flutter/material.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/enums/extraction_status.dart';
import '../../domain/entities/scanned_receipt_entity.dart';

class TotalSummaryBar extends StatelessWidget {
  final List<ScannedReceiptEntity> receipts;
  final Set<String> selectedIds;

  const TotalSummaryBar({
    super.key,
    required this.receipts,
    required this.selectedIds,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Only count selected+done receipts for the running total
    final selectedDone = receipts.where(
      (r) => selectedIds.contains(r.id) && r.status == ExtractionStatus.done,
    );

    final totals = <String, double>{};
    for (final r in selectedDone) {
      if (r.amount == null) continue;
      final key = r.currency ?? '';
      totals[key] = (totals[key] ?? 0) + r.amount!;
    }

    final selectedCount = selectedIds.length;

    return Container(
      width: double.infinity,
      color: cs.primaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ValueConst.docScannerReceiptCount(receipts.length),
            style: tt.bodyMedium!.copyWith(color: cs.onPrimaryContainer),
          ),
          Row(
            children: [
              if (selectedCount > 0)
                Text(
                  '$selectedCount selected',
                  style: tt.bodySmall!
                      .copyWith(color: cs.onPrimaryContainer.withValues(alpha: 0.7)),
                ),
              if (selectedCount > 0 && totals.isNotEmpty)
                Text(
                  '  ·  ',
                  style: tt.bodySmall!.copyWith(color: cs.onPrimaryContainer),
                ),
              if (totals.isNotEmpty)
                Text(
                  totals.entries
                      .map((e) =>
                          '${e.key}${e.value.toStringAsFixed(2)}')
                      .join('  '),
                  style: tt.titleSmall!.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
