import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/categories/domain/entities/categories_entity.dart';
import 'package:gravia/feature/categories/domain/entities/category_group_entity.dart';
import 'package:gravia/feature/categories/domain/usecase/get_categories_usecase.dart';
import 'package:gravia/feature/categories/presentation/bloc/categories_bloc.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';

import '../../../../helpers/fake_categories_repository.dart';

void main() {
  late FakeCategoriesRepository repository;

  const categories = CategoriesEntity(
    groups: [
      CategoryGroupEntity(
        name: 'Fresh',
        categories: [
          CategoryEntity(
            id: '1',
            name: 'Fruits',
            imageUrl: 'https://example.com/fruits.png',
          ),
        ],
      ),
    ],
  );

  setUp(() {
    // `CategoriesBloc._cachedCategories` is a static field (survives the
    // bloc instance being recreated on a real Categories-tab revisit) —
    // reset it so warm-start caching from one test doesn't leak into the
    // next.
    CategoriesBloc.resetCache();
    repository = FakeCategoriesRepository()..result = right(categories);
  });

  blocTest<CategoriesBloc, CategoriesState>(
    'emits [loading, loaded] when started succeeds',
    build: () =>
        CategoriesBloc(getCategoriesUseCase: GetCategoriesUseCase(repository)),
    act: (bloc) => bloc.add(const CategoriesEvent.started()),
    expect: () => [const CategoriesState.loaded(categories: categories)],
  );

  blocTest<CategoriesBloc, CategoriesState>(
    'emits [loading, error] when started fails',
    setUp: () =>
        repository.result = left(const Failure.unexpected(message: 'boom')),
    build: () =>
        CategoriesBloc(getCategoriesUseCase: GetCategoriesUseCase(repository)),
    act: (bloc) => bloc.add(const CategoriesEvent.started()),
    expect: () => [const CategoriesState.error(message: 'boom')],
  );

  group('warm start (cached data from a prior successful load)', () {
    setUp(() async {
      // Prime CategoriesBloc's static cache the same way a real first
      // Categories-tab load would — build a bloc, let it fetch and cache,
      // then discard it.
      final primer = CategoriesBloc(
        getCategoriesUseCase: GetCategoriesUseCase(repository),
      );
      primer.add(const CategoriesEvent.started());
      await primer.stream.first;
      await primer.close();
    });

    test(
      'seeds the loaded state immediately, before any event is processed',
      () {
        final bloc = CategoriesBloc(
          getCategoriesUseCase: GetCategoriesUseCase(repository),
        );
        expect(
          bloc.state,
          const CategoriesState.loaded(categories: categories),
        );
        bloc.close();
      },
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'never re-emits loading — silently refreshes in the background',
      build: () => CategoriesBloc(
        getCategoriesUseCase: GetCategoriesUseCase(repository),
      ),
      act: (bloc) => bloc.add(const CategoriesEvent.started()),
      // Refetch resolves to the same fake data, so the only emission is the
      // fresh loaded state — critically, CategoriesLoading is never emitted.
      expect: () => [const CategoriesState.loaded(categories: categories)],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'keeps the cached content and sets refreshFailed when the background '
      'refetch fails',
      build: () {
        repository.result = left(const Failure.unexpected(message: 'boom'));
        return CategoriesBloc(
          getCategoriesUseCase: GetCategoriesUseCase(repository),
        );
      },
      act: (bloc) => bloc.add(const CategoriesEvent.started()),
      expect: () => [
        const CategoriesState.loaded(
          categories: categories,
          refreshFailed: true,
        ),
      ],
    );
  });
}
