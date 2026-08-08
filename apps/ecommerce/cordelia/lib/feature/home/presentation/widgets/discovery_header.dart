import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:cordelia/constants/cordelia_color_const.dart';
import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';
import 'package:cordelia/widgets/cordelia_brand_mark.dart';

import 'discovery_search_field.dart';

/// Discovery's coloured header: the brand lockup and the shopper's avatar,
/// a greeting, and the store search field — the platform's own front door,
/// before any store's template takes over the app's look.
class DiscoveryHeader extends StatelessWidget {
  /// Null until the profile resolves. The greeting renders without a name
  /// rather than with a placeholder that would visibly change a frame later.
  final ProfileEntity? profile;

  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;

  const DiscoveryHeader({
    super.key,
    required this.profile,
    required this.searchController,
    required this.onQueryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final onOverlay = context.appColors.onOverlay;
    final currentProfile = profile;

    return HeaderCanvas(
      bottomPadding: AppSpacing.lg,
      gradient: CordeliaColorConst.brandHeaderGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CordeliaBrandMark(),
              const Spacer(),
              if (currentProfile != null)
                CordeliaAvatarImage(
                  profile: currentProfile,
                  size: CordeliaDimenConst.discoveryAvatar,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            ValueConst.discoveryGreeting(
              _timeOfDayGreeting,
              currentProfile?.name.firstName,
            ),
            style: CordeliaTextStyleConst.displayXsBold(
              tt,
            ).copyWith(color: onOverlay),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.discoveryPrompt,
            style: CordeliaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: onOverlay.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: AppSpacing.lg),
          DiscoverySearchField(
            controller: searchController,
            onChanged: onQueryChanged,
          ),
        ],
      ),
    );
  }

  String get _timeOfDayGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return ValueConst.discoveryGreetingMorning;
    if (hour < 17) return ValueConst.discoveryGreetingAfternoon;
    return ValueConst.discoveryGreetingEvening;
  }
}

extension on String {
  /// The leading word of a full name, for a greeting that addresses the
  /// shopper rather than reciting their record. Null for a blank name so
  /// [ValueConst.discoveryGreeting] drops the comma too.
  String? get firstName {
    final trimmed = trim();
    if (trimmed.isEmpty) return null;
    return trimmed.split(RegExp(r'\s+')).first;
  }
}
