import 'package:flutter/widgets.dart';

/// Standalone so a notification tap can navigate from outside the widget
/// tree without this file importing anything from the app — which would make
/// an import cycle out of `app.dart` ← router ← navigator.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
