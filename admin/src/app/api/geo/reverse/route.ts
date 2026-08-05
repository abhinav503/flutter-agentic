import { NextResponse } from "next/server";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { GeoError, reverseGeocode } from "@/lib/geo";

// GET /api/geo/reverse?latlng=<lat>,<lng> — the "use my location" prefill.
// Token-authed (not store-scoped): geo lookups are user actions, and the
// guard keeps the proxied Ola quota from being an open faucet.
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
  const latlng = searchParams.get("latlng") ?? "";
  const [latitude, longitude] = latlng.split(",").map(Number);
  if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
    return NextResponse.json(
      { error: "latlng must be <lat>,<lng>" },
      { status: 400 },
    );
  }

  try {
    const address = await reverseGeocode(latitude, longitude);
    if (!address) {
      return NextResponse.json(
        { error: "No address found for this location" },
        { status: 404 },
      );
    }
    return NextResponse.json({
      address: {
        formatted: address.formatted,
        address_line: address.addressLine,
        city: address.city,
        state: address.state,
        postal_code: address.postalCode,
        country: address.country,
        latitude: address.latitude,
        longitude: address.longitude,
      },
    });
  } catch (e) {
    if (e instanceof GeoError) {
      return NextResponse.json({ error: e.message }, { status: 502 });
    }
    throw e;
  }
}
