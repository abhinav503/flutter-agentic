import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/usecase/usecase.dart';

import 'package:gravia/constants/value_const.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/check_email_verified_usecase.dart';
import '../../domain/usecase/resend_verification_email_usecase.dart';
import '../../domain/usecase/sign_in_usecase.dart';
import '../../domain/usecase/sign_up_usecase.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// Key `SharedPreferenceService` uses to remember "signed up/in but not yet
/// verified" across app relaunches — read on `AuthStarted`, written by
/// [AuthBloc]. Per product spec: a pending user reopening the app lands
/// straight back on the persistent verify sheet, no way around it.
const kPendingEmailVerificationPrefKey = 'pending_email_verification';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUp;
  final SignInUseCase _signIn;
  final ResendVerificationEmailUseCase _resendVerification;
  final CheckEmailVerifiedUseCase _checkEmailVerified;

  Timer? _verificationTimer;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required ResendVerificationEmailUseCase resendVerificationEmailUseCase,
    required CheckEmailVerifiedUseCase checkEmailVerifiedUseCase,
  }) : _signUp = signUpUseCase,
       _signIn = signInUseCase,
       _resendVerification = resendVerificationEmailUseCase,
       _checkEmailVerified = checkEmailVerifiedUseCase,
       super(const AuthState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthResendVerificationRequested>(_onResendVerificationRequested);
    on<AuthVerificationTicked>(_onVerificationTicked);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = FirebaseAuthService.instance.currentUser;
    final pending =
        SharedPreferenceService.instance.getBool(
          kPendingEmailVerificationPrefKey,
        ) ??
        false;
    if (user != null && pending) {
      await _enterAwaitingVerification(emit, user.email ?? '');
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (kIsWeb) {
      emit(
        const AuthState.error(message: ValueConst.authWebUnsupportedMessage),
      );
      return;
    }
    emit(const AuthState.loading());
    final result = await _signUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        mobile: event.mobile,
        password: event.password,
      ),
    );
    await result.fold(
      (failure) async => emit(AuthState.error(message: failure.message)),
      (user) async => _enterAwaitingVerification(emit, user.email),
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (kIsWeb) {
      emit(
        const AuthState.error(message: ValueConst.authWebUnsupportedMessage),
      );
      return;
    }
    emit(const AuthState.loading());
    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );
    await result.fold(
      (failure) async {
        emit(AuthState.error(message: failure.message));
      },
      (user) async {
        if (user.emailVerified) {
          await SharedPreferenceService.instance.setBool(
            kPendingEmailVerificationPrefKey,
            false,
          );
          emit(AuthState.authenticated(user: user));
        } else {
          await _enterAwaitingVerification(emit, user.email);
        }
      },
    );
  }

  Future<void> _onResendVerificationRequested(
    AuthResendVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _resendVerification(const NoParams());
    // Only react on failure (e.g. Firebase rate-limits it) — the sheet's own
    // cooldown already reflects a successful resend, nothing else to emit.
    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (_) {},
    );
  }

  Future<void> _onVerificationTicked(
    AuthVerificationTicked event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _checkEmailVerified(const NoParams());
    await result.fold(
      // Transient poll failure (network blip) — stay in awaitingVerification,
      // the sheet never closes on its own, just retry next tick.
      (failure) async {},
      (user) async {
        if (user == null) return;
        _verificationTimer?.cancel();
        await SharedPreferenceService.instance.setBool(
          kPendingEmailVerificationPrefKey,
          false,
        );
        emit(AuthState.authenticated(user: user));
      },
    );
  }

  Future<void> _enterAwaitingVerification(
    Emitter<AuthState> emit,
    String email,
  ) async {
    await SharedPreferenceService.instance.setBool(
      kPendingEmailVerificationPrefKey,
      true,
    );
    emit(AuthState.awaitingVerification(email: email));
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => add(const AuthEvent.verificationTicked()),
    );
  }

  @override
  Future<void> close() {
    _verificationTimer?.cancel();
    return super.close();
  }
}
