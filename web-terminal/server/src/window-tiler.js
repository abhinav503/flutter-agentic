'use strict';

/**
 * Tiles the desktop after a native run: the web_terminal Chrome window to the
 * left 70%, the device window (iOS Simulator) to the right 30% — so the real
 * device sits beside the terminal instead of being mirrored into an iframe.
 *
 * macOS will not let one app move another app's window without permission. We
 * READ the screen geometry via NSScreen (no permission) and PLACE the windows
 * via System Events, which needs a one-time Accessibility grant for whatever
 * launched the bridge (Terminal / VS Code). Without it the osascript errors with
 * "not allowed assistive access" — we detect that, log guidance, and no-op so
 * the run itself is unaffected. The setup checklist surfaces the same fix.
 *
 * Single display assumed (the common dev case). Chrome window is matched by its
 * tab title — keep web/index.html's <title> in sync with CHROME_TITLE_MARKER.
 */

const { execFile } = require('child_process');
const os = require('os');
const logger = require('./logger');

// Substring of the web_terminal browser tab title used to find its Chrome
// window. Must match web/index.html's <title>.
const CHROME_TITLE_MARKER = 'Local Terminal';

// Left pane share; the device gets the remaining right share.
const TERMINAL_SHARE = 0.7;

// JXA: read NSScreen.visibleFrame (bottom-left origin) → top-left AX rect, then
// place the two windows. Throws if System Events is blocked (no Accessibility).
const SCRIPT = `
ObjC.import('AppKit');
function place(win, x, y, w, h) {
  win.position = [Math.round(x), Math.round(y)];
  win.size = [Math.round(w), Math.round(h)];
}
function firstWindowMatching(proc, marker) {
  var wins = proc.windows();
  for (var i = 0; i < wins.length; i++) {
    try { if (wins[i].name().indexOf(marker) !== -1) return wins[i]; } catch (e) {}
  }
  return null;
}
function run() {
  var se = Application('System Events');
  var screen = $.NSScreen.mainScreen;
  var f = screen.frame;
  var vf = screen.visibleFrame;
  var left = vf.origin.x;
  var totalW = vf.size.width;
  var usableH = vf.size.height;
  var top = f.size.height - (vf.origin.y + vf.size.height); // flip to top-left
  var splitW = Math.round(totalW * ${TERMINAL_SHARE});

  var procs = se.processes;
  // Device (iOS Simulator) → right share.
  try {
    var sim = procs.byName('Simulator');
    if (sim.exists()) {
      var sw = sim.windows()[0];
      if (sw) place(sw, left + splitW, top, totalW - splitW, usableH);
    }
  } catch (e) {}
  // web_terminal Chrome window → left share.
  try {
    var chrome = procs.byName('Google Chrome');
    if (chrome.exists()) {
      var cw = firstWindowMatching(chrome, '${CHROME_TITLE_MARKER}');
      if (cw) place(cw, left, top, splitW, usableH);
    }
  } catch (e) {}
  return 'ok';
}
`;

function notAllowed(stderr) {
  return /assistive access|not allowed|-1719|-25211/i.test(stderr || '');
}

/**
 * Best-effort; resolves whether or not tiling happened (never rejects). On a
 * non-mac host it's a no-op.
 */
function tileForNativeRun() {
  if (os.platform() !== 'darwin') return Promise.resolve();
  return new Promise((resolve) => {
    execFile(
      'osascript',
      ['-l', 'JavaScript', '-e', SCRIPT],
      { timeout: 8000 },
      (err, _stdout, stderr) => {
        if (!err) {
          logger.info('tile', 'arranged terminal + device windows');
        } else if (notAllowed(stderr)) {
          logger.warn(
            'tile',
            'window tiling skipped — grant Accessibility to your terminal app ' +
              '(System Settings → Privacy & Security → Accessibility)',
          );
        } else {
          logger.warn('tile', `window tiling failed: ${(stderr || err.message).trim()}`);
        }
        resolve();
      },
    );
  });
}

module.exports = { tileForNativeRun, CHROME_TITLE_MARKER };
