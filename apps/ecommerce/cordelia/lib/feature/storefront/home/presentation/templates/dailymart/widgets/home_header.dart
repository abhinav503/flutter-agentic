import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_search_bar.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';

/// Home's header: shopper avatar + name, the selected delivery address, a
/// notification bell, and the search bar beneath.
///
/// Not a `HeaderCanvas`/`HeroHeader` — DailyMart has no coloured header
/// treatment (spec sheet §8). This is just the first block of the page,
/// sitting on the same mint canvas as everything below it and scrolling away
/// with the rest.
///
/// The kit draws an unread count on the bell. Nothing in this app exposes an
/// unread notification count yet, so the badge is omitted rather than
/// hardcoded to the kit's "12" — it lands when the count does.
class DailyMartHomeHeader extends StatelessWidget {
  final String addressLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;

  /// Scopes the search bar's Hero tag — see [DailyMartSearchBar.heroTagFor].
  final String storeId;

  const DailyMartHomeHeader({
    super.key,
    required this.addressLabel,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onSearchTap,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const _Avatar(),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Identity(
                addressLabel: addressLabel,
                onLocationTap: onLocationTap,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            DailyMartIconDisc.outlined(
              asset: DailyMartImageConst.notification,
              onTap: onNotificationTap,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        DailyMartSearchBar(
          onTap: onSearchTap,
          heroTag: DailyMartSearchBar.heroTagFor(storeId),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    const size = DailyMartDimenConst.headerControlHeight;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) => switch (state) {
        ProfileLoaded(:final profile) => CordeliaAvatarImage(
          profile: profile,
          size: size,
        ),
        // Profile not resolved yet — the same default portrait the avatar
        // falls back to, so the frame never flips from glyph to photo.
        _ => ClipOval(
          child: Image.asset(
            ImageConst.profileDefault,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      },
    );
  }
}

class _Identity extends StatelessWidget {
  final String addressLabel;
  final VoidCallback onLocationTap;

  const _Identity({required this.addressLabel, required this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) => switch (state) {
            ProfileLoaded(:final profile) => Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DailyMartTextStyleConst.bodyMdSemibold(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
            // A guest has a settled answer, so it gets text rather than a
            // placeholder that would shimmer for the whole session.
            ProfileSignedOut() => Text(
              ValueConst.guestLabel,
              style: DailyMartTextStyleConst.bodyMdSemibold(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
            // Sized to the line it replaces so the address row beneath
            // doesn't jump when the name arrives.
            _ => const ShimmerBox(width: 120, height: 18),
          },
        ),
        InkWell(
          onTap: onLocationTap,
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: AppSpacing.lg,
                color: cs.onSurface,
              ),
              const SizedBox(width: AppSpacing.xs4),
              Flexible(
                child: Text(
                  addressLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DailyMartTextStyleConst.bodySmRegular(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppSpacing.lg,
                color: cs.onSurface,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
