import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/enums/orders_status_filter.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_price.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../bloc/orders_bloc.dart';
import '../widgets/orders_date_filter_sheet_content.dart';

/// `grofast` template's My Orders. The kit ships no orders *list* frame — its
/// order surfaces are the three Tracking frames — so this is composed from
/// the recipe its Notification screen already establishes (a search field
/// over a chip row over stacked cards), which is exactly the shape an order
/// list needs (spec sheet §11).
///
/// Search and the status chips both narrow the already-fetched list through
/// the shared [OrdersBloc]; neither re-queries.
class OrdersScreen extends BaseScreen {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseScreenState<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const _statusFilters = OrdersStatusFilter.values;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _filterLabel(OrdersStatusFilter filter) => switch (filter) {
    OrdersStatusFilter.all => GrofastValueConst.ordersFilterAllLabel,
    OrdersStatusFilter.active => GrofastValueConst.ordersFilterActiveLabel,
    OrdersStatusFilter.completed =>
      GrofastValueConst.ordersFilterCompletedLabel,
    OrdersStatusFilter.cancelled =>
      GrofastValueConst.ordersFilterCancelledLabel,
  };

  void _openDateFilterSheet(OrdersLoaded state) {
    final bloc = context.read<OrdersBloc>();

    showGrofastSheet<void>(
      child: GrofastOrdersDateFilterSheetContent(
        initialFilter: state.filter,
        anchor: DateTime.now(),
        onApply: (filter) =>
            bloc.add(OrdersEvent.filterApplied(filter: filter)),
      ),
    );
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state case OrdersLoaded(refreshFailed: true)) {
            showSnackBar(GrofastValueConst.ordersRefreshFailedMessage);
          }
          if (state case OrdersLoaded(cancelFailed: true)) {
            showSnackBar(GrofastValueConst.orderCancelFailedMessage);
          }
        },
        builder: (context, state) => GrofastScreenBody(
          title: GrofastValueConst.myOrdersTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl2,
          body: GrofastSwitcher(
            child: switch (state) {
              OrdersLoading() => Column(
                children: [
                  for (var i = 0; i < 4; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.base),
                    const GrofastCardSkeleton(
                      height: GrofastDimenConst.orderCardHeight,
                      radius: GrofastDimenConst.tileRadius,
                    ),
                  ],
                ],
              ),
              OrdersError(:final message) => GrofastErrorView(
                message: message,
                onRetry: () =>
                    context.read<OrdersBloc>().add(const OrdersEvent.started()),
              ),
              OrdersLoaded(:final orders) when orders.isEmpty =>
                GrofastEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: GrofastValueConst.ordersEmptyTitle,
                  subtitle: GrofastValueConst.ordersEmptySubtitle,
                ),
              OrdersLoaded() => _OrdersContent(
                orders: state.orders
                    .where((order) => state.statusFilter.matches(order))
                    .where((order) => order.matchesSearch(state.searchTerm))
                    .where((order) => state.filter?.matches(order) ?? true)
                    .toList(),
                statusFilter: state.statusFilter,
                dateFilterActive: state.filter != null,
                filterLabels: [
                  for (final filter in _statusFilters) _filterLabel(filter),
                ],
                searchController: _searchController,
                onSearch: (term) => context.read<OrdersBloc>().add(
                  OrdersEvent.searched(term: term),
                ),
                onStatusFilter: (index) => context.read<OrdersBloc>().add(
                  OrdersEvent.statusFilterChanged(
                    filter: _statusFilters[index],
                  ),
                ),
                onDateFilter: () => _openDateFilterSheet(state),
                onOrderTap: (order) =>
                    context.push(AppRoutes.trackOrder, extra: order),
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _OrdersContent extends StatelessWidget {
  final List<OrderEntity> orders;
  final OrdersStatusFilter statusFilter;
  final bool dateFilterActive;
  final List<String> filterLabels;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final ValueChanged<int> onStatusFilter;
  final VoidCallback onDateFilter;
  final ValueChanged<OrderEntity> onOrderTap;

  const _OrdersContent({
    required this.orders,
    required this.statusFilter,
    required this.dateFilterActive,
    required this.filterLabels,
    required this.searchController,
    required this.onSearch,
    required this.onStatusFilter,
    required this.onDateFilter,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GrofastSearchField(
        hint: GrofastValueConst.ordersSearchHint,
        controller: searchController,
        onChanged: onSearch,
        // The pack's filter square, docked the way Category Details docks
        // its own — here it scopes by *date*; status stays on the chip row.
        trailing: GrofastSquareAction(
          asset: GrofastImageConst.filter,
          active: dateFilterActive,
          onTap: onDateFilter,
          tooltip: GrofastValueConst.ordersDateFilterTitle,
        ),
      ),
      const SizedBox(height: AppSpacing.xl2),
      GrofastChipRow(
        big: true,
        labels: filterLabels,
        selectedIndex: OrdersStatusFilter.values.indexOf(statusFilter),
        onSelected: onStatusFilter,
      ),
      const SizedBox(height: AppSpacing.xl4),
      if (orders.isEmpty)
        GrofastEmptyState(
          icon: Icons.filter_alt_off_outlined,
          title: GrofastValueConst.ordersNoResultsTitle,
          subtitle: GrofastValueConst.ordersNoResultsSubtitle,
        )
      else
        for (final order in orders) ...[
          _OrderCard(order: order, onTap: () => onOrderTap(order)),
          const SizedBox(height: AppSpacing.base),
        ],
    ],
  );
}

/// One order, on the kit's 100-tall notification card (`168:2513`): the
/// first line item's photo filling a square well on the left, the order's
/// date over its total, a hairline, and the delivery line naming the address.
/// No status chip on the card — the chip row above already scopes the list,
/// and the delivery line's tense carries the rest.
class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  String _deliveryLine() {
    if (order.status == OrderStatus.cancelled) {
      return GrofastValueConst.orderCancelledLine;
    }
    final address = order.deliveryAddress;
    final label = address == null
        ? GrofastValueConst.profileNameFallback
        : (address.tag.isEmpty ? address.name : address.tag);
    return GrofastValueConst.orderDeliveryLine(
      label,
      order.status == OrderStatus.delivered,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(GrofastDimenConst.tileRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: GrofastDimenConst.orderCardHeight,
          child: Row(
            children: [
              SizedBox.square(
                dimension: GrofastDimenConst.orderCardHeight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: AppNetworkImage(
                    url: order.items.isEmpty ? '' : order.items.first.imageUrl,
                    fit: BoxFit.contain,
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
                        GrofastValueConst.orderNumberLabel(order.placedAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GrofastTextStyleConst.cardTitleBold(tt),
                      ),
                      const SizedBox(height: AppSpacing.xs3),
                      GrofastPrice(value: order.payableTotal),
                      const SizedBox(height: AppSpacing.xs),
                      Divider(height: 1, color: cs.outlineVariant),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _deliveryLine(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GrofastTextStyleConst.meta(
                          tt,
                        ).copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
