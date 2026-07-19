import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/auth_bloc.dart';
import 'login_screen.dart';

class LoginPage extends BasePage {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage> {
  // Login's docked footer (Terms + "Don't have an account?") lives outside
  // CollapsingHeaderSheet's scrollable body, as a plain Column sibling — the
  // default resize would shrink that whole Column when the keyboard opens,
  // dragging the footer up to hover just above the keyboard instead of
  // staying put behind it. The Email/Password fields still scroll into view
  // on focus regardless (that's MediaQuery.viewInsets-driven, not tied to
  // this flag) since they sit inside a real Scrollable.
  @override
  bool get resizeToAvoidBottomInset => false;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      resendVerificationEmailUseCase: sl(),
      checkEmailVerifiedUseCase: sl(),
      forgotPasswordUseCase: sl(),
    )..add(const AuthEvent.started()),
    child: const LoginScreen(),
  );
}
