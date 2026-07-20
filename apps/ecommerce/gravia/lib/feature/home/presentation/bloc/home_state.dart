part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({
    required HomeEntity home,
    // True only when a silent background refresh (a warm start seeded from
    // HomeBloc's cached data) fails — the already-visible cached content
    // stays on screen; the listener surfaces this via a snackbar instead of
    // replacing it with the error view.
    @Default(false) bool refreshFailed,
  }) = HomeLoaded;
  const factory HomeState.error({required String message}) = HomeError;
}
