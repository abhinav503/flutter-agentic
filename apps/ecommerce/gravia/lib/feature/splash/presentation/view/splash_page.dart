import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/image_const.dart';
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
  Widget buildBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final wordmarkStyle = Theme.of(context).textTheme.displaySmall!.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        );

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  style: wordmarkStyle,
                  children: [
                    const TextSpan(text: ValueConst.splashWordmarkLeft),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs4,
                        ),
                        child: SvgPicture.asset(
                          ImageConst.graviaBrandIcon,
                          height: wordmarkStyle.fontSize! * 0.72,
                        ),
                      ),
                    ),
                    const TextSpan(text: ValueConst.splashWordmarkRight),
                  ],
                ),
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
