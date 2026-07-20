import { NextResponse } from "next/server";
import {
  createAddress,
  getAddresses,
  parseAddressInput,
} from "@/lib/addresses";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { serializeAddress } from "@/lib/api/serializers";

// Shopper addresses — store-agnostic user data, so like /api/users (and
// unlike the /stores/... shopper routes) the uid always comes off a
// verified Firebase ID token, never a plain userId param.

export async function GET(request: Request) {
  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const addresses = await getAddresses(auth.uid);
  return NextResponse.json({ addresses: addresses.map(serializeAddress) });
}

export async function POST(request: Request) {
  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const body = await request.json().catch(() => ({}));
  const input = parseAddressInput(body);
  if (!input) {
    return NextResponse.json(
      {
        error:
          "name, phone, address_line1, city, country, postal_code, and tag are required",
      },
      { status: 400 },
    );
  }

  const address = await createAddress(auth.uid, input);
  return NextResponse.json(
    { address: serializeAddress(address) },
    { status: 201 },
  );
}
