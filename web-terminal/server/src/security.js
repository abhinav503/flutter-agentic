'use strict';

/**
 * Reusable request-guard predicates. Pure functions, no side effects — easy to
 * unit test and reuse across both the HTTP and WebSocket-upgrade paths.
 */

const { ALLOWED_HOSTS, ALLOWED_ORIGINS } = require('./config');

// Matches only localhost origins (any scheme/port). Used to scope CORS on
// /config.json so a public page can't read the token cross-origin.
const LOCALHOST_ORIGIN = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/;

/** True when the request's Host header is in the allowlist (DNS-rebind guard). */
function isHostAllowed(req) {
  return ALLOWED_HOSTS.has(req.headers.host || '');
}

/** True when an Origin header is localhost or explicitly allowed via env. */
function isAllowedOrigin(origin) {
  return LOCALHOST_ORIGIN.test(origin || '') || ALLOWED_ORIGINS.has(origin || '');
}

module.exports = { isHostAllowed, isAllowedOrigin };
