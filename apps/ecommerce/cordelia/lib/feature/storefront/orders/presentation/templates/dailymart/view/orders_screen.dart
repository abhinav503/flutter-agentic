import 'package:cordelia/constants/value_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/orders_status_filter.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_filter_chip.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_filter_pill.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_search_input.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../domain/entities/order_entity.dart';
import '../../../bloc/orders_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_filter_sheet_content.dart';
import '../widgets/orders_skeleton_body.dart';

/// `dailymart` template's My Orders (kit frame `35`) — a search field, a
/// status chip row, and the shopper's orders as tinted cards, each with an
/// inline Track Order action.
///
/// Reached by pushing [AppRoutes.orders] from the Profile tab's My Orders
/// row: this template's shell has four tabs and none of them is Orders, so
/// unlike gravia (where the same list *is* a tab) this is an ordinary pushed
/// screen. The kit's own frame draws the bottom nav under it with the Cart
/// tab lit, which no navigation in either app would produce — that's kit
/// boilerplate, not a spec, so it isn't reproduced.
///
/// Search and the chips narrow the already-fetched list through
/// `OrdersBloc`; neither re-queries the backend. Cancel isn't drawn here —
/// the kit gives the card one action — it lives on Track Order.
class OrdersScreen extends BaseScreen {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseScreenState<OrdersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  /// The date-only filter sheet behind the floating pill. Both exits (Reset
  /// and Apply) come back through `onApply` — a null filter is "no date
  /// constraint", so one path covers clearing and committing.
  Future<void> _openFilterSheet(OrdersFilter? current) => showDailyMartSheet(
    title: DailyMartValueConst.filterLabel,
    child: DailyMartOrdersFilterSheetContent(
      initialFilter: current,
      anchor: DateTime.now(),
      onApply: (filter) {
        context.read<OrdersBloc>().add(
          OrdersEvent.filterApplied(filter: filter),
        );
        Navigator.of(context).pop();
      },
    ),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        // The Filter pill re-adds the device inset itself (see below), so the
        // fade behind it can bleed to the edge.
        bottom: false,
        child: BlocConsumer<OrdersBloc, OrdersState>(
          listener: (context, state) {
            if (state case OrdersLoaded(cancelFailed: true)) {
              showSnackBar(DailyMartValueConst.orderCancelFailedMessage);
            }
            if (state case OrdersLoaded(rateFailed: true)) {
              showSnackBar(ValueConst.orderRatingFailedMessage);
            }
            if (state case OrdersLoaded(refreshFailed: true)) {
              showSnackBar(DailyMartValueConst.ordersRefreshFailedMessage);
            }
          },
          builder: (context, state) => Stack(
            // The scroll view shrink-wraps its content; without expanding, a
            // short list ends the stack early and the positioned fade + pill
            // pin to the content's bottom edge, not the device's.
            fit: StackFit.expand,
            children: [
              DailyMartTopSwitcher(
                child: switch (state) {
                  OrdersLoading() => const _Page(
                    key: ValueKey('loading'),
                    body: DailyMartOrdersSkeletonBody(),
                  ),
                  OrdersError() => _Page(
                    key: const ValueKey('error'),
                    body: ErrorView(
                      message: DailyMartValueConst.ordersLoadErrorMessage,
                      onRetry: () => context.read<OrdersBloc>().add(
                        const OrdersEvent.started(),
                      ),
                    ),
                  ),
                  final OrdersLoaded loaded => _Page(
                    key: const ValueKey('loaded'),
                    floatsFilterPill: true,
                    controls: _Controls(
                      controller: _searchController,
                      selected: loaded.statusFilter,
                    ),
                    body: _List(state: loaded, onTrack: _openTrackOrder),
                  ),
                },
              ),
              // Loaded only: there is nothing to filter behind a skeleton,
              // and an error state has no list to narrow.
              if (state case final OrdersLoaded loaded) ...[
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DailyMartBottomFade(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
                  child: Center(
                    child: DailyMartFilterPill(
                      active: loaded.filter != null,
                      onTap: () => _openFilterSheet(loaded.filter),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The search field + chip row. Only the loaded state shows them: filtering
/// a skeleton is meaningless, and an error state has no list to narrow.
class _Controls extends StatelessWidget {
  final TextEditingController controller;
  final OrdersStatusFilter selected;

  const _Controls({required this.controller, required this.selected});

  // A getter, not `static const`: the labels come from L10n and a
  // class-lifetime cache would pin whichever language was active first.
  static List<(OrdersStatusFilter, String)> get _chips => [
    (OrdersStatusFilter.all, DailyMartValueConst.ordersFilterAllLabel),
    (OrdersStatusFilter.active, DailyMartValueConst.ordersFilterActiveLabel),
    (
      OrdersStatusFilter.completed,
      DailyMartValueConst.ordersFilterCompletedLabel,
    ),
    (
      OrdersStatusFilter.cancelled,
      DailyMartValueConst.ordersFilterCancelledLabel,
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DailyMartSearchInput(
        controller: controller,
        hint: DailyMartValueConst.ordersSearchHint,
        onChanged: (term) =>
            context.read<OrdersBloc>().add(OrdersEvent.searched(term: term)),
      ),
      const SizedBox(height: AppSpacing.lg),
      // Scrolls: the kit's fourth chip is already clipped at 375pt, so the
      // row has to move rather than wrap or shrink its labels.
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (filter, label) in _chips) ...[
              if (filter != _chips.first.$1)
                const SizedBox(width: AppSpacing.sm),
              DailyMartFilterChip(
                label: label,
                selected: filter == selected,
                onTap: () => context.read<OrdersBloc>().add(
                  OrdersEvent.statusFilterChanged(filter: filter),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class _List extends StatelessWidget {
  final OrdersLoaded state;
  final ValueChanged<OrderEntity> onTrack;

  const _List({required this.state, required this.onTrack});

  @override
  Widget build(BuildContext context) {
    final filter = state.filter;
    final orders = [
      for (final order in state.orders)
        if (state.statusFilter.matches(order) &&
            order.matchesSearch(state.searchTerm) &&
            (filter?.matches(order) ?? true))
          order,
    ];

    if (orders.isEmpty) {
      // Two different nothings: a shopper with no orders at all needs a
      // different sentence from one whose filter simply excluded them.
      final unfiltered =
          state.orders.isEmpty &&
          state.searchTerm.isEmpty &&
          filter == null &&
          state.statusFilter == OrdersStatusFilter.all;
      return EmptyState(
        iconData: Icons.receipt_long_outlined,
        title: unfiltered
            ? DailyMartValueConst.ordersEmptyTitle
            : DailyMartValueConst.ordersNoResultsTitle,
        subtitle: unfiltered
            ? DailyMartValueConst.ordersEmptySubtitle
            : DailyMartValueConst.ordersNoResultsSubtitle,
      );
    }

    return Column(
      children: [
        for (var i = 0; i < orders.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.lg),
          DailyMartOrderCard(
            order: orders[i],
            // Only the All chip mixes statuses, so only it needs each card
            // to name its own.
            showStatus: state.statusFilter == OrdersStatusFilter.all,
            onTrack: () => onTrack(orders[i]),
          ),
        ],
      ],
    );
  }
}

/// The page shell every state sits in. The floating Filter pill lives
/// *outside* the state switcher (only the loaded state shows it), so the
/// loaded page pays the CTA clearance directly; the others clear the device
/// inset alone via the shell's default.
class _Page extends StatelessWidget {
  final Widget? controls;
  final Widget body;

  /// Only the loaded state floats the Filter pill, so only it needs the
  /// taller bottom inset.
  final bool floatsFilterPill;

  const _Page({
    super.key,
    this.controls,
    required this.body,
    this.floatsFilterPill = false,
  });

  @override
  Widget build(BuildContext context) => DailyMartScreenBody(
    title: DailyMartValueConst.myOrdersTitle,
    onBack: () => context.pop(),
    bottomInset: floatsFilterPill
        ? DailyMartDimenConst.floatingActionScrollInset(context)
        : null,
    body: controls == null
        ? body
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controls!,
              const SizedBox(height: AppSpacing.xl4),
              body,
            ],
          ),
  );
}
