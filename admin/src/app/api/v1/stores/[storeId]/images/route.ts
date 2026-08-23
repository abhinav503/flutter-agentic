import { NextResponse } from "next/server";
import { authorizeWrite } from "@/lib/api/v1/catalog-route";
import { ImageRehostError, isImageKind, rehostImage } from "@/lib/api/v1/images";

// POST { url, kind? } → { url } in the store's own bucket. `kind` picks the
// folder (products by default) and must be one the storage rules know.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const auth = await authorizeWrite(request, storeId, 1);
  if ("response" in auth) return auth.response;
  const body = await request.json().catch(() => ({}));
  const url = typeof body.url === "string" ? body.url.trim() : "";
  const kind = typeof body.kind === "string" ? body.kind : "products";
  if (!url) return NextResponse.json({ error: "url is required" }, { status: 400 });
  if (!isImageKind(kind)) return NextResponse.json({ error: `Unknown kind ${kind}` }, { status: 400 });
  try {
    const result = await rehostImage(storeId, kind, url);
    return NextResponse.json({ source_url: url, ...result });
  } catch (e) {
    if (e instanceof ImageRehostError) {
      return NextResponse.json({ error: e.message }, { status: e.status });
    }
    throw e;
  }
}
