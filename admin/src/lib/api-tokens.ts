import { createHash, randomBytes } from "node:crypto";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import { API_TOKEN_SCOPES, type ApiTokenScope } from "./api-token-scopes";

export { API_TOKEN_SCOPES, type ApiTokenScope } from "./api-token-scopes";

// Long-lived credentials for machine callers of the v1 API — a CLI in CI, an
// MCP server beside a coding agent, a sync job. Each token is bound to ONE
// store and a few scopes, never to an account: an agency managing twenty
// stores holds twenty tokens, and a leaked one reaches one catalog.
//
// Storage: apiTokens/{sha256(token)}. The doc id is the hash, so a request
// resolves with a single get and no index, and the plaintext exists only in
// the one response that created it (never at rest — same posture as a
// payment key secret, which is encrypted, except a token is verified rather
// than used, so a one-way hash is enough). No client rule exists for the
// collection: Admin SDK only.

const TOKEN_PREFIX = "cord_live_";
// 30 random bytes → 40 base64url chars: 240 bits, far past guessable.
const TOKEN_RANDOM_BYTES = 30;
const MAX_LABEL_LENGTH = 60;
const MAX_TOKENS_PER_STORE = 20;

export type ApiToken = {
  id: string;
  storeId: string;
  label: string;
  // The first characters of the token ("cord_live_ab12"), so an owner can
  // tell which of several tokens a config file holds without ever seeing
  // the rest again.
  prefix: string;
  scopes: ApiTokenScope[];
  createdBy: string;
  createdAtMs: number;
  lastUsedAtMs: number;
  revokedAtMs: number;
};

export function isApiToken(bearer: string): boolean {
  return bearer.startsWith(TOKEN_PREFIX);
}

function hashToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

function tokensRef() {
  return adminDb.collection("apiTokens");
}

function toApiToken(id: string, data: FirebaseFirestore.DocumentData): ApiToken {
  const ms = (v: unknown) => (v instanceof Timestamp ? v.toMillis() : 0);
  return {
    id,
    storeId: data.storeId as string,
    label: (data.label as string) ?? "",
    prefix: (data.prefix as string) ?? "",
    scopes: ((data.scopes as string[]) ?? []).filter((s): s is ApiTokenScope =>
      (API_TOKEN_SCOPES as readonly string[]).includes(s),
    ),
    createdBy: (data.createdBy as string) ?? "",
    createdAtMs: ms(data.createdAt),
    lastUsedAtMs: ms(data.lastUsedAt),
    revokedAtMs: ms(data.revokedAt),
  };
}

export class ApiTokenError extends Error {
  constructor(
    message: string,
    public readonly status: 400 | 409,
  ) {
    super(message);
  }
}

export function normaliseScopes(raw: unknown): ApiTokenScope[] | null {
  if (!Array.isArray(raw) || raw.length === 0) return null;
  const scopes = new Set<ApiTokenScope>();
  for (const s of raw) {
    if (typeof s !== "string" || !(API_TOKEN_SCOPES as readonly string[]).includes(s)) {
      return null;
    }
    scopes.add(s as ApiTokenScope);
  }
  return [...scopes];
}

// Returns the token's plaintext exactly once, beside its record.
export async function createApiToken(
  storeId: string,
  createdBy: string,
  input: { label: string; scopes: ApiTokenScope[] },
): Promise<{ token: string; record: ApiToken }> {
  const label = input.label.trim();
  if (label === "" || label.length > MAX_LABEL_LENGTH) {
    throw new ApiTokenError(`label must be 1–${MAX_LABEL_LENGTH} characters`, 400);
  }
  const live = await listApiTokens(storeId);
  if (live.length >= MAX_TOKENS_PER_STORE) {
    throw new ApiTokenError(
      `A store can hold at most ${MAX_TOKENS_PER_STORE} active tokens — revoke one first`,
      409,
    );
  }
  const token = TOKEN_PREFIX + randomBytes(TOKEN_RANDOM_BYTES).toString("base64url");
  const prefix = token.slice(0, TOKEN_PREFIX.length + 4);
  const ref = tokensRef().doc(hashToken(token));
  await ref.set({
    storeId,
    label,
    prefix,
    scopes: input.scopes,
    createdBy,
    createdAt: FieldValue.serverTimestamp(),
    lastUsedAt: null,
    revokedAt: null,
  });
  const snap = await ref.get();
  return { token, record: toApiToken(snap.id, snap.data()!) };
}

// Active tokens only — a revoked one is kept (its hash must keep refusing,
// and the audit trail is worth the doc) but is nobody's business to list.
export async function listApiTokens(storeId: string): Promise<ApiToken[]> {
  // Revoked ones are dropped here rather than in the query: a second
  // equality filter would need a composite index for a list that is at most
  // MAX_TOKENS_PER_STORE long.
  const snap = await tokensRef().where("storeId", "==", storeId).get();
  return snap.docs
    .map((d) => toApiToken(d.id, d.data()))
    .filter((t) => t.revokedAtMs === 0)
    .sort((a, b) => b.createdAtMs - a.createdAtMs);
}

// Revocation is a mark, not a delete: a deleted hash could be re-minted by
// chance (it can't, at 240 bits — but a mark also keeps who-revoked-when).
export async function revokeApiToken(
  storeId: string,
  tokenId: string,
): Promise<boolean> {
  const ref = tokensRef().doc(tokenId);
  const snap = await ref.get();
  if (!snap.exists || snap.data()!.storeId !== storeId) return false;
  if (snap.data()!.revokedAt) return true;
  await ref.update({ revokedAt: FieldValue.serverTimestamp() });
  return true;
}

// Only ever called with a bearer that isApiToken() — the guard routes
// Firebase ID tokens elsewhere. `lastUsedAt` is stamped at most once a
// minute so a busy sync doesn't turn every request into a write.
const LAST_USED_STAMP_INTERVAL_MS = 60_000;

export async function verifyApiToken(
  bearer: string,
): Promise<ApiToken | null> {
  const ref = tokensRef().doc(hashToken(bearer));
  const snap = await ref.get();
  if (!snap.exists) return null;
  const record = toApiToken(snap.id, snap.data()!);
  if (record.revokedAtMs > 0) return null;
  if (Date.now() - record.lastUsedAtMs > LAST_USED_STAMP_INTERVAL_MS) {
    // Fire-and-forget — a failed stamp must not fail the request.
    void ref.update({ lastUsedAt: FieldValue.serverTimestamp() }).catch(() => {});
  }
  return record;
}

export function serializeApiToken(t: ApiToken) {
  return {
    id: t.id,
    label: t.label,
    prefix: t.prefix,
    scopes: t.scopes,
    created_at: t.createdAtMs ? new Date(t.createdAtMs).toISOString() : "",
    last_used_at: t.lastUsedAtMs ? new Date(t.lastUsedAtMs).toISOString() : "",
  };
}
