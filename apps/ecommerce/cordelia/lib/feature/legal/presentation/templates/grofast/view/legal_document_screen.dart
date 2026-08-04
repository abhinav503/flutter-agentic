import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';

import '../../../view/legal_document_content.dart';

/// `grofast` template's render of the app-level legal copy (kit frame
/// `178:2819`) — the shared [LegalDocumentContent] set in the pack's type,
/// under its standard header row.
///
/// The document is app-level, not per-store: only its presentation is
/// templated.
class LegalDocumentScreen extends BaseScreen {
  final LegalDocumentContent content;

  const LegalDocumentScreen({super.key, required this.content});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends BaseScreenState<LegalDocumentScreen> {
  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final content = widget.content;

    return SafeArea(
      bottom: false,
      child: GrofastScreenBody(
        title: content.title,
        onBack: () => context.pop(),
        gap: AppSpacing.xl4,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.lastUpdated,
              style: GrofastTextStyleConst.meta(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              content.intro,
              style: GrofastTextStyleConst.bodyRelaxed(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
            for (final section in content.sections) ...[
              const SizedBox(height: AppSpacing.xl4),
              Text(
                section.heading,
                style: GrofastTextStyleConst.subheadBold(tt),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                section.body,
                style: GrofastTextStyleConst.bodyRelaxed(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
