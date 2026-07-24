import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../domain/entities/store_entity.dart';
import '../../domain/usecase/get_stores_usecase.dart';

part 'discovery_bloc.freezed.dart';
part 'discovery_event.dart';
part 'discovery_state.dart';

/// Debounce + switchMap: waits out the typing burst, then cancels any
/// in-flight search when a newer query arrives — same transformer gravia's
/// SearchBloc uses, so results can never come back out of order.
EventTransformer<E> _debounceRestartable<E>(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final GetStoresUseCase _getStores;

  static const Duration _debounceDuration = Duration(milliseconds: 300);

  DiscoveryBloc({required GetStoresUseCase getStoresUseCase})
    : _getStores = getStoresUseCase,
      super(const DiscoveryState.loading()) {
    on<DiscoveryStarted>(_onStarted);
    on<DiscoveryQueryChanged>(
      _onQueryChanged,
      transformer: _debounceRestartable(_debounceDuration),
    );
  }

  Future<void> _onStarted(
    DiscoveryStarted event,
    Emitter<DiscoveryState> emit,
  ) => _fetch(query: '', emit: emit);

  Future<void> _onQueryChanged(
    DiscoveryQueryChanged event,
    Emitter<DiscoveryState> emit,
  ) => _fetch(query: event.query.trim(), emit: emit);

  Future<void> _fetch({
    required String query,
    required Emitter<DiscoveryState> emit,
  }) async {
    final result = await _getStores(GetStoresParams(query: query));
    result.fold(
      (failure) =>
          emit(DiscoveryState.error(message: failure.message, query: query)),
      (stores) => emit(
        stores.isEmpty
            ? DiscoveryState.empty(query: query)
            : DiscoveryState.loaded(stores: stores, query: query),
      ),
    );
  }
}
