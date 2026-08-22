import 'package:core/core/base/base_page.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/onboarding/presentation/view/onboarding_page.dart';

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
      // Discovery either way. Browsing needs no account — a signed-out
      // shopper reaches stores, products, search and reviews, and meets the
      // sign-in gate only at the first thing that writes something of theirs
      // (see SignInGateX). A marketplace whose proposition is "discover
      // stores" cannot open with a signup form in front of that promise.
      //
      // Signed in but unverified still lands here too: they genuinely have a
      // session, and DiscoveryPage's own AuthBloc.started() (the same resume
      // check Login/Signup use) re-opens the persistent verify sheet on top.
      context.go(AppRoutes.discovery);
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              // Mark plus live text, not one baked wordmark SVG: the name then
              // renders in the theme's own typeface and inverts with the theme,
              // neither of which an exported wordmark can do. (The previous
              // asset set its text in an SVG `<text>` element, which
              // flutter_svg does not lay out at all.)
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(ImageConst.cordeliaBrandIcon, height: 34),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    ValueConst.appTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
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
