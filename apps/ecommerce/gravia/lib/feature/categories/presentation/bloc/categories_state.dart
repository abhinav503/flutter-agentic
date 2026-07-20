part of 'categories_bloc.dart';

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState.loading() = CategoriesLoading;
  const factory CategoriesState.loaded({
    required CategoriesEntity categories,
    // True only when a silent background refresh (a warm start seeded from
    // CategoriesBloc's cached data) fails — the already-visible cached
    // content stays on screen; the listener surfaces this via a snackbar
    // instead of replacing it with the error view.
    @Default(false) bool refreshFailed,
  }) = CategoriesLoaded;
  const factory CategoriesState.error({required String message}) =
      CategoriesError;
}
