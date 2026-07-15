import 'package:core/core/di/core_injection.dart';

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

  // ── Home (storefront) ──────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => const HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetHomeUseCase(sl()));

  // ── Search ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => const SearchRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl()),
  );
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
}
