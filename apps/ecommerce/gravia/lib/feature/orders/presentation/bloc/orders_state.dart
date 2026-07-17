part of 'orders_bloc.dart';

@freezed
sealed class OrdersState with _$OrdersState {
  const factory OrdersState.loading() = OrdersLoading;
  const factory OrdersState.loaded({
    required List<OrderEntity> orders,
    required OrdersTab selectedTab,
  }) = OrdersLoaded;
  const factory OrdersState.error({required String message}) = OrdersError;
}
