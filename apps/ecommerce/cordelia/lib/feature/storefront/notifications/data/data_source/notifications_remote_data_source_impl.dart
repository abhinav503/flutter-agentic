import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/notification_section_model.dart';
import 'notifications_remote_data_source.dart';

/// Backed by a bundled JSON asset — same pattern as the other mocked data
/// sources in this app.
///
/// One file per template, so each pack's screens demo their own kit's copy
/// instead of sharing one list that can only ever match one of them. A real
/// backend would key this on [storeId] rather than the store's template; when
/// that lands the template parameter goes away, and this class with it.
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl();

  /// Keyed off the store's `template_id` wire string, the same value the
  /// admin backend's `templates/{id}` docs use — so adding a template means
  /// adding its folder and its `pubspec.yaml` line, not editing a switch here.
  static String _assetPath(String templateId) =>
      'assets/data/templates/$templateId/notifications.json';

  @override
  Future<List<NotificationSectionModel>> getNotifications({
    required String storeId,
    required String templateId,
  }) async {
    final raw = await rootBundle.loadString(_assetPath(templateId));
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (json) =>
              NotificationSectionModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
