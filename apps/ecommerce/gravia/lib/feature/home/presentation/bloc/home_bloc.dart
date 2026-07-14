import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecase/get_home_usecase.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase _getHome;

  HomeBloc({required GetHomeUseCase getHomeUseCase})
      : _getHome = getHomeUseCase,
        super(const HomeState.loading()) {
    on<HomeStarted>(_onStarted);
    on<HomeFavouriteToggled>(_onFavouriteToggled);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final result = await _getHome(const NoParams());
    result.fold(
      (failure) => emit(HomeState.error(message: failure.message)),
      (home) => emit(HomeState.loaded(home: home)),
    );
  }

  void _onFavouriteToggled(
    HomeFavouriteToggled event,
    Emitter<HomeState> emit,
  ) {
    switch (state) {
      case HomeLoaded(:final home):
        final updatedProducts = home.popularProducts
            .map((p) => p.id == event.productId
                ? p.copyWith(isFavourite: !p.isFavourite)
                : p)
            .toList();
        emit(HomeState.loaded(home: home.copyWith(popularProducts: updatedProducts)));
      case HomeLoading():
      case HomeError():
        break;
    }
  }
}
