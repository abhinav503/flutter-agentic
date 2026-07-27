import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/widgets/cordelia_hero_header.dart';

import 'legal_document_content.dart';

/// Static, no-BLoC screen for a legal document (Terms & Conditions, Privacy
/// Policy) — same coloured-header + white-sheet shape as every other pushed
/// screen, but no data/domain layer at all since [content] is fixed copy,
/// not something a repository fetches.
class LegalDocumentScreen extends BaseScreen {
  final LegalDocumentContent content;

  const LegalDocumentScreen({super.key, required this.content});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends BaseScreenState<LegalDocumentScreen> {
  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Column(
        children: [
          Expanded(
            child: CollapsingHeaderSheet(
              initialHeaderHeight: 110,
              header: CordeliaHeroHeader(
                title: widget.content.title,
                onBack: () => context.pop(),
              ),
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.content.lastUpdated,
                      style: GraviaTextStyleConst.textSmRegular(
                        tt,
                      ).copyWith(color: GraviaColorConst.gray500),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      widget.content.intro,
                      style: GraviaTextStyleConst.textMdRegular(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    Text(
                      widget.content.heading,
                      style: GraviaTextStyleConst.textMdBold(
                        tt,
                      ).copyWith(color: cs.primary),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      widget.content.body,
                      style: GraviaTextStyleConst.textMdRegular(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
