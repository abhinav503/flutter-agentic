import { NextResponse } from "next/server";
import { deleteAddress, parseAddressInput, updateAddress } from "@/lib/addresses";
import { requireAuthedUser, UnauthorizedError } from "@/lib/api/admin-guard";
import { serializeAddress } from "@/lib/api/serializers";

// PUT replaces the whole address — the form always submits every field, so
// there's no partial-patch case to support (same whole-snapshot reasoning
// as the cart's whole-doc replace).
export async function PUT(
  request: Request,
  { params }: { params: Promise<{ addressId: string }> },
) {
  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const { addressId } = await params;
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

  const address = await updateAddress(auth.uid, addressId, input);
  if (!address) {
    return NextResponse.json({ error: "Address not found" }, { status: 404 });
  }
  return NextResponse.json({ address: serializeAddress(address) });
}

// Returns the addresses remaining after the delete — same "sync from the
// response" shape as recent-searches' DELETE.
export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ addressId: string }> },
) {
  let auth;
  try {
    auth = await requireAuthedUser(request);
  } catch (e) {
    if (e instanceof UnauthorizedError) {
      return NextResponse.json({ error: e.message }, { status: 401 });
    }
    throw e;
  }

  const { addressId } = await params;
  const addresses = await deleteAddress(auth.uid, addressId);
  if (!addresses) {
    return NextResponse.json({ error: "Address not found" }, { status: 404 });
  }
  return NextResponse.json({ addresses: addresses.map(serializeAddress) });
}
