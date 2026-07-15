part of 'categories_bloc.dart';

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState.loading() = CategoriesLoading;
  const factory CategoriesState.loaded({required CategoriesEntity categories}) =
      CategoriesLoaded;
  const factory CategoriesState.error({required String message}) = CategoriesError;
}
