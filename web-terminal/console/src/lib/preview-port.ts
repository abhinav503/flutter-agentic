// The Flutter dev-server port arrives once, on the preview document request
// (/preview-proxy?port=<p>); the asset and DWDS requests that follow can't
// carry it, so it's remembered here. Module-level works because all route
// handlers share one Node process (dev-only, single user, one preview at a
// time — same assumption as the bridge).
let currentPort = 8080;

export function getPreviewPort(): number {
  return currentPort;
}

export function setPreviewPort(port: number): void {
  if (Number.isInteger(port) && port > 0) currentPort = port;
}
