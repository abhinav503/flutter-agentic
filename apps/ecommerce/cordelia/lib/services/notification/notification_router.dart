import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/enums/notification_type.dart';
import 'package:cordelia/feature/home/domain/entities/store_entity.dart';
import 'package:cordelia/feature/home/domain/usecase/get_store_usecase.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/services/firebase_auth_service.dart';

import 'notification_navigator.dart';
import 'notification_payload.dart';

/// Turns a tapped push into navigation — the one place that decides where a
/// notification lands.
///
/// **A store-scoped push opens that store, not just the app.** Every
/// storefront page renders inside a storefront session: the Storefront route
/// takes a full `StorefrontRouteArgs` via `extra` and the pages under it read
/// [ActiveStoreCubit], neither of which a push can carry — it holds only a
/// store id. So the store is fetched first, its storefront mounted, and only
/// then is the store-scoped page pushed on top of it.
///
/// A platform notification belongs to no store and lands on Discovery, which
/// is also where anything unroutable ends up (a deactivated store, no network
/// on a cold start).
class NotificationRouter {
  const NotificationRouter._();

  /// Routes reachable without a store behind them. Everything else is a
  /// storefront page and needs the session opened first.
  static const _appLevelRoutes = {AppRoutes.discovery, AppRoutes.search};

  /// Destinations that are somebody's own and 401 without an account. A
  /// signed-out device still receives platform-wide pushes, and since the
  /// app browses without an account it can now be open when one is tapped —
  /// so the tap has to land somewhere that works. It opens the store the
  /// notification was about and stops there, rather than pushing a page
  /// that would fail or a login form nobody asked for.
  static const _signedInOnlyRoutes = {
    AppRoutes.notifications,
    AppRoutes.orders,
    AppRoutes.trackOrder,
    AppRoutes.cart,
    AppRoutes.wishlist,
  };

  static bool _canOpen(String path) =>
      !_signedInOnlyRoutes.contains(path) ||
      FirebaseAuthService.instance.currentUser != null;

  static Future<void> route(NotificationPayload payload) async {
    if (payload.type == NotificationType.normal) return;

    final route = payload.route;
    // No destination means "just open the app" — yanking the shopper off
    // whatever they had on screen would be worse than doing nothing.
    if (route == null || route.isEmpty) return;
    final path = route.startsWith('/') ? route : '/$route';

    final storeId = payload.storeId;
    if (storeId == null || storeId.isEmpty) {
      _go(
        _appLevelRoutes.contains(path) && _canOpen(path)
            ? path
            : AppRoutes.discovery,
      );
      return;
    }

    // Already inside the store that sent this: push the page rather than
    // re-mounting the storefront, which would reset the shell to its home
    // tab and drop whatever the shopper had pushed above it.
    if (_activeStoreId() == storeId) {
      if (_canOpen(path)) _push(path);
      return;
    }

    final result = await sl<GetStoreUseCase>()(
      GetStoreParams(storeId: storeId),
    );
    result.fold((_) => _go(AppRoutes.discovery), (store) => _open(store, path));
  }

  static void _open(StoreEntity store, String path) {
    _go(
      AppRoutes.storefront,
      extra: StorefrontRouteArgs(store: ActiveStoreEntity.fromStore(store)),
    );

    // Home is where `go` already landed; anything else is a page above it.
    if (_appLevelRoutes.contains(path) || !_canOpen(path)) return;

    // Deferred one frame: `go` only schedules the rebuild, and the page being
    // pushed reads the [ActiveStoreCubit] that `StorefrontPage` seeds in the
    // initState of that rebuild.
    WidgetsBinding.instance.addPostFrameCallback((_) => _push(path));
  }

  /// `null` outside a storefront. Read through the root navigator's context,
  /// which sits below the app-level provider.
  static String? _activeStoreId() {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return null;
    return context.read<ActiveStoreCubit>().state?.storeId;
  }

  // Both re-read the context rather than taking one: a tap is handled across
  // an await and, on a terminated-state launch, before the navigator exists.
  static void _go(String path, {Object? extra}) =>
      rootNavigatorKey.currentContext?.go(path, extra: extra);

  static void _push(String path) => rootNavigatorKey.currentContext?.push(path);
}
