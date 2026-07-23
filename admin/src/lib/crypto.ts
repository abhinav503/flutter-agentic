import {
  createCipheriv,
  createDecipheriv,
  createHash,
  randomBytes,
} from "node:crypto";

// Symmetric encryption for secrets held at rest in Firestore (currently only
// a store's Razorpay key secret). The key material is server-only — it lives
// in PAYMENTS_ENC_KEY (Vercel env), never ships to any client, and the
// ciphertext is never returned by an API serializer. AES-256-GCM gives us
// authenticated encryption, so a tampered ciphertext fails to decrypt rather
// than yielding garbage.

const ALGORITHM = "aes-256-gcm";
const IV_LENGTH = 12; // 96-bit nonce — the GCM standard
const PREFIX = "v1"; // versions the on-disk format so it can evolve later

// PAYMENTS_ENC_KEY is ideally 64 hex chars (32 bytes). Anything else is
// hashed to a stable 32-byte key so a plain passphrase still works — but a
// real 32-byte random hex key is what production should set.
function encryptionKey(): Buffer {
  const raw = process.env.PAYMENTS_ENC_KEY;
  if (!raw) {
    throw new Error("PAYMENTS_ENC_KEY is not set");
  }
  if (/^[0-9a-fA-F]{64}$/.test(raw)) {
    return Buffer.from(raw, "hex");
  }
  return createHash("sha256").update(raw).digest();
}

// Returns `v1:<iv>:<authTag>:<ciphertext>`, all base64 — one opaque string
// stored in a single Firestore field.
export function encryptSecret(plaintext: string): string {
  const iv = randomBytes(IV_LENGTH);
  const cipher = createCipheriv(ALGORITHM, encryptionKey(), iv);
  const ciphertext = Buffer.concat([
    cipher.update(plaintext, "utf8"),
    cipher.final(),
  ]);
  const authTag = cipher.getAuthTag();
  return [
    PREFIX,
    iv.toString("base64"),
    authTag.toString("base64"),
    ciphertext.toString("base64"),
  ].join(":");
}

export function decryptSecret(encoded: string): string {
  const parts = encoded.split(":");
  if (parts.length !== 4 || parts[0] !== PREFIX) {
    throw new Error("Malformed encrypted secret");
  }
  const [, ivB64, tagB64, dataB64] = parts;
  const decipher = createDecipheriv(
    ALGORITHM,
    encryptionKey(),
    Buffer.from(ivB64, "base64"),
  );
  decipher.setAuthTag(Buffer.from(tagB64, "base64"));
  return Buffer.concat([
    decipher.update(Buffer.from(dataB64, "base64")),
    decipher.final(),
  ]).toString("utf8");
}
