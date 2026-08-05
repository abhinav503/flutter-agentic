import { NextResponse } from "next/server";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { autocomplete, GeoError } from "@/lib/geo";

// GET /api/geo/autocomplete?q=<text>[&latlng=<lat>,<lng>] — address
// type-ahead for the address form; optional latlng biases results near the
// shopper. Same auth reasoning as ../reverse.
export async function GET(request: Request) {
  try {
    await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const { searchParams } = new URL(request.url);
  const q = (searchParams.get("q") ?? "").trim();
  if (q.length < 3) {
    // Too short to suggest against — an empty list, not an error, so the
    // client doesn't need a length rule of its own.
    return NextResponse.json({ suggestions: [] });
  }

  let near: { latitude: number; longitude: number } | undefined;
  const latlng = searchParams.get("latlng");
  if (latlng) {
    const [latitude, longitude] = latlng.split(",").map(Number);
    if (Number.isFinite(latitude) && Number.isFinite(longitude)) {
      near = { latitude, longitude };
    }
  }

  try {
    const suggestions = await autocomplete(q, near);
    return NextResponse.json({
      suggestions: suggestions.map((s) => ({
        description: s.description,
        place_id: s.placeId,
        latitude: s.latitude,
        longitude: s.longitude,
      })),
    });
  } catch (e) {
    if (e instanceof GeoError) {
      return NextResponse.json({ error: e.message }, { status: 502 });
    }
    throw e;
  }
}
