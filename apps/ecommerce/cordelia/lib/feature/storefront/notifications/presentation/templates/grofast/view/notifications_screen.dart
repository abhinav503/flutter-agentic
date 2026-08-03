import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/enums/notification_kind.dart';
import 'package:cordelia/feature/storefront/notifications/domain/entities/notification_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../bloc/notifications_bloc.dart';

/// `grofast` template's Notifications (kit frame `119:942`) — the kit's
/// "Now" / "Past" sections, each a run of rows carrying a tinted kind glyph.
///
/// Deviations from the frame, both for want of data: the kit's per-card
/// **map** thumbnail is dropped (nothing stores an order's route), and its
/// status filter chips are dropped with it — the shared notifications feed is
/// a per-template mock of mixed kinds, not an order list to filter (spec
/// sheet §11).
class NotificationsScreen extends BaseScreen {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends BaseScreenState<NotificationsScreen> {
  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) => GrofastScreenBody(
          title: GrofastValueConst.notificationsTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl4,
          body: GrofastSwitcher(
            child: switch (state) {
              NotificationsLoading() => const _NotificationsSkeletonBody(),
              NotificationsError(:final message, :final template) =>
                GrofastErrorView(
                  message: message,
                  onRetry: () => context.read<NotificationsBloc>().add(
                    NotificationsEvent.started(template: template),
                  ),
                ),
              NotificationsLoaded(:final sections)
                  when sections.every((s) => s.notifications.isEmpty) =>
                const GrofastEmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: GrofastValueConst.notificationsEmptyTitle,
                  subtitle: GrofastValueConst.notificationsEmptySubtitle,
                ),
              NotificationsLoaded(:final sections) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final section in sections) ...[
                    Row(
                      children: [
                        Text(
                          section.title,
                          style: GrofastTextStyleConst.sectionBold(
                            Theme.of(context).textTheme,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.base),
                        _CountPill(count: section.notifications.length),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final notification in section.notifications) ...[
                      _NotificationRow(notification: notification),
                      const SizedBox(height: AppSpacing.base),
                    ],
                    const SizedBox(height: AppSpacing.xl4),
                  ],
                ],
              ),
            },
          ),
        ),
      ),
    );
  }
}

/// The kit sets a small green count beside each section title.
class _CountPill extends StatelessWidget {
  final int count;

  const _CountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.xs4,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(AppSpacing.base),
      ),
      child: Text(
        '$count',
        style: GrofastTextStyleConst.meta(tt).copyWith(color: cs.onPrimary),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationRow({required this.notification});

  /// Each pack maps the shared [NotificationKind]s onto its own glyphs; this
  /// one has exported artwork for three of them and falls back to a Material
  /// symbol for the rest (spec sheet §5).
  ({String? asset, IconData? icon}) get _glyph => switch (notification.kind) {
    NotificationKind.discount => (asset: GrofastImageConst.gift, icon: null),
    NotificationKind.orderPlaced => (
      asset: GrofastImageConst.check,
      icon: null,
    ),
    NotificationKind.orderDelivered => (
      asset: GrofastImageConst.check,
      icon: null,
    ),
    NotificationKind.payment => (asset: null, icon: Icons.payments_rounded),
    NotificationKind.security => (asset: null, icon: Icons.shield_rounded),
    NotificationKind.account => (asset: null, icon: Icons.person_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final glyph = _glyph;

    return IconInfoRow(
      leading: Container(
        width: GrofastDimenConst.menuRowHeight,
        height: GrofastDimenConst.menuRowHeight,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: glyph.asset != null
            ? AppSvgImage.asset(
                glyph.asset!,
                width: AppSpacing.xl4,
                height: AppSpacing.xl4,
                color: cs.primary,
              )
            : Icon(glyph.icon, size: AppSpacing.xl4, color: cs.primary),
      ),
      title: notification.title,
      subtitle: notification.message,
      titleStyle: GrofastTextStyleConst.rowTitleBold(tt),
      subtitleStyle: GrofastTextStyleConst.bodySmall(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
    );
  }
}

class _NotificationsSkeletonBody extends StatelessWidget {
  const _NotificationsSkeletonBody();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerSectionHeader(),
      SizedBox(height: AppSpacing.lg),
      ShimmerListRow(itemCount: 5),
    ],
  );
}
