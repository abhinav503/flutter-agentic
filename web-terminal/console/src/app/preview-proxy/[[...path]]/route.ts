import type { NextRequest } from "next/server";

// Same-origin proxy for the preview iframe. The visual-edit overlay needs
// `iframe.contentDocument`, which the browser only allows same-origin — so in
// edit mode the iframe loads /preview-proxy/?port=<p> from the console origin
// and this route forwards to the Flutter dev server on 127.0.0.1:<p>.
//
// The port arrives once on the document request; the asset requests that
// follow can't carry it, so it's remembered module-side (dev-only, single
// user, one preview at a time — same assumption as the bridge).
let currentPort = 8080;

export async function GET(
  request: NextRequest,
  ctx: { params: Promise<{ path?: string[] }> },
) {
  const { path } = await ctx.params;
  const url = new URL(request.url);

  const portParam = Number(url.searchParams.get("port"));
  if (Number.isInteger(portParam) && portParam > 0) currentPort = portParam;

  const qs = new URLSearchParams(url.searchParams);
  qs.delete("port");
  // "localhost", not 127.0.0.1 — `flutter run --web-hostname localhost` can
  // bind IPv6-only (::1), and Node's fetch resolves localhost to either family.
  const target = `http://localhost:${currentPort}/${path?.join("/") ?? ""}${
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

  return new Response(upstream.body, {
    status: upstream.status,
    headers: {
      "content-type": contentType || "application/octet-stream",
      "cache-control": "no-store",
    },
  });
}
