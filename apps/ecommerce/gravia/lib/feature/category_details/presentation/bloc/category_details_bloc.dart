import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/enums/product_price_filter.dart';
import 'package:gravia/enums/product_sort_option.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/category_details_entity.dart';
import '../../domain/usecase/get_category_details_usecase.dart';

part 'category_details_bloc.freezed.dart';
part 'category_details_event.dart';
part 'category_details_state.dart';

class CategoryDetailsBloc extends Bloc<CategoryDetailsEvent, CategoryDetailsState> {
  final GetCategoryDetailsUseCase _getCategoryDetails;

  CategoryDetailsBloc({required GetCategoryDetailsUseCase getCategoryDetailsUseCase})
      : _getCategoryDetails = getCategoryDetailsUseCase,
        super(const CategoryDetailsState.loading()) {
    on<CategoryDetailsStarted>(_onStarted);
    on<CategoryDetailsSortChanged>(_onSortChanged);
    on<CategoryDetailsPriceFilterChanged>(_onPriceFilterChanged);
  }

  Future<void> _onStarted(
    CategoryDetailsStarted event,
    Emitter<CategoryDetailsState> emit,
  ) async {
    final result = await _getCategoryDetails(
      GetCategoryDetailsParams(categoryId: event.categoryId),
    );
    result.fold(
      (failure) => emit(
        CategoryDetailsState.error(
          message: failure.message,
          categoryId: event.categoryId,
          categoryName: event.categoryName,
        ),
      ),
      (details) => emit(
        CategoryDetailsState.loaded(
          categoryName: event.categoryName,
          details: details,
          sort: ProductSortOption.relevance,
          priceFilter: ProductPriceFilter.all,
        ),
      ),
    );
  }

  void _onSortChanged(
    CategoryDetailsSortChanged event,
    Emitter<CategoryDetailsState> emit,
  ) {
    if (state case CategoryDetailsLoaded loaded) {
      emit(loaded.copyWith(sort: event.sort));
    }
  }

  void _onPriceFilterChanged(
    CategoryDetailsPriceFilterChanged event,
    Emitter<CategoryDetailsState> emit,
  ) {
    if (state case CategoryDetailsLoaded loaded) {
      emit(loaded.copyWith(priceFilter: event.priceFilter));
    }
  }
}
