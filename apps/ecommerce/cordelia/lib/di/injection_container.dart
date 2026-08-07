import 'package:core/core/di/core_injection.dart';

import '../feature/auth/data/data_source/auth_remote_data_source.dart';
import '../feature/auth/data/data_source/auth_remote_data_source_impl.dart';
import '../feature/auth/data/repository_impl/auth_repository_impl.dart';
import '../feature/auth/domain/repository/auth_repository.dart';
import '../feature/auth/domain/usecase/change_password_usecase.dart';
import '../feature/auth/domain/usecase/delete_account_usecase.dart';
import '../feature/auth/domain/usecase/check_email_verified_usecase.dart';
import '../feature/auth/domain/usecase/forgot_password_usecase.dart';
import '../feature/auth/domain/usecase/resend_verification_email_usecase.dart';
import '../feature/auth/domain/usecase/sign_in_usecase.dart';
import '../feature/auth/domain/usecase/sign_out_usecase.dart';
import '../feature/auth/domain/usecase/sign_up_usecase.dart';
import '../feature/auth/domain/usecase/update_profile_usecase.dart';
import '../feature/home/data/data_source/stores_remote_data_source.dart';
import '../feature/home/data/data_source/stores_remote_data_source_impl.dart';
import '../feature/home/data/repository_impl/stores_repository_impl.dart';
import '../feature/home/domain/repository/stores_repository.dart';
import '../feature/home/domain/usecase/get_stores_usecase.dart';
import '../feature/storefront/cart/data/data_source/cart_remote_data_source.dart';
import '../feature/storefront/cart/data/data_source/cart_remote_data_source_impl.dart';
import '../feature/storefront/cart/data/data_source/coupons_remote_data_source.dart';
import '../feature/storefront/cart/data/data_source/coupons_remote_data_source_impl.dart';
import '../feature/storefront/cart/data/repository_impl/cart_repository_impl.dart';
import '../feature/storefront/cart/data/repository_impl/coupons_repository_impl.dart';
import '../feature/storefront/cart/domain/repository/cart_repository.dart';
import '../feature/storefront/cart/domain/repository/coupons_repository.dart';
import '../feature/storefront/cart/domain/usecase/get_cart_usecase.dart';
import '../feature/storefront/cart/domain/usecase/validate_coupon_usecase.dart';
import '../feature/storefront/cart/domain/usecase/save_cart_usecase.dart';
import '../feature/storefront/address/data/data_source/address_remote_data_source.dart';
import '../feature/storefront/address/data/data_source/address_remote_data_source_impl.dart';
import '../feature/storefront/address/data/repository_impl/address_repository_impl.dart';
import '../feature/storefront/address/domain/repository/address_repository.dart';
import '../feature/storefront/address/domain/usecase/create_address_usecase.dart';
import '../feature/storefront/address/domain/usecase/delete_address_usecase.dart';
import '../feature/storefront/address/domain/usecase/get_addresses_usecase.dart';
import '../feature/storefront/address/domain/usecase/update_address_usecase.dart';
import '../feature/storefront/categories/data/data_source/categories_remote_data_source.dart';
import '../feature/storefront/categories/data/data_source/categories_remote_data_source_impl.dart';
import '../feature/storefront/categories/data/repository_impl/categories_repository_impl.dart';
import '../feature/storefront/categories/domain/repository/categories_repository.dart';
import '../feature/storefront/categories/domain/usecase/get_categories_usecase.dart';
import '../feature/storefront/category_details/data/data_source/category_details_remote_data_source.dart';
import '../feature/storefront/category_details/data/data_source/category_details_remote_data_source_impl.dart';
import '../feature/storefront/category_details/data/repository_impl/category_details_repository_impl.dart';
import '../feature/storefront/category_details/domain/repository/category_details_repository.dart';
import '../feature/storefront/category_details/domain/usecase/get_category_details_usecase.dart';
import '../feature/storefront/geo/data/data_source/geo_remote_data_source.dart';
import '../feature/storefront/geo/data/data_source/geo_remote_data_source_impl.dart';
import '../feature/storefront/geo/data/repository_impl/geo_repository_impl.dart';
import '../feature/storefront/geo/domain/repository/geo_repository.dart';
import '../feature/storefront/geo/domain/usecase/get_current_location_address_usecase.dart';
import '../feature/storefront/geo/domain/usecase/lookup_pincode_usecase.dart';
import '../feature/storefront/geo/domain/usecase/reverse_geocode_usecase.dart';
import '../feature/storefront/geo/domain/usecase/search_places_usecase.dart';
import '../feature/storefront/favourites/data/data_source/favourites_remote_data_source.dart';
import '../feature/storefront/favourites/data/data_source/favourites_remote_data_source_impl.dart';
import '../feature/storefront/favourites/data/repository_impl/favourites_repository_impl.dart';
import '../feature/storefront/favourites/domain/repository/favourites_repository.dart';
import '../feature/storefront/favourites/domain/usecase/add_favourite_usecase.dart';
import '../feature/storefront/favourites/domain/usecase/get_favourites_usecase.dart';
import '../feature/storefront/favourites/domain/usecase/remove_favourite_usecase.dart';
import '../feature/storefront/home/data/data_source/home_remote_data_source.dart';
import '../feature/storefront/home/data/data_source/home_remote_data_source_impl.dart';
import '../feature/storefront/home/data/repository_impl/home_repository_impl.dart';
import '../feature/storefront/home/domain/repository/home_repository.dart';
import '../feature/storefront/home/domain/usecase/get_home_usecase.dart';
import '../feature/storefront/notifications/data/data_source/notifications_remote_data_source.dart';
import '../feature/storefront/notifications/data/data_source/notifications_remote_data_source_impl.dart';
import '../feature/storefront/notifications/data/repository_impl/notifications_repository_impl.dart';
import '../feature/storefront/notifications/domain/repository/notifications_repository.dart';
import '../feature/storefront/notifications/domain/usecase/get_notifications_usecase.dart';
import '../feature/storefront/notifications/domain/usecase/mark_notifications_read_usecase.dart';
import '../feature/storefront/orders/data/data_source/orders_remote_data_source.dart';
import '../feature/storefront/orders/data/data_source/orders_remote_data_source_impl.dart';
import '../feature/storefront/orders/data/data_source/payment_gateway_data_source.dart';
import '../feature/storefront/orders/data/data_source/razorpay_gateway_data_source_impl.dart';
import '../feature/storefront/orders/data/repository_impl/orders_repository_impl.dart';
import '../feature/storefront/orders/data/repository_impl/payment_gateway_repository_impl.dart';
import '../feature/storefront/orders/domain/repository/orders_repository.dart';
import '../feature/storefront/orders/domain/repository/payment_gateway_repository.dart';
import '../feature/storefront/orders/domain/usecase/cancel_order_usecase.dart';
import '../feature/storefront/orders/domain/usecase/rate_order_usecase.dart';
import '../feature/storefront/orders/domain/usecase/create_order_usecase.dart';
import '../feature/storefront/orders/domain/usecase/create_payment_usecase.dart';
import '../feature/storefront/orders/domain/usecase/get_orders_usecase.dart';
import '../feature/storefront/orders/domain/usecase/process_payment_usecase.dart';
import '../feature/storefront/product_details/data/data_source/product_details_remote_data_source.dart';
import '../feature/storefront/product_details/data/data_source/product_details_remote_data_source_impl.dart';
import '../feature/storefront/product_details/data/repository_impl/product_details_repository_impl.dart';
import '../feature/storefront/product_details/domain/repository/product_details_repository.dart';
import '../feature/storefront/product_details/domain/usecase/get_product_details_usecase.dart';
import '../feature/storefront/reviews/data/data_source/reviews_remote_data_source.dart';
import '../feature/storefront/reviews/data/data_source/reviews_remote_data_source_impl.dart';
import '../feature/storefront/reviews/data/repository_impl/reviews_repository_impl.dart';
import '../feature/storefront/reviews/domain/repository/reviews_repository.dart';
import '../feature/storefront/reviews/domain/usecase/delete_my_review_usecase.dart';
import '../feature/storefront/reviews/domain/usecase/get_product_reviews_usecase.dart';
import '../feature/storefront/reviews/domain/usecase/submit_product_review_usecase.dart';
import '../feature/storefront/profile/data/data_source/profile_remote_data_source.dart';
import '../feature/storefront/profile/data/data_source/profile_remote_data_source_impl.dart';
import '../feature/storefront/profile/data/repository_impl/profile_repository_impl.dart';
import '../feature/storefront/profile/domain/repository/profile_repository.dart';
import '../feature/storefront/profile/domain/usecase/get_profile_usecase.dart';
import '../feature/storefront/search/data/data_source/search_remote_data_source.dart';
import '../feature/storefront/search/data/data_source/search_remote_data_source_impl.dart';
import '../feature/storefront/search/data/repository_impl/search_repository_impl.dart';
import '../feature/storefront/search/domain/repository/search_repository.dart';
import '../feature/storefront/search/domain/usecase/add_recent_search_usecase.dart';
import '../feature/storefront/search/domain/usecase/get_search_usecase.dart';
import '../feature/storefront/search/domain/usecase/remove_recent_search_usecase.dart';
import '../feature/storefront/search/domain/usecase/search_catalog_usecase.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the CordeliaApps super app: shared core services first, then this
/// app's features (data sources → repositories → use cases) as they land.
Future<void> initDependencies() async {
  await initCoreDependencies();

  // ── Auth ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => const AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => ResendVerificationEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckEmailVerifiedUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  // ── Home (store discovery) ─────────────────────────────────────────────
  sl.registerLazySingleton<StoresRemoteDataSource>(
    () => const StoresRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<StoresRepository>(() => StoresRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetStoresUseCase(sl()));

  // ── Storefront: Home ────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => const HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetHomeUseCase(sl()));

  // ── Storefront: Orders / Checkout / Payment ────────────────────────────
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => const OrdersRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => CreatePaymentUseCase(sl()));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl()));
  sl.registerLazySingleton(() => RateOrderUseCase(sl()));

  sl.registerLazySingleton<PaymentGatewayDataSource>(
    () => const RazorpayGatewayDataSourceImpl(),
  );
  sl.registerLazySingleton<PaymentGatewayRepository>(
    () => PaymentGatewayRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ProcessPaymentUseCase(sl()));

  // ── Storefront: Cart (own fetch/persist — separate from Checkout) ──────
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => const CartRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => SaveCartUseCase(sl()));

  // ── Storefront: Coupons (the cart's promo row) ───────────────────────────
  sl.registerLazySingleton<CouponsRemoteDataSource>(
    () => const CouponsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CouponsRepository>(
    () => CouponsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ValidateCouponUseCase(sl()));

  // ── Storefront: Favourites ───────────────────────────────────────────────
  sl.registerLazySingleton<FavouritesRemoteDataSource>(
    () => const FavouritesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<FavouritesRepository>(
    () => FavouritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFavouritesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavouriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavouriteUseCase(sl()));

  // ── Storefront: Search ───────────────────────────────────────────────────
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => const SearchRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSearchUseCase(sl()));
  sl.registerLazySingleton(() => SearchCatalogUseCase(sl()));
  sl.registerLazySingleton(() => AddRecentSearchUseCase(sl()));
  sl.registerLazySingleton(() => RemoveRecentSearchUseCase(sl()));

  // ── Storefront: Category Details ────────────────────────────────────────
  sl.registerLazySingleton<CategoryDetailsRemoteDataSource>(
    () => const CategoryDetailsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoryDetailsRepository>(
    () => CategoryDetailsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCategoryDetailsUseCase(sl()));

  // ── Storefront: Product Details ─────────────────────────────────────────
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => const ProductDetailsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));

  // ── Storefront: Product Reviews ─────────────────────────────────────────
  sl.registerLazySingleton<ReviewsRemoteDataSource>(
    () => const ReviewsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProductReviewsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitProductReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMyReviewUseCase(sl()));

  // ── Storefront: Categories (storeId-scoped catalog) ─────────────────────
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => const CategoriesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // ── Storefront: Profile (user-scoped, not per-store) ────────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => const ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  // ── Storefront: Address (user-scoped, not per-store) ────────────────────
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => const AddressRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAddressesUseCase(sl()));
  sl.registerLazySingleton(() => CreateAddressUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));

  // ── Storefront: Geo (user-scoped address-form lookups via /api/geo/*) ───
  sl.registerLazySingleton<GeoRemoteDataSource>(
    () => const GeoRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<GeoRepository>(() => GeoRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCurrentLocationAddressUseCase(sl()));
  sl.registerLazySingleton(() => ReverseGeocodeUseCase(sl()));
  sl.registerLazySingleton(() => SearchPlacesUseCase(sl()));
  sl.registerLazySingleton(() => LookupPincodeUseCase(sl()));

  // ── Storefront: Notifications (store feed + CordeliaApps platform feed,
  // merged server-side) ───────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => const NotificationsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationsReadUseCase(sl()));
}
