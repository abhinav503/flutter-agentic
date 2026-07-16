import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/categories_entity.dart';
import '../../domain/usecase/get_categories_usecase.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase _getCategories;

  CategoriesBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategories = getCategoriesUseCase,
      super(const CategoriesState.loading()) {
    on<CategoriesStarted>(_onStarted);
  }

  Future<void> _onStarted(
    CategoriesStarted event,
    Emitter<CategoriesState> emit,
  ) async {
    final result = await _getCategories(const NoParams());
    result.fold(
      (failure) => emit(CategoriesState.error(message: failure.message)),
      (categories) => emit(CategoriesState.loaded(categories: categories)),
    );
  }
}
