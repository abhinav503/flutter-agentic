// Server-side geo lookups for the shopper app's address form. One left:
// India Post (pincode → city/state; keyless, proxied anyway so the app has
// one code path and web builds dodge CORS).
//
// Reverse geocoding and place autocomplete used to live here against **Ola
// Maps**, and are gone. Two reasons, either sufficient: OLA_MAPS_API_KEY was
// never configured in production, so both endpoints had returned 502 since
// the day they shipped; and Ola only covers India, while this app sells in
// seven markets. Reverse geocoding now happens on the device itself
// (Android's Geocoder / iOS's CLGeocoder — no key, no quota, works
// everywhere, and needs no account, which is what lets a signed-out shopper
// use it). Place autocomplete has no keyless equivalent and was dropped
// rather than replaced.

export class GeoError extends Error {}

export type PincodeInfo = {
  city: string;
  state: string;
  country: string;
};

// India Post's community API (api.postalpincode.in) — keyless and free, but
// best-effort (no SLA): callers treat null as "no autofill", never an error
// the shopper sees.
export async function lookupPincode(
  pincode: string,
): Promise<PincodeInfo | null> {
  const response = await fetch(
    `https://api.postalpincode.in/pincode/${pincode}`,
  );
  if (!response.ok) {
    throw new GeoError(`India Post lookup failed (${response.status})`);
  }

  const data = (await response.json()) as Array<{
    Status?: string;
    PostOffice?: Array<{
      District?: string;
      State?: string;
      Country?: string;
    }>;
  }>;
  const office = data?.[0]?.PostOffice?.[0];
  if (data?.[0]?.Status !== "Success" || !office) return null;
  return {
    city: office.District ?? "",
    state: office.State ?? "",
    country: office.Country ?? "India",
  };
}
