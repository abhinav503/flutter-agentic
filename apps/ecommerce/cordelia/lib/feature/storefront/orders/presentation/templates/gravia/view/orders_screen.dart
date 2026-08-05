import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/enums/orders_tab.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/templates/gravia/widgets/gravia_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import '../../../../../reviews/presentation/templates/gravia/widgets/write_review_sheet_content.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../bloc/orders_bloc.dart';
import '../../../order_review_actions.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_filter_sheet_content.dart';
import '../widgets/orders_segmented_tab_bar.dart';
import '../widgets/orders_skeleton_body.dart';

class OrdersScreen extends BaseScreen {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseScreenState<OrdersScreen>
    with OrderReviewActions {
  @override
  Future<void> showRateOrderSheet({
    required int initialRating,
    required String initialText,
    required void Function(int rating, String text) onSubmit,
  }) => showGraviaSheet<void>(
    title: ValueConst.rateOrderSheetTitle,
    child: GraviaWriteReviewSheetContent(
      initialRating: initialRating,
      initialText: initialText,
      textLabel: ValueConst.rateOrderTextLabel,
      textHint: ValueConst.rateOrderTextHint,
      onSubmit: onSubmit,
      onMessage: showSnackBar,
    ),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state case OrdersError(:final message)) showSnackBar(message);
        // Warm-start background refresh failed — cached content is still
        // showing, so this is a toast, not an error view.
        if (state case OrdersLoaded(refreshFailed: true)) {
          showSnackBar(GraviaValueConst.ordersRefreshFailedMessage);
        }
        // Cancel failed and its optimistic update rolled back.
        if (state case OrdersLoaded(cancelFailed: true)) {
          showSnackBar(GraviaValueConst.cancelFailedMessage);
        }
        if (state case OrdersLoaded(rateFailed: true)) {
          showSnackBar(ValueConst.orderRatingFailedMessage);
        }
      },
      builder: (context, state) => GraviaSwitcher(
        child: switch (state) {
          OrdersLoading() => CollapsingHeaderSheet(
            key: const ValueKey('loading'),
            initialHeaderHeight: GraviaDimenConst.headerHeightTabs,
            header: GraviaHeroHeader.page(
              title: GraviaValueConst.ordersPageTitle,
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
              message: GraviaValueConst.ordersLoadErrorMessage,
              onRetry: () =>
                  context.read<OrdersBloc>().add(const OrdersEvent.started()),
            ),
          ),
          OrdersLoaded(:final orders, :final selectedTab, :final filter) =>
            _buildLoaded(context, orders, selectedTab, filter),
        },
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
      initialHeaderHeight: GraviaDimenConst.headerHeightTabs,
      header: GraviaHeroHeader.page(
        title: GraviaValueConst.ordersPageTitle,
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
              asset: GraviaImageConst.filter,
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
            ? EmptyState(
                iconData: Icons.shopping_bag_outlined,
                title: GraviaValueConst.ordersEmptyTitle,
                subtitle: GraviaValueConst.ordersEmptySubtitle,
              )
            : Column(
                children: [
                  for (var i = 0; i < visible.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.xl2),
                    OrderCard(
                      order: visible[i],
                      onCancel: () => _confirmCancel(context, visible[i].id),
                      onTrackOrder: () => _openTrackOrder(visible[i]),
                      // Track Order *is* the details view — it itemises the
                      // order, its totals and its timeline. A second screen
                      // saying the same thing for a past order would only
                      // differ by which of them has a live status.
                      onViewDetails: () => _openTrackOrder(visible[i]),
                      onWriteReview: () => rateOrder(visible[i]),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  /// Opens Track Order and, if it came back asking to cancel, dispatches
  /// that here — the bloc lives on this screen (its optimistic cancel and
  /// warm cache belong to this list), so the pushed screen reports the
  /// intent rather than owning a second instance of it.
  Future<void> _openTrackOrder(OrderEntity order) async {
    final cancelledId = await context.push<String>(
      AppRoutes.trackOrder,
      extra: order,
    );
    if (cancelledId == null || !mounted) return;
    context.read<OrdersBloc>().add(OrdersEvent.cancelled(orderId: cancelledId));
  }

  void _confirmCancel(BuildContext context, String orderId) {
    final bloc = context.read<OrdersBloc>();
    showGraviaConfirmSheet(
      context: context,
      title: GraviaValueConst.cancelOrderConfirmTitle,
      message: GraviaValueConst.cancelOrderConfirmBody,
      confirmLabel: GraviaValueConst.cancelOrderConfirmCta,
      onConfirm: () => bloc.add(OrdersEvent.cancelled(orderId: orderId)),
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
      title: GraviaValueConst.filterSheetTitle,
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
