import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_circle.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';

import 'package:cordelia/feature/support/presentation/support_channels.dart';
import 'package:cordelia/feature/support/presentation/support_glyphs.dart';
import 'package:cordelia/feature/support/presentation/support_launcher.dart';

/// `gravia`'s Help & Support — the store's own contact, CordeliaApps
/// underneath it, and the refunds policy, in the pack's coloured-header +
/// white-sheet shape.
///
/// Static and BLoC-less like the legal screens: [channels] is resolved from
/// the storefront session already in memory, so there is nothing to fetch and
/// no loading state to mirror.
///
/// The kit ships no support frame — this screen is composed from recipes the
/// pack already owns (the hero header, the sheet, [IconInfoRow]), the same
/// way the Language row was added to Profile.
class SupportScreen extends BaseScreen {
  final SupportChannels channels;

  const SupportScreen({super.key, required this.channels});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends BaseScreenState<SupportScreen> {
  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CollapsingHeaderSheet(
      initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
      header: GraviaHeroHeader(
        title: ValueConst.helpAndSupportLabel,
        onBack: () => context.pop(),
      ),
      body: Padding(
        // The sheet scrolls to the device edge, so the last row re-adds the
        // bottom inset itself.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ValueConst.supportIntro,
              style: GraviaTextStyleConst.textMdRegular(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
            for (final section in widget.channels.sections) ...[
              const SizedBox(height: AppSpacing.xl2),
              Text(
                section.title,
                style: GraviaTextStyleConst.textMdBold(
                  tt,
                ).copyWith(color: cs.primary),
              ),
              if (section.subtitle.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  section.subtitle,
                  style: GraviaTextStyleConst.textSmRegular(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: AppSpacing.xs),
              for (final channel in section.channels)
                IconInfoRow(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.base,
                  ),
                  leading: AppIconCircle(
                    size: supportGlyphCircleSize,
                    color: cs.surfaceContainerLow,
                    child: Icon(
                      supportChannelGlyph(channel.kind),
                      size: supportGlyphSize,
                      color: cs.onSurface,
                    ),
                  ),
                  title: channel.label,
                  subtitle: channel.value.isEmpty ? null : channel.value,
                  titleStyle: GraviaTextStyleConst.textMdMedium(
                    tt,
                  ).copyWith(color: cs.onSurface),
                  subtitleStyle: GraviaTextStyleConst.textSmRegular(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                  trailing: AppSvgImage.asset(
                    GraviaImageConst.directionRight,
                    color: cs.onSurfaceVariant,
                    width: AppSpacing.xl,
                    height: AppSpacing.xl,
                  ),
                  onTap: () => context.openSupportChannel(channel),
                ),
              if (section.note.isNotEmpty)
                Text(
                  section.note,
                  style: GraviaTextStyleConst.textSmRegular(
                    tt,
                  ).copyWith(color: GraviaColorConst.gray500),
                ),
            ],
            if (widget.channels.versionLabel.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl2),
              Text(
                widget.channels.versionLabel,
                style: GraviaTextStyleConst.textSmRegular(
                  tt,
                ).copyWith(color: GraviaColorConst.gray500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
