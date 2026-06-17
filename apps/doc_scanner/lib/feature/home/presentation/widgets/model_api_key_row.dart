import 'package:flutter/material.dart';

import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/theme/app_spacing.dart';

class ModelApiKeyRow extends StatelessWidget {
  final String? apiKey;
  final VoidCallback onEdit;
  final VoidCallback? onCopy;

  const ModelApiKeyRow({
    super.key,
    required this.apiKey,
    required this.onEdit,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hasKey = apiKey != null && apiKey!.isNotEmpty;

    return Row(
      children: [
        Icon(Icons.key_rounded, size: 13, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            hasKey ? _masked(apiKey!) : ValueConst.docScannerApiKeyLabel,
            style: tt.bodySmall?.copyWith(
              color: hasKey ? cs.onSurfaceVariant : cs.primary,
              fontFamily: hasKey ? 'monospace' : null,
              letterSpacing: hasKey ? 1.2 : null,
            ),
          ),
        ),
        if (hasKey && onCopy != null)
          GestureDetector(
            onTap: onCopy,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.copy_rounded, size: 14, color: cs.onSurfaceVariant),
            ),
          ),
        GestureDetector(
          onTap: onEdit,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Icon(Icons.edit_rounded, size: 14, color: cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  String _masked(String key) {
    if (key.length <= 8) return '••••••••';
    return '••••••••${key.substring(key.length - 4)}';
  }
}
