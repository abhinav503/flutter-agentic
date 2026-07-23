import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/order_status.dart';
import 'package:gravia/enums/orders_tab.dart';
import 'package:gravia/feature/orders/domain/entities/order_entity.dart';
import 'package:gravia/feature/orders/domain/entities/order_line_item_entity.dart';
import 'package:gravia/feature/orders/domain/usecase/cancel_order_usecase.dart';
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
    build: () => OrdersBloc(
      getOrdersUseCase: GetOrdersUseCase(repository),
      cancelOrderUseCase: CancelOrderUseCase(repository),
    ),
    act: (bloc) => bloc.add(const OrdersEvent.started()),
    expect: () => [
      OrdersState.loaded(orders: [order], selectedTab: OrdersTab.past),
    ],
  );

  blocTest<OrdersBloc, OrdersState>(
    'emits [loading, error] when started fails',
    setUp: () =>
        repository.result = left(const Failure.unexpected(message: 'boom')),
    build: () => OrdersBloc(
      getOrdersUseCase: GetOrdersUseCase(repository),
      cancelOrderUseCase: CancelOrderUseCase(repository),
    ),
    act: (bloc) => bloc.add(const OrdersEvent.started()),
    expect: () => [const OrdersState.error(message: 'boom')],
  );

  group('warm start (cached data from a prior successful load)', () {
    setUp(() async {
      // Prime OrdersBloc's static cache the same way a real first
      // Orders-tab load would — build a bloc, let it fetch and cache, then
      // discard it.
      final primer = OrdersBloc(
        getOrdersUseCase: GetOrdersUseCase(repository),
        cancelOrderUseCase: CancelOrderUseCase(repository),
      );
      primer.add(const OrdersEvent.started());
      await primer.stream.first;
      await primer.close();
    });

    test(
      'seeds the loaded state immediately, before any event is processed',
      () {
        final bloc = OrdersBloc(
          getOrdersUseCase: GetOrdersUseCase(repository),
          cancelOrderUseCase: CancelOrderUseCase(repository),
        );
        expect(
          bloc.state,
          OrdersState.loaded(orders: [order], selectedTab: OrdersTab.past),
        );
        bloc.close();
      },
    );

    blocTest<OrdersBloc, OrdersState>(
      'never re-emits loading — silently refreshes in the background',
      build: () => OrdersBloc(
        getOrdersUseCase: GetOrdersUseCase(repository),
        cancelOrderUseCase: CancelOrderUseCase(repository),
      ),
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
        return OrdersBloc(
          getOrdersUseCase: GetOrdersUseCase(repository),
          cancelOrderUseCase: CancelOrderUseCase(repository),
        );
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

  group('cancel', () {
    final upcoming = OrderEntity(
      id: '2',
      status: OrderStatus.inProcess,
      placedAt: DateTime(2026, 3, 10, 9),
      deliveryOtp: '1234',
      items: const [
        OrderLineItemEntity(
          productName: 'Bananas',
          weight: '1kg',
          imageUrl: 'https://example.com/banana.png',
          price: 2.50,
          quantity: 1,
        ),
      ],
    );

    final cancelled = OrderEntity(
      id: '2',
      status: OrderStatus.cancelled,
      refundStatus: RefundStatus.processed,
      placedAt: upcoming.placedAt,
      deliveryOtp: upcoming.deliveryOtp,
      items: upcoming.items,
    );

    blocTest<OrdersBloc, OrdersState>(
      'optimistically cancels, then reconciles with the server order',
      setUp: () {
        repository.result = right([upcoming]);
        // OrderEntity has no `==`, so the reconciled state must carry the
        // exact instance the repository returns for identity equality.
        repository.cancelResult = right(cancelled);
      },
      build: () => OrdersBloc(
        getOrdersUseCase: GetOrdersUseCase(repository),
        cancelOrderUseCase: CancelOrderUseCase(repository),
      ),
      seed: () =>
          OrdersState.loaded(orders: [upcoming], selectedTab: OrdersTab.past),
      act: (bloc) => bloc.add(const OrdersEvent.cancelled(orderId: '2')),
      expect: () => [
        // Optimistic: cancelled with refund shown as pending.
        isA<OrdersLoaded>().having(
          (s) => s.orders.single.refundStatus,
          'optimistic refundStatus',
          RefundStatus.pending,
        ),
        // Reconciled with the server's returned order (refund processed).
        OrdersState.loaded(orders: [cancelled], selectedTab: OrdersTab.past),
      ],
    );

    blocTest<OrdersBloc, OrdersState>(
      'rolls back and sets cancelFailed when the cancel request fails',
      setUp: () {
        repository.result = right([upcoming]);
        repository.cancelResult = left(
          const Failure.unexpected(message: 'boom'),
        );
      },
      build: () => OrdersBloc(
        getOrdersUseCase: GetOrdersUseCase(repository),
        cancelOrderUseCase: CancelOrderUseCase(repository),
      ),
      seed: () =>
          OrdersState.loaded(orders: [upcoming], selectedTab: OrdersTab.past),
      act: (bloc) => bloc.add(const OrdersEvent.cancelled(orderId: '2')),
      expect: () => [
        isA<OrdersLoaded>().having(
          (s) => s.orders.single.status,
          'optimistic status',
          OrderStatus.cancelled,
        ),
        // Rolled back to the original upcoming order, cancelFailed flagged.
        OrdersState.loaded(
          orders: [upcoming],
          selectedTab: OrdersTab.past,
          cancelFailed: true,
        ),
      ],
    );
  });
}
