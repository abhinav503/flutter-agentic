import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Pill − / value / + stepper for cart rows and product detail.
///
/// Passing null for [onDecrement]/[onIncrement] disables that side's tap and
/// dims its icon — the caller decides limits (e.g. min 1, stock max).
class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const QuantityStepper({
    super.key,
    required this.value,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: AppRadius.full,
        border: Border.all(color: cs.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs2),
            child: Text(
              '$value',
              style: tt.titleMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _StepButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? cs.onSurface.withValues(alpha: 0.38)
              : cs.primary,
        ),
      ),
    );
  }
}
