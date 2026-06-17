import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Three pulsing dots — a lightweight "working…" indicator for inline spots
/// like a streaming chat bubble or a sending state. Colour defaults to
/// [ColorScheme.onSurfaceVariant]; pass [color] to override.
class LoadingDots extends StatefulWidget {
  final Color? color;

  const LoadingDots({super.key, this.color});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      height: AppSpacing.lg,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_controller.value + i * 0.2) % 1.0;
            final opacity =
                0.3 + 0.7 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs4),
              child: Opacity(
                opacity: opacity,
                child: CircleAvatar(
                  radius: AppSpacing.xs4,
                  backgroundColor: color,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
