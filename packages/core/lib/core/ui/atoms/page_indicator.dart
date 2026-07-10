import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Dot row marking position within a paged flow (onboarding, carousels).
/// The active dot is an elongated pill; inactive dots are small circles.
///
/// ```dart
/// PageIndicator(count: 3, currentIndex: 1)
/// ```
class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == currentIndex ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == currentIndex
                  ? cs.primary
                  : cs.surfaceContainerHighest,
              borderRadius: AppRadius.full,
            ),
          ),
        ],
      ],
    );
  }
}
