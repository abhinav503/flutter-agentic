import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_menu_tile.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';

import 'package:cordelia/feature/support/presentation/support_channels.dart';
import 'package:cordelia/feature/support/presentation/support_glyphs.dart';
import 'package:cordelia/feature/support/presentation/support_launcher.dart';

/// `grofast`'s Help & Support — the store's contact, CordeliaApps beneath it,
/// and the refunds policy, as the pack's filled menu cards under its standard
/// header row.
///
/// The kit ships no support frame, so this is composed from recipes the pack
/// already owns ([GrofastScreenBody], [GrofastMenuTile]) — the same rows
/// Profile is built from, now carrying the address they open.
///
/// Static and BLoC-less: [channels] comes from the storefront session already
/// in memory, so there is nothing to fetch and no skeleton to mirror.
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

    return SafeArea(
      bottom: false,
      child: GrofastScreenBody(
        title: ValueConst.helpAndSupportLabel,
        onBack: () => context.pop(),
        gap: AppSpacing.xl4,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              ValueConst.supportIntro,
              style: GrofastTextStyleConst.bodyRelaxed(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
            for (final section in widget.channels.sections) ...[
              const SizedBox(height: AppSpacing.xl4),
              Text(section.title, style: GrofastTextStyleConst.subheadBold(tt)),
              if (section.subtitle.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs3),
                Text(
                  section.subtitle,
                  style: GrofastTextStyleConst.bodySmall(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ],
              for (final channel in section.channels) ...[
                const SizedBox(height: AppSpacing.base),
                GrofastMenuTile(
                  icon: supportChannelGlyph(channel.kind),
                  label: channel.label,
                  subtitle: channel.value.isEmpty ? null : channel.value,
                  onTap: () => context.openSupportChannel(channel),
                ),
              ],
              if (section.note.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.base),
                Text(
                  section.note,
                  style: GrofastTextStyleConst.bodySmall(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ],
            if (widget.channels.versionLabel.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl4),
              Text(
                widget.channels.versionLabel,
                textAlign: TextAlign.center,
                style: GrofastTextStyleConst.bodySmall(
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
