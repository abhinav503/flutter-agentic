import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';

import '../../../view/legal_document_content.dart';

/// `dailymart` template's legal document (kit frame `50 Privacy & Policy`),
/// serving both Privacy Policy and Terms & Conditions — a white sheet with
/// the pack's header row, a bold effective-date line, and the document body
/// beside a permanently-visible scroll rail.
///
/// Static, no-BLoC: [content] is fixed copy, not something a repository
/// fetches, so this screen has no data/domain layer at all.
///
/// The rail is the kit's one un-Material touch here — it draws the scrollbar
/// as part of the page rather than as a fade-in overlay, so this uses a
/// [RawScrollbar] pinned visible with a green thumb on a hairline track
/// instead of the platform default.
class LegalDocumentScreen extends BaseScreen {
  final LegalDocumentContent content;

  const LegalDocumentScreen({super.key, required this.content});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends BaseScreenState<LegalDocumentScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.sheetHairline;

    return ColoredBox(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: RawScrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: DailyMartDimenConst.scrollRailWidth,
          thumbColor: cs.primary,
          trackColor: hairline,
          // Without this the painter draws its default black-at-10% line
          // down the track's inner edge — the kit's rail is one clean pill.
          trackBorderColor: Colors.transparent,
          radius: const Radius.circular(AppRadius.fullValue),
          trackRadius: const Radius.circular(AppRadius.fullValue),
          // Sits the rail in the screen gutter, where the kit draws it —
          // not flush against the device edge.
          crossAxisMargin: AppSpacing.lg,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.base,
              AppSpacing.lg,
              AppSpacing.xl10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DailyMartHeaderRow(
                  title: widget.content.title,
                  onBack: () => context.pop(),
                ),
                const SizedBox(height: AppSpacing.xl4),
                Padding(
                  // Keeps the copy clear of the rail; the header row above
                  // still spans the full gutter-to-gutter width. The kit
                  // leaves a wide channel here — the copy stops well short
                  // of the rail rather than running up against it.
                  padding: const EdgeInsets.only(right: AppSpacing.xl7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.content.lastUpdated,
                        style: DailyMartTextStyleConst.bodyLgSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                      // The kit prints the numbered clauses straight after
                      // the date — no lead paragraph, so `content.intro`
                      // (gravia's) is deliberately unrendered here.
                      for (final section in widget.content.sections) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          section.heading,
                          style: DailyMartTextStyleConst.bodyMdMedium(
                            tt,
                          ).copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          section.body,
                          style: DailyMartTextStyleConst.bodySmRegular(
                            tt,
                          ).copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
