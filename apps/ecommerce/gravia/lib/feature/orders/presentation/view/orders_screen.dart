import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_tab.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';

import '../../domain/entities/order_entity.dart';
import '../bloc/orders_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_segmented_tab_bar.dart';

class OrdersScreen extends BaseScreen {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseScreenState<OrdersScreen> {
  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state case OrdersError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          OrdersLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          OrdersError() => SafeArea(
            child: ErrorView(
              message: ValueConst.ordersLoadErrorMessage,
              onRetry: () =>
                  context.read<OrdersBloc>().add(const OrdersEvent.started()),
            ),
          ),
          OrdersLoaded(:final orders, :final selectedTab) => _buildLoaded(
            context,
            orders,
            selectedTab,
          ),
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    List<OrderEntity> orders,
    OrdersTab selectedTab,
  ) {
    final visible = orders
        .where(
          (o) => o.status.isUpcoming == (selectedTab == OrdersTab.upcoming),
        )
        .toList();

    return CollapsingHeaderSheet(
      initialHeaderHeight: 190,
      header: GraviaHeroHeader.page(
        title: ValueConst.ordersPageTitle,
        trailing: GraviaGlassIconButton(
          icon: Icons.tune_rounded,
          onTap: () => showSnackBar(ValueConst.comingSoonMessage),
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
}
