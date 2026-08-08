import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_payload.dart';
import 'notification_router.dart';

@pragma('vm:entry-point')
void _onTapLocalNotification(NotificationResponse response) {
  final raw = response.payload;
  if (raw == null || raw.isEmpty) return;
  NotificationRouter.route(
    NotificationPayload.fromData(jsonDecode(raw) as Map<String, dynamic>),
  );
}

/// Renders a foreground message as a system notification.
///
/// Android draws nothing for a foreground push on its own, so this fills that
/// gap and carries the tap payload. iOS presents foreground notifications
/// natively (opted into in [FirebaseMessagingService.init]), so every method
/// here no-ops there rather than double-drawing.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  /// Must match the `default_notification_channel_id` meta-data in
  /// AndroidManifest.xml — the channel a *backgrounded* push is drawn on is
  /// picked by the OS from that value, not by this class.
  static const _channelId = 'default_channel';
  static const _channelName = 'General';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Platform.isIOS) return;

    // NOT @mipmap/ic_launcher: Android keeps only a small icon's alpha
    // channel and fills it white, so the launcher's round adaptive shape
    // rendered as a filled ring. ic_notification is a flat monochrome glyph
    // drawn for exactly this.
    const androidInit = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: _onTapLocalNotification,
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Order updates, offers and CordeliaApps announcements',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> show(RemoteMessage message) async {
    if (Platform.isIOS) return;
    final notification = message.notification;
    // A data-only message has nothing to draw. The feed still picked it up on
    // the next screen open, so silently ignoring it is right.
    if (notification == null) return;

    // Read from `data`, not `notification.android.imageUrl`: the sender puts
    // it in both, and `data` is the copy that survives every platform's
    // notification-block differences.
    final bitmap = await _fetchBitmap(message.data['imageUrl'] as String?);

    await _plugin.show(
      // Random rather than a counter: ids only need to not collide within a
      // session, and a fixed id would make each push replace the last.
      id: Random().nextInt(100000),
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          color: const Color(0xFF007A60),
          largeIcon: bitmap,
          styleInformation: bitmap == null
              ? null
              : BigPictureStyleInformation(
                  bitmap,
                  // The picture already IS the large icon; leaving both on
                  // shows the same image twice once expanded.
                  hideExpandedLargeIcon: true,
                ),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Downloads a push image for the foreground path.
  ///
  /// Android renders the image itself only while the app is **backgrounded**;
  /// in the foreground we draw the notification, so the bytes have to be
  /// fetched here — flutter_local_notifications cannot take a URL.
  ///
  /// Returns null on anything unexpected, which degrades to a text-only
  /// notification. Losing the picture is not a reason to lose the message.
  Future<ByteArrayAndroidBitmap?> _fetchBitmap(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      // Timeouts on `BaseOptions`, not the per-request `Options`: a
      // connectTimeout can only be set here, and an unreachable host hanging
      // on connect is exactly the case this guards. Without them a bare Dio
      // waits forever, and since the notification isn't drawn until this
      // returns, a dead image host meant no banner at all rather than a
      // text-only one. Tighter than HttpService's 10s/30s — a push already
      // has the shopper's attention and the artwork is its optional part.
      final response = await Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ).get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) return null;
      return ByteArrayAndroidBitmap(Uint8List.fromList(bytes));
    } catch (error) {
      debugPrint('Notification image fetch failed: $error');
      return null;
    }
  }
}
