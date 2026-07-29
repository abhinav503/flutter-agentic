import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import '../../../../domain/entities/profile_entity.dart';

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
    final onOverlay = context.appColors.onOverlay;

    return GraviaHeroHeader.page(
      title: ValueConst.profilePageTitle,
      bottomGap: AppSpacing.lg,
      bottom: Row(
        children: [
          CordeliaAvatarImage(profile: profile, size: _avatarSize),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  style: GraviaTextStyleConst.textMdBold(
                    tt,
                  ).copyWith(color: onOverlay),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  profile.email,
                  style: GraviaTextStyleConst.textSmRegular(
                    tt,
                  ).copyWith(color: onOverlay),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GraviaGlassIconButton(
            asset: GraviaImageConst.editRectangle,
            onTap: onEditTap,
          ),
        ],
      ),
    );
  }
}
