import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_tab.dart';
import 'package:gravia/feature/orders/domain/entities/order_entity.dart';
import 'package:gravia/feature/orders/domain/entities/order_line_item_entity.dart';
import 'package:gravia/feature/orders/domain/usecase/get_orders_usecase.dart';
import 'package:gravia/feature/orders/presentation/bloc/orders_bloc.dart';

import '../../../../helpers/fake_orders_repository.dart';

void main() {
  late FakeOrdersRepository repository;

  final order = OrderEntity(
    id: '1',
    status: OrderStatus.delivered,
    placedAt: DateTime(2026, 3, 9, 10, 15),
    deliveryOtp: '',
    items: const [
      OrderLineItemEntity(
        productName: 'Washington Red Apple',
        weight: '1kg',
        imageUrl: 'https://example.com/apple.png',
        price: 6.30,
        quantity: 1,
      ),
    ],
  );

  setUp(() {
    // `OrdersBloc._cachedOrders` is a static field (survives the bloc
    // instance being recreated on a real Orders-tab revisit) — reset it so
    // warm-start caching from one test doesn't leak into the next.
    OrdersBloc.resetCache();
    repository = FakeOrdersRepository()..result = right([order]);
  });

  blocTest<OrdersBloc, OrdersState>(
    'emits [loading, loaded] when started succeeds',
    build: () => OrdersBloc(getOrdersUseCase: GetOrdersUseCase(repository)),
    act: (bloc) => bloc.add(const OrdersEvent.started()),
    expect: () => [
      OrdersState.loaded(orders: [order], selectedTab: OrdersTab.past),
    ],
  );

  blocTest<OrdersBloc, OrdersState>(
    'emits [loading, error] when started fails',
    setUp: () =>
        repository.result = left(const Failure.unexpected(message: 'boom')),
    build: () => OrdersBloc(getOrdersUseCase: GetOrdersUseCase(repository)),
    act: (bloc) => bloc.add(const OrdersEvent.started()),
    expect: () => [const OrdersState.error(message: 'boom')],
  );

  group('warm start (cached data from a prior successful load)', () {
    setUp(() async {
      // Prime OrdersBloc's static cache the same way a real first
      // Orders-tab load would — build a bloc, let it fetch and cache, then
      // discard it.
      final primer = OrdersBloc(getOrdersUseCase: GetOrdersUseCase(repository));
      primer.add(const OrdersEvent.started());
      await primer.stream.first;
      await primer.close();
    });

    test(
      'seeds the loaded state immediately, before any event is processed',
      () {
        final bloc = OrdersBloc(getOrdersUseCase: GetOrdersUseCase(repository));
        expect(
          bloc.state,
          OrdersState.loaded(orders: [order], selectedTab: OrdersTab.past),
        );
        bloc.close();
      },
    );

    blocTest<OrdersBloc, OrdersState>(
      'never re-emits loading — silently refreshes in the background',
      build: () => OrdersBloc(getOrdersUseCase: GetOrdersUseCase(repository)),
      act: (bloc) => bloc.add(const OrdersEvent.started()),
      // Refetch resolves to the same fake data, so the only emission is the
      // fresh loaded state — critically, OrdersLoading is never emitted.
      expect: () => [
        OrdersState.loaded(orders: [order], selectedTab: OrdersTab.past),
      ],
    );

    blocTest<OrdersBloc, OrdersState>(
      'keeps the cached content and sets refreshFailed when the background '
      'refetch fails',
      build: () {
        repository.result = left(const Failure.unexpected(message: 'boom'));
        return OrdersBloc(getOrdersUseCase: GetOrdersUseCase(repository));
      },
      act: (bloc) => bloc.add(const OrdersEvent.started()),
      expect: () => [
        OrdersState.loaded(
          orders: [order],
          selectedTab: OrdersTab.past,
          refreshFailed: true,
        ),
      ],
    );
  });
}
