import 'package:flutter/material.dart';

/// Stacked, same-centred circles — e.g. a status/success graphic's halo
/// rings around a solid icon disc. [radii] and [colors] are ordered
/// outermost → innermost and must be the same length; [child] renders
/// centred inside the innermost circle.
///
/// Animates in on mount: each circle pops from radius 0 to its target size
/// (a scale transform, not a relayout), starting outermost and cascading
/// inward — [staggerDelay] is the offset between each circle's start,
/// [circleDuration] how long each one's own grow-in takes. Pass
/// `animate: false` for a static render.
///
/// ```dart
/// AppConcentricCircles(
///   radii: const [128, 96, 64],
///   colors: [
///     cs.primary.withValues(alpha: 0.1),
///     cs.primary.withValues(alpha: 0.1),
///     cs.primary,
///   ],
///   child: Icon(Icons.check, color: cs.onPrimary),
/// )
/// ```
class AppConcentricCircles extends StatefulWidget {
  final List<double> radii;
  final List<Color> colors;
  final Widget? child;
  final bool animate;
  final Duration staggerDelay;
  final Duration circleDuration;
  final Curve curve;

  const AppConcentricCircles({
    super.key,
    required this.radii,
    required this.colors,
    this.child,
    this.animate = true,
    this.staggerDelay = const Duration(milliseconds: 500),
    this.circleDuration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeOut,
  }) : assert(
         radii.length == colors.length,
         'AppConcentricCircles requires one colour per radius',
       );

  @override
  State<AppConcentricCircles> createState() => _AppConcentricCirclesState();
}

class _AppConcentricCirclesState extends State<AppConcentricCircles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();

    final totalMs =
        widget.circleDuration.inMilliseconds +
        widget.staggerDelay.inMilliseconds * (widget.radii.length - 1);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    _scales = List.generate(widget.radii.length, (i) {
      if (!widget.animate) return const AlwaysStoppedAnimation(1.0);

      final startMs = widget.staggerDelay.inMilliseconds * i;
      final start = totalMs == 0 ? 0.0 : startMs / totalMs;
      final end = totalMs == 0
          ? 1.0
          : ((startMs + widget.circleDuration.inMilliseconds) / totalMs)
                .clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        // Interval requires begin <= end strictly when both are 1.0 — the
        // last circle's window can round to exactly [1.0, 1.0].
        curve: Interval(start, start == end ? 1.0 : end, curve: widget.curve),
      );
    });

    if (widget.animate) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxSize = widget.radii.reduce((a, b) => a > b ? a : b);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => SizedBox(
        width: maxSize,
        height: maxSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < widget.radii.length; i++)
              Transform.scale(
                scale: _scales[i].value,
                child: Container(
                  width: widget.radii[i],
                  height: widget.radii[i],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.colors[i],
                  ),
                  alignment: Alignment.center,
                  child: i == widget.radii.length - 1 ? widget.child : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
