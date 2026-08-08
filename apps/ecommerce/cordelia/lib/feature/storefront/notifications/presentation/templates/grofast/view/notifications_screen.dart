import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/notification_kind.dart';
import 'package:cordelia/feature/storefront/notifications/domain/entities/notification_entity.dart';
import 'package:cordelia/feature/storefront/notifications/domain/entities/notification_section_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../widgets/notifications_skeleton_body.dart';
import '../../../bloc/notifications_bloc.dart';
import '../../../notifications_permission_body.dart';

/// `grofast` template's Notifications (kit frame `168:2316`) — My Orders'
/// exact layout minus the search row: the `Button-Text/Big` chip row over
/// the pack's 100-tall cards.
///
/// The chips are **All + the feed's own section titles** ("Now", "Past", and
/// whatever else the mock ships) — section titles are data, so the row can't
/// be a fixed enum. Which chip is selected is UI-local view state, same as a
/// tab index; the sections themselves come from the shared bloc untouched.
///
/// The kit's per-card map thumbnail stays dropped (nothing stores an order's
/// route) — the card's well carries the kind's tinted glyph disc instead
/// (spec sheet §11).
class NotificationsScreen extends BaseScreen {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends BaseScreenState<NotificationsScreen> {
  /// 0 = All; `i + 1` = `sections[i]`. An index, not a title — two sections
  /// with the same title would make a title ambiguous.
  int _selectedChip = 0;

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  List<NotificationSectionEntity> _visible(
    List<NotificationSectionEntity> sections,
  ) {
    final nonEmpty = sections.where((s) => s.notifications.isNotEmpty).toList();
    if (_selectedChip == 0) return nonEmpty;
    final index = _selectedChip - 1;
    if (index >= nonEmpty.length) return nonEmpty;
    return [nonEmpty[index]];
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        // The pack renders its own error view, so this listener exists for
        // the one thing that has nowhere on the page to live: the OS
        // declining to ask about notifications a second time.
        listener: (context, state) {
          if (state case NotificationsPermissionRequired(blocked: true)) {
            showSnackBar(ValueConst.notificationsPermissionBlockedMessage);
          }
        },
        builder: (context, state) => GrofastScreenBody(
          title: GrofastValueConst.notificationsTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl4,
          body: GrofastSwitcher(
            child: switch (state) {
              NotificationsLoading() =>
                const GrofastNotificationsSkeletonBody(),
              NotificationsPermissionRequired(:final requesting) =>
                NotificationsPermissionBody(
                  icon: Icons.notifications_off_rounded,
                  action: GrofastPrimaryButton(
                    label: ValueConst.notificationsPermissionCta,
                    state: requesting
                        ? AppButtonState.loading
                        : AppButtonState.idle,
                    onTap: () => context.read<NotificationsBloc>().add(
                      const NotificationsEvent.permissionRequested(),
                    ),
                  ),
                ),
              NotificationsError(:final message) => GrofastErrorView(
                message: message,
                onRetry: () => context.read<NotificationsBloc>().add(
                  const NotificationsEvent.started(),
                ),
              ),
              NotificationsLoaded(:final sections)
                  when sections.every((s) => s.notifications.isEmpty) =>
                GrofastEmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: GrofastValueConst.notificationsEmptyTitle,
                  subtitle: GrofastValueConst.notificationsEmptySubtitle,
                ),
              NotificationsLoaded(:final sections) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GrofastChipRow(
                    big: true,
                    labels: [
                      GrofastValueConst.notificationsFilterAllLabel,
                      for (final section in sections)
                        if (section.notifications.isNotEmpty) section.title,
                    ],
                    selectedIndex: _selectedChip,
                    onSelected: (index) =>
                        setState(() => _selectedChip = index),
                  ),
                  const SizedBox(height: AppSpacing.xl4),
                  for (final section in _visible(sections)) ...[
                    for (final notification in section.notifications) ...[
                      _NotificationCard(notification: notification),
                      const SizedBox(height: AppSpacing.base),
                    ],
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

/// One notification, on the same 100-tall card as an order (kit `168:2513`):
/// the kind's tinted glyph disc where the order card puts its photo, the
/// title over a hairline, and the message beneath. When the sender attached
/// artwork the card grows to carry it under that row — the kit has no frame
/// for this, so it reuses the card's own corner rather than inventing a shape.
class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationCard({required this.notification});

  /// The shape the console asks senders to upload at, so a picture that
  /// looked right in the composer isn't cropped differently here than it is
  /// in the push banner.
  static const double _artworkAspect = 2;

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

    final row = SizedBox(
      height: GrofastDimenConst.orderCardHeight,
      child: Row(
        children: [
          SizedBox.square(
            dimension: GrofastDimenConst.orderCardHeight,
            child: Center(
              child: Container(
                width: GrofastDimenConst.menuRowHeight,
                height: GrofastDimenConst.menuRowHeight,
                decoration: BoxDecoration(
                  // The disc needs its own step off the card it sits on.
                  color: cs.surface,
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
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GrofastTextStyleConst.cardTitleBold(tt),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Divider(height: 1, color: cs.outlineVariant),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GrofastTextStyleConst.bodySmall(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(GrofastDimenConst.tileRadius),
      child: notification.imageUrl.isEmpty
          ? row
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                row,
                Padding(
                  // Inset on three sides so the artwork sits *inside* the
                  // card rather than re-cutting its corners; flush to the
                  // row above, which already ends on its own padding.
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      GrofastDimenConst.tileRadius,
                    ),
                    child: AspectRatio(
                      aspectRatio: _artworkAspect,
                      child: AppNetworkImage(url: notification.imageUrl),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
