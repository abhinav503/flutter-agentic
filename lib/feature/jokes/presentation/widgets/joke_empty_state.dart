import 'package:flutter/material.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/button.dart';


class JokeEmptyState extends StatelessWidget {
  final VoidCallback onTap;

  const JokeEmptyState({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_very_satisfied_outlined,
              size: 72,
              color: cs.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              ValueConst.jokeEmptyTitle,
              style: tt.titleLarge!.copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              ValueConst.jokeEmptySubtitle,
              style: tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl4),
            AppButton(
              label: ValueConst.jokeEmptyButton,
              onTap: onTap,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
