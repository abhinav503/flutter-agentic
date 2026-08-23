import { randomUUID } from "node:crypto";
import { lookup } from "node:dns/promises";
import { isIP } from "node:net";
import { getStorage } from "firebase-admin/storage";
import "@/lib/firebase-admin";

// Copies a public image into the store's own Storage folder, so a catalog
// imported from Shopify (or anywhere) keeps its photos after the merchant
// closes the account they came from. Same path scheme as the console's
// uploads ({storeId}/{kind}/{uuid}.{ext}) and the same bucket.

const MAX_IMAGE_BYTES = 10 * 1024 * 1024;
const FETCH_TIMEOUT_MS = 15_000;
const ALLOWED_KINDS = ["products", "categories", "banners", "brands", "store"] as const;
export type ImageKind = (typeof ALLOWED_KINDS)[number];

export function isImageKind(k: string): k is ImageKind {
  return (ALLOWED_KINDS as readonly string[]).includes(k);
}

export class ImageRehostError extends Error {
  constructor(
    message: string,
    public readonly status: 400 | 413 | 415 | 502 = 400,
  ) {
    super(message);
  }
}

function isPrivateAddress(ip: string): boolean {
  const v = isIP(ip);
  if (v === 4) {
    const [a, b] = ip.split(".").map(Number);
    return (
      a === 10 ||
      a === 127 ||
      a === 0 ||
      (a === 169 && b === 254) ||
      (a === 172 && b >= 16 && b <= 31) ||
      (a === 192 && b === 168) ||
      (a === 100 && b >= 64 && b <= 127)
    );
  }
  if (v === 6) {
    const lower = ip.toLowerCase();
    return (
      lower === "::1" ||
      lower === "::" ||
      lower.startsWith("fc") ||
      lower.startsWith("fd") ||
      lower.startsWith("fe80") ||
      lower.startsWith("::ffff:") // v4-mapped — re-check the v4 part
    );
  }
  return true; // not an address at all
}

async function resolvesToPrivateAddress(hostname: string): Promise<boolean> {
  if (hostname === "localhost" || hostname.endsWith(".localhost") || hostname.endsWith(".internal")) return true;
  if (isIP(hostname)) return isPrivateAddress(hostname);
  try {
    const addresses = await lookup(hostname, { all: true });
    if (addresses.length === 0) return true;
    return addresses.some((a) => {
      const mapped = a.address.toLowerCase().startsWith("::ffff:") ? a.address.slice(7) : a.address;
      return isPrivateAddress(mapped);
    });
  } catch {
    return true;
  }
}

const EXT_BY_TYPE: Record<string, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
  "image/gif": "gif",
  "image/avif": "avif",
  "image/svg+xml": "svg",
};

function bucket() {
  const name = process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET;
  if (!name) throw new Error("NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET is not set");
  return getStorage().bucket(name);
}

export async function rehostImage(
  storeId: string,
  kind: ImageKind,
  sourceUrl: string,
): Promise<{ url: string; bytes: number; contentType: string }> {
  let parsed: URL;
  try {
    parsed = new URL(sourceUrl);
  } catch {
    throw new ImageRehostError("url must be an absolute https URL.");
  }
  if (parsed.protocol !== "https:") throw new ImageRehostError("url must use https.");
  // The server fetches on the caller's behalf, so the caller must not be
  // able to point it at anything private — loopback, link-local, the
  // cloud metadata address, RFC 1918 ranges — by name or by number. The
  // name is resolved here and the fetch pinned to the same host, so a
  // record that changes between check and fetch still can't escape.
  if (await resolvesToPrivateAddress(parsed.hostname)) {
    throw new ImageRehostError("url must point at a public host.");
  }
  // Our own bucket is the destination, never a source worth copying again.
  if (parsed.hostname === "firebasestorage.googleapis.com" && parsed.pathname.includes(encodeURIComponent(storeId))) {
    return { url: sourceUrl, bytes: 0, contentType: "" };
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), FETCH_TIMEOUT_MS);
  let res: Response;
  try {
    res = await fetch(sourceUrl, { signal: controller.signal, redirect: "follow" });
  } catch {
    throw new ImageRehostError("The image could not be fetched.", 502);
  } finally {
    clearTimeout(timer);
  }
  if (!res.ok) throw new ImageRehostError(`The image URL answered ${res.status}.`, 502);
  const contentType = (res.headers.get("content-type") ?? "").split(";")[0].trim();
  const ext = EXT_BY_TYPE[contentType];
  if (!ext) throw new ImageRehostError(`Not an image (${contentType || "no content-type"}).`, 415);
  const declared = Number(res.headers.get("content-length") ?? 0);
  if (declared > MAX_IMAGE_BYTES) throw new ImageRehostError("Image is over 10 MB.", 413);
  const buf = Buffer.from(await res.arrayBuffer());
  if (buf.byteLength > MAX_IMAGE_BYTES) throw new ImageRehostError("Image is over 10 MB.", 413);

  const path = `${storeId}/${kind}/${randomUUID()}.${ext}`;
  const token = randomUUID();
  const file = bucket().file(path);
  await file.save(buf, {
    contentType,
    metadata: { metadata: { firebaseStorageDownloadTokens: token, sourceUrl } },
  });
  // The same download-URL shape the client SDK hands the console, so the
  // storefront's image loader treats both identically.
  const url = `https://firebasestorage.googleapis.com/v0/b/${bucket().name}/o/${encodeURIComponent(path)}?alt=media&token=${token}`;
  return { url, bytes: buf.byteLength, contentType };
}
