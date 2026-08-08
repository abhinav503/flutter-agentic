import 'dart:convert';

// Every template names its shell `ShellPage` (the class name belongs to the
// role, not the pack), so both need a prefix to be dispatched from the one
// switch below.
import 'package:cordelia/feature/storefront/shell/presentation/templates/dailymart/view/shell_page.dart'
    as dailymart;
import 'package:cordelia/feature/storefront/shell/presentation/templates/gravia/view/shell_page.dart'
    as gravia;
import 'package:cordelia/feature/storefront/shell/presentation/templates/grofast/view/shell_page.dart'
    as grofast;
import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/services/notification/firebase_messaging_service.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/l10n/active_locale_scope.dart';
import 'package:cordelia/l10n/store_locale_prefs.dart';
import 'package:cordelia/theme/active_theme_controller.dart';
import 'package:cordelia/theme/active_theme_scope.dart';

/// GoRouter `extra` for the storefront route — carried whole (not flattened
/// fields) so tab-jump callers (`context.go(AppRoutes.storefront, extra: …)`
/// from Cart's "Track Your Order", Profile's "My Orders", Home's "see all")
/// can rebuild it straight from `ActiveStoreCubit.state`.
class StorefrontRouteArgs {
  final ActiveStoreEntity store;

  /// Which shell tab to land on — a template's shell defines its own tab
  /// order (see `ShellPage`'s index constants for `gravia`); `0` is every
  /// template's home tab.
  final int initialTab;

  const StorefrontRouteArgs({required this.store, this.initialTab = 0});
}

/// Landing page for a selected store — owns the storefront session: seeds
/// the app-level [ActiveStoreCubit], applies the store's template theme, and
/// dispatches to the template's shell. Everything rendered below is the
/// selected [StorefrontTemplate]'s own `presentation/templates/<name>/`
/// layer over the shared storefront `domain`/`data`.
class StorefrontPage extends BasePage {
  final ActiveStoreEntity store;
  final int initialTab;

  const StorefrontPage({super.key, required this.store, this.initialTab = 0});

  @override
  State<StorefrontPage> createState() => _StorefrontPageState();
}

class _StorefrontPageState extends BasePageState<StorefrontPage> {
  ActiveThemeController? _activeTheme;
  ActiveLocaleController? _activeLocale;
  bool _themeApplyRequested = false;
  bool _localeApplyRequested = false;

  // Captured here (not looked up in dispose) — ancestor lookups from
  // dispose() throw "Looking up a deactivated widget's ancestor is unsafe".
  late final ActiveStoreCubit _activeStore;

  /// This storefront visit's token, handed back on teardown so a visit that
  /// has already been replaced doesn't tear down its successor's state.
  late final int _storeSession;

  @override
  void initState() {
    super.initState();
    _activeStore = context.read<ActiveStoreCubit>();
    _storeSession = _activeStore.open(widget.store);
    // The store's broadcasts are heard for exactly as long as the shopper is
    // in the store — leaving stops them without anything to mute. Not awaited
    // and not guarded on web: the service no-ops there.
    if (!kIsWeb) {
      FirebaseMessagingService.instance.subscribeToStore(widget.store.storeId);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _activeTheme ??= ActiveThemeScope.of(context);
    _activeLocale ??= ActiveLocaleScope.of(context);
    if (!_themeApplyRequested) {
      _themeApplyRequested = true;
      _applyTemplateTheme();
    }
    if (!_localeApplyRequested) {
      _localeApplyRequested = true;
      // Post-frame, not synchronous: apply() notifies the app-level
      // ValueListenableBuilder, and this runs during the mount pass —
      // marking an ancestor dirty mid-build throws. Also gives it the same
      // session-guard shape as _applyTemplateTheme.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_activeStore.isCurrentSession(_storeSession)) return;
        _applyStoreLocale();
      });
    }
  }

  /// The shopper's on-device override wins over the admin's store default.
  /// Every template is localized (its pack consts are getters over
  /// `L10n.current`), so the store language applies regardless of template.
  ///
  /// The store's currency rides along: the shopper picks the language, the
  /// store fixes what it charges in, and both land in one call so no frame
  /// renders one without the other.
  void _applyStoreLocale() {
    final effective =
        StoreLocalePrefs.overrideFor(widget.store.storeId) ??
        widget.store.language;
    _activeLocale?.apply(effective.asLocale, currency: widget.store.currency);
  }

  Future<void> _applyTemplateTheme() async {
    final config = await _templateThemeConfig(widget.store.templateId);
    // Session-guarded like dispose(): if this visit was replaced (tab jump
    // to another store) or popped while the asset load was in flight, the
    // stale config must not land on the successor's — or the app default's —
    // theme.
    if (!_activeStore.isCurrentSession(_storeSession)) return;
    _activeTheme?.apply(config);
  }

  @override
  void dispose() {
    // Not called synchronously: dispose fires while the framework is
    // mid-unmount with the tree locked (popping back to Discovery), and both
    // calls notify still-mounted ancestors (`resetToAppDefault` a
    // ValueListenableBuilder, `clear` the app-level cubit's listeners) —
    // deferring to a post-frame callback lets those rebuilds happen on the
    // next frame instead of during the locked unmount pass.
    final activeTheme = _activeTheme;
    final activeLocale = _activeLocale;
    final activeStore = _activeStore;
    final session = _storeSession;
    final storeId = widget.store.storeId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Deferring the teardown means it can land *after* a replacement
      // storefront has already mounted and installed its own store + theme —
      // which is exactly what a tab jump (`context.go(AppRoutes.storefront,
      // …)`) does. Tearing down then would strand the new storefront with a
      // null store, and its shell reads that non-null on every frame.
      // Theme and locale reset inside the same guarded callback, so a race
      // can't reset one but not the other.
      if (!activeStore.isCurrentSession(session)) return;
      // Inside the same session guard as the rest: a tab jump that replaced
      // this visit may already have subscribed to another store, and an
      // unguarded unsubscribe here would silence its successor.
      if (!kIsWeb) {
        FirebaseMessagingService.instance.unsubscribeFromStore(storeId);
      }
      activeTheme?.resetToAppDefault();
      activeLocale?.resetToAppDefault();
      activeStore.closeSession(session);
    });
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => switch (widget.store.templateId) {
    StorefrontTemplate.gravia => gravia.ShellPage(
      initialTab: widget.initialTab,
    ),
    StorefrontTemplate.dailymart => dailymart.ShellPage(
      initialTab: widget.initialTab,
    ),
    StorefrontTemplate.grofast => grofast.ShellPage(
      initialTab: widget.initialTab,
    ),
  };
}

/// Each template's own bundled theme config lives under
/// assets/theme/templates/. Falls back to the app's own boot config on any
/// load failure — same defensive shape as main.dart's `_loadThemeConfig`.
///
/// Path derived from `wireValue` (same scheme as the notifications mock's
/// `assets/data/templates/<id>/`), so a new template adds its asset +
/// `pubspec.yaml` line without editing a switch here — and a typo'd name
/// falls into the same defaults fallback as any other load failure.
Future<AppThemeConfig> _templateThemeConfig(
  StorefrontTemplate templateId,
) async {
  final assetPath =
      'assets/theme/templates/${templateId.wireValue}_theme_config.json';
  try {
    final raw = await rootBundle.loadString(assetPath);
    return AppThemeConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return AppThemeConfig.defaults;
  }
}
