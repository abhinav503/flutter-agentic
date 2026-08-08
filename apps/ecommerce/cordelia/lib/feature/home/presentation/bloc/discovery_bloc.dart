import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/utils/event_transformers.dart';

import '../../domain/entities/store_entity.dart';
import '../../domain/usecase/get_stores_usecase.dart';
import '../recent_stores_prefs.dart';

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
    on<DiscoveryStoreOpened>(_onStoreOpened);
  }

  Future<void> _onStarted(
    DiscoveryStarted event,
    Emitter<DiscoveryState> emit,
  ) => _fetch(query: '', emit: emit);

  Future<void> _onQueryChanged(
    DiscoveryQueryChanged event,
    Emitter<DiscoveryState> emit,
  ) => _fetch(query: event.query.trim(), emit: emit);

  // Reordering the rail must not cost a refetch — the store list on screen is
  // still correct, only which ids sit at the front of it changed.
  Future<void> _onStoreOpened(
    DiscoveryStoreOpened event,
    Emitter<DiscoveryState> emit,
  ) async {
    final recentIds = await recordRecentStore(event.storeId);
    if (state case DiscoveryLoaded(:final stores, :final query)) {
      emit(
        DiscoveryState.loaded(
          stores: stores,
          query: query,
          recentStores: query.isEmpty
              ? _resolveRecents(recentIds, stores)
              : const [],
        ),
      );
    }
  }

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
            : DiscoveryState.loaded(
                stores: stores,
                query: query,
                recentStores: query.isEmpty
                    ? _resolveRecents(readRecentStoreIds(), stores)
                    : const [],
              ),
      ),
    );
  }

  List<StoreEntity> _resolveRecents(
    List<String> recentIds,
    List<StoreEntity> stores,
  ) {
    final byId = {for (final store in stores) store.id: store};
    return recentIds.map((id) => byId[id]).nonNulls.toList();
  }
}
