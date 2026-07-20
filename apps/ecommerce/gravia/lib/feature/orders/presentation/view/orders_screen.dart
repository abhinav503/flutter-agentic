import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_tab.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../domain/entities/order_entity.dart';
import '../bloc/orders_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_filter_sheet_content.dart';
import '../widgets/orders_segmented_tab_bar.dart';
import '../widgets/orders_skeleton_body.dart';

class OrdersScreen extends BaseScreen {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseScreenState<OrdersScreen> {
  @override
  Widget body(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state case OrdersError(:final message)) showSnackBar(message);
          // Warm-start background refresh failed — cached content is still
          // showing, so this is a toast, not an error view.
          if (state case OrdersLoaded(refreshFailed: true)) {
            showSnackBar(ValueConst.ordersRefreshFailedMessage);
          }
        },
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state) {
            OrdersLoading() => CollapsingHeaderSheet(
              key: const ValueKey('loading'),
              initialHeaderHeight: 190,
              header: GraviaHeroHeader.page(
                title: ValueConst.ordersPageTitle,
                bottomGap: AppSpacing.lg,
                // Static Past tab — real selection/filter data doesn't exist
                // yet, so the tab bar is a non-interactive placeholder that
                // keeps the header the same height as the loaded state.
                bottom: OrdersSegmentedTabBar(
                  selected: OrdersTab.past,
                  onChanged: (_) {},
                ),
              ),
              body: const OrdersSkeletonBody(),
            ),
            OrdersError() => SafeArea(
              key: const ValueKey('error'),
              child: ErrorView(
                message: ValueConst.ordersLoadErrorMessage,
                onRetry: () =>
                    context.read<OrdersBloc>().add(const OrdersEvent.started()),
              ),
            ),
            OrdersLoaded(:final orders, :final selectedTab, :final filter) =>
              _buildLoaded(context, orders, selectedTab, filter),
          },
        ),
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    List<OrderEntity> orders,
    OrdersTab selectedTab,
    OrdersFilter? filter,
  ) {
    // The filter is a Past-tab feature — Upcoming is the handful of live
    // orders, so it gets no filter button and ignores any applied filter.
    final isPast = selectedTab == OrdersTab.past;
    final visible = orders
        .where(
          (o) =>
              o.status.isUpcoming == !isPast &&
              (!isPast || filter == null || filter.matches(o)),
        )
        .toList();

    return CollapsingHeaderSheet(
      key: const ValueKey('loaded'),
      initialHeaderHeight: 190,
      header: GraviaHeroHeader.page(
        title: ValueConst.ordersPageTitle,
        // Always laid out, faded on Upcoming — dropping it to null shrinks
        // the title row by the glass disc's height and the whole header
        // visibly jumps on every tab switch. The fade runs on the segmented
        // bar's own duration so both read as one tab transition.
        trailing: IgnorePointer(
          ignoring: !isPast,
          child: AnimatedOpacity(
            opacity: isPast ? 1 : 0,
            duration: OrdersSegmentedTabBar.slideDuration,
            child: GraviaGlassIconButton(
              asset: ImageConst.filter,
              onTap: () => _showFilterSheet(context, orders, filter),
            ),
          ),
        ),
        bottomGap: AppSpacing.lg,
        bottom: OrdersSegmentedTabBar(
          selected: selectedTab,
          onChanged: (tab) =>
              context.read<OrdersBloc>().add(OrdersEvent.tabChanged(tab: tab)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl2,
        ),
        child: visible.isEmpty
            ? const EmptyState(
                iconData: Icons.shopping_bag_outlined,
                title: ValueConst.ordersEmptyTitle,
                subtitle: ValueConst.ordersEmptySubtitle,
              )
            : Column(
                children: [
                  for (var i = 0; i < visible.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.xl2),
                    OrderCard(
                      order: visible[i],
                      onCancel: () => context.read<OrdersBloc>().add(
                        OrdersEvent.cancelled(orderId: visible[i].id),
                      ),
                      onTrackOrder: () =>
                          showSnackBar(ValueConst.comingSoonMessage),
                      onViewDetails: () =>
                          showSnackBar(ValueConst.comingSoonMessage),
                      onWriteReview: () =>
                          showSnackBar(ValueConst.comingSoonMessage),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    List<OrderEntity> orders,
    OrdersFilter? applied,
  ) {
    final bloc = context.read<OrdersBloc>();
    final now = DateTime.now();
    final earliest = orders.fold<DateTime?>(
      null,
      (first, o) =>
          first == null || o.placedAt.isBefore(first) ? o.placedAt : first,
    );

    showGraviaSheet(
      title: ValueConst.filterSheetTitle,
      child: OrdersFilterSheetContent(
        initialFilter: applied ?? OrdersFilter(from: earliest ?? now, to: now),
        anchor: now,
        showSheet: ({required title, required child}) =>
            showGraviaSheet<void>(title: title, child: child),
        onApply: (filter) {
          Navigator.pop(context);
          bloc.add(OrdersEvent.filterApplied(filter: filter));
        },
      ),
    );
  }
}
