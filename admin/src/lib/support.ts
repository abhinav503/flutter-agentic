// A store's support contact: how a shopper reaches the people who can
// actually fix their order.
//
// This lives on the store doc rather than in a platform-wide setting because
// the problems shoppers have — a wrong item, a missing delivery, a refund
// that never landed — are the *store's* to resolve. The platform address
// (see SUPPORT_FALLBACK_EMAIL in cordelia) stays available underneath for
// account and app problems, which is the other half a store cannot help with.
//
// Every field is optional. A store that fills in nothing still leaves its
// shoppers the platform fallback, so this is never a dead end.

export type StoreSupport = {
  // Where a shopper writes about an order. '' = not published.
  email: string;
  // Dialled with a `tel:` intent, so it is stored as the owner typed it
  // (spacing and country code included) rather than as bare digits. '' = not
  // published.
  phone: string;
  // Free text, in the store's own language: "Mon–Sat, 9am–7pm". Authored
  // rather than structured because the shapes owners actually need (festival
  // closures, a lunch break, "24/7") do not fit a weekday grid, and the only
  // thing done with it is printing it. '' = not published.
  hours: string;
};

export const DEFAULT_STORE_SUPPORT: StoreSupport = {
  email: "",
  phone: "",
  hours: "",
};

export const MAX_SUPPORT_EMAIL_LENGTH = 254;
export const MAX_SUPPORT_PHONE_LENGTH = 32;
export const MAX_SUPPORT_HOURS_LENGTH = 120;

// Deliberately permissive — the same shape check the app's own
// FieldValidationX.isValidEmail applies, and no more. A stricter rule here
// would reject valid addresses an owner really does read mail at, and the
// cost of a typo is a bounced support mail rather than a broken checkout.
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function isSupportEmail(value: string): boolean {
  return value.length <= MAX_SUPPORT_EMAIL_LENGTH && EMAIL_PATTERN.test(value);
}

// A dialable number needs digits; everything else in it is punctuation the
// owner chose. Six is the shortest real subscriber number in the markets
// this ships to, and short codes are not something a store publishes.
export function isSupportPhone(value: string): boolean {
  if (value.length > MAX_SUPPORT_PHONE_LENGTH) return false;
  const digits = value.replace(/\D/g, "");
  return digits.length >= 6;
}

// Tolerant read of the `support` map off a store doc. Every store predating
// the field reads back as DEFAULT_STORE_SUPPORT — no store contact, platform
// fallback only, which is exactly what those stores offered before this
// existed.
export function mapStoreSupport(data: unknown): StoreSupport {
  const raw = (data ?? {}) as Record<string, unknown>;
  return {
    email: text(raw.email, MAX_SUPPORT_EMAIL_LENGTH),
    phone: text(raw.phone, MAX_SUPPORT_PHONE_LENGTH),
    hours: text(raw.hours, MAX_SUPPORT_HOURS_LENGTH),
  };
}

// Reading is lenient where writing is strict: a doc written long ago is
// printed as-is (truncated, never rejected), while the PUT route validates
// before it stores. Same split as mapStoreDelivery's `?? 0` vs money().
function text(value: unknown, max: number): string {
  if (typeof value !== "string") return "";
  return value.trim().slice(0, max);
}
