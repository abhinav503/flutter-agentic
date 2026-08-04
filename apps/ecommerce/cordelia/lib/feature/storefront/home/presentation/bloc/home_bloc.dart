import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecase/get_home_usecase.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase _getHome;
  final String _storeId;

  // Scoped to the store: unlike gravia (one store forever), this app opens a
  // different store's Home behind the same static cache across visits —
  // unscoped, a warm start would flash the previously-opened store's cached
  // catalog for one frame before the fresh fetch resolves.
  static final _cache = ScopedBlocCache<HomeEntity>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  HomeBloc({required GetHomeUseCase getHomeUseCase, required String storeId})
    : _getHome = getHomeUseCase,
      _storeId = storeId,
      super(
        _cache.seed(
          scope: storeId,
          warm: (home) => HomeState.loaded(home: home),
          cold: HomeState.loading,
        ),
      ) {
    on<HomeStarted>(_onStarted);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final Either<Failure, HomeEntity> result = await _getHome(
      GetHomeParams(storeId: _storeId),
    );
    result.fold((failure) {
      switch (state) {
        case HomeLoaded(:final home):
          emit(HomeState.loaded(home: home, refreshFailed: true));
        case HomeLoading():
        case HomeError():
          emit(HomeState.error(message: failure.message));
      }
    }, (home) => _emitLoaded(home, emit));
  }

  void _emitLoaded(HomeEntity home, Emitter<HomeState> emit) {
    _cache.save(_storeId, home);
    emit(HomeState.loaded(home: home));
  }
}
