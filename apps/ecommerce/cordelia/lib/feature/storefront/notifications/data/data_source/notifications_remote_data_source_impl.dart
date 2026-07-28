import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../models/notification_section_model.dart';
import 'notifications_remote_data_source.dart';

/// Backed by a bundled JSON asset — same pattern as the other mocked data
/// sources in this app.
///
/// One file per template, so each pack's screens demo their own kit's copy
/// instead of sharing one list that can only ever match one of them. A real
/// backend would key this on the store rather than the template; when that
/// lands the parameter goes away, and this class with it.
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl();

  /// Keyed off `wireValue`, the same string the admin backend's
  /// `templates/{id}` docs use — so adding a template means adding its folder
  /// and its `pubspec.yaml` line, not editing a switch here.
  static String _assetPath(StorefrontTemplate template) =>
      'assets/data/templates/${template.wireValue}/notifications.json';

  @override
  Future<List<NotificationSectionModel>> getNotifications(
    StorefrontTemplate template,
  ) async {
    final raw = await rootBundle.loadString(_assetPath(template));
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (json) =>
              NotificationSectionModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
