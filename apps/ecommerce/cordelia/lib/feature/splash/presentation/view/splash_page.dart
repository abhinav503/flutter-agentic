import 'package:core/core/base/base_page.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/feature/onboarding/presentation/view/onboarding_page.dart';
import 'package:cordelia/services/firebase_auth_service.dart';

class SplashPage extends BasePage {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BasePageState<SplashPage> {
  static const _holdDuration = Duration(milliseconds: 1600);

  @override
  void initState() {
    super.initState();
    Future.delayed(_holdDuration, () {
      if (!mounted) return;
      final hasSeenOnboarding =
          SharedPreferenceService.instance.getBool(kHasSeenOnboardingPrefKey) ??
          false;
      if (!hasSeenOnboarding) {
        context.go(AppRoutes.onboarding);
        return;
      }
      // Signed-in always means home (the store-discovery screen), verified
      // or not — a user who is signed in but still unverified genuinely has
      // a session, so sending them to Login would be confusing. HomePage's
      // own AuthBloc.started() (the same resume check Login/Signup use)
      // detects the still-pending case and re-opens the persistent verify
      // sheet on top of discovery.
      final isSignedIn = FirebaseAuthService.instance.currentUser != null;
      context.go(isSignedIn ? AppRoutes.discovery : AppRoutes.login);
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                ImageConst.cordeliaWordmarkIcon,
                height: 45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl4),
            child: LoadingDots(color: cs.primary),
          ),
        ],
      ),
    );
  }
}
