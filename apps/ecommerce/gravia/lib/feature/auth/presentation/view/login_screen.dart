import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/inline_text_link.dart';
import 'package:core/core/ui/atoms/labeled_divider.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/dimen_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/mixins/textfield_validations.dart';
import 'package:gravia/widgets/gravia_form_field.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/login_header.dart';
import '../widgets/terms_footer.dart';

enum _LoginField { email, password }

class LoginScreen extends BaseScreen {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreen>
    with TextfieldValidations {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Map<_LoginField, String> _errors = {};
  bool _sheetOpen = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError(_LoginField field) {
    if (_errors.containsKey(field)) setState(() => _errors.remove(field));
  }

  bool _validate() {
    final errors = <_LoginField, String>{};
    final emailError = validateEmail(_emailController.text);
    if (emailError != null) errors[_LoginField.email] = emailError;
    final passwordError = validatePassword(_passwordController.text);
    if (passwordError != null) errors[_LoginField.password] = passwordError;
    if (errors.isNotEmpty) {
      setState(() {
        _errors
          ..clear()
          ..addAll(errors);
      });
    }
    return errors.isEmpty;
  }

  void _submit() {
    if (!_validate()) return;
    context.read<AuthBloc>().add(
      AuthEvent.loginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => switch (state) {
        AuthAwaitingVerification(:final email) => _openVerifySheet(email),
        AuthAuthenticated() => _closeSheetAndGoHome(),
        AuthError(:final message) => showSnackBar(message),
        _ => null,
      },
      child: Column(
        children: [
          Expanded(
            child: CollapsingHeaderSheet(
              initialHeaderHeight: 210,
              header: const LoginHeader(),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GraviaFormField(
                          label: ValueConst.emailLabel,
                          controller: _emailController,
                          hint: ValueConst.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _errors[_LoginField.email],
                          onChanged: (_) => _clearError(_LoginField.email),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        GraviaFormField(
                          label: ValueConst.passwordLabel,
                          controller: _passwordController,
                          hint: ValueConst.passwordHint,
                          obscureText: true,
                          errorText: _errors[_LoginField.password],
                          onChanged: (_) => _clearError(_LoginField.password),
                        ),
                        const SizedBox(height: AppSpacing.xl2),
                        GraviaPrimaryButton(
                          label: ValueConst.continueLabel,
                          state: isLoading
                              ? AppButtonState.loading
                              : AppButtonState.idle,
                          onTap: isLoading ? null : _submit,
                        ),
                        const SizedBox(height: AppSpacing.xl2),
                        AppLabeledDivider(
                          label: ValueConst.orLoginWith,
                          textStyle:
                              TextStyleConst.textSmRegular(
                                Theme.of(context).textTheme,
                              ).copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(
                          label: ValueConst.continueWithGoogle,
                          variant: AppButtonVariant.secondary,
                          fullWidth: true,
                          leadingIcon: AppSvgImage.asset(
                            ImageConst.googleIcon,
                            width: 20,
                            height: 20,
                          ),

                          labelStyle: TextStyleConst.textMdMedium(
                            Theme.of(context).textTheme,
                          ),
                          height: DimenConst.controlHeight,
                          onTap: () =>
                              showSnackBar(ValueConst.comingSoonMessage),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppButton(
                          label: ValueConst.continueWithApple,
                          variant: AppButtonVariant.secondary,
                          fullWidth: true,
                          leadingIcon: AppSvgImage.asset(
                            ImageConst.appleIcon,
                            width: 20,
                            height: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          labelStyle: TextStyleConst.textMdMedium(
                            Theme.of(context).textTheme,
                          ),
                          height: DimenConst.controlHeight,
                          onTap: () =>
                              showSnackBar(ValueConst.comingSoonMessage),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TermsFooter(),
                    const SizedBox(height: AppSpacing.lg),
                    AppInlineTextLink(
                      text: ValueConst.dontHaveAccount,
                      linkText: ValueConst.signupLink,
                      onTap: () => context.push(AppRoutes.signup),
                      textStyle:
                          TextStyleConst.textSmRegular(
                            Theme.of(context).textTheme,
                          ).copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                      linkStyle: TextStyleConst.textSmMedium(
                        Theme.of(context).textTheme,
                      ).copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openVerifySheet(String email) async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    await showVerifyEmailSheetHere(
      email: email,
      onResend: () => context.read<AuthBloc>().add(
        const AuthEvent.resendVerificationRequested(),
      ),
    );
    _sheetOpen = false;
  }

  void _closeSheetAndGoHome() {
    if (_sheetOpen && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      _sheetOpen = false;
    }
    context.go(AppRoutes.home);
  }
}
