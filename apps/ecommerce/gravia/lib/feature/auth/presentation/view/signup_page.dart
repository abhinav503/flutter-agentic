import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/auth_bloc.dart';
import 'signup_screen.dart';

class SignupPage extends BasePage {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends BasePageState<SignupPage> {
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      resendVerificationEmailUseCase: sl(),
      checkEmailVerifiedUseCase: sl(),
    )..add(const AuthEvent.started()),
    child: const SignupScreen(),
  );
}
