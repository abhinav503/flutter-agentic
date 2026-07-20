import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import type { Address } from "./types";

// Admin SDK path like cart.ts/recent-searches.ts — per-user data, but
// unlike those the caller is a *verified* uid (requireAuthedUser on the
// /api/users/addresses routes), since addresses ride the same token-authed
// surface as the shopper profile.
function addressesRef(uid: string) {
  return adminDb.collection("users").doc(uid).collection("addresses");
}

// Wire (snake_case) -> Address fields, validating the required ones. The
// form's bounded picklists (city/country) still get server-side presence
// checks — the API shouldn't trust that only gravia's form calls it.
export function parseAddressInput(body: {
  [key: string]: unknown;
}): Omit<Address, "id"> | null {
  const required = {
    name: body.name,
    phone: body.phone,
    addressLine1: body.address_line1,
    city: body.city,
    country: body.country,
    postalCode: body.postal_code,
    tag: body.tag,
  };
  for (const value of Object.values(required)) {
    if (typeof value !== "string" || !value.trim()) return null;
  }
  return {
    ...(required as Record<keyof typeof required, string>),
    addressLine2:
      typeof body.address_line2 === "string" ? body.address_line2 : "",
    landmark: typeof body.landmark === "string" ? body.landmark : "",
    isDefault: body.is_default === true,
  };
}

export async function getAddresses(uid: string): Promise<Address[]> {
  const snap = await addressesRef(uid).orderBy("createdAt").get();
  return snap.docs.map(
    (d) => ({ id: d.id, ...d.data() }) as Address,
  );
}

export async function createAddress(
  uid: string,
  data: Omit<Address, "id">,
): Promise<Address> {
  // The shopper's first address becomes their default automatically — the
  // form has no "set as default" toggle, and Home's delivery label needs a
  // default to exist.
  const isFirst = (await addressesRef(uid).limit(1).get()).empty;
  const ref = addressesRef(uid).doc();
  const address = { ...data, isDefault: isFirst || data.isDefault };
  await ref.set({ ...address, createdAt: FieldValue.serverTimestamp() });
  return { id: ref.id, ...address };
}

export async function updateAddress(
  uid: string,
  id: string,
  data: Omit<Address, "id">,
): Promise<Address | null> {
  const ref = addressesRef(uid).doc(id);
  if (!(await ref.get()).exists) return null;
  await ref.set(
    { ...data, updatedAt: FieldValue.serverTimestamp() },
    { merge: true },
  );
  return { id, ...data };
}
