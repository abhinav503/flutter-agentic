import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/switch.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:cordelia/services/user_profile_cache_service.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_menu_tile.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/profile_bloc.dart';
import '../widgets/profile_identity_header.dart';
import '../widgets/profile_skeleton_body.dart';

/// `dailymart` template's Profile tab — a plain white sheet: the identity
/// row, then two labelled groups of bordered menu rows. No app bar, no
/// coloured header, nothing pinned (spec sheet §8), which is what makes this
/// screen structurally different from gravia's collapsing-sheet Profile even
/// though the row set is deliberately identical.
class ProfileScreen extends BaseScreen {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen> {
  /// Pushes the Edit Profile form prefilled from [profile]; if it returned a
  /// result (Cancel/back pops with none), dispatches it into the shell's
  /// `ProfileBloc` so this screen updates without a re-fetch.
  Future<void> _openEditProfile(ProfileEntity profile) async {
    final result = await context.push<ProfileEntity>(
      AppRoutes.editProfile,
      extra: profile,
    );
    if (result == null || !mounted) return;
    context.read<ProfileBloc>().add(ProfileEvent.saved(profile: result));
  }

  Future<void> _signOut() async {
    await FirebaseAuthService.instance.signOut();
    await UserProfileCacheService.instance.clear();
    // Defensive — Profile is only reachable once AuthAuthenticated has fired,
    // which already clears this key, but a stale flag here would wrongly
    // reopen the verify sheet for the next account signing in on this device.
    await SharedPreferenceService.instance.setBool(
      kPendingEmailVerificationPrefKey,
      false,
    );
    if (!mounted) return;
    context.read<CartCubit>().reset();
    context.read<FavouritesCubit>().reset();
    context.go(AppRoutes.login);
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state case ProfileError(:final message)) showSnackBar(message);
          },
          builder: (context, state) => DailyMartTopSwitcher(
            child: switch (state) {
              ProfileLoading() => const _Page(
                key: ValueKey('loading'),
                body: DailyMartProfileSkeletonBody(),
              ),
              ProfileError() => KeyedSubtree(
                key: const ValueKey('error'),
                child: ErrorView(
                  message: DailyMartValueConst.profileLoadErrorMessage,
                  onRetry: () => context.read<ProfileBloc>().add(
                    const ProfileEvent.started(),
                  ),
                ),
              ),
              ProfileLoaded(:final profile) => _Page(
                key: const ValueKey('loaded'),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileIdentityHeader(profile: profile),
                    const SizedBox(height: AppSpacing.xl5),
                    _Section(
                      title: DailyMartValueConst.generalSectionTitle,
                      rows: [
                        DailyMartMenuTile(
                          asset: DailyMartImageConst.menuUser,
                          label: DailyMartValueConst.editProfileLabel,
                          onTap: () => _openEditProfile(profile),
                        ),
                        DailyMartMenuTile(
                          asset: DailyMartImageConst.menuLock,
                          label: DailyMartValueConst.changePasswordLabel,
                          onTap: () => context.push(AppRoutes.changePassword),
                        ),
                        DailyMartMenuTile(
                          // No kit export for an orders glyph — this pack
                          // draws no Orders surface at all yet (see onTap).
                          icon: Icons.shopping_bag_outlined,
                          label: DailyMartValueConst.myOrdersLabel,
                          // Unlike gravia, this template's shell has no
                          // Orders tab and no Orders screen to push, so the
                          // row states that plainly instead of opening
                          // gravia's and mixing two packs on one nav bar.
                          onTap: () => showSnackBar(
                            DailyMartValueConst.comingSoonSubtitle(
                              DailyMartValueConst.myOrdersLabel,
                            ),
                          ),
                        ),
                        DailyMartMenuTile(
                          asset: DailyMartImageConst.location,
                          label: DailyMartValueConst.myAddressLabel,
                          onTap: () => context.push(AppRoutes.selectAddress),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl5),
                    _Section(
                      title: DailyMartValueConst.preferencesSectionTitle,
                      rows: [
                        DailyMartMenuTile(
                          icon: Icons.dark_mode_outlined,
                          label: DailyMartValueConst.darkModeLabel,
                          // Material's own Switch grows the thumb when
                          // selected with no public way to equalize the two
                          // states — AppSwitch keeps one fixed thumb size.
                          trailing: AppSwitch(
                            value:
                                Theme.of(context).brightness ==
                                Brightness.dark,
                            // Greyscale/100 (#DFE1E7) in light — the kit's
                            // off-track. AppSwitch's own default
                            // (surfaceContainerHighest) is this pack's near
                            // white #EFF4FF, which reads as no track at all.
                            inactiveTrackColor: Theme.of(
                              context,
                            ).colorScheme.outlineVariant,
                            onChanged: (isDark) => ThemeModeScope.of(
                              context,
                            ).setMode(
                              isDark ? ThemeMode.dark : ThemeMode.light,
                            ),
                          ),
                        ),
                        DailyMartMenuTile(
                          asset: DailyMartImageConst.menuShieldCheck,
                          label: DailyMartValueConst.privacyPolicyLabel,
                          onTap: () => context.push(AppRoutes.privacyPolicy),
                        ),
                        DailyMartMenuTile(
                          icon: Icons.article_outlined,
                          label: DailyMartValueConst.termsAndConditionsLabel,
                          onTap: () =>
                              context.push(AppRoutes.termsAndConditions),
                        ),
                        DailyMartMenuTile(
                          asset: DailyMartImageConst.menuLogout,
                          // The kit's export points its arrow *into* the
                          // door; its own frame mirrors the glyph so the
                          // arrow exits rightwards.
                          flipIconHorizontally: true,
                          iconColor: Theme.of(context).colorScheme.error,
                          label: DailyMartValueConst.logoutLabel,
                          onTap: () => showDailyMartConfirmSheet(
                            context: context,
                            title: DailyMartValueConst.logoutTitle,
                            message: DailyMartValueConst.logoutConfirmMessage,
                            confirmLabel: DailyMartValueConst.logoutLabel,
                            onConfirm: _signOut,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}

/// The scroll view the skeleton, the error and the loaded body all sit in —
/// one padding recipe, so a state swap never shifts the content sideways.
class _Page extends StatelessWidget {
  final Widget body;

  const _Page({super.key, required this.body});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xl2,
      AppSpacing.lg,
      AppSpacing.xl10,
    ),
    child: body,
  );
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const _Section({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: DailyMartTextStyleConst.bodyLgSemibold(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
        for (final row in rows) ...[const SizedBox(height: AppSpacing.lg), row],
      ],
    );
  }
}
