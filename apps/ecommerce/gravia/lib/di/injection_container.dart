import 'package:core/core/di/core_injection.dart';

import '../feature/address/data/data_source/address_remote_data_source.dart';
import '../feature/address/data/data_source/address_remote_data_source_impl.dart';
import '../feature/address/data/repository_impl/address_repository_impl.dart';
import '../feature/address/domain/repository/address_repository.dart';
import '../feature/address/domain/usecase/get_addresses_usecase.dart';
import '../feature/auth/data/data_source/auth_remote_data_source.dart';
import '../feature/auth/data/data_source/auth_remote_data_source_impl.dart';
import '../feature/auth/data/repository_impl/auth_repository_impl.dart';
import '../feature/auth/domain/repository/auth_repository.dart';
import '../feature/auth/domain/usecase/check_email_verified_usecase.dart';
import '../feature/auth/domain/usecase/resend_verification_email_usecase.dart';
import '../feature/auth/domain/usecase/sign_in_usecase.dart';
import '../feature/auth/domain/usecase/sign_out_usecase.dart';
import '../feature/auth/domain/usecase/sign_up_usecase.dart';
import '../feature/auth/domain/usecase/update_profile_usecase.dart';
import '../feature/categories/data/data_source/categories_remote_data_source.dart';
import '../feature/categories/data/data_source/categories_remote_data_source_impl.dart';
import '../feature/categories/data/repository_impl/categories_repository_impl.dart';
import '../feature/categories/domain/repository/categories_repository.dart';
import '../feature/categories/domain/usecase/get_categories_usecase.dart';
import '../feature/category_details/data/data_source/category_details_remote_data_source.dart';
import '../feature/category_details/data/data_source/category_details_remote_data_source_impl.dart';
import '../feature/category_details/data/repository_impl/category_details_repository_impl.dart';
import '../feature/category_details/domain/repository/category_details_repository.dart';
import '../feature/category_details/domain/usecase/get_category_details_usecase.dart';
import '../feature/home/data/data_source/home_remote_data_source.dart';
import '../feature/home/data/data_source/home_remote_data_source_impl.dart';
import '../feature/home/data/repository_impl/home_repository_impl.dart';
import '../feature/home/domain/repository/home_repository.dart';
import '../feature/home/domain/usecase/get_home_usecase.dart';
import '../feature/notifications/data/data_source/notifications_remote_data_source.dart';
import '../feature/notifications/data/data_source/notifications_remote_data_source_impl.dart';
import '../feature/notifications/data/repository_impl/notifications_repository_impl.dart';
import '../feature/notifications/domain/repository/notifications_repository.dart';
import '../feature/notifications/domain/usecase/get_notifications_usecase.dart';
import '../feature/orders/data/data_source/orders_remote_data_source.dart';
import '../feature/orders/data/data_source/orders_remote_data_source_impl.dart';
import '../feature/orders/data/repository_impl/orders_repository_impl.dart';
import '../feature/orders/domain/repository/orders_repository.dart';
import '../feature/orders/domain/usecase/get_orders_usecase.dart';
import '../feature/product_details/data/data_source/product_details_remote_data_source.dart';
import '../feature/product_details/data/data_source/product_details_remote_data_source_impl.dart';
import '../feature/product_details/data/repository_impl/product_details_repository_impl.dart';
import '../feature/product_details/domain/repository/product_details_repository.dart';
import '../feature/product_details/domain/usecase/get_product_details_usecase.dart';
import '../feature/profile/data/data_source/profile_remote_data_source.dart';
import '../feature/profile/data/data_source/profile_remote_data_source_impl.dart';
import '../feature/profile/data/repository_impl/profile_repository_impl.dart';
import '../feature/profile/domain/repository/profile_repository.dart';
import '../feature/profile/domain/usecase/get_profile_usecase.dart';
import '../feature/search/data/data_source/search_remote_data_source.dart';
import '../feature/search/data/data_source/search_remote_data_source_impl.dart';
import '../feature/search/data/repository_impl/search_repository_impl.dart';
import '../feature/search/domain/repository/search_repository.dart';
import '../feature/search/domain/usecase/get_search_usecase.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the Gravia app: shared core services first, then this app's
/// features (data sources → repositories → use cases) as they land.
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

  // ── Home (storefront) ──────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => const HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetHomeUseCase(sl()));

  // ── Search ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => const SearchRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSearchUseCase(sl()));

  // ── Categories ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => const CategoriesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // ── Category Details ────────────────────────────────────────────────────
  sl.registerLazySingleton<CategoryDetailsRemoteDataSource>(
    () => const CategoryDetailsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoryDetailsRepository>(
    () => CategoryDetailsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCategoryDetailsUseCase(sl()));

  // ── Product Details ─────────────────────────────────────────────────────
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => const ProductDetailsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));

  // ── Profile ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => const ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  // ── Address ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => const AddressRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAddressesUseCase(sl()));

  // ── Orders ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => const OrdersRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));

  // ── Notifications ────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => const NotificationsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
}
