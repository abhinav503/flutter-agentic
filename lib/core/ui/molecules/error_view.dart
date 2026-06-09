import 'package:flutter/material.dart';

import '../../constants/value_const.dart';
import '../../theme/app_spacing.dart';
import '../atoms/button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: cs.error),
          const SizedBox(height: AppSpacing.base),
          Text(
            message,
            textAlign: TextAlign.center,
            style: tt.bodyMedium!.copyWith(color: cs.onSurface),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.base),
            AppButton(
              label: ValueConst.retryButton,
              variant: AppButtonVariant.primary,
              onTap: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
