import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';

import '../../../../domain/entities/profile_entity.dart';

/// Profile's identity block — a 64px avatar beside the shopper's name and
/// email. Flat on the surface with no header canvas and no edit affordance
/// of its own: this pack puts editing behind the "Edit Profile" row below
/// (spec sheet §8 — no coloured header anywhere), unlike gravia's
/// `ProfileHeroHeader`, where the avatar itself is the edit trigger.
class ProfileIdentityHeader extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileIdentityHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        CordeliaAvatarImage(
          profile: profile,
          size: DailyMartDimenConst.profileAvatarSize,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DailyMartTextStyleConst.bodyLgBold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.xs4),
              Text(
                profile.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DailyMartTextStyleConst.bodySmRegular(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
