// Server-side geo lookups for the shopper app's address form — Ola Maps
// (reverse geocode + autocomplete; key stays in OLA_MAPS_API_KEY) and India
// Post (pincode → city/state; keyless, proxied anyway so the app has one
// code path and web builds dodge CORS). Same fetch/typed-error/narrow-return
// shape as payments.ts' Razorpay calls.

export class GeoError extends Error {}

// What the app's address form needs to prefill — nothing more. Both Ola
// responses are mapped onto this one shape.
export type GeoAddress = {
  formatted: string;
  addressLine: string;
  city: string;
  state: string;
  postalCode: string;
  country: string;
  latitude: number | null;
  longitude: number | null;
};

export type PlaceSuggestion = {
  description: string;
  placeId: string;
  latitude: number | null;
  longitude: number | null;
};

export type PincodeInfo = {
  city: string;
  state: string;
  country: string;
};

const OLA_BASE = "https://api.olamaps.io";

function olaApiKey(): string {
  const key = process.env.OLA_MAPS_API_KEY;
  if (!key) throw new GeoError("OLA_MAPS_API_KEY is not configured");
  return key;
}

// Ola's responses follow the Google Places conventions (results /
// predictions, geometry.location, address_components with types[]), but the
// exact fields aren't contractual — every read below is defensive.
type OlaComponent = { long_name?: string; short_name?: string; types?: string[] };
type OlaResult = {
  formatted_address?: string;
  address_components?: OlaComponent[];
  geometry?: { location?: { lat?: number; lng?: number } };
  name?: string;
};

function componentOf(components: OlaComponent[], ...types: string[]): string {
  for (const type of types) {
    const match = components.find((c) => c.types?.includes(type));
    if (match?.long_name) return match.long_name;
  }
  return "";
}

function toGeoAddress(result: OlaResult): GeoAddress {
  const components = result.address_components ?? [];
  const formatted = result.formatted_address ?? result.name ?? "";
  const city = componentOf(
    components,
    "locality",
    "administrative_area_level_3",
    "sublocality_level_1",
    "sublocality",
  );
  const state = componentOf(components, "administrative_area_level_1");
  const postalCode = componentOf(components, "postal_code");
  const country = componentOf(components, "country");
  // The form's line 1 is the formatted address minus the parts that get
  // their own fields — best-effort trim, never empty when formatted isn't.
  const tail = [city, state, postalCode, country].filter(Boolean);
  let addressLine = formatted;
  for (const part of tail) {
    addressLine = addressLine.replace(`, ${part}`, "").replace(part, "");
  }
  addressLine = addressLine.replace(/[,\s]+$/, "").replace(/^[,\s]+/, "");
  return {
    formatted,
    addressLine: addressLine || formatted,
    city,
    state,
    postalCode,
    country: country || "India",
    latitude: result.geometry?.location?.lat ?? null,
    longitude: result.geometry?.location?.lng ?? null,
  };
}

export async function reverseGeocode(
  latitude: number,
  longitude: number,
): Promise<GeoAddress | null> {
  const url = new URL(`${OLA_BASE}/places/v1/reverse-geocode`);
  url.searchParams.set("latlng", `${latitude},${longitude}`);
  url.searchParams.set("api_key", olaApiKey());

  const response = await fetch(url);
  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new GeoError(
      `Ola reverse geocode failed (${response.status}): ${detail}`,
    );
  }

  const data = (await response.json()) as { results?: OlaResult[] };
  const first = data.results?.[0];
  return first ? toGeoAddress(first) : null;
}

export async function autocomplete(
  input: string,
  near?: { latitude: number; longitude: number },
): Promise<PlaceSuggestion[]> {
  const url = new URL(`${OLA_BASE}/places/v1/autocomplete`);
  url.searchParams.set("input", input);
  if (near) {
    url.searchParams.set("location", `${near.latitude},${near.longitude}`);
  }
  url.searchParams.set("api_key", olaApiKey());

  const response = await fetch(url);
  if (!response.ok) {
    const detail = await response.text().catch(() => "");
    throw new GeoError(
      `Ola autocomplete failed (${response.status}): ${detail}`,
    );
  }

  const data = (await response.json()) as {
    predictions?: Array<
      OlaResult & { description?: string; place_id?: string }
    >;
  };
  return (data.predictions ?? [])
    .filter((p) => p.description || p.formatted_address)
    .map((p) => ({
      description: p.description ?? p.formatted_address ?? "",
      placeId: p.place_id ?? "",
      latitude: p.geometry?.location?.lat ?? null,
      longitude: p.geometry?.location?.lng ?? null,
    }));
}

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
