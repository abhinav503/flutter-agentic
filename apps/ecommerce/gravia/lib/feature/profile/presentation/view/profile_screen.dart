import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/switch.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'package:gravia/feature/shell/presentation/view/shell_page.dart';
import 'package:gravia/services/firebase_auth_service.dart';
import 'package:gravia/services/user_profile_cache_service.dart';

import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_hero_header.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileScreen extends BaseScreen {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen> {
  /// Pushes the Edit Profile form prefilled from [profile]; if it returned a
  /// result (Cancel/back pops with none), dispatches it into this screen's
  /// own `ProfileBloc` so the header updates without a re-fetch.
  Future<void> _openEditProfile(ProfileEntity profile) async {
    final result = await context.push<ProfileEntity>(
      AppRoutes.editProfile,
      extra: profile,
    );
    if (result == null || !mounted) return;
    context.read<ProfileBloc>().add(ProfileEvent.saved(profile: result));
  }

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state case ProfileError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          ProfileLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          ProfileError() => SafeArea(
            child: ErrorView(
              message: ValueConst.profileLoadErrorMessage,
              onRetry: () =>
                  context.read<ProfileBloc>().add(const ProfileEvent.started()),
            ),
          ),
          ProfileLoaded(:final profile) => CollapsingHeaderSheet(
            initialHeaderHeight: 195,
            header: ProfileHeroHeader(
              profile: profile,
              onEditTap: () => _openEditProfile(profile),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl2,
              ),
              child: Column(
                children: [
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.lock,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.changePasswordLabel,
                    onTap: () => showSnackBar(ValueConst.comingSoonMessage),
                  ),
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.shoppingBag,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.myOrdersLabel,
                    // Orders isn't a standalone route — it's a ShellPage tab
                    // — so this jumps the shell there directly, same
                    // mechanism as the Order Placed sheet's "Track Your
                    // Order" (docs/ai-rules/design.md).
                    onTap: () => context.go(
                      AppRoutes.home,
                      extra: ShellPage.ordersTabIndex,
                    ),
                  ),
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.locationIcon,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.myAddressLabel,
                    onTap: () => context.push(AppRoutes.selectAddress),
                  ),
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.eye,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.darkModeLabel,
                    // Material's own Switch grows the thumb when selected
                    // (M3 spec: active radius 12, inactive 8) with no public
                    // way to equalize them — AppSwitch keeps one fixed thumb
                    // size in both states instead, plus the exact kit-spec
                    // track colours (Gray/100 off, Success/500 on).
                    trailing: AppSwitch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (isDark) => ThemeModeScope.of(
                        context,
                      ).setMode(isDark ? ThemeMode.dark : ThemeMode.light),
                      activeTrackColor: ColorConst.success500,
                      inactiveTrackColor: ColorConst.gray100,
                    ),
                  ),
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.shieldCheck,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.privacyPolicyLabel,
                    onTap: () => context.push(AppRoutes.privacyPolicy),
                  ),
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.notes,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.termsAndConditionsLabel,
                    onTap: () => context.push(AppRoutes.termsAndConditions),
                  ),
                  ProfileMenuTile(
                    iconBuilder: (color, size) => AppSvgImage.asset(
                      ImageConst.logout,
                      color: color,
                      width: size,
                      height: size,
                    ),
                    label: ValueConst.logoutLabel,
                    danger: true,
                    trailing: const SizedBox.shrink(),
                    onTap: () => _signOut(context),
                  ),
                ],
              ),
            ),
          ),
        },
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuthService.instance.signOut();
    await UserProfileCacheService.instance.clear();
    // Defensive — Profile is only reachable once AuthAuthenticated has fired,
    // which already clears this key, but a stale flag here would wrongly
    // reopen the verify sheet for the next account signing in on this device.
    await SharedPreferenceService.instance.setBool(
      kPendingEmailVerificationPrefKey,
      false,
    );
    if (context.mounted) context.go(AppRoutes.login);
  }
}
