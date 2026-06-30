import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';
import 'notification_payload.dart';
import 'notification_router.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call once from the home screen's first frame (see add-notification-feature
  /// guide A2 for why this must not run in main()).
  Future<void> init() async {
    final settings = await _messaging.requestPermission();
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    // iOS: show notifications while the app is in the foreground (no-op on Android).
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await LocalNotificationService.instance.init();

    // getToken can throw (FCM registration failure, transient SERVICE_NOT_AVAILABLE).
    // Log and carry on — the foreground/tap listeners below must still wire up.
    try {
      debugPrint('FCM token: ${await _messaging.getToken()}');
    } catch (e) {
      debugPrint('FCM getToken failed: $e');
    }

    // Terminated → opened by a notification tap. Query AFTER the router is mounted.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      NotificationRouter.route(NotificationPayload.fromData(initial.data));
    }

    // Foreground: Android renders via local notifications; iOS shows it natively.
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM onMessage (foreground): '
          'notification=${message.notification?.title} data=${message.data}');
      LocalNotificationService.instance.show(message);
    });

    // Background (app alive, not foreground) → user taps the system notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM onMessageOpenedApp (tapped): data=${message.data}');
      NotificationRouter.route(NotificationPayload.fromData(message.data));
    });
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  Future<bool> isEnabled() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
