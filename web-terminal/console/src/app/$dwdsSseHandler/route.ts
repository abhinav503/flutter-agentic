import type { NextRequest } from "next/server";
import { getPreviewPort } from "@/lib/preview-port";

// Proxy for the DWDS injected debug client. In debug builds the client must
// establish this connection before it runs main(); the bridge spawns
// `flutter run` with --web-server-debug-injected-client-protocol=sse so the
// connection is plain HTTP (an EventSource GET + message POSTs) instead of a
// WebSocket, and the preview-proxy rewrites the injected URL to this
// same-origin path. Both directions carry credentials, so Caddy's basic auth
// stays intact in the cloud image.

function targetUrl(request: NextRequest): string {
  const url = new URL(request.url);
  return `http://localhost:${getPreviewPort()}/$dwdsSseHandler${url.search}`;
}

export async function GET(request: NextRequest) {
  let upstream: Response;
  try {
    upstream = await fetch(targetUrl(request), {
      cache: "no-store",
      headers: { accept: request.headers.get("accept") ?? "text/event-stream" },
      // Tear down the upstream SSE stream when the iframe goes away.
      signal: request.signal,
    });
  } catch {
    return new Response("The preview debug service is not running.", {
      status: 502,
    });
  }
  return new Response(upstream.body, {
    status: upstream.status,
    headers: {
      "content-type":
        upstream.headers.get("content-type") ?? "text/event-stream",
      "cache-control": "no-store",
    },
  });
}

export async function POST(request: NextRequest) {
  try {
    const upstream = await fetch(targetUrl(request), {
      method: "POST",
      cache: "no-store",
      headers: {
        "content-type": request.headers.get("content-type") ?? "text/plain",
      },
      body: await request.text(),
    });
    return new Response(await upstream.text(), { status: upstream.status });
  } catch {
    return new Response("The preview debug service is not running.", {
      status: 502,
    });
  }
}
