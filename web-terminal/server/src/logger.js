'use strict';

/**
 * Tiny structured logger — timestamped, scoped, level-aware.
 *
 * Keeps log lines uniform across modules (`<iso> [level] [scope] message`)
 * instead of scattering bare `console.log` calls. warn/error go to stderr so
 * they can be separated from normal output in production.
 */

function emit(stream, level, scope, message) {
  stream(`${new Date().toISOString()} [${level}] [${scope}] ${message}`);
}

module.exports = {
  info: (scope, message) => emit(console.log, 'info', scope, message),
  warn: (scope, message) => emit(console.warn, 'warn', scope, message),
  error: (scope, message) => emit(console.error, 'error', scope, message),
};
