import 'package:xterm/xterm.dart';

/// Corrects xterm 4.0.0's mouse-wheel button encoding.
///
/// xterm.dart encodes wheel buttons as `64 + button` (see `TerminalMouseButton`
/// in the package: `wheelUp = 64 + 4 = 68`, `wheelDown = 64 + 5 = 69`). The
/// SGR/X10 spec is `64 + (button - 4)`, i.e. wheelUp = 64, wheelDown = 65. The
/// off-by-four makes apps read the wheel as extra mouse buttons 8/9, so
/// alt-screen TUIs (claude, codex, vim…) never scroll. This handler delegates
/// clicks/drags to the default handler unchanged and re-encodes only wheel
/// events with the correct button id.
class WheelFixMouseHandler implements TerminalMouseHandler {
  const WheelFixMouseHandler();

  @override
  String? call(TerminalMouseEvent event) {
    final button = event.button;

    // Clicks and drags are encoded correctly upstream — leave them alone.
    if (!button.isWheel) return defaultMouseHandler(event);

    // Mirror the upstream gating: only the scroll-reporting mouse modes emit a
    // wheel report, and wheel "release" is never reported.
    if (!event.state.mouseMode.reportScroll) return null;
    if (event.buttonState == TerminalMouseButtonState.up) return null;

    final id = button.id - 4; // 68→64 (up), 69→65 (down), 70→66, 71→67
    final x = event.position.x + 1; // reports are 1-based
    final y = event.position.y + 1;

    switch (event.state.mouseReportMode) {
      case MouseReportMode.sgr:
        return '\x1b[<$id;$x;${y}M';
      case MouseReportMode.urxvt:
        return '\x1b[${32 + id};$x;${y}M';
      case MouseReportMode.normal:
      case MouseReportMode.utf:
        final btn = String.fromCharCode(32 + id);
        final col = String.fromCharCode(32 + x);
        final row = String.fromCharCode(32 + y);
        return '\x1b[M$btn$col$row';
    }
  }
}
