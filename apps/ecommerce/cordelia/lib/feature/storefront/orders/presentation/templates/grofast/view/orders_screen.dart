import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/orders_status_filter.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_price.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../bloc/orders_bloc.dart';
import '../widgets/order_status_pill.dart';

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
              OrdersLoading() => const ShimmerListRow(itemCount: 4),
              OrdersError(:final message) => GrofastErrorView(
                message: message,
                onRetry: () =>
                    context.read<OrdersBloc>().add(const OrdersEvent.started()),
              ),
              OrdersLoaded(:final orders) when orders.isEmpty =>
                const GrofastEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: GrofastValueConst.ordersEmptyTitle,
                  subtitle: GrofastValueConst.ordersEmptySubtitle,
                ),
              OrdersLoaded() => _OrdersContent(
                orders: state.orders
                    .where((order) => state.statusFilter.matches(order))
                    .where((order) => order.matchesSearch(state.searchTerm))
                    .toList(),
                statusFilter: state.statusFilter,
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
  final List<String> filterLabels;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final ValueChanged<int> onStatusFilter;
  final ValueChanged<OrderEntity> onOrderTap;

  const _OrdersContent({
    required this.orders,
    required this.statusFilter,
    required this.filterLabels,
    required this.searchController,
    required this.onSearch,
    required this.onStatusFilter,
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
      ),
      const SizedBox(height: AppSpacing.xl2),
      GrofastChipWrap(
        labels: filterLabels,
        selectedIndex: OrdersStatusFilter.values.indexOf(statusFilter),
        onSelected: onStatusFilter,
      ),
      const SizedBox(height: AppSpacing.xl4),
      if (orders.isEmpty)
        const GrofastEmptyState(
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

/// One order: the first line item's photo, the order's date and total, a
/// status pill, and the item count.
class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              SizedBox.square(
                dimension: GrofastDimenConst.lineItemThumbSize,
                child: AppNetworkImage(
                  url: order.items.isEmpty ? '' : order.items.first.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GrofastValueConst.orderNumberLabel(order.placedAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GrofastTextStyleConst.rowTitleBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    GrofastPrice(value: order.totalPrice),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      GrofastValueConst.orderItemCount(order.items.length),
                      style: GrofastTextStyleConst.meta(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              GrofastOrderStatusPill(status: order.status),
            ],
          ),
        ),
      ),
    );
  }
}
