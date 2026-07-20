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
  static CategoriesEntity? _cachedCategories;

  @visibleForTesting
  static void resetCache() => _cachedCategories = null;

  CategoriesBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategories = getCategoriesUseCase,
      super(
        _cachedCategories != null
            ? CategoriesState.loaded(categories: _cachedCategories!)
            : const CategoriesState.loading(),
      ) {
    on<CategoriesStarted>(_onStarted);
  }

  Future<void> _onStarted(
    CategoriesStarted event,
    Emitter<CategoriesState> emit,
  ) async {
    final result = await _getCategories(const NoParams());
    result.fold((failure) {
      switch (state) {
        case CategoriesLoaded(:final categories):
          emit(
            CategoriesState.loaded(categories: categories, refreshFailed: true),
          );
        case CategoriesLoading():
        case CategoriesError():
          emit(CategoriesState.error(message: failure.message));
      }
    }, (categories) => _emitLoaded(categories, emit));
  }

  void _emitLoaded(CategoriesEntity categories, Emitter<CategoriesState> emit) {
    _cachedCategories = categories;
    emit(CategoriesState.loaded(categories: categories));
  }
}
