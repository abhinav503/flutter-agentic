import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';

/// The pack's screen shell (spec sheet §8/§11): one scroll view carrying the
/// header row as its first item — this pack scrolls its header away rather
/// than docking it — at the standard `lg / base / lg` gutters, with an
/// optional CTA floating over a [DailyMartBottomFade].
///
/// One padding recipe for every state a screen swaps through, so a
/// loading → loaded → error transition never shifts the content sideways.
///
/// With a [floatingAction] the shell becomes a `Stack(fit: StackFit.expand)`:
/// the scroll view shrink-wraps its content, so without expanding, a short
/// page ends the stack early and the positioned fade + CTA pin to the
/// content's bottom edge instead of the device's. The scroll view then pays
/// [DailyMartDimenConst.floatingActionScrollInset] so its last row clears
/// the CTA; without one it pays the device inset alone (the screen's
/// `SafeArea` deliberately leaves the bottom edge to this shell).
class DailyMartScreenBody extends StatelessWidget {
  /// The content below the header row.
  final Widget body;

  /// Builds the standard [DailyMartHeaderRow]. Null (with no [headerRow])
  /// means a headerless shell — a tab root whose header is pinned outside,
  /// or a body slot under an already-rendered header.
  final String? title;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// Replaces the [title]-built [DailyMartHeaderRow] for screens with their
  /// own header recipe (Home's identity band).
  final Widget? headerRow;

  /// Space between the header row and [body].
  final double gap;

  /// Top padding of the scroll view.
  final double topPadding;

  /// Bottom clearance when nothing floats. Defaults to the device inset +
  /// `lg`; a shell tab sitting above the nav bar (which already owns the
  /// bottom edge) passes its own breathing room instead. Ignored when
  /// [floatingAction] is set — the CTA clearance takes over.
  final double? bottomInset;

  /// The CTA docked over the bottom fade, spanning the `lg` gutters at
  /// `device inset + lg` above the bottom edge (wrap in [Center] for a
  /// shrink-wrapped pill).
  final Widget? floatingAction;

  /// When true the scroll view drops its horizontal gutters so [body] can
  /// bleed edge-to-edge (Home's peeking carousel); the header row keeps its
  /// own `lg` gutters.
  final bool fullBleedBody;

  const DailyMartScreenBody({
    super.key,
    required this.body,
    this.title,
    this.onBack,
    this.trailing,
    this.headerRow,
    this.gap = AppSpacing.lg,
    this.topPadding = AppSpacing.base,
    this.bottomInset,
    this.floatingAction,
    this.fullBleedBody = false,
  }) : assert(
         title == null || headerRow == null,
         'Pass a title or a custom headerRow, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final header =
        headerRow ??
        (title == null
            ? null
            : DailyMartHeaderRow(
                title: title!,
                onBack: onBack,
                trailing: trailing,
              ));

    final horizontal = fullBleedBody ? 0.0 : AppSpacing.lg;
    final bottom = floatingAction != null
        ? DailyMartDimenConst.floatingActionScrollInset(context)
        : bottomInset ?? MediaQuery.paddingOf(context).bottom + AppSpacing.lg;

    final scrollView = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontal, topPadding, horizontal, bottom),
      child: header == null
          ? body
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fullBleedBody)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: header,
                  )
                else
                  header,
                SizedBox(height: gap),
                body,
              ],
            ),
    );

    if (floatingAction == null) return scrollView;

    return Stack(
      fit: StackFit.expand,
      children: [
        scrollView,
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DailyMartBottomFade(),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          child: floatingAction!,
        ),
      ],
    );
  }
}
