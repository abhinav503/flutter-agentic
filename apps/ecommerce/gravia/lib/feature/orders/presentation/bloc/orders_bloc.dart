import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_tab.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/usecase/get_orders_usecase.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase _getOrders;

  OrdersBloc({required GetOrdersUseCase getOrdersUseCase})
    : _getOrders = getOrdersUseCase,
      super(const OrdersState.loading()) {
    on<OrdersStarted>(_onStarted);
    on<OrdersTabChanged>(_onTabChanged);
    on<OrdersCancelled>(_onCancelled);
  }

  Future<void> _onStarted(
    OrdersStarted event,
    Emitter<OrdersState> emit,
  ) async {
    final result = await _getOrders(const NoParams());
    result.fold(
      (failure) => emit(OrdersState.error(message: failure.message)),
      (orders) => emit(
        OrdersState.loaded(orders: orders, selectedTab: OrdersTab.upcoming),
      ),
    );
  }

  void _onTabChanged(OrdersTabChanged event, Emitter<OrdersState> emit) {
    switch (state) {
      case OrdersLoaded(:final orders):
        emit(OrdersState.loaded(orders: orders, selectedTab: event.tab));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  void _onCancelled(OrdersCancelled event, Emitter<OrdersState> emit) {
    switch (state) {
      case OrdersLoaded(:final orders, :final selectedTab):
        final updated = [
          for (final order in orders)
            if (order.id == event.orderId)
              OrderEntity(
                id: order.id,
                status: OrderStatus.cancelled,
                placedAt: order.placedAt,
                deliveryOtp: order.deliveryOtp,
                items: order.items,
              )
            else
              order,
        ];
        emit(OrdersState.loaded(orders: updated, selectedTab: selectedTab));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }
}
