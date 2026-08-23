"use client";

import { useCallback, useEffect, useState } from "react";
import { Copy, KeyRound } from "lucide-react";
import { toast } from "sonner";
import { useAuth } from "@/lib/auth-context";
import {
  API_TOKEN_SCOPES,
  API_TOKEN_SCOPE_LABELS,
  type ApiTokenScope,
} from "@/lib/api-token-scopes";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";

// The wire shape of GET /api/v1/stores/{id}/tokens (serializeApiToken).
type TokenRow = {
  id: string;
  label: string;
  prefix: string;
  scopes: ApiTokenScope[];
  created_at: string;
  last_used_at: string;
};

// Settings → Developers: the store's API tokens. A token is shown in full
// exactly once, in the dialog that created it — after that only its prefix
// exists anywhere, so the list can't leak what the server never kept.
export function DeveloperSettings({ storeId }: { storeId: string }) {
  const { user } = useAuth();
  const [tokens, setTokens] = useState<TokenRow[] | null>(null);
  const [creating, setCreating] = useState(false);
  const [revoking, setRevoking] = useState<TokenRow | null>(null);
  const [minted, setMinted] = useState<{ token: string; label: string } | null>(null);

  const load = useCallback(async () => {
    if (!user) return;
    const idToken = await user.getIdToken();
    const res = await fetch(`/api/v1/stores/${storeId}/tokens`, {
      headers: { Authorization: `Bearer ${idToken}` },
    });
    const rows = res.ok
      ? ((await res.json()) as { tokens: TokenRow[] }).tokens
      : [];
    return rows;
  }, [user, storeId]);

  useEffect(() => {
    let active = true;
    load().then((rows) => {
      if (active && rows) setTokens(rows);
    });
    return () => {
      active = false;
    };
  }, [load]);

  const reload = useCallback(async () => {
    const rows = await load();
    if (rows) setTokens(rows);
  }, [load]);

  async function revoke(row: TokenRow) {
    if (!user) return;
    const idToken = await user.getIdToken();
    const res = await fetch(`/api/v1/stores/${storeId}/tokens/${row.id}`, {
      method: "DELETE",
      headers: { Authorization: `Bearer ${idToken}` },
    });
    if (res.ok || res.status === 404) {
      toast.success(`Revoked "${row.label}"`);
      await reload();
    } else {
      toast.error("Could not revoke the token");
    }
    setRevoking(null);
  }

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <KeyRound className="size-4" /> API tokens
          </CardTitle>
          <CardDescription>
            Let a script, CI job, coding agent or the Cordelia CLI act on this
            store without your login. Each token is bound to this store and to
            the scopes you pick; revoke it here the moment it leaks. Send it as{" "}
            <code className="rounded bg-muted px-1">Authorization: Bearer cord_live_…</code>.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {tokens === null ? (
            <p className="text-sm text-muted-foreground">Loading…</p>
          ) : tokens.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              No tokens yet. Create one to use the API or the CLI.
            </p>
          ) : (
            <ul className="divide-y divide-border rounded-md border border-border">
              {tokens.map((row) => (
                <li key={row.id} className="flex items-center gap-4 p-3">
                  <div className="min-w-0 flex-1">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-medium">{row.label}</span>
                      <code className="text-xs text-muted-foreground">{row.prefix}…</code>
                    </div>
                    <div className="mt-1 flex flex-wrap gap-1">
                      {row.scopes.map((s) => (
                        <Badge key={s} variant="secondary">
                          {s}
                        </Badge>
                      ))}
                    </div>
                    <p className="mt-1 text-xs text-muted-foreground">
                      Created {row.created_at ? new Date(row.created_at).toLocaleDateString() : "—"}
                      {" · "}
                      {row.last_used_at
                        ? `Last used ${new Date(row.last_used_at).toLocaleString()}`
                        : "Never used"}
                    </p>
                  </div>
                  <Button
                    variant="ghost"
                    size="sm"
                    className="text-destructive"
                    onClick={() => setRevoking(row)}
                  >
                    Revoke
                  </Button>
                </li>
              ))}
            </ul>
          )}
          <Button onClick={() => setCreating(true)}>Create token</Button>
        </CardContent>
      </Card>

      {creating && (
        <CreateTokenDialog
          storeId={storeId}
          onClose={() => setCreating(false)}
          onCreated={async (token, label) => {
            setCreating(false);
            setMinted({ token, label });
            await reload();
          }}
        />
      )}

      {minted && (
        <Dialog open onOpenChange={(open) => !open && setMinted(null)}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Copy your token now</DialogTitle>
              <DialogDescription>
                This is the only time &ldquo;{minted.label}&rdquo; is shown in
                full. Store it somewhere safe — if you lose it, revoke it and
                create another.
              </DialogDescription>
            </DialogHeader>
            <div className="flex items-center gap-2">
              <Input readOnly value={minted.token} className="font-mono text-xs" />
              <Button
                variant="outline"
                size="icon"
                aria-label="Copy token"
                onClick={async () => {
                  await navigator.clipboard.writeText(minted.token);
                  toast.success("Token copied");
                }}
              >
                <Copy className="size-4" />
              </Button>
            </div>
            <DialogFooter>
              <Button onClick={() => setMinted(null)}>I&apos;ve saved it</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      <AlertDialog open={!!revoking} onOpenChange={(open) => !open && setRevoking(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Revoke &quot;{revoking?.label}&quot;?</AlertDialogTitle>
            <AlertDialogDescription>
              Anything using this token stops working immediately. This
              can&apos;t be undone — create a new token instead.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => revoking && revoke(revoking)}
            >
              Revoke
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

function CreateTokenDialog({
  storeId,
  onClose,
  onCreated,
}: {
  storeId: string;
  onClose: () => void;
  onCreated: (token: string, label: string) => void;
}) {
  const { user } = useAuth();
  const [label, setLabel] = useState("");
  const [scopes, setScopes] = useState<ApiTokenScope[]>(["catalog:write"]);
  const [submitting, setSubmitting] = useState(false);

  function toggle(scope: ApiTokenScope) {
    setScopes((prev) =>
      prev.includes(scope) ? prev.filter((s) => s !== scope) : [...prev, scope],
    );
  }

  async function submit() {
    if (!user) return;
    setSubmitting(true);
    try {
      const idToken = await user.getIdToken();
      const res = await fetch(`/api/v1/stores/${storeId}/tokens`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${idToken}`,
        },
        body: JSON.stringify({ label, scopes }),
      });
      const payload = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(payload.error ?? "Could not create the token");
      onCreated(payload.token as string, label.trim());
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not create the token");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open onOpenChange={(open) => !open && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Create API token</DialogTitle>
          <DialogDescription>
            Name it for where it will live, and grant only what that needs.
          </DialogDescription>
        </DialogHeader>
        <div className="flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="token-label">Label</Label>
            <Input
              id="token-label"
              value={label}
              onChange={(e) => setLabel(e.target.value)}
              placeholder="e.g. Shopify sync on CI, Claude Code on my laptop"
              maxLength={60}
              autoFocus
            />
          </div>
          <div className="flex flex-col gap-2">
            <Label>Scopes</Label>
            {API_TOKEN_SCOPES.map((scope) => (
              <label key={scope} className="flex items-start gap-2 text-sm">
                <Checkbox
                  checked={scopes.includes(scope)}
                  onCheckedChange={() => toggle(scope)}
                  className="mt-0.5"
                />
                <span>
                  <code className="text-xs">{scope}</code>
                  <span className="block text-xs text-muted-foreground">
                    {API_TOKEN_SCOPE_LABELS[scope]}
                  </span>
                </span>
              </label>
            ))}
          </div>
        </div>
        <DialogFooter>
          <Button
            onClick={submit}
            disabled={submitting || label.trim() === "" || scopes.length === 0}
          >
            {submitting ? "Creating…" : "Create token"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
