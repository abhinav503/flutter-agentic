import { createHash, randomBytes } from "node:crypto";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { adminAuth, adminDb } from "./firebase-admin";
import { API_TOKEN_SCOPES, type ApiTokenScope } from "./api-token-scopes";

// The OAuth 2.1 authorization server an MCP host (claude.ai's custom
// connectors, Claude Code, Cursor, ChatGPT) talks to before it may call
// /api/mcp on an owner's behalf. Authorization-code + PKCE, dynamic client
// registration, public clients only — exactly what the MCP auth spec asks
// for and nothing more.
//
// Identity comes from the console's own Firebase login: the consent page
// signs the owner in, lists the stores their `storeIds` claim grants, and
// posts their ID token here. What we mint is our own: an opaque
// `cord_oauth_` access token (short-lived) and a rotating refresh token,
// both stored hashed in `oauthTokens` the way API tokens are, so the guard
// resolves either kind with one lookup and a leaked token is one revoke.

export const OAUTH_ACCESS_PREFIX = "cord_oauth_";
const REFRESH_PREFIX = "cord_refresh_";
const CODE_TTL_MS = 10 * 60 * 1000;
const ACCESS_TTL_MS = 60 * 60 * 1000;
const REFRESH_TTL_MS = 30 * 24 * 60 * 60 * 1000;
const MAX_REDIRECT_URIS = 10;

export class OAuthError extends Error {
  constructor(
    public readonly code:
      | "invalid_request"
      | "invalid_client"
      | "invalid_grant"
      | "unsupported_grant_type"
      | "invalid_scope"
      | "access_denied",
    message: string,
    public readonly status: 400 | 401 = 400,
  ) {
    super(message);
  }
}

const hash = (s: string) => createHash("sha256").update(s).digest("hex");
const token = (prefix: string) => prefix + randomBytes(30).toString("base64url");
const ms = (v: unknown) => (v instanceof Timestamp ? v.toMillis() : 0);

export function isOAuthAccessToken(bearer: string): boolean {
  return bearer.startsWith(OAUTH_ACCESS_PREFIX);
}

// --- clients ----------------------------------------------------------------

export type OAuthClient = {
  clientId: string;
  clientName: string;
  redirectUris: string[];
};

// A redirect may only go to https, or to localhost over http (a desktop host
// completing the flow on a loopback port). Custom schemes are refused — a
// registered `claude://` is not verifiable the way a URL is.
function isAllowedRedirect(uri: string): boolean {
  try {
    const u = new URL(uri);
    if (u.protocol === "https:") return true;
    return u.protocol === "http:" && (u.hostname === "localhost" || u.hostname === "127.0.0.1");
  } catch {
    return false;
  }
}

export async function registerClient(body: Record<string, unknown>): Promise<OAuthClient> {
  const uris = Array.isArray(body.redirect_uris) ? body.redirect_uris.map(String) : [];
  if (uris.length === 0 || uris.length > MAX_REDIRECT_URIS || !uris.every(isAllowedRedirect)) {
    throw new OAuthError("invalid_request", "redirect_uris must be 1–10 https (or localhost http) URLs");
  }
  const auth = body.token_endpoint_auth_method;
  if (auth !== undefined && auth !== "none") {
    throw new OAuthError("invalid_request", "Only public clients (token_endpoint_auth_method: none) are supported");
  }
  const clientId = "cc_" + randomBytes(16).toString("base64url");
  const client: OAuthClient = {
    clientId,
    clientName: String(body.client_name ?? "").slice(0, 100) || "MCP client",
    redirectUris: uris,
  };
  await adminDb.collection("oauthClients").doc(clientId).set({
    ...client,
    createdAt: FieldValue.serverTimestamp(),
  });
  return client;
}

export async function getClient(clientId: string): Promise<OAuthClient | null> {
  const snap = await adminDb.collection("oauthClients").doc(clientId).get();
  if (!snap.exists) return null;
  const d = snap.data()!;
  return { clientId, clientName: d.clientName as string, redirectUris: d.redirectUris as string[] };
}

// --- scopes ------------------------------------------------------------------

// A request with no scope gets everything a store owner can delegate; one
// that names scopes gets exactly those. Unknown scopes are refused rather
// than ignored, so a host can't believe it holds something it doesn't.
export function parseScopes(raw: string | null | undefined): ApiTokenScope[] {
  if (!raw || !raw.trim()) return [...API_TOKEN_SCOPES];
  const scopes: ApiTokenScope[] = [];
  for (const s of raw.split(/\s+/).filter(Boolean)) {
    if (!(API_TOKEN_SCOPES as readonly string[]).includes(s)) {
      throw new OAuthError("invalid_scope", `Unknown scope ${s}`);
    }
    scopes.push(s as ApiTokenScope);
  }
  return [...new Set(scopes)];
}

// --- authorization codes ------------------------------------------------------

export type AuthorizeRequest = {
  clientId: string;
  redirectUri: string;
  codeChallenge: string;
  scopes: ApiTokenScope[];
  state: string;
};

// Validates the query an MCP host sent the consent page with. Errors here
// must NOT redirect (the redirect_uri itself may be the problem) — the
// page shows them.
export async function validateAuthorizeRequest(q: URLSearchParams): Promise<AuthorizeRequest & { client: OAuthClient }> {
  if (q.get("response_type") !== "code") {
    throw new OAuthError("invalid_request", "response_type must be code");
  }
  const clientId = q.get("client_id") ?? "";
  const client = await getClient(clientId);
  if (!client) throw new OAuthError("invalid_client", "Unknown client_id — register first", 401);
  const redirectUri = q.get("redirect_uri") ?? "";
  if (!client.redirectUris.includes(redirectUri)) {
    throw new OAuthError("invalid_request", "redirect_uri is not one this client registered");
  }
  if (q.get("code_challenge_method") !== "S256") {
    throw new OAuthError("invalid_request", "code_challenge_method must be S256");
  }
  const codeChallenge = q.get("code_challenge") ?? "";
  if (!/^[A-Za-z0-9_-]{43,128}$/.test(codeChallenge)) {
    throw new OAuthError("invalid_request", "code_challenge is missing or malformed");
  }
  return {
    client,
    clientId,
    redirectUri,
    codeChallenge,
    scopes: parseScopes(q.get("scope")),
    state: q.get("state") ?? "",
  };
}

// The owner said yes. Their Firebase ID token proves who, and its storeIds
// claim is what the grant covers — snapshotted now, so a store added to
// the account later needs a fresh consent.
export async function issueAuthorizationCode(
  req: AuthorizeRequest,
  idToken: string,
  storeIds: string[],
): Promise<string> {
  let decoded;
  try {
    decoded = await adminAuth.verifyIdToken(idToken);
  } catch {
    throw new OAuthError("access_denied", "Sign in again to continue", 401);
  }
  const owned = ((decoded.storeIds as string[] | undefined) ?? []);
  const granted = storeIds.filter((id) => owned.includes(id));
  if (granted.length === 0) {
    throw new OAuthError("access_denied", "Pick at least one store you own");
  }
  const code = token("cord_code_");
  await adminDb.collection("oauthCodes").doc(hash(code)).set({
    clientId: req.clientId,
    redirectUri: req.redirectUri,
    codeChallenge: req.codeChallenge,
    scopes: req.scopes,
    uid: decoded.uid,
    email: decoded.email ?? "",
    storeIds: granted,
    expiresAt: Timestamp.fromMillis(Date.now() + CODE_TTL_MS),
    usedAt: null,
  });
  return code;
}

// --- tokens --------------------------------------------------------------------

export type OAuthGrant = {
  tokenId: string;
  uid: string;
  email: string;
  clientId: string;
  storeIds: string[];
  scopes: ApiTokenScope[];
};

type TokenResponse = {
  access_token: string;
  token_type: "Bearer";
  expires_in: number;
  refresh_token: string;
  scope: string;
};

async function mintTokens(grant: Omit<OAuthGrant, "tokenId">): Promise<TokenResponse> {
  const access = token(OAUTH_ACCESS_PREFIX);
  const refresh = token(REFRESH_PREFIX);
  const now = Date.now();
  const batch = adminDb.batch();
  const base = {
    uid: grant.uid,
    email: grant.email,
    clientId: grant.clientId,
    storeIds: grant.storeIds,
    scopes: grant.scopes,
    createdAt: FieldValue.serverTimestamp(),
    lastUsedAt: null,
    revokedAt: null,
  };
  batch.set(adminDb.collection("oauthTokens").doc(hash(access)), {
    ...base,
    kind: "access",
    expiresAt: Timestamp.fromMillis(now + ACCESS_TTL_MS),
  });
  batch.set(adminDb.collection("oauthTokens").doc(hash(refresh)), {
    ...base,
    kind: "refresh",
    expiresAt: Timestamp.fromMillis(now + REFRESH_TTL_MS),
  });
  await batch.commit();
  return {
    access_token: access,
    token_type: "Bearer",
    expires_in: ACCESS_TTL_MS / 1000,
    refresh_token: refresh,
    scope: grant.scopes.join(" "),
  };
}

export async function exchangeCode(form: URLSearchParams): Promise<TokenResponse> {
  const code = form.get("code") ?? "";
  const verifier = form.get("code_verifier") ?? "";
  const clientId = form.get("client_id") ?? "";
  const redirectUri = form.get("redirect_uri") ?? "";
  if (!code || !verifier || !clientId) {
    throw new OAuthError("invalid_request", "code, code_verifier and client_id are required");
  }
  const ref = adminDb.collection("oauthCodes").doc(hash(code));
  // A code is single-use: claim it inside a transaction so two exchanges
  // racing on the same code can't both succeed.
  const grant = await adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new OAuthError("invalid_grant", "Unknown or expired code");
    const d = snap.data()!;
    if (d.usedAt || ms(d.expiresAt) < Date.now()) {
      throw new OAuthError("invalid_grant", "Unknown or expired code");
    }
    if (d.clientId !== clientId) throw new OAuthError("invalid_grant", "Code was issued to another client");
    if (redirectUri && d.redirectUri !== redirectUri) {
      throw new OAuthError("invalid_grant", "redirect_uri does not match");
    }
    const expected = createHash("sha256").update(verifier).digest("base64url");
    if (expected !== d.codeChallenge) throw new OAuthError("invalid_grant", "PKCE verification failed");
    tx.update(ref, { usedAt: FieldValue.serverTimestamp() });
    return {
      uid: d.uid as string,
      email: (d.email as string) ?? "",
      clientId,
      storeIds: d.storeIds as string[],
      scopes: d.scopes as ApiTokenScope[],
    };
  });
  return mintTokens(grant);
}

// Refresh tokens rotate: the old one is revoked as the new pair is minted,
// so a stolen refresh token stops working the moment the legitimate host
// refreshes (or vice versa — either way, one of them gets a visible error).
export async function refreshTokens(form: URLSearchParams): Promise<TokenResponse> {
  const refresh = form.get("refresh_token") ?? "";
  const clientId = form.get("client_id") ?? "";
  if (!refresh.startsWith(REFRESH_PREFIX)) throw new OAuthError("invalid_grant", "Invalid refresh token");
  const ref = adminDb.collection("oauthTokens").doc(hash(refresh));
  const grant = await adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new OAuthError("invalid_grant", "Unknown refresh token");
    const d = snap.data()!;
    if (d.kind !== "refresh" || d.revokedAt || ms(d.expiresAt) < Date.now()) {
      throw new OAuthError("invalid_grant", "Refresh token expired or revoked");
    }
    if (clientId && d.clientId !== clientId) throw new OAuthError("invalid_grant", "Wrong client");
    tx.update(ref, { revokedAt: FieldValue.serverTimestamp() });
    return {
      uid: d.uid as string,
      email: (d.email as string) ?? "",
      clientId: d.clientId as string,
      storeIds: d.storeIds as string[],
      scopes: d.scopes as ApiTokenScope[],
    };
  });
  return mintTokens(grant);
}

const LAST_USED_STAMP_INTERVAL_MS = 60_000;

export async function verifyOAuthAccessToken(bearer: string): Promise<OAuthGrant | null> {
  const ref = adminDb.collection("oauthTokens").doc(hash(bearer));
  const snap = await ref.get();
  if (!snap.exists) return null;
  const d = snap.data()!;
  if (d.kind !== "access" || d.revokedAt || ms(d.expiresAt) < Date.now()) return null;
  if (Date.now() - ms(d.lastUsedAt) > LAST_USED_STAMP_INTERVAL_MS) {
    void ref.update({ lastUsedAt: FieldValue.serverTimestamp() }).catch(() => {});
  }
  return {
    tokenId: snap.id,
    uid: d.uid as string,
    email: (d.email as string) ?? "",
    clientId: d.clientId as string,
    storeIds: (d.storeIds as string[]) ?? [],
    scopes: (d.scopes as ApiTokenScope[]) ?? [],
  };
}

// Every token a client holds for this owner — what "Disconnect" in the
// console revokes in one go.
export async function revokeGrantsFor(uid: string, clientId?: string): Promise<number> {
  let q = adminDb.collection("oauthTokens").where("uid", "==", uid);
  if (clientId) q = q.where("clientId", "==", clientId);
  const snap = await q.get();
  const batch = adminDb.batch();
  let n = 0;
  for (const d of snap.docs) {
    if (!d.data().revokedAt) {
      batch.update(d.ref, { revokedAt: FieldValue.serverTimestamp() });
      n++;
    }
  }
  if (n) await batch.commit();
  return n;
}

// The apps an owner has connected — one row per client, from the live
// tokens it holds — for the console's "Connected apps" list.
export type ConnectedApp = {
  clientId: string;
  clientName: string;
  scopes: ApiTokenScope[];
  storeIds: string[];
  connectedAtMs: number;
  lastUsedAtMs: number;
};

export async function listConnectedApps(uid: string): Promise<ConnectedApp[]> {
  const snap = await adminDb.collection("oauthTokens").where("uid", "==", uid).get();
  const byClient = new Map<string, ConnectedApp>();
  for (const d of snap.docs) {
    const t = d.data();
    if (t.revokedAt || ms(t.expiresAt) < Date.now()) continue;
    const clientId = t.clientId as string;
    const row = byClient.get(clientId) ?? {
      clientId,
      clientName: "",
      scopes: (t.scopes as ApiTokenScope[]) ?? [],
      storeIds: (t.storeIds as string[]) ?? [],
      connectedAtMs: ms(t.createdAt),
      lastUsedAtMs: 0,
    };
    row.connectedAtMs = Math.min(row.connectedAtMs || ms(t.createdAt), ms(t.createdAt));
    row.lastUsedAtMs = Math.max(row.lastUsedAtMs, ms(t.lastUsedAt));
    byClient.set(clientId, row);
  }
  await Promise.all(
    [...byClient.values()].map(async (row) => {
      row.clientName = (await getClient(row.clientId))?.clientName ?? "Unknown app";
    }),
  );
  return [...byClient.values()].sort((a, b) => b.connectedAtMs - a.connectedAtMs);
}
