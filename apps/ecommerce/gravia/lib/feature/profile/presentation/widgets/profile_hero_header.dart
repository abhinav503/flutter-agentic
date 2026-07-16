import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';

import '../../domain/entities/profile_entity.dart';

/// [GraviaHeroHeader.page] for Profile: the bold page title over an identity
/// row — avatar, name, email, and a glass edit trigger.
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
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    return GraviaHeroHeader.page(
      title: ValueConst.profilePageTitle,
      bottomGap: AppSpacing.lg,
      bottom: Row(
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
                  style: TextStyleConst.textMdBold(
                    tt,
                  ).copyWith(color: onOverlay),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  profile.email,
                  style: TextStyleConst.textSmRegular(
                    tt,
                  ).copyWith(color: onOverlay),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GraviaGlassIconButton(
            asset: ImageConst.editRectangle,
            onTap: onEditTap,
          ),
        ],
      ),
    );
  }
}
