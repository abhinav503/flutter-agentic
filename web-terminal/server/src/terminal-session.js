'use strict';

/**
 * One PTY session bound to one WebSocket.
 *
 * Spawns the login shell as the current user, pipes PTY output to the socket,
 * and applies `input`/`resize` messages coming back. Returns a handle with
 * `dispose()` so the server can tear sessions down on shutdown.
 */

const pty = require('node-pty');
const { SHELL, PTY, PROJECT_DIR } = require('./config');
const logger = require('./logger');

/** Send a JSON frame only if the socket is still open. */
function send(ws, payload) {
  if (ws.readyState === ws.OPEN) ws.send(JSON.stringify(payload));
}

/** Apply a single client message to the shell. Unknown/malformed messages are ignored. */
function applyClientMessage(shell, raw) {
  let msg;
  try {
    msg = JSON.parse(raw.toString());
  } catch {
    return; // ignore non-JSON frames
  }

  if (msg.type === 'input' && typeof msg.data === 'string') {
    shell.write(msg.data);
  } else if (
    msg.type === 'resize' &&
    Number.isInteger(msg.cols) &&
    Number.isInteger(msg.rows)
  ) {
    try {
      shell.resize(msg.cols, msg.rows);
    } catch {
      /* shell already exited */
    }
  }
}

/**
 * Wire a fresh PTY to `ws`. Returns `{ pid, dispose }`.
 * The session self-disposes when the socket closes; `dispose()` is also safe
 * to call externally (e.g. on server shutdown) and is idempotent.
 */
function createTerminalSession(ws) {
  const shell = pty.spawn(SHELL, ['-l'], {
    name: PTY.name,
    cols: PTY.cols,
    rows: PTY.rows,
    cwd: PROJECT_DIR,
    env: process.env,
  });

  logger.info('term', `session started (pid ${shell.pid}, shell ${SHELL})`);

  let disposed = false;
  const dispose = () => {
    if (disposed) return;
    disposed = true;
    try {
      shell.kill();
    } catch {
      /* already dead */
    }
  };

  // PTY -> browser
  shell.onData((data) => send(ws, { type: 'output', data }));
  shell.onExit(({ exitCode }) => {
    send(ws, { type: 'exit', code: exitCode });
    ws.close();
  });

  // browser -> PTY
  ws.on('message', (raw) => applyClientMessage(shell, raw));
  ws.on('error', (err) => logger.warn('term', `ws error (pid ${shell.pid}): ${err.message}`));
  ws.on('close', () => {
    logger.info('term', `session closed (pid ${shell.pid})`);
    dispose();
  });

  return { pid: shell.pid, dispose };
}

module.exports = { createTerminalSession };
