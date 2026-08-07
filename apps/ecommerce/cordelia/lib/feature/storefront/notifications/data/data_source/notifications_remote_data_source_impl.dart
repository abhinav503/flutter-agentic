import 'package:core/core/network/http_service.dart';
import 'package:dio/dio.dart';

import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';

import '../models/notification_model.dart';
import 'notifications_remote_data_source.dart';

/// Backed by the admin API's notifications endpoint, which merges the store's
/// own feed with the CordeliaApps platform feed and stamps each item's read
/// state for the caller.
///
/// The bundled-JSON version this replaced was keyed on the store's template,
/// so every store on a template saw the same invented list; the feed is
/// per-store data now, and the template only decides how it's drawn.
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl();

  /// Sent when there's a signed-in shopper, omitted when there isn't: the
  /// endpoint treats an anonymous caller as "everything unread" rather than
  /// rejecting them, so a signed-out shopper still sees the store's offers.
  static Future<Options?> _authOptions() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return null;
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<List<NotificationModel>> getNotifications({
    required String storeId,
  }) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.notificationsPath(storeId),
      options: await _authOptions(),
    );
    final list = (response.data?['notifications'] as List<dynamic>?) ?? const [];
    return list
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markRead({
    required String storeId,
    required List<String> notificationIds,
  }) async {
    if (notificationIds.isEmpty) return;
    final options = await _authOptions();
    // No token means no account to hang a read receipt on. Returning early
    // keeps the caller from having to know that.
    if (options == null) return;

    await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.notificationsPath(storeId),
      data: {'notification_ids': notificationIds},
      options: options,
    );
  }
}
