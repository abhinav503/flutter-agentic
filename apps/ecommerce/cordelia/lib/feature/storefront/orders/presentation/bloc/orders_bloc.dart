import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/enums/orders_filter_period.dart';
import 'package:cordelia/enums/orders_status_filter.dart';
import 'package:cordelia/enums/orders_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/usecase/cancel_order_usecase.dart';
import '../../domain/usecase/get_orders_usecase.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase _getOrders;
  final CancelOrderUseCase _cancelOrder;
  final String _storeId;

  // Only the fetched list is cached — [OrdersLoaded.selectedTab]/
  // [OrdersLoaded.filter] are transient view selections, so a warm start
  // always reopens on the default Past tab with no filter.
  static final _cache = BlocCache<List<OrderEntity>>();

  // Opening store A's orders then store B's behind the same static cache
  // would otherwise flash A's stale list before B's fetch resolves — same
  // guard as HomeBloc's _cachedStoreId.
  static String? _cachedStoreId;

  @visibleForTesting
  static void resetCache() {
    _cache.reset();
    _cachedStoreId = null;
  }

  OrdersBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
    required String storeId,
  }) : _getOrders = getOrdersUseCase,
       _cancelOrder = cancelOrderUseCase,
       _storeId = storeId,
       super(_seed(storeId)) {
    on<OrdersStarted>(_onStarted);
    on<OrdersTabChanged>(_onTabChanged);
    on<OrdersCancelled>(_onCancelled);
    on<OrdersFilterApplied>(_onFilterApplied);
    on<OrdersStatusFilterChanged>(_onStatusFilterChanged);
    on<OrdersSearched>(_onSearched);
  }

  static OrdersState _seed(String storeId) {
    if (_cachedStoreId != storeId) {
      _cache.reset();
      _cachedStoreId = storeId;
    }
    return _cache.seed(
      warm: (orders) =>
          OrdersState.loaded(orders: orders, selectedTab: OrdersTab.past),
      cold: OrdersState.loading,
    );
  }

  Future<void> _onStarted(
    OrdersStarted event,
    Emitter<OrdersState> emit,
  ) async {
    final result = await _getOrders(GetOrdersParams(storeId: _storeId));
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
        _emitView(loaded.copyWith(selectedTab: event.tab), emit);
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
      _emitView(loaded.copyWith(orders: optimistic), emit);

      final result = await _cancelOrder(
        CancelOrderParams(storeId: _storeId, orderId: event.orderId),
      );
      result.fold(
        (failure) {
          // Roll back to the pre-cancel list; the listener toasts the failure.
          _cache.save(loaded.orders);
          emit(loaded.copyWith(cancelFailed: true, refreshFailed: false));
        },
        (serverOrder) {
          final reconciled = [...loaded.orders];
          reconciled[index] = serverOrder;
          _cache.save(reconciled);
          _emitView(loaded.copyWith(orders: reconciled), emit);
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
        // Carried through so Track Order keeps its dated steps during the
        // optimistic window; the server's reconciled order then brings the
        // real CANCELLED entry.
        statusHistory: order.statusHistory,
      );

  void _onStatusFilterChanged(
    OrdersStatusFilterChanged event,
    Emitter<OrdersState> emit,
  ) {
    switch (state) {
      case final OrdersLoaded loaded:
        _emitView(loaded.copyWith(statusFilter: event.filter), emit);
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  void _onSearched(OrdersSearched event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        _emitView(loaded.copyWith(searchTerm: event.term), emit);
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  void _onFilterApplied(OrdersFilterApplied event, Emitter<OrdersState> emit) {
    switch (state) {
      case final OrdersLoaded loaded:
        _emitView(loaded.copyWith(filter: event.filter), emit);
      case OrdersLoading():
      case OrdersError():
        break;
    }
  }

  /// Emits a view update with both one-shot flags cleared.
  ///
  /// The screen's listener consumes [OrdersLoaded.refreshFailed] and
  /// [OrdersLoaded.cancelFailed] the moment they arrive, so any later
  /// emission has to drop them — carried forward by `copyWith` they toast
  /// again on every chip tap and, on `dailymart`'s Orders, on every
  /// keystroke in the search field.
  void _emitView(OrdersLoaded next, Emitter<OrdersState> emit) =>
      emit(next.copyWith(cancelFailed: false, refreshFailed: false));

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
