import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/screen_body.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';

/// The pack's screen shell (spec sheet §8/§11): the header row over one
/// scroll view at the standard `lg / base / lg` gutters, with an optional
/// CTA floating over a [DailyMartBottomFade]. A back-button header docks
/// above the scroll (see [pinnedHeader]); a back-less one scrolls away with
/// the content.
///
/// Core's [ScreenBody] carrying this pack's gutter, fade and inset — the
/// layout algorithm (one padding recipe for every state a screen swaps
/// through, the expand-the-stack rule a floating CTA needs) lives there
/// once. What stays here is the kit's `title/onBack → DailyMartHeaderRow`
/// convenience and its rule for which headers pin.
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

  /// Keeps the header row outside the scroll view, docked above it — the
  /// same pinned pattern the Cart/Checkout/Wishlist screens hand-roll. Null
  /// defaults to pinning exactly the headers that carry a back button
  /// ([title] + [onBack]); tab roots and custom [headerRow]s keep scrolling
  /// away unless a caller opts in.
  final bool? pinnedHeader;

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
    this.pinnedHeader,
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

    return ScreenBody(
      body: body,
      header: header,
      gutter: AppSpacing.lg,
      gap: gap,
      topPadding: topPadding,
      bottomInset: bottomInset,
      floatingAction: floatingAction,
      floatingActionScrollInset: floatingAction == null
          ? null
          : DailyMartDimenConst.floatingActionScrollInset(context),
      bottomFade: const DailyMartBottomFade(),
      fullBleedBody: fullBleedBody,
      // This pack pins exactly the headers that carry a back button; tab
      // roots and custom header rows scroll away unless a caller opts in.
      pinnedHeader: pinnedHeader ?? (title != null && onBack != null),
    );
  }
}
