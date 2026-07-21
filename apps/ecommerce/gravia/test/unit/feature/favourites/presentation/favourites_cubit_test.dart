import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/favourites/domain/usecase/add_favourite_usecase.dart';
import 'package:gravia/feature/favourites/domain/usecase/get_favourites_usecase.dart';
import 'package:gravia/feature/favourites/domain/usecase/remove_favourite_usecase.dart';
import 'package:gravia/feature/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';

import '../../../../helpers/fake_favourites_repository.dart';

void main() {
  late FakeFavouritesRepository repository;
  late FavouritesCubit cubit;

  const product = ProductEntity(
    id: '1',
    name: 'Washington Red Apple',
    imageUrl: 'https://example.com/apple.png',
    price: 6.30,
    originalPrice: 8.00,
    discountPercentage: 20,
    unitValue: 300,
    unitType: ProductUnitType.grams,
    prepTime: '10 Min',
    isFavourite: false,
  );

  setUp(() {
    repository = FakeFavouritesRepository();
    cubit = FavouritesCubit(
      getFavouritesUseCase: GetFavouritesUseCase(repository),
      addFavouriteUseCase: AddFavouriteUseCase(repository),
      removeFavouriteUseCase: RemoveFavouriteUseCase(repository),
    );
  });
  tearDown(() => cubit.close());

  test('starts loading, with no items, before hydrate resolves', () {
    expect(cubit.state.isLoading, isTrue);
    expect(cubit.state.items, isEmpty);
  });

  test('hydrate seeds state from the repository and clears isLoading', () async {
    repository.result = right([product]);

    await cubit.hydrate();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.items, [product]);
  });

  test('a failed hydrate leaves the list empty but still clears isLoading', () async {
    repository.result = left(const Failure.unexpected(message: 'boom'));

    await cubit.hydrate();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.items, isEmpty);
  });

  test('toggle adds an unfavourited product and persists it', () async {
    cubit.toggle(product);
    // Fire-and-forget persist — pump the microtask queue before asserting.
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.items, [product]);
    expect(repository.lastAddedId, '1');
  });

  test('toggle removes an already-favourited product and persists it', () async {
    repository.result = right([product]);
    await cubit.hydrate();

    cubit.toggle(product);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.items, isEmpty);
    expect(repository.lastRemovedId, '1');
  });

  test('isFavourite reflects current state membership', () async {
    expect(cubit.isFavourite('1'), isFalse);

    cubit.toggle(product);
    expect(cubit.isFavourite('1'), isTrue);
  });

  test('reset clears the list without persisting', () async {
    repository.result = right([product]);
    await cubit.hydrate();

    cubit.reset();

    expect(cubit.state.items, isEmpty);
    expect(repository.lastRemovedId, isNull);
  });
}
