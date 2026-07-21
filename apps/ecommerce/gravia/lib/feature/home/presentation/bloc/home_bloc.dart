import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';
import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecase/get_home_usecase.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase _getHome;
  static final _cache = BlocCache<HomeEntity>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  HomeBloc({required GetHomeUseCase getHomeUseCase})
    : _getHome = getHomeUseCase,
      super(
        _cache.seed(
          warm: (home) => HomeState.loaded(home: home),
          cold: HomeState.loading,
        ),
      ) {
    on<HomeStarted>(_onStarted);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final result = await _getHome(const NoParams());
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
    _cache.save(home);
    emit(HomeState.loaded(home: home));
  }
}
