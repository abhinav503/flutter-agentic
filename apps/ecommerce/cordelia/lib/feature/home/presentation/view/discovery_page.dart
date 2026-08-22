import 'package:core/core/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:cordelia/feature/home/presentation/bloc/discovery_bloc.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc_provider.dart';
import 'package:cordelia/widgets/cordelia_sheet.dart';

import 'discovery_screen.dart';

/// The app's entry point after auth — CordeliaApps' own store-search
/// surface, not any one store's UI. Deliberately hosts the persistent
/// verify-email-sheet resume logic here (mirroring gravia's `ShellPage`
/// pattern, scoped one level down since this app has no tab shell) rather
/// than at `app.dart`'s root — so a future storefront/store-UI route stays
/// free of this platform-level auth plumbing.
class DiscoveryPage extends BasePage {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends BasePageState<DiscoveryPage> {
  bool _verifySheetOpen = false;

  // A relaunch-while-unverified session lands here (Splash sends any signed-
  // in user straight to home, verified or not — see its own doc) rather
  // than back to Login, since the user genuinely does have a session.
  // AuthBloc.started() (the same resume check Login/Signup use) detects the
  // still-pending case and re-opens the persistent verify sheet on top of
  // discovery instead. Nothing to do for every other outcome — this is a
  // resume check, not a live auth flow, so the listener only reacts to
  // awaitingVerification.
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
    create: (_) => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      resendVerificationEmailUseCase: sl(),
      checkEmailVerifiedUseCase: sl(),
      forgotPasswordUseCase: sl(),
      authSession: sl(),
    )..add(const AuthEvent.started()),
    child: Builder(
      builder: (context) => BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state case AuthAwaitingVerification(:final email)) {
            _openVerifySheet(email);
          }
          if (state case AuthAuthenticated()) _closeVerifySheet();
        },
        child: child,
      ),
    ),
  );

  Future<void> _openVerifySheet(String email) async {
    if (_verifySheetOpen) return;
    _verifySheetOpen = true;
    await showVerifyEmailSheet(
      context: context,
      email: email,
      onResend: () => context.read<AuthBloc>().add(
        const AuthEvent.resendVerificationRequested(),
      ),
    );
    _verifySheetOpen = false;
  }

  void _closeVerifySheet() {
    if (_verifySheetOpen && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      _verifySheetOpen = false;
    }
  }

  // No app bar: the screen opens on its own coloured header canvas, which
  // carries the brand lockup a title bar used to.
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) =>
        DiscoveryBloc(getStoresUseCase: sl())
          ..add(const DiscoveryEvent.started()),
    // Hoisted above the screen so the greeting/avatar survive a rebuild of
    // the discovery list, and so the profile is fetched once per visit
    // rather than once per query.
    child: profileBlocProvider(child: const DiscoveryScreen()),
  );
}
