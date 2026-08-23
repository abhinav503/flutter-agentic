import { NextResponse } from "next/server";
import { authorizeWrite, parseEntity, tracedRoute, unknownEntity } from "@/lib/api/v1/catalog-route";
import { consumeRateLimit } from "@/lib/api/rate-limit";
import { IMPORT_FORMATS, ImportError, runImport, type ImportFormatOrAuto } from "@/lib/api/v1/import";

// POST a CSV. Two request shapes, one behaviour:
//   Content-Type: text/csv  with the file as the body and the options as
//                           query params (?entity=products&format=shopify&commit=true)
//                           format: auto (default, sniffs the header) |
//                                   cordelia | shopify | woocommerce | meta
//   Content-Type: application/json  { csv, entity, format, commit, ... }
// Dry run unless commit=true — the response is the plan either way.
export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const url = new URL(request.url);
  const contentType = (request.headers.get("content-type") ?? "").split(";")[0].trim();

  let csv = "";
  let options: Record<string, unknown> = Object.fromEntries(url.searchParams.entries());
  if (contentType === "application/json") {
    const body = await request.json().catch(() => null);
    if (!body || typeof body.csv !== "string") {
      return NextResponse.json({ error: "Body must be { csv: string, ... }" }, { status: 400 });
    }
    csv = body.csv;
    options = { ...options, ...body };
  } else if (contentType === "text/csv" || contentType === "text/plain" || contentType === "application/octet-stream") {
    csv = await request.text();
  } else if (contentType === "multipart/form-data") {
    const form = await request.formData();
    const file = form.get("file");
    if (!(file instanceof File)) {
      return NextResponse.json({ error: "multipart body needs a `file` part" }, { status: 400 });
    }
    csv = await file.text();
    for (const [k, v] of form.entries()) if (typeof v === "string") options[k] = v;
  } else {
    return NextResponse.json(
      { error: "Send the CSV as text/csv, multipart `file`, or JSON { csv }" },
      { status: 415 },
    );
  }

  const rawEntity = String(options.entity ?? "products");
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const format = String(options.format ?? "auto") as ImportFormatOrAuto;
  if (format !== "auto" && !IMPORT_FORMATS.includes(format)) {
    return NextResponse.json({ error: `format must be auto or one of ${IMPORT_FORMATS.join(", ")}` }, { status: 400 });
  }
  const truthy = (v: unknown) => v === true || v === "true" || v === "1";
  const commit = truthy(options.commit);
  const createMissing = options.create_missing === undefined ? undefined : truthy(options.create_missing);
  const tagsAsCategories = truthy(options.tags_as_categories);

  const auth = await authorizeWrite(request, storeId, 0);
  if ("response" in auth) return auth.response;

  return tracedRoute(`POST import`, storeId, auth.actor, async () => {
  try {
    const report = await runImport(
      storeId,
      csv,
      { entity, format, commit, createMissing, tagsAsCategories },
      auth.actor.uid,
    );
    if (commit) {
      try {
        consumeRateLimit(
          auth.actor.kind === "token" ? `t:${auth.actor.tokenId}` : `u:${auth.actor.uid}`,
          report.rows_read,
        );
      } catch {
        // Already written; the limiter's refusal applies to the next call.
      }
    }
    return NextResponse.json(report);
  } catch (e) {
    if (e instanceof ImportError) {
      return NextResponse.json({ error: e.message }, { status: e.status });
    }
    throw e;
  }
  }, { format, entity, commit });
}
