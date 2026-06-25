'use strict';

/**
 * Serves the built Flutter web app from WEB_DIR, with a SPA fallback to
 * index.html for client-side routes. Path traversal outside WEB_DIR is blocked.
 */

const fs = require('fs');
const path = require('path');
const { WEB_DIR } = require('./config');

const MIME = Object.freeze({
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.wasm': 'application/wasm',
  '.ttf': 'font/ttf',
  '.woff2': 'font/woff2',
});

/** Content-Type for a path, defaulting to octet-stream for unknown extensions. */
function contentTypeFor(filePath) {
  return MIME[path.extname(filePath)] || 'application/octet-stream';
}

function serveIndexFallback(res) {
  fs.readFile(path.join(WEB_DIR, 'index.html'), (err, html) => {
    if (err) return res.writeHead(404).end('not found');
    res.writeHead(200, { 'content-type': MIME['.html'] }).end(html);
  });
}

function serveStatic(req, res) {
  if (!fs.existsSync(WEB_DIR)) {
    res.writeHead(503, { 'content-type': 'text/plain' });
    res.end('Flutter web build not found. Run `flutter build web` in apps/web_terminal, or use the dev flow.');
    return;
  }

  let urlPath = decodeURIComponent((req.url || '/').split('?')[0]);
  if (urlPath === '/') urlPath = '/index.html';

  const filePath = path.join(WEB_DIR, path.normalize(urlPath));
  // Prevent path traversal outside WEB_DIR.
  if (!filePath.startsWith(WEB_DIR)) {
    res.writeHead(403).end('forbidden');
    return;
  }

  fs.readFile(filePath, (err, data) => {
    if (err) return serveIndexFallback(res); // SPA fallback for client routes
    res.writeHead(200, { 'content-type': contentTypeFor(filePath) }).end(data);
  });
}

module.exports = { serveStatic, MIME };
