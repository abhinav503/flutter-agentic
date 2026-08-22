import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_menu_tile.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';

import 'package:cordelia/feature/support/presentation/support_channels.dart';
import 'package:cordelia/feature/support/presentation/support_glyphs.dart';
import 'package:cordelia/feature/support/presentation/support_launcher.dart';

/// `dailymart`'s Help & Support — the store's contact, CordeliaApps beneath
/// it, and the refunds policy, as the pack's bordered strips under its
/// standard header row.
///
/// The kit ships no support frame, so this is composed from recipes the pack
/// already owns — [DailyMartScreenBody] and [DailyMartMenuTile], the same
/// rows Profile is built from, now carrying the address they open.
///
/// Static and BLoC-less: [channels] comes from the storefront session
/// already in memory, so there is nothing to fetch and no skeleton to mirror.
class SupportScreen extends BaseScreen {
  final SupportChannels channels;

  const SupportScreen({super.key, required this.channels});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends BaseScreenState<SupportScreen> {
  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // The pack's standard wrapper, same as every other dailymart screen:
    // `DailyMartScreenBody` deliberately owns only the bottom edge, so the
    // top inset is the screen's to pay or the header row sits under the
    // status bar.
    return ColoredBox(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: DailyMartScreenBody(
          title: ValueConst.helpAndSupportLabel,
          onBack: () => context.pop(),
          gap: AppSpacing.lg,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ValueConst.supportIntro,
                style: DailyMartTextStyleConst.bodySmRegular(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
              for (final section in widget.channels.sections) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  section.title,
                  style: DailyMartTextStyleConst.bodyLgSemibold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
                if (section.subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs3),
                  Text(
                    section.subtitle,
                    style: DailyMartTextStyleConst.bodyXsMedium(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
                for (final channel in section.channels) ...[
                  const SizedBox(height: AppSpacing.xs),
                  DailyMartMenuTile(
                    icon: supportChannelGlyph(channel.kind),
                    label: channel.label,
                    subtitle: channel.value.isEmpty ? null : channel.value,
                    onTap: () => context.openSupportChannel(channel),
                  ),
                ],
                if (section.note.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    section.note,
                    style: DailyMartTextStyleConst.bodyXsMedium(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ],
              if (widget.channels.versionLabel.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl2),
                Text(
                  widget.channels.versionLabel,
                  style: DailyMartTextStyleConst.bodyXsMedium(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
