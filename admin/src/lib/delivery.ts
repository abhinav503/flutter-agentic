// A store's delivery policy: what it charges to deliver, and where it will
// deliver at all. Both halves live on the store doc under `delivery`, and
// both are computed here — the fee is part of what a shopper is charged, so
// it must come out identically in the payment intent (checkout-quote) and in
// the order transaction (orders.ts), which is only guaranteed if it is the
// same code. Same reasoning as CartQuote itself.

// Flat fee, an optional waiver threshold, and the areas served.
export type StoreDelivery = {
  // Charged per order, in the store's own currency's major units. 0 = the
  // store never charges for delivery, which is what every store did before
  // this existed.
  fee: number;
  // Goods subtotal at or above which `fee` is waived. 0 = no threshold, i.e.
  // the fee always applies. There is no "free above 0" case to express — a
  // store that wants unconditional free delivery sets `fee` to 0.
  freeAbove: number;
  // Postal-code **prefixes** this store delivers to; an empty list means it
  // delivers everywhere. Prefixes rather than whole codes because the unit a
  // store actually thinks in is a city or a district ("560" is Bengaluru,
  // "SW1" is Westminster), and enumerating every code in one would be
  // thousands of rows an owner has to maintain by hand.
  areas: string[];
};

export const DEFAULT_STORE_DELIVERY: StoreDelivery = {
  fee: 0,
  freeAbove: 0,
  areas: [],
};

// An owner can hold a lot of prefixes legitimately (a national courier
// contract), but not unbounded — this is one array field on a doc that every
// discovery load reads.
export const MAX_DELIVERY_AREAS = 500;
export const MAX_DELIVERY_AREA_LENGTH = 12;

// Thrown when the chosen address falls outside the store's areas. Distinct
// from OrderCreationError because the shopper's remedy is different: nothing
// about the cart will fix it, only a different address.
export class DeliveryUnserviceableError extends Error {
  constructor(message = "This store does not deliver to the selected address") {
    super(message);
    this.name = "DeliveryUnserviceableError";
  }
}

// Postal codes are compared with case and internal spacing removed: a UK code
// is written "SW1A 1AA" or "sw1a1aa" depending on who typed it, and neither
// spelling should decide whether an order can be placed.
function normalizePostalCode(code: string): string {
  return code.replace(/\s+/g, "").toUpperCase();
}

// Trims, normalizes and dedupes what the owner typed into the areas field.
// Over-long entries are dropped rather than truncated — a truncated prefix
// silently widens the area it matches, which is the one failure mode worth
// refusing outright.
export function normalizeDeliveryAreas(input: unknown): string[] {
  if (!Array.isArray(input)) return [];
  const seen = new Set<string>();
  for (const raw of input) {
    if (typeof raw !== "string") continue;
    const code = normalizePostalCode(raw);
    if (!code || code.length > MAX_DELIVERY_AREA_LENGTH) continue;
    seen.add(code);
    if (seen.size >= MAX_DELIVERY_AREAS) break;
  }
  return [...seen];
}

// Tolerant read of the `delivery` map off a store doc. Every store predating
// the field — which is all of them — reads back as DEFAULT_STORE_DELIVERY,
// i.e. free delivery everywhere, exactly the behaviour their storefronts
// already hardcoded.
export function mapStoreDelivery(data: unknown): StoreDelivery {
  const raw = (data ?? {}) as Record<string, unknown>;
  return {
    fee: nonNegative(raw.fee),
    freeAbove: nonNegative(raw.freeAbove),
    areas: normalizeDeliveryAreas(raw.areas),
  };
}

// Rejects NaN/Infinity/negatives to 0 rather than letting them through: a
// non-finite fee would propagate into the charged amount, and a negative one
// would pay the shopper to order.
function nonNegative(value: unknown): number {
  const n = typeof value === "number" ? value : Number(value);
  if (!Number.isFinite(n) || n <= 0) return 0;
  return Math.round(n * 100) / 100;
}

// Whether [postalCode] falls inside the store's delivery areas.
//
// An address saved before the location feature can have an empty postal code
// (the field is optional in the form). Such an address is treated as
// serviceable: the store never said it *wasn't*, and blocking checkout on a
// field the shopper was never required to fill would break existing accounts.
// A store that needs the guarantee gets it by asking for the code, which the
// address form already offers.
export function isServiceable(
  delivery: StoreDelivery,
  postalCode: string,
): boolean {
  if (delivery.areas.length === 0) return true;
  const code = normalizePostalCode(postalCode ?? "");
  if (!code) return true;
  return delivery.areas.some((prefix) => code.startsWith(prefix));
}

// The fee to charge on a cart whose goods come to [goodsSubtotal].
//
// The threshold is measured on the subtotal **net of any coupon** — what the
// shopper actually pays for goods, not what the goods were listed at. The
// consequence is deliberate and worth knowing: a coupon can drop a cart back
// under the threshold and re-introduce the fee. Measuring on the pre-discount
// total instead would let a large enough coupon buy free delivery the store
// never offered.
export function deliveryFeeFor(
  delivery: StoreDelivery,
  goodsSubtotal: number,
): number {
  if (delivery.fee <= 0) return 0;
  if (delivery.freeAbove > 0 && goodsSubtotal >= delivery.freeAbove) return 0;
  return delivery.fee;
}
