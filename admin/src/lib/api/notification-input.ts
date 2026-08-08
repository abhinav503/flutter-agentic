import {
  NOTIFICATION_IMAGE_MAX_BYTES,
  NOTIFICATION_KINDS,
  type NotificationKind,
} from "@/lib/types";
import type { PushInput } from "@/lib/push";

// Shared by both send routes so a store owner and a superadmin can't have
// their input validated differently. Returns null rather than throwing —
// each route maps that to its own 400.
export function parsePushInput(body: unknown): PushInput | null {
  if (typeof body !== "object" || body === null) return null;
  const { kind, title, message, imageUrl } = body as Record<string, unknown>;

  if (typeof title !== "string" || typeof message !== "string") return null;
  const trimmedTitle = title.trim();
  const trimmedMessage = message.trim();
  if (!trimmedTitle || !trimmedMessage) return null;

  // An unrecognised kind is rejected rather than defaulted: the kind picks
  // the glyph every storefront draws, so silently substituting one would
  // ship the wrong icon rather than surface the mistake.
  if (!NOTIFICATION_KINDS.includes(kind as NotificationKind)) return null;

  // Absent, wrong-typed, or blank all mean "no image" — the field is
  // optional, so none of them is an error. Anything else must be a real
  // https URL: it is handed to FCM, which fetches it on the device, and
  // http:// is blocked there by both platforms' transport rules.
  const trimmedImage = typeof imageUrl === "string" ? imageUrl.trim() : "";
  if (trimmedImage && !isHttpsUrl(trimmedImage)) return null;

  return {
    kind: kind as NotificationKind,
    title: trimmedTitle,
    message: trimmedMessage,
    imageUrl: trimmedImage,
  };
}

function isHttpsUrl(value: string): boolean {
  try {
    return new URL(value).protocol === "https:";
  } catch {
    return false;
  }
}

/**
 * Rejects artwork FCM would silently drop, checked at the server rather than
 * only in the upload field — that check runs in the sender's browser and a
 * scripted caller never sees it.
 *
 * Returns an error message, or null when the image is acceptable.
 *
 * **A check that can't be made is not a failure.** A HEAD that errors, or a
 * host that answers without `content-length`, leaves us no worse off than
 * before this existed, and refusing to send over it would block a legitimate
 * notification because of someone else's CDN. Only a length we actually read
 * and that actually exceeds the ceiling rejects.
 */
export async function imageSizeError(url: string): Promise<string | null> {
  if (!url) return null;

  let length: string | null;
  try {
    const response = await fetch(url, { method: "HEAD" });
    if (!response.ok) return null;
    length = response.headers.get("content-length");
  } catch {
    return null;
  }

  const bytes = length === null ? NaN : Number(length);
  if (!Number.isFinite(bytes) || bytes <= NOTIFICATION_IMAGE_MAX_BYTES) {
    return null;
  }

  return `Image must be under ${Math.round(
    NOTIFICATION_IMAGE_MAX_BYTES / 1024,
  )} KB — this one is ${Math.round(bytes / 1024)} KB`;
}
