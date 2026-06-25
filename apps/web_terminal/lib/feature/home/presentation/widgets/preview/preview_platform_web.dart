import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'package:web_terminal/constants/api_constants.dart';

/// Seeds the preview with a dev-server URL, not the bridge's own origin —
/// pointing the iframe there would render a second terminal. (A local Flutter
/// `web-server` sets no `X-Frame-Options`, so the localhost frame embeds fine.)
String resolvePreviewUrl() => ApiConstants.defaultPreviewUrl;

Widget buildPreviewSurface(String url, int reloadToken) =>
    _PreviewIframe(url: url, reloadToken: reloadToken);

class _PreviewIframe extends StatefulWidget {
  const _PreviewIframe({required this.url, required this.reloadToken});

  final String url;
  final int reloadToken;

  @override
  State<_PreviewIframe> createState() => _PreviewIframeState();
}

class _PreviewIframeState extends State<_PreviewIframe> {
  late final String _viewType;
  late final web.HTMLIFrameElement _iframe;

  @override
  void initState() {
    super.initState();
    // Unique per instance so multiple previews never collide on a view type.
    _viewType = 'terminal-preview-${identityHashCode(this)}';
    _iframe = web.HTMLIFrameElement()
      ..src = widget.url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
    ui_web.platformViewRegistry
        .registerViewFactory(_viewType, (int _) => _iframe);
  }

  @override
  void didUpdateWidget(covariant _PreviewIframe oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reassigning `src` reloads the frame even when the URL is unchanged, so a
    // bumped reload token forces a refresh.
    if (oldWidget.url != widget.url ||
        oldWidget.reloadToken != widget.reloadToken) {
      _iframe.src = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
