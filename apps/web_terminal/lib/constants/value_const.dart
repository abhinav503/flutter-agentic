/// All user-facing copy for the web_terminal app. No inline string literals in
/// widgets — add new strings here (monorepo `ValueConst` convention).
class ValueConst {
  const ValueConst._();

  static const appTitle = 'Local Terminal';
  static const homeAppBarTitle = 'Local Terminal';

  // Status line
  static const statusConnecting = 'Connecting to local shell…';
  static const statusConnected = 'Connected';
  static const statusExited = 'Session ended';
  static const reconnectButton = 'Reconnect';

  // Inline notices written into the terminal itself
  static String exitNotice(int code) =>
      '\r\n[process exited with code $code]\r\n';
  static String errorNotice(String message) =>
      '\r\n[connection error: $message]\r\n';

  // Input bar
  static const inputHint = 'Type a message…';
  static const sendButton = 'Send';

  // Preview pane (right half, web only)
  static const previewAddressHint = 'Preview URL…';
  static const previewReloadLabel = 'Reload';
  static const previewReloadTooltip = 'Reload preview';

  // Apps bar (left pane) — pick which app under apps/ to preview, run/stop it.
  static const appsLabel = 'Preview app';
  static const appsTooltip = 'Choose an app to preview';
  static const appRunLabel = 'Run';
  static const appStopLabel = 'Stop';
  static const appStartingLabel = 'Starting…';

  // Device selector (left pane) — pick the run target (web preview or a device).
  static const deviceLabel = 'on';
  static const deviceTooltip = 'Choose a device to run on';
  // Shown under an offline emulator/simulator in the dropdown.
  static const deviceEmulatorHint = 'Emulator · boots on Run';

  // Native run pane (right half, native target) — the real device window is
  // tiled to the right; this panel just reports state.
  static String deviceRunningTitle(String device) => 'Running on $device';
  static const deviceRunningSubtitle =
      'The app is launching on the device window, tiled to the right.';
  static String deviceStartingTitle(String device) => 'Starting on $device…';
  static String deviceIdleTitle(String device) => 'Ready to run on $device';
  static const deviceIdleSubtitle =
      'Press Run to launch the app on this device.';
  static String deviceFailedTitle(String device) => "Couldn't run on $device";
  static const deviceFailedFallback =
      'The run did not start. Press Run to try again.';

  // Snackbar when the device list can't be fetched from the bridge.
  static const devicesLoadError =
      'Could not load devices. Showing the web preview only.';

  // Setup checklist (top-bar button + right pane)
  static const setupTooltip = 'Local setup';
  static const setupPanelTitle = 'Local setup';
  static const setupRefreshTooltip = 'Re-check';
  static const setupCloseTooltip = 'Close setup';
  static const setupChecking = 'Checking your machine…';
  static const setupAllInstalled = "Everything is installed. You're ready to go.";
  static const setupInstalledLabel = 'Installed';
  static const setupMissingLabel = 'Not installed';
  static const setupManualLabel = 'Manual step';
  static String setupMissingCount(int n) =>
      n == 1 ? '1 item left to install' : '$n items left to install';

  // Command block (run/copy a shell command) — reusable across features.
  static const commandRunLabel = 'Run';
  static const commandCopyLabel = 'Copy';
  static const commandCopiedNotice = 'Copied to clipboard';

  // Agent dropdown (top-bar)
  static const agentTooltip = 'Switch agent';
  static const agentTerminalLabel = 'Terminal';
  static const agentTerminalSubtitle = 'Plain shell';
  static const agentClaudeLabel = 'Claude';
  static const agentClaudeSubtitle = 'Claude Code agent';
  static const agentCodexLabel = 'Codex';
  static const agentCodexSubtitle = 'Codex agent';

  // Launch commands written to the PTY when an agent is selected.
  static const claudeCommand = 'claude';
  static const codexCommand = 'codex';

  // Carriage return appended to a launch command written to the PTY stdin so
  // the shell executes it.
  static const keyEnter = '\r';
}
