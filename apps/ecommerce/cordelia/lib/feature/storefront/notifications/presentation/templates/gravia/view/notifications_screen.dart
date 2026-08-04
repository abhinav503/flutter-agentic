import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/templates/gravia/widgets/gravia_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import '../../../../domain/entities/notification_section_entity.dart';
import '../../../bloc/notifications_bloc.dart';
import '../widgets/notification_row.dart';
import '../widgets/notifications_skeleton_body.dart';

class NotificationsScreen extends BaseScreen {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends BaseScreenState<NotificationsScreen> {
  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
      listener: (context, state) {
        if (state case NotificationsError(:final message)) {
          showSnackBar(message);
        }
      },
      builder: (context, state) => GraviaSwitcher(
        child: switch (state) {
          NotificationsLoading() => CollapsingHeaderSheet(
            key: const ValueKey('loading'),
            initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
            header: GraviaHeroHeader(
              title: GraviaValueConst.notificationsTitle,
              onBack: () => context.pop(),
            ),
            body: const NotificationsSkeletonBody(),
          ),
          NotificationsError() => SafeArea(
            key: const ValueKey('error'),
            child: ErrorView(
              message: GraviaValueConst.notificationsLoadErrorMessage,
              onRetry: () => context.read<NotificationsBloc>().add(
                const NotificationsEvent.started(),
              ),
            ),
          ),
          NotificationsLoaded(:final sections) => KeyedSubtree(
            key: const ValueKey('loaded'),
            child: _buildLoaded(context, sections),
          ),
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    List<NotificationSectionEntity> sections,
  ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final sheetHairline = context.appColors.sheetHairline;

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
            header: GraviaHeroHeader(
              title: GraviaValueConst.notificationsTitle,
              onBack: () => context.pop(),
            ),
            body: sections.isEmpty
                ? const EmptyState(
                    iconData: Icons.notifications_none,
                    title: GraviaValueConst.notificationsEmptyTitle,
                    subtitle: GraviaValueConst.notificationsEmptySubtitle,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl2,
                      AppSpacing.lg,
                      AppSpacing.xl4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var s = 0; s < sections.length; s++) ...[
                          if (s > 0) const SizedBox(height: AppSpacing.xl4),
                          SectionHeader(
                            title: sections[s].title,
                            titleStyle: GraviaTextStyleConst.textLgBold(
                              tt,
                            ).copyWith(color: cs.onSurface),
                          ),
                          const SizedBox(height: AppSpacing.base),
                          for (
                            var i = 0;
                            i < sections[s].notifications.length;
                            i++
                          ) ...[
                            if (i > 0) ...[
                              const SizedBox(height: AppSpacing.base),
                              Divider(color: sheetHairline, height: 1),
                              const SizedBox(height: AppSpacing.base),
                            ],
                            NotificationRow(
                              notification: sections[s].notifications[i],
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
