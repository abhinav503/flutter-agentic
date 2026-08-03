import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';

/// Home's identity band (kit frame `17:1`): the shopper's avatar, the
/// selected delivery address in a pill, and the notification bell — then the
/// greeting block beneath it.
///
/// Not a coloured header canvas: this pack has none (spec sheet §8). The band
/// is simply the first block of the page and scrolls away with everything
/// else.
///
/// The kit draws an unread count on the bell; nothing in this app exposes one
/// yet, so the badge is the plain dot rather than a hardcoded number.
class GrofastHomeHeader extends StatelessWidget {
  final String addressLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;

  const GrofastHomeHeader({
    super.key,
    required this.addressLabel,
    required this.onLocationTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Avatar(),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Center(
                child: _LocationPill(label: addressLabel, onTap: onLocationTap),
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            GrofastHeaderAction(
              asset: GrofastImageConst.bell,
              onTap: onNotificationTap,
              showDot: true,
              tooltip: GrofastValueConst.notificationsTitle,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl6),
        const _Greeting(),
        const SizedBox(height: AppSpacing.xs2),
        Text(
          GrofastValueConst.greetingSubtitle,
          style: GrofastTextStyleConst.bodyMedium(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// "Hey Yona 👋" — the shopper's first name off the shell's [ProfileBloc],
/// with a neutral fallback while it loads or if it never arrives, so the
/// greeting never renders half-written.
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final name = switch (state) {
          ProfileLoaded(:final profile) when profile.name.trim().isNotEmpty =>
            profile.name.trim().split(' ').first,
          _ => GrofastValueConst.greetingFallbackName,
        };

        return Text(
          GrofastValueConst.greeting(name),
          style: GrofastTextStyleConst.displayBold(tt),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) => switch (state) {
        ProfileLoaded(:final profile) => CordeliaAvatarImage(
          profile: profile,
          size: GrofastDimenConst.headerControlHeight,
        ),
        // Loading *and* error hold the same disc: a failed profile fetch
        // shouldn't leave a hole where the avatar goes, and the header has
        // no other way to report it (the screen's listener does).
        _ => const ShimmerBox.circle(
          size: GrofastDimenConst.headerControlHeight,
        ),
      },
    );
  }
}

/// The centred address pill. Outlined, not filled — the kit keeps Home's
/// header chrome as light as its back control.
class _LocationPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LocationPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.full,
        side: BorderSide(color: cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GrofastTextStyleConst.bodySmall(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.xs3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppSpacing.lg,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
