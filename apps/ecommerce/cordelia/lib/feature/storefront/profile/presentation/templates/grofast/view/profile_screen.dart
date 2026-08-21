import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/switch.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/presentation/delete_account.dart';
import 'package:cordelia/feature/auth/presentation/sign_out.dart';
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/store_language_switch.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_menu_tile.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_options_sheet_content.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';

import '../widgets/profile_skeleton_body.dart';
import '../../../bloc/profile_bloc.dart';

/// `grofast` template's Profile tab (kit frame `122:1143`): the identity
/// block, the kit's three square shortcuts, then the menu rows.
///
/// The kit's shortcut row is Notification / Voucher / Wishlist. Vouchers have
/// no backend, so that middle tile becomes **My Orders** — a surface this
/// storefront does have and which the kit's own menu never offers a way into
/// (spec sheet §11).
class ProfileScreen extends BaseScreen {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen>
    with DeleteAccountAction {
  void _confirmDeleteAccount() => showGrofastConfirmSheet(
    context: context,
    title: ValueConst.deleteAccountTitle,
    message: ValueConst.deleteAccountConfirmMessage,
    confirmLabel: ValueConst.deleteAccountLabel,
    onConfirm: deleteAccount,
  );

  void _openEditProfile(ProfileEntity profile) =>
      context.push(AppRoutes.editProfile, extra: profile);

  /// The shopper's per-store language override — persists the pick and
  /// applies the locale in one tap (see [StoreLanguageSwitchX]).
  void _showLanguageSheet() => showGrofastSheet<void>(
    title: ValueConst.languageLabel,
    child: GrofastOptionsSheetContent<StoreLanguage>(
      options: StoreLanguage.values,
      labelOf: (language) => language.label,
      selected: context.currentStoreLanguage,
      onSelected: context.switchStoreLanguage,
    ),
  );

  void _confirmSignOut() => showGrofastConfirmSheet(
    context: context,
    title: GrofastValueConst.logOutTitle,
    message: GrofastValueConst.logOutConfirmMessage,
    confirmLabel: GrofastValueConst.logOutLabel,
    onConfirm: () => signOutAndReturnToLogin(context),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return withDeleteAccountProgress(
      SafeArea(
        bottom: false,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) => GrofastScreenBody(
            headerRow: GrofastHeaderRow(
              title: GrofastValueConst.profileTitle,
              // A tab root has nowhere to pop back to.
              showBack: false,
              trailing: GrofastHeaderAction(
                asset: GrofastImageConst.bell,
                onTap: () => context.push(AppRoutes.notifications),
                tooltip: GrofastValueConst.notificationsTitle,
              ),
            ),
            gap: AppSpacing.xl4,
            // The shell runs `extendBody`, so this scroll view reaches under
            // the nav: clear the bar, and let the last row pass behind the
            // dome — that content is what makes the dome visible.
            bottomInset: GrofastDimenConst.navScrollInset(context),
            body: GrofastSwitcher(
              child: switch (state) {
                ProfileLoading() => const GrofastProfileSkeletonBody(),
                ProfileError(:final message) => GrofastErrorView(
                  message: message,
                  onRetry: () => context.read<ProfileBloc>().add(
                    const ProfileEvent.started(),
                  ),
                ),
                ProfileLoaded(:final profile) => _ProfileContent(
                  profile: profile,
                  onEditProfile: () => _openEditProfile(profile),
                  onLanguage: _showLanguageSheet,
                  onSignOut: _confirmSignOut,
                  onDeleteAccount: _confirmDeleteAccount,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEditProfile;
  final VoidCallback onLanguage;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;

  const _ProfileContent({
    required this.profile,
    required this.onEditProfile,
    required this.onLanguage,
    required this.onSignOut,
    required this.onDeleteAccount,
  });

  void _toggleDarkMode(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ThemeModeScope.of(
      context,
    ).setMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CordeliaAvatarImage(
            profile: profile,
            size: GrofastDimenConst.profileAvatarSize,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          profile.name.trim().isEmpty
              ? GrofastValueConst.profileNameFallback
              : profile.name,
          textAlign: TextAlign.center,
          style: GrofastTextStyleConst.sectionBold(tt),
        ),
        const SizedBox(height: AppSpacing.xs3),
        Text(
          profile.email,
          textAlign: TextAlign.center,
          style: GrofastTextStyleConst.bodyMedium(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl6),
        Row(
          children: [
            Expanded(
              child: GrofastQuickTile(
                label: GrofastValueConst.notificationTileLabel,
                asset: GrofastImageConst.bell,
                onTap: () => context.push(AppRoutes.notifications),
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: GrofastQuickTile(
                label: GrofastValueConst.ordersTileLabel,
                // Not the kit's gift.svg: that glyph belonged to the Voucher
                // tile this slot replaced, and a gift reads as rewards, not
                // orders. The pack has no order/receipt SVG, so this joins
                // the menu rows' Material-rounded system instead.
                icon: Icons.receipt_long_rounded,
                onTap: () => context.push(AppRoutes.orders),
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: GrofastQuickTile(
                label: GrofastValueConst.wishlistTileLabel,
                asset: GrofastImageConst.heart,
                iconColor: cs.error,
                onTap: () => context.push(AppRoutes.wishlist),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl4),
        GrofastMenuTile(
          label: GrofastValueConst.myProfileLabel,
          icon: Icons.person_rounded,
          onTap: onEditProfile,
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          label: GrofastValueConst.myAddressLabel,
          icon: Icons.location_on_rounded,
          onTap: () => context.push(AppRoutes.selectAddress),
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          label: GrofastValueConst.changePasswordLabel,
          icon: Icons.lock_rounded,
          onTap: () => context.push(AppRoutes.changePassword),
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          label: GrofastValueConst.darkModeLabel,
          icon: Icons.dark_mode_rounded,
          // Acts in place, so the row's own tap toggles the switch rather
          // than navigating — the chevron would promise a screen.
          onTap: () => _toggleDarkMode(context),
          trailing: AppSwitch(
            value: Theme.of(context).brightness == Brightness.dark,
            // The pack's surfaceContainerHighest is a near-white that reads as
            // no track at all against the tile — use the kit's own hairline.
            inactiveTrackColor: cs.outlineVariant,
            onChanged: (_) => _toggleDarkMode(context),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          // Material glyph, not a kit export — the kit's list has a Language
          // row but ships no glyph for it.
          label: ValueConst.languageLabel,
          icon: Icons.language,
          onTap: onLanguage,
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          // Material glyph, not a kit export — the kit has no support row and
          // ships no glyph for one, same call as the Language row above.
          label: ValueConst.helpAndSupportLabel,
          icon: Icons.help_outline_rounded,
          onTap: () => context.push(AppRoutes.support),
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          label: GrofastValueConst.privacyPolicyLabel,
          asset: GrofastImageConst.gear,
          onTap: () => context.push(AppRoutes.privacyPolicy),
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          label: GrofastValueConst.termsAndConditionsLabel,
          icon: Icons.shield_rounded,
          onTap: () => context.push(AppRoutes.termsAndConditions),
        ),
        const SizedBox(height: AppSpacing.base),
        GrofastMenuTile(
          label: GrofastValueConst.logOutLabel,
          asset: GrofastImageConst.logout,
          iconColor: cs.error,
          showChevron: false,
          onTap: onSignOut,
        ),
        const SizedBox(height: AppSpacing.base),
        // Last row on purpose: the most destructive action sits furthest
        // from the ones a shopper opens Profile to use.
        GrofastMenuTile(
          label: ValueConst.deleteAccountLabel,
          asset: GrofastImageConst.delete,
          iconColor: cs.error,
          showChevron: false,
          onTap: onDeleteAccount,
        ),
      ],
    );
  }
}
