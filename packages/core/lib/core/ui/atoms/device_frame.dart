import 'package:flutter/material.dart';

/// Decorative phone bezel that frames [child] like a device screenshot —
/// rounded body, a top notch, and side button nubs. Purely presentational
/// (no real device metrics); every dimension is a fraction of the incoming
/// width so the frame scales with whatever box it's given instead of being
/// tuned to one fixed screen size.
///
/// ```dart
/// DeviceFrame(child: AppNetworkImage(url: shot.url))
/// ```
class DeviceFrame extends StatelessWidget {
  final Widget child;
  final Color? bezelColor;

  const DeviceFrame({super.key, required this.child, this.bezelColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bezel = bezelColor ?? cs.scrim;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bezelWidth = width * 0.028;
        final cornerRadius = width * 0.17;
        final notchWidth = width * 0.32;
        final notchHeight = width * 0.06;
        // Nubs live inside this reserved side margin rather than
        // overflowing past DeviceFrame's own bounds — a PageView clips each
        // page to its own slot, so a negative-offset Positioned poking
        // outside the widget's box gets silently clipped away.
        final nubMargin = width * 0.014;
        final nubThickness = nubMargin * 1.8;

        return Stack(
          children: [
            // Positioned.fill forces the bezel to the full incoming size —
            // without it, an un-positioned Stack child only sizes to its
            // largest un-positioned descendant (here, the small notch),
            // collapsing the whole frame down to notch size.
            Positioned.fill(
              left: nubMargin,
              right: nubMargin,
              child: Container(
                padding: EdgeInsets.all(bezelWidth),
                decoration: BoxDecoration(
                  color: bezel,
                  borderRadius: BorderRadius.circular(cornerRadius),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(cornerRadius - bezelWidth),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned.fill(child: child),
                      Padding(
                        padding: EdgeInsets.only(top: bezelWidth * 0.6),
                        child: Container(
                          width: notchWidth,
                          height: notchHeight,
                          decoration: BoxDecoration(
                            color: bezel,
                            borderRadius:
                                BorderRadius.circular(notchHeight / 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _SideButton(
              alignment: Alignment.centerLeft,
              thickness: nubThickness,
              top: constraints.maxHeight * 0.16,
              length: constraints.maxHeight * 0.045,
              color: bezel,
            ),
            _SideButton(
              alignment: Alignment.centerLeft,
              thickness: nubThickness,
              top: constraints.maxHeight * 0.23,
              length: constraints.maxHeight * 0.07,
              color: bezel,
            ),
            _SideButton(
              alignment: Alignment.centerRight,
              thickness: nubThickness,
              top: constraints.maxHeight * 0.18,
              length: constraints.maxHeight * 0.09,
              color: bezel,
            ),
          ],
        );
      },
    );
  }
}

/// A single power/volume nub protruding from the bezel edge.
class _SideButton extends StatelessWidget {
  final Alignment alignment;
  final double thickness;
  final double top;
  final double length;
  final Color color;

  const _SideButton({
    required this.alignment,
    required this.thickness,
    required this.top,
    required this.length,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: alignment == Alignment.centerLeft ? 0 : null,
      right: alignment == Alignment.centerRight ? 0 : null,
      top: top,
      child: Container(
        width: thickness,
        height: length,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.horizontal(
            left: alignment == Alignment.centerRight
                ? Radius.circular(thickness)
                : Radius.zero,
            right: alignment == Alignment.centerLeft
                ? Radius.circular(thickness)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}
