import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/presentation/delete_account.dart';
import 'package:cordelia/feature/auth/presentation/sign_out.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/feature/storefront/shell/presentation/templates/gravia/view/shell_page.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/store_language_switch.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/radio_options_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/templates/gravia/widgets/gravia_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/switch.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/profile_bloc.dart';
import '../widgets/profile_hero_header.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_skeleton_body.dart';

class ProfileScreen extends BaseScreen {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen>
    with DeleteAccountAction {
  void _confirmDeleteAccount() => showGraviaConfirmSheet(
    context: context,
    title: ValueConst.deleteAccountTitle,
    message: ValueConst.deleteAccountConfirmMessage,
    confirmLabel: ValueConst.deleteAccountLabel,
    onConfirm: deleteAccount,
  );

  /// The shopper's per-store language override — persists the pick and
  /// applies the locale in one tap (see [StoreLanguageSwitchX]); the sheet
  /// pops itself before reporting (see [RadioOptionsSheetContent]).
  void _showLanguageSheet() => showGraviaSheet(
    title: GraviaValueConst.languageLabel,
    child: RadioOptionsSheetContent<StoreLanguage>(
      options: StoreLanguage.values,
      labelOf: (language) => language.label,
      selected: context.currentStoreLanguage,
      onSelected: context.switchStoreLanguage,
    ),
  );

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
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return withDeleteAccountProgress(
      BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state case ProfileError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => GraviaSwitcher(
          child: switch (state) {
            // Unreachable: the Profile tab is gated on an account. Shares
            // the skeleton rather than inventing a branch nobody sees.
            ProfileLoading() ||
            ProfileSignedOut() => const CollapsingHeaderSheet(
              key: ValueKey('loading'),
              initialHeaderHeight: GraviaDimenConst.headerHeightIdentity,
              header: ProfileSkeletonHeader(),
              body: ProfileSkeletonBody(),
            ),
            ProfileError() => SafeArea(
              key: const ValueKey('error'),
              child: ErrorView(
                message: GraviaValueConst.profileLoadErrorMessage,
                onRetry: () => context.read<ProfileBloc>().add(
                  const ProfileEvent.started(),
                ),
              ),
            ),
            ProfileLoaded(:final profile) => CollapsingHeaderSheet(
              key: const ValueKey('loaded'),
              initialHeaderHeight: GraviaDimenConst.headerHeightIdentity,
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
                        GraviaImageConst.lock,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.changePasswordLabel,
                      onTap: () => context.push(AppRoutes.changePassword),
                    ),
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.shoppingBag,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.myOrdersLabel,
                      // Orders isn't a standalone route — it's a ShellPage tab
                      // — so this jumps the shell there directly, same
                      // mechanism as the Order Placed sheet's "Track Your
                      // Order" (docs/ai-rules/design.md).
                      onTap: () => context.go(
                        AppRoutes.storefront,
                        extra: StorefrontRouteArgs(
                          store: context.read<ActiveStoreCubit>().state!,
                          initialTab: ShellPage.ordersTabIndex,
                        ),
                      ),
                    ),
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.locationIcon,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.myAddressLabel,
                      onTap: () => context.push(AppRoutes.selectAddress),
                    ),
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.eye,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.darkModeLabel,
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
                        activeTrackColor: GraviaColorConst.success500,
                        inactiveTrackColor: GraviaColorConst.gray100,
                      ),
                    ),
                    ProfileMenuTile(
                      // Material glyph, not a pack SVG — the kit ships no
                      // language row (this affordance is ours), and no
                      // bundled icon reads as "language".
                      iconBuilder: (color, size) =>
                          Icon(Icons.language, color: color, size: size),
                      label: GraviaValueConst.languageLabel,
                      onTap: _showLanguageSheet,
                    ),
                    ProfileMenuTile(
                      // Material glyph, not a pack SVG — the kit ships no
                      // support frame and no bundled icon reads as "help",
                      // same call as the Language row above.
                      iconBuilder: (color, size) => Icon(
                        Icons.help_outline_rounded,
                        color: color,
                        size: size,
                      ),
                      label: ValueConst.helpAndSupportLabel,
                      onTap: () => context.push(AppRoutes.support),
                    ),
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.shieldCheck,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.privacyPolicyLabel,
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.notes,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.termsAndConditionsLabel,
                      onTap: () => context.push(AppRoutes.termsAndConditions),
                    ),
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.logout,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: GraviaValueConst.logoutLabel,
                      danger: true,
                      trailing: const SizedBox.shrink(),
                      onTap: () => showGraviaConfirmSheet(
                        context: context,
                        title: GraviaValueConst.logoutTitle,
                        message: GraviaValueConst.logoutConfirmMessage,
                        confirmLabel: GraviaValueConst.logoutLabel,
                        onConfirm: () => signOutAndReturnToDiscovery(context),
                      ),
                    ),
                    // Last row on purpose: the most destructive action sits
                    // furthest from the ones a shopper opens Profile to use.
                    ProfileMenuTile(
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        GraviaImageConst.trash,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      label: ValueConst.deleteAccountLabel,
                      danger: true,
                      trailing: const SizedBox.shrink(),
                      onTap: _confirmDeleteAccount,
                    ),
                  ],
                ),
              ),
            ),
          },
        ),
      ),
    );
  }
}
