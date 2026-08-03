import 'package:flutter/material.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';

/// The arc that gives the GROFAST pack its silhouette (spec sheet §2/§10).
///
/// The kit draws a sheet's top edge — and Product Details' hero *bottom*
/// edge — as a shallow ellipse rather than a pair of rounded corners: the
/// centre climbs [GrofastDimenConst.sheetDomeRise] above the edges on a
/// 375-wide frame, and the rise scales with width so the curvature reads the
/// same on every device.
///
/// The kit's own geometry is a 633 × 230 ellipse on a 375 viewport; a
/// quadratic Bézier through the same three points (both edges and the peak)
/// is visually identical over an arc this shallow and costs one path
/// operation, so that is what every dome here draws.
double _riseFor(double width) =>
    width * GrofastDimenConst.sheetDomeRise / _kitFrameWidth;

/// The kit's artboard width — the denominator every proportional dimension
/// in this file is measured against.
const double _kitFrameWidth = 375;

/// Appends the pack's upward arc to [path], from `(rect.left, …)` across to
/// `(rect.right, …)`, peaking [rise] above [edgeY].
void _addDome(Path path, Rect rect, double edgeY, double rise) {
  path
    ..moveTo(rect.left, edgeY + rise)
    ..quadraticBezierTo(rect.center.dx, edgeY - rise, rect.right, edgeY + rise);
}

/// The sheet silhouette: a floating drag handle **and** the domed surface
/// below it, as one shape — so `AppBottomSheet` paints both in `cs.surface`
/// and the transparent gap between them lets the scrim through, exactly as
/// the kit draws it.
///
/// Passed to `AppBottomSheet.shape`; content must clear
/// [GrofastSheetMetrics.contentTop] or it lands inside the arc.
class GrofastDomeSheetBorder extends ShapeBorder {
  const GrofastDomeSheetBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final rise = _riseFor(rect.width);
    final peakY = rect.top + GrofastSheetMetrics.handleBand;

    final handle = RRect.fromLTRBR(
      rect.center.dx - GrofastDimenConst.sheetHandleWidth / 2,
      rect.top,
      rect.center.dx + GrofastDimenConst.sheetHandleWidth / 2,
      rect.top + GrofastDimenConst.sheetHandleHeight,
      const Radius.circular(GrofastDimenConst.sheetHandleHeight / 2),
    );

    final path = Path()..addRRect(handle);
    _addDome(path, rect, peakY, rise);
    return path
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => const GrofastDomeSheetBorder();
}

/// Where a domed sheet's chrome sits, derived from the shape above so a
/// screen never re-adds the handle band by hand.
abstract final class GrofastSheetMetrics {
  /// Handle height + the transparent gap below it — everything above the
  /// dome's peak.
  static const double handleBand =
      GrofastDimenConst.sheetHandleHeight + GrofastDimenConst.sheetHandleGap;

  /// Top padding for a domed sheet's content: past the handle band, then the
  /// kit's own clearance below the peak.
  static const double contentTop =
      handleBand + GrofastDimenConst.sheetContentTop;
}

/// The same arc on a surface's **bottom** edge — Product Details' hero well,
/// which is the only place the pack flips the dome (spec sheet §10).
class GrofastBottomDomeClipper extends CustomClipper<Path> {
  const GrofastBottomDomeClipper();

  @override
  Path getClip(Size size) {
    final rise = _riseFor(size.width);
    final rect = Offset.zero & size;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      // Bottom edge runs right-to-left, so the arc is mirrored: the edges sit
      // `rise` above the centre, which bulges down to the full height.
      ..lineTo(size.width, size.height - rise)
      ..quadraticBezierTo(
        rect.center.dx,
        size.height + rise,
        0,
        size.height - rise,
      );
    return path..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// The bottom nav's silhouette: a bar whose top edge is interrupted by a
/// circular notch centred on the active tab (spec sheet §10). The notch
/// travels with the selection, so [notchCenterX] is animated by the caller.
class GrofastNavBarClipper extends CustomClipper<Path> {
  final double notchCenterX;

  const GrofastNavBarClipper({required this.notchCenterX});

  @override
  Path getClip(Size size) {
    final radius = GrofastDimenConst.navNotchDiameter / 2;
    // The notch circle is centred *on* the bar's top edge, so exactly its
    // lower half is cut away and the raised disc drops into the hole.
    final notch = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(notchCenterX, 0), radius: radius),
      );

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      notch,
    );
  }

  @override
  bool shouldReclip(covariant GrofastNavBarClipper oldClipper) =>
      oldClipper.notchCenterX != notchCenterX;
}
