part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({required HomeEntity home}) = HomeLoaded;
  const factory HomeState.error({required String message}) = HomeError;
}
