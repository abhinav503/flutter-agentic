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
import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/app_update/presentation/bloc/app_update_bloc.dart';
import 'package:cordelia/feature/app_update/presentation/view/update_required_screen.dart';
import 'package:cordelia/feature/onboarding/presentation/view/onboarding_page.dart';
import 'package:cordelia/services/app_info_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends BasePage {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BasePageState<SplashPage> {
  static const _holdDuration = Duration(milliseconds: 1600);

  // The brand hold and the version check run together; whichever is
  // slower decides when the splash ends. A check that fails resolves to
  // "proceed" inside the bloc, so the splash can never hang on it.
  late final AppUpdateBloc _updateBloc =
      AppUpdateBloc(getUpdateRequirementUseCase: sl())..add(
        AppUpdateEvent.started(
          installedVersion: AppInfoService.instance.version,
        ),
      );
  late final Future<void> _hold = Future.delayed(_holdDuration);

  @override
  void dispose() {
    _updateBloc.close();
    super.dispose();
  }

  @override
  Widget buildBlocProviders(Widget child) =>
      BlocProvider.value(value: _updateBloc, child: child);

  Future<void> _proceed() async {
    await _hold;
    if (!mounted) return;
    {
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
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocConsumer<AppUpdateBloc, AppUpdateState>(
      listener: (context, state) {
        if (state is AppUpdateProceed) _proceed();
      },
      builder: (context, state) => switch (state) {
        AppUpdateChecking() || AppUpdateProceed() => _brandHold(context),
        AppUpdateRequired(:final requirement) => UpdateRequiredScreen(
          requirement: requirement,
        ),
      },
    );
  }

  Widget _brandHold(BuildContext context) {
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
