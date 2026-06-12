import 'package:flutter/material.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/scanned_receipt_entity.dart';
import 'receipt_row.dart';

class LedgerContent extends StatelessWidget {
  final List<ScannedReceiptEntity> receipts;

  const LedgerContent({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (receipts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl4),
        child: Center(
          child: Text(
            ValueConst.docScannerLedgerEmpty,
            style: tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    // Group totals by currency
    final totals = <String, double>{};
    for (final r in receipts) {
      if (r.amount == null) continue;
      final key = r.currency ?? '';
      totals[key] = (totals[key] ?? 0) + r.amount!;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    ValueConst.docScannerLedgerColName,
                    style: tt.labelSmall!
                        .copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    ValueConst.docScannerLedgerColDate,
                    style: tt.labelSmall!
                        .copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                Text(
                  ValueConst.docScannerLedgerColAmount,
                  style:
                      tt.labelSmall!.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Divider(),
          // Receipt rows
          ...receipts.map((r) => ReceiptRow(receipt: r)),
          // Totals
          if (totals.isNotEmpty) ...[
            const Divider(thickness: 1.5),
            const SizedBox(height: AppSpacing.xs),
            ...totals.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ValueConst.docScannerLedgerTotal(e.key),
                      style: tt.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      '${e.key}${e.value.toStringAsFixed(2)}',
                      style: tt.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
