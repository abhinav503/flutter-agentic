import 'package:flutter/widgets.dart';

import 'package:web_terminal/constants/api_constants.dart';

String resolvePreviewUrl() => ApiConstants.defaultPreviewUrl;

// Non-web platforms can't embed an `<iframe>`.
Widget buildPreviewSurface(String url, int reloadToken) =>
    const SizedBox.shrink();
