import 'dart:convert';

// Every template names its shell `ShellPage` (the class name belongs to the
// role, not the pack), so both need a prefix to be dispatched from the one
// switch below.
import 'package:cordelia/feature/storefront/shell/presentation/templates/dailymart/view/shell_page.dart'
    as dailymart;
import 'package:cordelia/feature/storefront/shell/presentation/templates/gravia/view/shell_page.dart'
    as gravia;
import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';
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
  bool _themeApplyRequested = false;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _activeTheme ??= ActiveThemeScope.of(context);
    if (!_themeApplyRequested) {
      _themeApplyRequested = true;
      _applyTemplateTheme();
    }
  }

  Future<void> _applyTemplateTheme() async {
    final config = await _templateThemeConfig(widget.store.templateId);
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
    final activeStore = _activeStore;
    final session = _storeSession;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Deferring the teardown means it can land *after* a replacement
      // storefront has already mounted and installed its own store + theme —
      // which is exactly what a tab jump (`context.go(AppRoutes.storefront,
      // …)`) does. Tearing down then would strand the new storefront with a
      // null store, and its shell reads that non-null on every frame.
      if (!activeStore.isCurrentSession(session)) return;
      activeTheme?.resetToAppDefault();
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
