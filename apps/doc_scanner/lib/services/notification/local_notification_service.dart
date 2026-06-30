import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_payload.dart';
import 'notification_router.dart';

@pragma('vm:entry-point')
void _onTapLocalNotification(NotificationResponse response) {
  final raw = response.payload;
  if (raw == null || raw.isEmpty) return;
  final payload =
      NotificationPayload.fromData(jsonDecode(raw) as Map<String, dynamic>);
  NotificationRouter.route(payload);
}

class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  static const _channelId = 'default_channel';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Platform.isIOS) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: _onTapLocalNotification,
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      'General',
      description: 'General notifications',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> show(RemoteMessage message) async {
    if (Platform.isIOS) return;
    final notification = message.notification;
    await _plugin.show(
      id: Random().nextInt(100000),
      title: notification?.title,
      body: notification?.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'General',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
