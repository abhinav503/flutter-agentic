import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';

import '../../domain/entities/notification_section_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_row.dart';

class NotificationsScreen extends BaseScreen {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends BaseScreenState<NotificationsScreen> {
  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state case NotificationsError(:final message)) {
            showSnackBar(message);
          }
        },
        builder: (context, state) => switch (state) {
          NotificationsLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          NotificationsError() => SafeArea(
            child: ErrorView(
              message: ValueConst.notificationsLoadErrorMessage,
              onRetry: () => context.read<NotificationsBloc>().add(
                const NotificationsEvent.started(),
              ),
            ),
          ),
          NotificationsLoaded(:final sections) => _buildLoaded(
            context,
            sections,
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

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: 110,
            header: GraviaHeroHeader(
              title: ValueConst.notificationsTitle,
              onBack: () => context.pop(),
            ),
            body: sections.isEmpty
                ? const EmptyState(
                    iconData: Icons.notifications_none,
                    title: ValueConst.notificationsEmptyTitle,
                    subtitle: ValueConst.notificationsEmptySubtitle,
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
                            titleStyle: TextStyleConst.textLgBold(
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
                              Divider(color: cs.sheetHairline, height: 1),
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
