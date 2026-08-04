import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../bloc/change_password_bloc_provider.dart';
import 'change_password_screen.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends BasePageState<ChangePasswordPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) =>
      changePasswordBlocProvider(child: const ChangePasswordScreen());
}
