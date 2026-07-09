import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';

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
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  Color backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  @override
  Widget buildBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Translucent on-primary circle — the gravia on-header
                // control treatment (design.md), scaled up as the brand mark.
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl2),
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_basket_rounded,
                    size: 64,
                    color: cs.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl2),
                Text(
                  ValueConst.appTitle,
                  style: tt.displaySmall!.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ValueConst.splashTagline,
                  style: tt.bodyLarge!.copyWith(
                    color: cs.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl4),
            child: LoadingDots(color: cs.onPrimary),
          ),
        ],
      ),
    );
  }
}
