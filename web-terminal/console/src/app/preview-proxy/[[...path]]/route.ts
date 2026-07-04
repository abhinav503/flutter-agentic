import type { NextRequest } from "next/server";
import { getPreviewPort, setPreviewPort } from "@/lib/preview-port";

// Same-origin proxy for the preview iframe. The visual-edit overlay needs
// `iframe.contentDocument`, which the browser only allows same-origin — so in
// edit mode the iframe loads /preview-proxy/?port=<p> from the console origin
// and this route forwards to the Flutter dev server on 127.0.0.1:<p>.
//
// The port is remembered in @/lib/preview-port, shared with the
// /$dwdsSseHandler route that proxies the debug-client connection.

export async function GET(
  request: NextRequest,
  ctx: { params: Promise<{ path?: string[] }> },
) {
  const { path } = await ctx.params;
  const url = new URL(request.url);

  const portParam = Number(url.searchParams.get("port"));
  setPreviewPort(portParam);

  const qs = new URLSearchParams(url.searchParams);
  qs.delete("port");
  // "localhost", not 127.0.0.1 — `flutter run --web-hostname localhost` can
  // bind IPv6-only (::1), and Node's fetch resolves localhost to either family.
  const target = `http://localhost:${getPreviewPort()}/${path?.join("/") ?? ""}${
    qs.size ? `?${qs}` : ""
  }`;

  let upstream: Response;
  try {
    upstream = await fetch(target, {
      cache: "no-store",
      headers: { accept: request.headers.get("accept") ?? "*/*" },
    });
  } catch {
    return new Response("The preview server is not running.", { status: 502 });
  }

  const contentType = upstream.headers.get("content-type") ?? "";

  // Flutter's index.html declares <base href="/">, which would point every
  // relative asset URL at the console root — rebase it under the proxy.
  if (contentType.includes("text/html")) {
    const html = await upstream.text();
    const rewritten = html.replace(
      /<base\s+href="\/"\s*\/?>/,
      '<base href="/preview-proxy/">',
    );
    return new Response(rewritten, {
      status: upstream.status,
      headers: { "content-type": contentType, "cache-control": "no-store" },
    });
  }

  // The DDC bootstrap hardcodes the DWDS debug-client URL as an absolute
  // http://localhost:<flutter-port>/$dwdsSseHandler — unreachable from the
  // browser when the dev server sits behind this proxy (Docker/cloud). The
  // injected client must connect before it runs main(), so a dead URL leaves
  // the app stuck on the loading bar. Rebase it to the page origin, where the
  // /$dwdsSseHandler route forwards it.
  if (target.endsWith("main_module.bootstrap.js")) {
    const js = await upstream.text();
    const rewritten = js.replace(
      /(["'])(?:ws|http)s?:\/\/[^"']*\/(\$dwdsSseHandler)\1/,
      "$1/$2$1",
    );
    return new Response(rewritten, {
      status: upstream.status,
      headers: {
        "content-type": contentType || "application/javascript",
        "cache-control": "no-store",
      },
    });
  }

  return new Response(upstream.body, {
    status: upstream.status,
    headers: {
      "content-type": contentType || "application/octet-stream",
      "cache-control": "no-store",
    },
  });
}
