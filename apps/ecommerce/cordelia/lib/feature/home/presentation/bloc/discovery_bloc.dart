import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/utils/event_transformers.dart';

import '../../domain/entities/store_entity.dart';
import '../../domain/usecase/get_stores_usecase.dart';

part 'discovery_bloc.freezed.dart';
part 'discovery_event.dart';
part 'discovery_state.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final GetStoresUseCase _getStores;

  DiscoveryBloc({required GetStoresUseCase getStoresUseCase})
    : _getStores = getStoresUseCase,
      super(const DiscoveryState.loading()) {
    on<DiscoveryStarted>(_onStarted);
    on<DiscoveryQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestartable(),
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
