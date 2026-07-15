part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  const factory CategoriesEvent.started() = CategoriesStarted;
}
