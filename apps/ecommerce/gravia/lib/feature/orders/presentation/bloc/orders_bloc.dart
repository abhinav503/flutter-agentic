import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';
import 'package:core/core/usecase/usecase.dart';

import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_filter_period.dart';
import 'package:gravia/enums/orders_tab.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/usecase/cancel_order_usecase.dart';
import '../../domain/usecase/get_orders_usecase.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase _getOrders;
  final CancelOrderUseCase _cancelOrder;

  // Only the fetched list is cached — [OrdersLoaded.selectedTab]/
  // [OrdersLoaded.filter] are transient view selections, so a warm start
  // always reopens on the default Past tab with no filter.
  static final _cache = BlocCache<List<OrderEntity>>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  OrdersBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  }) : _getOrders = getOrdersUseCase,
       _cancelOrder = cancelOrderUseCase,
       super(
         _cache.seed(
           warm: (orders) =>
               OrdersState.loaded(orders: orders, selectedTab: OrdersTab.past),
           cold: OrdersState.loading,
         ),
       ) {
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
    result.fold((failure) {
      switch (state) {
        // Warm start: cached content is already on screen — keep it there
        // and let the failure surface as a snackbar instead of an error view.
        case final OrdersLoaded loaded:
          emit(loaded.copyWith(refreshFailed: true));
        case OrdersLoading():
        case OrdersError():
          emit(OrdersState.error(message: failure.message));
      }
    }, (orders) => _emitLoaded(orders, OrdersTab.past, emit));
  }

  void _onTabChanged(OrdersTabChanged event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        emit(loaded.copyWith(selectedTab: event.tab, cancelFailed: false));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  Future<void> _onCancelled(
    OrdersCancelled event,
    Emitter<OrdersState> emit,
  ) async {
    if (state case final OrdersLoaded loaded) {
      final index = loaded.orders.indexWhere((o) => o.id == event.orderId);
      // Only an upcoming order can be cancelled — ignore a stale tap on an
      // already-cancelled/delivered one.
      if (index == -1 || !loaded.orders[index].status.isUpcoming) return;

      // Optimistic: flip to cancelled with the refund shown as processing
      // until the server confirms, so the card moves to Past immediately.
      final optimistic = [...loaded.orders];
      optimistic[index] = _cancelledCopy(
        loaded.orders[index],
        RefundStatus.pending,
      );
      _cache.save(optimistic);
      emit(loaded.copyWith(orders: optimistic, cancelFailed: false));

      final result = await _cancelOrder(event.orderId);
      result.fold(
        (failure) {
          // Roll back to the pre-cancel list; the listener toasts the failure.
          _cache.save(loaded.orders);
          emit(loaded.copyWith(cancelFailed: true));
        },
        (serverOrder) {
          final reconciled = [...loaded.orders];
          reconciled[index] = serverOrder;
          _cache.save(reconciled);
          emit(loaded.copyWith(orders: reconciled));
        },
      );
    }
  }

  OrderEntity _cancelledCopy(OrderEntity order, RefundStatus refundStatus) =>
      OrderEntity(
        id: order.id,
        status: OrderStatus.cancelled,
        refundStatus: refundStatus,
        placedAt: order.placedAt,
        deliveryOtp: order.deliveryOtp,
        items: order.items,
        deliveryAddress: order.deliveryAddress,
      );

  void _onFilterApplied(OrdersFilterApplied event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        emit(loaded.copyWith(filter: event.filter, cancelFailed: false));
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  void _emitLoaded(
    List<OrderEntity> orders,
    OrdersTab selectedTab,
    Emitter<OrdersState> emit, {
    OrdersFilter? filter,
  }) {
    _cache.save(orders);
    emit(
      OrdersState.loaded(
        orders: orders,
        selectedTab: selectedTab,
        filter: filter,
      ),
    );
  }
}
