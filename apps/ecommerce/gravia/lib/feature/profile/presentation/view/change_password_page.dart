import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/change_password_bloc.dart';
import 'change_password_screen.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends BasePageState<ChangePasswordPage> {
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => ChangePasswordBloc(changePasswordUseCase: sl()),
    child: const ChangePasswordScreen(),
  );
}
