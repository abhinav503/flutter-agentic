import { NextResponse } from "next/server";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { GeoError, lookupPincode } from "@/lib/geo";

// GET /api/geo/pincode/<pincode> — 6-digit pincode → city/state autofill,
// via India Post (best-effort; the app fails silent on 404/502 so a flaky
// upstream never blocks the form).
export async function GET(
  request: Request,
  { params }: { params: Promise<{ pincode: string }> },
) {
  try {
    await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const { pincode } = await params;
  if (!/^\d{6}$/.test(pincode)) {
    return NextResponse.json(
      { error: "pincode must be 6 digits" },
      { status: 400 },
    );
  }

  try {
    const info = await lookupPincode(pincode);
    if (!info) {
      return NextResponse.json({ error: "Unknown pincode" }, { status: 404 });
    }
    return NextResponse.json({
      pincode: { city: info.city, state: info.state, country: info.country },
    });
  } catch (e) {
    if (e instanceof GeoError) {
      return NextResponse.json({ error: e.message }, { status: 502 });
    }
    throw e;
  }
}
