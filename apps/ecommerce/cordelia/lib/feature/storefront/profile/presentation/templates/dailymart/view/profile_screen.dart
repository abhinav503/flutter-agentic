import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/switch.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/presentation/delete_account.dart';
import 'package:cordelia/feature/auth/presentation/sign_out.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/store_language_switch.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_menu_tile.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_radio_sheet_content.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';
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

class _ProfileScreenState extends BaseScreenState<ProfileScreen>
    with DeleteAccountAction {
  void _confirmDeleteAccount() => showDailyMartConfirmSheet(
    context: context,
    title: ValueConst.deleteAccountTitle,
    message: ValueConst.deleteAccountConfirmMessage,
    confirmLabel: ValueConst.deleteAccountLabel,
    onConfirm: deleteAccount,
  );

  /// The shopper's per-store language override — persists the pick and
  /// applies the locale in one tap (see [StoreLanguageSwitchX]).
  void _showLanguageSheet() => showDailyMartSheet<void>(
    title: ValueConst.languageLabel,
    child: DailyMartRadioSheetContent<StoreLanguage>(
      options: StoreLanguage.values,
      labelOf: (language) => language.label,
      selected: context.currentStoreLanguage,
      onSelected: context.switchStoreLanguage,
    ),
  );

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

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return withDeleteAccountProgress(
      ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          bottom: false,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state case ProfileError(:final message)) {
                showSnackBar(message);
              }
            },
            builder: (context, state) => DailyMartTopSwitcher(
              child: switch (state) {
                // Unreachable: the Profile tab is gated on an account.
                ProfileLoading() || ProfileSignedOut() => const _Page(
                  key: ValueKey('loading'),
                  body: DailyMartProfileSkeletonBody(),
                ),
                // Error shares the page shell so the branch pays the same
                // padding as the others.
                ProfileError() => _Page(
                  key: const ValueKey('error'),
                  body: ErrorView(
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
                            // No kit export for an orders glyph — the kit's own
                            // list never draws this row.
                            icon: Icons.shopping_bag_outlined,
                            label: DailyMartValueConst.myOrdersLabel,
                            // This template's shell has no Orders tab (gravia
                            // reaches the same list through one), so the row is
                            // the way in — a pushed screen, not a tab jump.
                            onTap: () => context.push(AppRoutes.orders),
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
                              onChanged: (isDark) =>
                                  ThemeModeScope.of(context).setMode(
                                    isDark ? ThemeMode.dark : ThemeMode.light,
                                  ),
                            ),
                          ),
                          DailyMartMenuTile(
                            // Material glyph, not a kit export — the kit's
                            // list has a Language row but ships no glyph for
                            // it.
                            icon: Icons.language,
                            label: ValueConst.languageLabel,
                            onTap: _showLanguageSheet,
                          ),
                          DailyMartMenuTile(
                            // Material glyph — the kit ships no support frame
                            // and no bundled icon reads as "help", same call
                            // as the Language row above.
                            icon: Icons.help_outline_rounded,
                            label: ValueConst.helpAndSupportLabel,
                            onTap: () => context.push(AppRoutes.support),
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
                              onConfirm: () =>
                                  signOutAndReturnToDiscovery(context),
                            ),
                          ),
                          // Last row on purpose: the most destructive action
                          // sits furthest from the ones a shopper opens
                          // Profile to use.
                          DailyMartMenuTile(
                            asset: DailyMartImageConst.delete,
                            iconColor: Theme.of(context).colorScheme.error,
                            label: ValueConst.deleteAccountLabel,
                            onTap: _confirmDeleteAccount,
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
      ),
    );
  }
}

/// The scroll view the skeleton, the error and the loaded body all sit in —
/// the pack shell with no header row (this tab draws its identity header in
/// the body) and the nav bar owning the bottom edge.
class _Page extends StatelessWidget {
  final Widget body;

  const _Page({super.key, required this.body});

  @override
  Widget build(BuildContext context) => DailyMartScreenBody(
    topPadding: AppSpacing.xl2,
    // The shell's nav bar owns the bottom edge; this is breathing room
    // above it, not a device inset.
    bottomInset: AppSpacing.xl10,
    body: body,
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
