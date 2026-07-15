import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/profile_entity.dart';

/// The coloured header canvas for Profile: a bold page title (same
/// Text/xl/bold treatment as [CategoriesHeroHeader]'s) over an identity row
/// — avatar, name, email, and a glass edit trigger — the pack's signature
/// "coloured header canvas" composition (docs/ai-rules/design.md).
class ProfileHeroHeader extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEditTap;

  const ProfileHeroHeader({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  static const _avatarSize = 56.0;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topInset + AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ValueConst.profilePageTitle,
            style: TextStyleConst.textXlBold(tt).copyWith(color: onOverlay),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: _avatarSize,
                  height: _avatarSize,
                  child: AppNetworkImage(
                    url: profile.avatarUrl,
                    fit: BoxFit.cover,
                    assetPlaceholder: ImageConst.profileDefault,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.name,
                      style: TextStyleConst.textMdBold(tt).copyWith(color: onOverlay),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs4),
                    Text(
                      profile.email,
                      style: TextStyleConst.textSmRegular(tt).copyWith(color: onOverlay),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppIconButton(
                iconBuilder: (color, size) => AppSvgImage.asset(
                  ImageConst.editRectangle,
                  color: color,
                  width: size,
                  height: size,
                ),
                containerSize: 45,
                iconSize: 20,
                variant: AppIconButtonVariant.glass,
                onTap: onEditTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
