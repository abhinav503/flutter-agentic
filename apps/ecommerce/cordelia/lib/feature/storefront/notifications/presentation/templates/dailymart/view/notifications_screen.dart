import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/feature/storefront/template/storefront_template.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';

import '../../../../domain/entities/notification_section_entity.dart';
import '../../../bloc/notifications_bloc.dart';
import '../widgets/notification_row.dart';
import '../widgets/notifications_skeleton_body.dart';

/// `dailymart` template's Notifications — a plain white sheet with the pack's
/// own header row at the top of the scroll view, then dated sections of
/// icon-disc rows separated by hairlines (spec sheet §8: no app bar, no
/// coloured header, nothing pinned).
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
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state case NotificationsError(:final message)) {
              showSnackBar(message);
            }
          },
          builder: (context, state) => AppSwitcher(
            curve: Curves.easeInOut,
            child: switch (state) {
              NotificationsError() => KeyedSubtree(
                key: const ValueKey('error'),
                child: ErrorView(
                  message: DailyMartValueConst.notificationsLoadErrorMessage,
                  onRetry: () => context.read<NotificationsBloc>().add(
                    const NotificationsEvent.started(
                      template: StorefrontTemplate.dailymart,
                    ),
                  ),
                ),
              ),
              // Loading and loaded share the header and the scroll view, so
              // only the body swaps — a differently-structured loading
              // state makes the whole page jump when data lands.
              NotificationsLoading() => const _Page(
                key: ValueKey('loading'),
                body: DailyMartNotificationsSkeletonBody(),
              ),
              NotificationsLoaded(:final sections) => _Page(
                key: const ValueKey('loaded'),
                body: sections.isEmpty
                    ? const EmptyState(
                        iconData: Icons.notifications_none_rounded,
                        title: DailyMartValueConst.notificationsEmptyTitle,
                        subtitle:
                            DailyMartValueConst.notificationsEmptySubtitle,
                      )
                    : _Sections(sections: sections),
              ),
            },
          ),
        ),
      ),
    );
  }
}

/// The page shell the skeleton, the empty state and the list all sit in.
class _Page extends StatelessWidget {
  final Widget body;

  const _Page({super.key, required this.body});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.base,
      AppSpacing.lg,
      AppSpacing.xl10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyMartHeaderRow(
          title: DailyMartValueConst.notificationsTitle,
          onBack: () => context.pop(),
        ),
        const SizedBox(height: AppSpacing.lg),
        body,
      ],
    ),
  );
}

class _Sections extends StatelessWidget {
  final List<NotificationSectionEntity> sections;

  const _Sections({required this.sections});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var s = 0; s < sections.length; s++) ...[
          if (s > 0) const SizedBox(height: AppSpacing.lg),
          Text(
            sections[s].title,
            style: DailyMartTextStyleConst.bodyMdSemibold(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          for (var i = 0; i < sections[s].notifications.length; i++) ...[
            const SizedBox(height: AppSpacing.lg),
            NotificationRow(notification: sections[s].notifications[i]),
            // Hairline *between* rows only — the last row of a section is
            // closed by the next section's label, not by a rule.
            if (i < sections[s].notifications.length - 1) ...[
              const SizedBox(height: AppSpacing.lg),
              Divider(color: hairline, height: 1, thickness: 1),
            ],
          ],
        ],
      ],
    );
  }
}
