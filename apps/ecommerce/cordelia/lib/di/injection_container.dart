import 'package:core/core/di/core_injection.dart';

import '../feature/auth/data/data_source/auth_remote_data_source.dart';
import '../feature/auth/data/data_source/auth_remote_data_source_impl.dart';
import '../feature/auth/data/repository_impl/auth_repository_impl.dart';
import '../feature/auth/domain/repository/auth_repository.dart';
import '../feature/auth/domain/usecase/change_password_usecase.dart';
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
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  // ── Home (store discovery) ─────────────────────────────────────────────
  sl.registerLazySingleton<StoresRemoteDataSource>(
    () => const StoresRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<StoresRepository>(() => StoresRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetStoresUseCase(sl()));
}
