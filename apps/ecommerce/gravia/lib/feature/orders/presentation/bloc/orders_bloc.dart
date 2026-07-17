import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_filter_period.dart';
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
    on<OrdersFilterApplied>(_onFilterApplied);
  }

  Future<void> _onStarted(
    OrdersStarted event,
    Emitter<OrdersState> emit,
  ) async {
    final result = await _getOrders(const NoParams());
    result.fold(
      (failure) => emit(OrdersState.error(message: failure.message)),
      (orders) => emit(
        OrdersState.loaded(orders: orders, selectedTab: OrdersTab.past),
      ),
    );
  }

  void _onTabChanged(OrdersTabChanged event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        emit(loaded.copyWith(selectedTab: event.tab));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  void _onCancelled(OrdersCancelled event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        final updated = [
          for (final order in loaded.orders)
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
        emit(loaded.copyWith(orders: updated));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  void _onFilterApplied(OrdersFilterApplied event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        emit(loaded.copyWith(filter: event.filter));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }
}
