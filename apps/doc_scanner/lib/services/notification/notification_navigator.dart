import 'package:flutter/widgets.dart';

// Standalone so the notification service can navigate without importing app.dart
// (which would create an import cycle through the router → pages → service).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
