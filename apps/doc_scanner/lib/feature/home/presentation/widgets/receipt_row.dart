import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import '../../domain/entities/scanned_receipt_entity.dart';

class ReceiptRow extends StatelessWidget {
  final ScannedReceiptEntity receipt;

  const ReceiptRow({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Text(
                receipt.restaurantName ?? '—',
                style: tt.bodyMedium!.copyWith(color: cs.onSurface),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              receipt.date ?? '—',
              style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            receipt.formattedAmount,
            style: tt.bodyMedium!.copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
