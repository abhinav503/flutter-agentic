"use client";

import { useEffect, useState } from "react";
import { ShieldCheck } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import {
  API_TOKEN_SCOPE_LABELS,
  type ApiTokenScope,
} from "@/lib/api-token-scopes";
import { AuthDialogProvider, useAuthDialog } from "@/components/auth-dialog";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

// The OAuth consent screen an MCP host (claude.ai, Claude Code, Cursor,
// ChatGPT) sends an owner to. Signs them in with the console's own login,
// shows who is asking and for what, lets them pick which of their stores
// the connection may manage, and hands the decision to the server, which
// answers with where to send the browser next. Nothing here can mint a
// token: the server checks the ID token and the store ownership again.

type Pending = {
  client_name: string;
  scopes: ApiTokenScope[];
  redirect_host: string;
  known_host: boolean;
};

export default function OAuthAuthorizePage() {
  return (
    <AuthDialogProvider stayOnPage>
      <Consent />
    </AuthDialogProvider>
  );
}

function Consent() {
  const { user, loading: authLoading, signOutUser } = useAuth();
  const { stores, loading: storesLoading } = useStore();
  const openAuth = useAuthDialog();
  // The host's query is the whole request; it goes back to the server
  // verbatim with the decision, so nothing is re-encoded on the way.
  const [query] = useState(() =>
    typeof window === "undefined" ? "" : window.location.search.replace(/^\?/, ""),
  );
  const [pending, setPending] = useState<Pending | null>(null);
  const [error, setError] = useState<string | null>(null);
  // Stores the owner has unticked — default is every store the account
  // owns, so the list is derived rather than copied into state.
  const [excluded, setExcluded] = useState<string[]>([]);
  const selected = stores.map((s) => s.id).filter((id) => !excluded.includes(id));
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    let active = true;
    fetch(`/api/oauth/authorize?${query}`)
      .then(async (res) => {
        const body = await res.json();
        if (!res.ok) throw new Error(body.error_description ?? "Invalid authorization request");
        if (active) setPending(body as Pending);
      })
      .catch((e: Error) => {
        if (active) setError(e.message);
      });
    return () => {
      active = false;
    };
  }, [query]);

  async function decide(decision: "allow" | "deny") {
    if (!user) return;
    setSubmitting(true);
    try {
      const res = await fetch("/api/oauth/authorize", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          query,
          decision,
          id_token: await user.getIdToken(),
          store_ids: selected,
        }),
      });
      const body = await res.json();
      if (!res.ok) throw new Error(body.error_description ?? "Could not complete authorization");
      window.location.assign(body.redirect as string);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Could not complete authorization");
      setSubmitting(false);
    }
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-muted/30 p-4">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <ShieldCheck className="size-5" />
            {pending ? `Connect ${pending.client_name} to CordeliaApps` : "Connect to CordeliaApps"}
          </CardTitle>
          <CardDescription>
            {pending
              ? `${pending.client_name} wants to manage your store on your behalf. You can disconnect it any time from Settings → Developers.`
              : "Checking the request…"}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-5">
          {error && <p className="text-sm text-destructive">{error}</p>}

          {pending && !error && (
            <>
              {/* Who actually receives the grant. A client may call itself
                  anything; the redirect host is the part it can't fake. */}
              <p
                className={`rounded-md border px-3 py-2 text-xs ${
                  pending.known_host
                    ? "border-border text-muted-foreground"
                    : "border-destructive/40 bg-destructive/5 text-destructive"
                }`}
              >
                {pending.known_host ? "After you allow, you'll return to " : "Careful — this request will send your access to an unrecognised site: "}
                <code className="font-semibold">{pending.redirect_host}</code>
                {pending.known_host ? "." : ". Only continue if you started this from that site."}
              </p>
              <div>
                <p className="mb-2 text-sm font-medium">It will be able to</p>
                <ul className="list-disc space-y-1 pl-5 text-sm text-muted-foreground">
                  {pending.scopes.map((s) => (
                    <li key={s}>{API_TOKEN_SCOPE_LABELS[s]}</li>
                  ))}
                </ul>
              </div>

              {authLoading ? (
                <p className="text-sm text-muted-foreground">Loading…</p>
              ) : !user ? (
                <div className="space-y-3">
                  <p className="text-sm">Sign in to the account that owns the store.</p>
                  <div className="flex gap-2">
                    <Button onClick={() => openAuth("login")}>Sign in</Button>
                    <Button variant="outline" onClick={() => openAuth("signup")}>
                      Create account
                    </Button>
                  </div>
                </div>
              ) : (
                <>
                  <div>
                    <p className="mb-2 text-sm font-medium">For these stores</p>
                    {storesLoading ? (
                      <p className="text-sm text-muted-foreground">Loading your stores…</p>
                    ) : stores.length === 0 ? (
                      <p className="text-sm text-muted-foreground">
                        This account owns no stores yet. Create one in the console first.
                      </p>
                    ) : (
                      <ul className="space-y-2">
                        {stores.map((s) => (
                          <li key={s.id}>
                            <label className="flex items-center gap-2 text-sm">
                              <Checkbox
                                checked={selected.includes(s.id)}
                                onCheckedChange={(checked) =>
                                  setExcluded((prev) =>
                                    checked === true
                                      ? prev.filter((id) => id !== s.id)
                                      : [...new Set([...prev, s.id])],
                                  )
                                }
                              />
                              {s.name}
                            </label>
                          </li>
                        ))}
                      </ul>
                    )}
                  </div>
                  <p className="text-xs text-muted-foreground">
                    Signed in as {user.email}.{" "}
                    {/* An agency laptop is often signed into a client's
                        account; switching here beats finding the console's
                        sign-out first. The page stays put — the host's request
                        is still in the URL. */}
                    <button
                      type="button"
                      className="underline underline-offset-2 hover:text-foreground"
                      onClick={() => {
                        setExcluded([]);
                        void signOutUser();
                      }}
                    >
                      Not you? Sign out
                    </button>
                  </p>
                  <div className="flex justify-end gap-2">
                    <Button variant="ghost" onClick={() => decide("deny")} disabled={submitting}>
                      Cancel
                    </Button>
                    <Button
                      onClick={() => decide("allow")}
                      disabled={submitting || selected.length === 0}
                    >
                      {submitting ? "Connecting…" : "Allow"}
                    </Button>
                  </div>
                </>
              )}
            </>
          )}
        </CardContent>
      </Card>
    </main>
  );
}
