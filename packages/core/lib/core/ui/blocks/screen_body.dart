import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// The scroll-away-header screen shell several style packs share: one scroll
/// view at the pack's gutter carrying the (pack-built) header row as its
/// first item, with an optional CTA floating over a bottom fade.
///
/// One padding recipe for **every** state a screen swaps through, so a
/// loading → loaded → empty → error transition never shifts content sideways
/// and every branch pays the same bottom inset.
///
/// With a [floatingAction] the shell becomes a `Stack(fit: StackFit.expand)`:
/// the scroll view shrink-wraps its content, so without expanding, a short
/// page ends the stack early and the fade + CTA pin to the content's bottom
/// edge instead of the device's. The scroll view then pays
/// [floatingActionScrollInset] so its last row clears the CTA; without one it
/// pays the device inset alone (the screen's `SafeArea` deliberately leaves
/// the bottom edge to this shell).
///
/// Packs keep a thin wrapper over this (their `title/onBack → HeaderRow`
/// convenience plus their gutter, fade, and inset constants) — the layout
/// algorithm lives here once.
class ScreenBody extends StatelessWidget {
  /// The content below the header row.
  final Widget body;

  /// The pack's fully-built header row. Null means a headerless shell — a
  /// tab root whose header is pinned outside, or a body slot under an
  /// already-rendered header.
  final Widget? header;

  /// The pack's horizontal gutter.
  final double gutter;

  /// Space between [header] and [body].
  final double gap;

  /// Top padding of the scroll view.
  final double topPadding;

  /// Bottom clearance when nothing floats. Defaults to the device inset +
  /// `lg`; a shell tab sitting above a nav bar (which already owns the
  /// bottom edge) passes its own breathing room instead. Ignored when
  /// [floatingAction] is set — [floatingActionScrollInset] takes over.
  final double? bottomInset;

  /// The CTA floating over [bottomFade], spanning the gutters at
  /// `device inset + lg` above the bottom edge.
  final Widget? floatingAction;

  /// The scroll clearance that keeps the last row visible above a floating
  /// CTA — the pack computes it from its CTA height + fade. Required
  /// alongside [floatingAction].
  final double? floatingActionScrollInset;

  /// The pack's fade, positioned across the stack's bottom edge when
  /// [floatingAction] is set (e.g. a [BottomFade] preset).
  final Widget? bottomFade;

  /// Drops the horizontal gutters so [body] can bleed edge-to-edge (a
  /// peeking carousel); [header] keeps its own gutters.
  final bool fullBleedBody;

  /// Replaces the scroll view with a plain column — for a screen whose body
  /// is itself a scrollable that must own the viewport.
  final bool scrollable;

  /// Docks [header] *above* the scroll view instead of scrolling it away
  /// with the content, so the body clips at the viewport's top edge rather
  /// than sliding under a back button.
  ///
  /// Which headers pin is the pack's rule, not this block's — one pins the
  /// ones carrying a back button, another every non-custom header — so the
  /// wrapper resolves it and passes a plain bool.
  final bool pinnedHeader;

  const ScreenBody({
    super.key,
    required this.body,
    this.header,
    this.gutter = AppSpacing.lg,
    this.gap = AppSpacing.lg,
    this.topPadding = AppSpacing.base,
    this.bottomInset,
    this.floatingAction,
    this.floatingActionScrollInset,
    this.bottomFade,
    this.fullBleedBody = false,
    this.scrollable = true,
    this.pinnedHeader = false,
  }) : assert(
         floatingAction == null || floatingActionScrollInset != null,
         'A floatingAction needs floatingActionScrollInset so the last row '
         'can scroll clear of it.',
       );

  @override
  Widget build(BuildContext context) {
    final horizontal = fullBleedBody ? 0.0 : gutter;
    final bottom = floatingAction != null
        ? floatingActionScrollInset!
        : bottomInset ?? MediaQuery.paddingOf(context).bottom + AppSpacing.lg;

    final view = pinnedHeader && header != null
        ? _pinned(context, horizontal: horizontal, bottom: bottom)
        : _scrolling(context, horizontal: horizontal, bottom: bottom);

    if (floatingAction == null) return view;

    return Stack(
      fit: StackFit.expand,
      children: [
        view,
        if (bottomFade != null)
          Positioned(left: 0, right: 0, bottom: 0, child: bottomFade!),
        Positioned(
          left: gutter,
          right: gutter,
          bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          child: floatingAction!,
        ),
      ],
    );
  }

  /// Header docked above, body scrolling beneath it. The header keeps the
  /// full gutter even when the body bleeds — a title hard against the screen
  /// edge reads as a mistake.
  Widget _pinned(
    BuildContext context, {
    required double horizontal,
    required double bottom,
  }) {
    final bodyPadding = EdgeInsets.fromLTRB(horizontal, 0, horizontal, bottom);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(gutter, topPadding, gutter, 0),
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
  }

  /// Header as the scroll view's first item, scrolling away with the body.
  Widget _scrolling(
    BuildContext context, {
    required double horizontal,
    required double bottom,
  }) {
    final content = header == null
        ? body
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fullBleedBody)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: gutter),
                  child: header,
                )
              else
                header!,
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

    return scrollable
        ? SingleChildScrollView(padding: padding, child: content)
        : Padding(padding: padding, child: content);
  }
}
