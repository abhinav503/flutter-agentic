import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Dot row (or column) marking position within a paged flow (onboarding, carousels).
/// The active dot is an elongated pill; inactive dots are small circles.
///
/// ```dart
/// PageIndicator(count: 3, currentIndex: 1)
/// PageIndicator(count: 3, currentIndex: 1, axis: Axis.vertical)
/// ```
class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Axis axis;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.axis = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isHorizontal = axis == Axis.horizontal;

    final dots = [
      for (var i = 0; i < count; i++) ...[
        if (i > 0) SizedBox(width: isHorizontal ? AppSpacing.xs2 : 0, height: isHorizontal ? 0 : AppSpacing.xs2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHorizontal ? (i == currentIndex ? 20 : 6) : 6,
          height: isHorizontal ? 6 : (i == currentIndex ? 20 : 6),
          decoration: BoxDecoration(
            color: i == currentIndex ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: AppRadius.full,
          ),
        ),
      ],
    ];

    return isHorizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: dots)
        : Column(mainAxisSize: MainAxisSize.min, children: dots);
  }
}
