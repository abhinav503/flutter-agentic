import 'dart:async';

import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/feature/storefront/cart/domain/entities/applied_coupon_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/usecase/get_cart_usecase.dart';
import 'package:cordelia/feature/storefront/cart/domain/usecase/save_cart_usecase.dart';
import 'package:cordelia/feature/storefront/cart/domain/usecase/validate_coupon_usecase.dart';
import 'package:cordelia/feature/storefront/favourites/domain/usecase/add_favourite_usecase.dart';
import 'package:cordelia/feature/storefront/favourites/domain/usecase/get_favourites_usecase.dart';
import 'package:cordelia/feature/storefront/favourites/domain/usecase/remove_favourite_usecase.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/home_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/usecase/get_home_usecase.dart';
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/feature/storefront/profile/domain/usecase/get_profile_usecase.dart';

/// The use cases a storefront needs before it will mount, faked once.
///
/// Every widget test that opens a storefront has to satisfy the same handful
/// — the shell hydrates the cart and the wishlist, Home fetches, the header
/// reads the profile — and each was redeclaring them privately: eight fakes
/// across twenty-two declarations, which is eight chances for two tests to
/// disagree about what an empty cart looks like.
///
/// Each counts its [calls], because "how many times did entering a store
/// fetch this?" is the question these tests most often exist to answer, and
/// a counter nobody reads costs nothing.
class FakeGetHomeUseCase implements GetHomeUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, HomeEntity>> call(GetHomeParams params) async {
    calls++;
    return right(
      const HomeEntity(categories: [], popularProducts: [], banners: []),
    );
  }
}

class FakeGetCartUseCase implements GetCartUseCase {
  int calls = 0;

  /// What the server is holding. Set before the fetch a test cares about.
  List<CartItemEntity> result = const [];

  /// Set to hold a fetch open. The cubit's staleness guards only matter
  /// while one is in flight, so a test that wants to end a session
  /// mid-fetch completes this when it is ready.
  Completer<List<CartItemEntity>>? gate;

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(
    GetCartParams params,
  ) async {
    calls++;
    final pending = gate;
    if (pending != null) return right(await pending.future);
    return right(result);
  }
}

class FakeSaveCartUseCase implements SaveCartUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(
    SaveCartParams params,
  ) async {
    calls++;
    return right(params.items);
  }
}

class FakeValidateCouponUseCase implements ValidateCouponUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, AppliedCouponEntity>> call(
    ValidateCouponParams params,
  ) async {
    calls++;
    return right(const AppliedCouponEntity(code: '', discount: 0));
  }
}

class FakeGetFavouritesUseCase implements GetFavouritesUseCase {
  int calls = 0;
  List<ProductEntity> result = const [];

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetFavouritesParams params,
  ) async {
    calls++;
    return right(result);
  }
}

class FakeAddFavouriteUseCase implements AddFavouriteUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, void>> call(AddFavouriteParams params) async {
    calls++;
    return right(null);
  }
}

class FakeRemoveFavouriteUseCase implements RemoveFavouriteUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, void>> call(RemoveFavouriteParams params) async {
    calls++;
    return right(null);
  }
}

class FakeGetProfileUseCase implements GetProfileUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
    calls++;
    return right(
      const ProfileEntity(
        name: 'Test',
        email: 't@t.co',
        phone: '',
        avatarUrl: '',
      ),
    );
  }
}
