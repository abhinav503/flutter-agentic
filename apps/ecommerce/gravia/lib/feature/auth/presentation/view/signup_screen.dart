import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/atoms/inline_text_link.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/mixins/textfield_validations.dart';
import 'package:gravia/widgets/gravia_form_field.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/signup_header.dart';

enum _SignupField { name, email, mobile, password }

class SignupScreen extends BaseScreen {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends BaseScreenState<SignupScreen>
    with TextfieldValidations {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  final Map<_SignupField, String> _errors = {};
  bool _agreedToTerms = true;
  bool _sheetOpen = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError(_SignupField field) {
    if (_errors.containsKey(field)) setState(() => _errors.remove(field));
  }

  bool _validate() {
    final errors = <_SignupField, String>{};
    final nameError = validateName(_nameController.text);
    if (nameError != null) errors[_SignupField.name] = nameError;
    final emailError = validateEmail(_emailController.text);
    if (emailError != null) errors[_SignupField.email] = emailError;
    final mobileError = validateMobile(_mobileController.text);
    if (mobileError != null) errors[_SignupField.mobile] = mobileError;
    final passwordError = validatePassword(_passwordController.text);
    if (passwordError != null) errors[_SignupField.password] = passwordError;
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
    if (!_agreedToTerms) {
      showSnackBar(ValueConst.mustAgreeToTermsMessage);
      return;
    }
    if (!_validate()) return;
    context.read<AuthBloc>().add(
      AuthEvent.signUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim(),
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
      child: CollapsingHeaderSheet(
        initialHeaderHeight: 170,
        header: SignupHeader(onBack: () => context.pop()),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GraviaFormField(
                    label: ValueConst.nameLabel,
                    controller: _nameController,
                    hint: ValueConst.nameHint,
                    keyboardType: TextInputType.name,
                    errorText: _errors[_SignupField.name],
                    onChanged: (_) => _clearError(_SignupField.name),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GraviaFormField(
                    label: ValueConst.emailLabel,
                    controller: _emailController,
                    hint: ValueConst.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _errors[_SignupField.email],
                    onChanged: (_) => _clearError(_SignupField.email),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GraviaFormField(
                    label: ValueConst.mobileLabel,
                    controller: _mobileController,
                    hint: ValueConst.mobileHint,
                    keyboardType: TextInputType.phone,
                    errorText: _errors[_SignupField.mobile],
                    onChanged: (_) => _clearError(_SignupField.mobile),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GraviaFormField(
                    label: ValueConst.passwordLabel,
                    controller: _passwordController,
                    hint: ValueConst.passwordHint,
                    obscureText: true,
                    errorText: _errors[_SignupField.password],
                    onChanged: (_) => _clearError(_SignupField.password),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _agreedToTerms = !_agreedToTerms),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppCheckbox(
                          value: _agreedToTerms,
                          shape: AppCheckboxShape.square,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text.rich(
                          TextSpan(
                            style:
                                TextStyleConst.textSmRegular(
                                  Theme.of(context).textTheme,
                                ).copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            children: [
                              const TextSpan(text: ValueConst.iAgreeLabel),
                              TextSpan(
                                text: ValueConst.termsAndConditionsLink,
                                style:
                                    TextStyleConst.textSmMedium(
                                      Theme.of(context).textTheme,
                                    ).copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.push(
                                    AppRoutes.termsAndConditions,
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  GraviaPrimaryButton(
                    label: ValueConst.signupButtonLabel,
                    state: isLoading
                        ? AppButtonState.loading
                        : AppButtonState.idle,
                    onTap: isLoading ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  AppInlineTextLink(
                    text: ValueConst.alreadyHaveAccount,
                    linkText: ValueConst.loginLink,
                    onTap: () => context.pop(),
                    textStyle:
                        TextStyleConst.textSmRegular(
                          Theme.of(context).textTheme,
                        ).copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    linkStyle: TextStyleConst.textSmMedium(
                      Theme.of(context).textTheme,
                    ).copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              );
            },
          ),
        ),
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
