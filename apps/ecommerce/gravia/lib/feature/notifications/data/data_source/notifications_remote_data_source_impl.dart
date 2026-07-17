import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/notification_section_model.dart';
import 'notifications_remote_data_source.dart';

/// Backed by a bundled JSON asset — same pattern as the other mocked data
/// sources in this app.
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl();

  @override
  Future<List<NotificationSectionModel>> getNotifications() async {
    final raw = await rootBundle.loadString('assets/data/notifications.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (json) =>
              NotificationSectionModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
