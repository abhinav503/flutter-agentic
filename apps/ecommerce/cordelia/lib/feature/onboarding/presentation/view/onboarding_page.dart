import 'package:core/core/base/base_page.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

/// Key `SharedPreferenceService` uses to remember that the first-launch
/// carousel has been completed — read by `SplashPage`, written here.
const kHasSeenOnboardingPrefKey = 'has_seen_onboarding';

class OnboardingPage extends BasePage {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends BasePageState<OnboardingPage> {
  @override
  bool get resizeToAvoidBottomInset => false;

  @override
  Widget buildBody(BuildContext context) => const OnboardingScreen();
}
