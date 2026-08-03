import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../bloc/change_password_bloc.dart';
import 'change_password_screen.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends BasePageState<ChangePasswordPage> {
  /// No app bar anywhere in this pack — the screen renders its own header row
  /// as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => ChangePasswordBloc(changePasswordUseCase: sl()),
    child: const ChangePasswordScreen(),
  );
}
