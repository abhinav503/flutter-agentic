import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';

import 'grofast_header_row.dart';

/// The pack's screen shell (spec sheet §8): the header row over one scroll
/// view at the 30px gutter, with an optional CTA floating over a
/// `surface → transparent` fade. A back-button header docks above the
/// scroll (see [pinnedHeader]); a back-less one scrolls away with the
/// content.
///
/// One padding recipe for **every** state a screen swaps through, so a
/// loading → loaded → empty → error transition never shifts content sideways
/// and every branch pays the same bottom inset.
///
/// With a [floatingAction] the shell becomes a `Stack(fit: StackFit.expand)`:
/// the scroll view shrink-wraps its content, so without expanding, a short
/// page ends the stack early and the fade + CTA pin to the content's bottom
/// edge instead of the device's. The scroll view then pays
/// [GrofastDimenConst.floatingActionScrollInset] so its last row clears the
/// CTA; without one it pays the device inset alone (the screen's `SafeArea`
/// deliberately leaves the bottom edge to this shell).
class GrofastScreenBody extends StatelessWidget {
  final Widget body;

  /// Builds the standard [GrofastHeaderRow]. Null (with no [headerRow]) means
  /// a headerless shell — a tab root whose header is pinned outside, or a
  /// body slot under an already-rendered header.
  final String? title;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;

  /// Replaces the [title]-built header for screens with their own recipe
  /// (Home's identity band).
  final Widget? headerRow;

  /// Space between the header row and [body].
  final double gap;

  final double topPadding;

  /// Bottom clearance when nothing floats. Defaults to the device inset +
  /// `lg`; a shell tab sitting above the nav bar passes
  /// [GrofastDimenConst.navScrollInset] instead. Ignored when
  /// [floatingAction] is set — the CTA clearance takes over.
  final double? bottomInset;

  /// The CTA floating over the bottom fade, spanning the gutters at
  /// `device inset + lg` above the bottom edge.
  final Widget? floatingAction;

  /// Drops the horizontal gutters so [body] can bleed edge-to-edge (Home's
  /// peeking carousel); the header row keeps its own gutters.
  final bool fullBleedBody;

  /// Replaces the scroll view with a plain column — for a screen whose body
  /// is itself a scrollable that must own the viewport (a long list with its
  /// own physics).
  final bool scrollable;

  /// Keeps the header outside the scroll view, docked above it. Null
  /// defaults to pinning exactly the headers that carry the back control
  /// (a title-built row with [showBack]); tab roots and custom [headerRow]s
  /// keep scrolling away unless a caller opts in.
  final bool? pinnedHeader;

  const GrofastScreenBody({
    super.key,
    required this.body,
    this.title,
    this.onBack,
    this.showBack = true,
    this.trailing,
    this.headerRow,
    this.gap = AppSpacing.xl4,
    this.topPadding = AppSpacing.base,
    this.bottomInset,
    this.floatingAction,
    this.fullBleedBody = false,
    this.scrollable = true,
    this.pinnedHeader,
  }) : assert(
         title == null || headerRow == null,
         'Pass a title or a custom headerRow, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final header =
        headerRow ??
        (title == null && !showBack
            ? null
            : GrofastHeaderRow(
                title: title,
                onBack: onBack,
                showBack: showBack,
                trailing: trailing,
              ));

    final horizontal = fullBleedBody ? 0.0 : GrofastDimenConst.screenGutter;
    final bottom = floatingAction != null
        ? GrofastDimenConst.floatingActionScrollInset(context)
        : bottomInset ?? MediaQuery.paddingOf(context).bottom + AppSpacing.lg;
    final pinned =
        header != null && (pinnedHeader ?? (headerRow == null && showBack));

    final Widget view;
    if (pinned) {
      // The header docks above the scroll view — content clips at the
      // viewport's top edge instead of sliding under the back control.
      final bodyPadding = EdgeInsets.fromLTRB(horizontal, 0, horizontal, bottom);
      view = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: GrofastDimenConst.screenGutter,
            ).copyWith(top: topPadding),
            child: header,
          ),
          SizedBox(height: gap),
          Expanded(
            child: scrollable
                ? SingleChildScrollView(padding: bodyPadding, child: body)
                : Padding(padding: bodyPadding, child: body),
          ),
        ],
      );
    } else {
      final content = header == null
          ? body
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fullBleedBody)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GrofastDimenConst.screenGutter,
                    ),
                    child: header,
                  )
                else
                  header,
                SizedBox(height: gap),
                body,
              ],
            );

      final padding = EdgeInsets.fromLTRB(
        horizontal,
        topPadding,
        horizontal,
        bottom,
      );

      view = scrollable
          ? SingleChildScrollView(padding: padding, child: content)
          : Padding(padding: padding, child: content);
    }

    if (floatingAction == null) return view;

    return Stack(
      fit: StackFit.expand,
      children: [
        view,
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GrofastBottomFade(),
        ),
        Positioned(
          left: GrofastDimenConst.screenGutter,
          right: GrofastDimenConst.screenGutter,
          bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          child: floatingAction!,
        ),
      ],
    );
  }
}

/// The `surface → transparent` gradient a floating CTA sits on, so content
/// scrolling underneath fades out instead of colliding with the button. The
/// pack has no docked bar; this fade is what separates the two layers
/// (spec sheet §8).
class GrofastBottomFade extends StatelessWidget {
  final double height;

  /// True when the fade sits at the device edge with a control floating in
  /// it: it then pays the device inset and turns fully opaque partway down,
  /// so the button has solid surface behind it.
  ///
  /// False when it sits **on top of** an already-opaque band (Product
  /// Details' dock): the inset belongs to that band, and any opaque stretch
  /// here is a white slab above the row rather than a fade into it — so the
  /// gradient runs the fade's whole length and lands exactly on the band.
  final bool carriesFloatingAction;

  const GrofastBottomFade({
    super.key,
    this.height = GrofastDimenConst.bottomFadeHeight,
  }) : carriesFloatingAction = true;

  const GrofastBottomFade.overDock({
    super.key,
    this.height = GrofastDimenConst.bottomFadeHeight,
  }) : carriesFloatingAction = false;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return IgnorePointer(
      child: Container(
        height: carriesFloatingAction
            ? height + MediaQuery.paddingOf(context).bottom
            : height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [surface.withValues(alpha: 0), surface],
            stops: carriesFloatingAction ? const [0, 0.55] : const [0, 1],
          ),
        ),
      ),
    );
  }
}
