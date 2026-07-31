"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { getStore } from "@/lib/stores";
import { getTemplates } from "@/lib/templates";
import type { Template } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ImageUploadField } from "@/components/image-upload-field";
import { toast } from "sonner";

// The store's public face in CordeliaApps discovery + which storefront
// template renders it. Reads prefill via the world-readable store doc;
// saves through PUT /api/stores/{storeId} so templateId stays validated
// server-side against the seeded templates collection.
function StoreProfileCard({ storeId }: { storeId: string }) {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [templates, setTemplates] = useState<Template[]>([]);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [logoUrl, setLogoUrl] = useState("");
  const [keywords, setKeywords] = useState("");
  const [templateId, setTemplateId] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    let active = true;
    Promise.all([getStore(storeId), getTemplates()])
      .then(([store, fetchedTemplates]) => {
        if (!active) return;
        setTemplates(fetchedTemplates);
        if (store) {
          setName(store.name);
          setDescription(store.description);
          setLogoUrl(store.logoUrl);
          setKeywords(store.searchKeywords.join(", "));
          setTemplateId(store.templateId);
        }
        setLoading(false);
      })
      .catch(() => {
        if (active) setLoading(false);
        toast.error("Could not load store profile");
      });
    return () => {
      active = false;
    };
  }, [storeId]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!user) return;
    setSaving(true);
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          name: name.trim(),
          description: description.trim(),
          logoUrl: logoUrl.trim(),
          searchKeywords: keywords
            .split(",")
            .map((k) => k.trim())
            .filter(Boolean),
          templateId,
        }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(body.error ?? "Could not save store profile");
      }
      toast.success("Store profile saved");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSaving(false);
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Store profile</CardTitle>
        <CardDescription>
          What shoppers see in CordeliaApps discovery, and which template your
          storefront opens with.
        </CardDescription>
      </CardHeader>
      <CardContent>
        {loading ? (
          <p className="text-sm text-muted-foreground">Loading…</p>
        ) : (
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="store-profile-name">Store name</Label>
              <Input
                id="store-profile-name"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="store-profile-description">Description</Label>
              <Textarea
                id="store-profile-description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder="A short line shoppers see under your store name"
              />
            </div>
            <ImageUploadField
              id="store-profile-logo"
              label="Logo"
              storeId={storeId}
              kind="store"
              value={logoUrl}
              onChange={setLogoUrl}
            />
            <div className="flex flex-col gap-2">
              <Label htmlFor="store-profile-keywords">Search keywords</Label>
              <Input
                id="store-profile-keywords"
                value={keywords}
                onChange={(e) => setKeywords(e.target.value)}
                placeholder="grocery, fresh, daily essentials"
              />
              <p className="text-xs text-muted-foreground">
                Comma-separated. Discovery search matches these along with your
                store name.
              </p>
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="store-profile-template">Template</Label>
              <Select value={templateId} onValueChange={setTemplateId}>
                <SelectTrigger id="store-profile-template" className="w-full">
                  <SelectValue placeholder="Choose a template" />
                </SelectTrigger>
                <SelectContent>
                  {templates.map((t) => (
                    <SelectItem key={t.id} value={t.id}>
                      {t.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <p className="text-xs text-muted-foreground">
                Changes your storefront&apos;s look the next time shoppers open
                your store.
              </p>
            </div>
            <Button
              type="submit"
              disabled={saving || !name.trim() || !templateId}
              className="self-start"
            >
              {saving ? "Saving…" : "Save profile"}
            </Button>
          </form>
        )}
      </CardContent>
    </Card>
  );
}

type PaymentStatus = {
  configured: boolean;
  keyId: string | null;
  isTest: boolean;
  webhookConfigured: boolean;
};

export default function SettingsPage() {
  const { user } = useAuth();
  const { storeId } = useStore();
  const [status, setStatus] = useState<PaymentStatus | null>(null);
  const [loading, setLoading] = useState(true);
  const [keyId, setKeyId] = useState("");
  const [keySecret, setKeySecret] = useState("");
  const [saving, setSaving] = useState(false);
  const [webhookSecret, setWebhookSecret] = useState("");
  const [savingWebhook, setSavingWebhook] = useState(false);

  const webhookUrl =
    typeof window !== "undefined" && storeId
      ? `${window.location.origin}/api/stores/${storeId}/webhooks/razorpay`
      : "";

  useEffect(() => {
    if (!user || !storeId) return;
    let active = true;
    (async () => {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}/payment-config`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (!active) return;
      if (res.ok) setStatus(await res.json());
      setLoading(false);
    })();
    return () => {
      active = false;
    };
  }, [user, storeId]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!user || !storeId) return;
    setSaving(true);
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}/payment-config`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ keyId: keyId.trim(), keySecret: keySecret.trim() }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(body.error ?? "Could not save payment keys");
      }
      setStatus(body);
      setKeyId("");
      setKeySecret("");
      toast.success("Payment keys saved");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSaving(false);
    }
  }

  async function handleWebhookSubmit(e: FormEvent) {
    e.preventDefault();
    if (!user || !storeId) return;
    setSavingWebhook(true);
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}/payment-config`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ webhookSecret: webhookSecret.trim() }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(body.error ?? "Could not save webhook secret");
      }
      setStatus(body);
      setWebhookSecret("");
      toast.success("Webhook secret saved");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSavingWebhook(false);
    }
  }

  if (!storeId) return null;

  return (
    <div className="flex max-w-2xl flex-col gap-6">
      <div>
        <h1 className="text-lg font-semibold">Settings</h1>
        <p className="text-sm text-muted-foreground">
          This store&apos;s public profile, storefront template, and Razorpay
          account — plus the account you sign in with.
        </p>
      </div>

      <h2 className="-mb-2 text-sm font-semibold text-muted-foreground">
        Store
      </h2>

      <StoreProfileCard storeId={storeId} />

      <Card>
        <CardHeader>
          <CardTitle className="flex flex-wrap items-center gap-2">
            Razorpay
            {!loading &&
              (status?.configured ? (
                <>
                  <Badge variant="success" className="gap-1">
                    <span className="size-1.5 rounded-full bg-white" />
                    Connected
                  </Badge>
                  <Badge variant={status.isTest ? "secondary" : "default"}>
                    {status.isTest ? "Test mode" : "Live mode"}
                  </Badge>
                </>
              ) : (
                <Badge variant="outline">Not connected</Badge>
              ))}
          </CardTitle>
          <CardDescription>
            {loading
              ? "Loading…"
              : status?.configured
                ? `Payments settle into this Razorpay account — key ${status.keyId}`
                : "Not connected yet. Paste your Razorpay Key ID and Key Secret below."}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="keyId">Key ID</Label>
              <Input
                id="keyId"
                placeholder="rzp_test_xxxxxxxxxxxxxx"
                value={keyId}
                onChange={(e) => setKeyId(e.target.value)}
                autoComplete="off"
              />
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="keySecret">Key Secret</Label>
              <Input
                id="keySecret"
                type="password"
                placeholder="Never shown again after saving"
                value={keySecret}
                onChange={(e) => setKeySecret(e.target.value)}
                autoComplete="off"
              />
              <p className="text-xs text-muted-foreground">
                Your secret is encrypted before it is stored and is never sent
                back to this page.
              </p>
            </div>
            <Button
              type="submit"
              disabled={saving || !keyId.trim() || !keySecret.trim()}
              className="self-start"
            >
              {saving ? "Saving…" : status?.configured ? "Update keys" : "Save keys"}
            </Button>
          </form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="flex flex-wrap items-center gap-2">
            Webhook
            {!loading &&
              (status?.webhookConfigured ? (
                <Badge variant="success" className="gap-1">
                  <span className="size-1.5 rounded-full bg-white" />
                  Configured
                </Badge>
              ) : (
                <Badge variant="outline">Not configured</Badge>
              ))}
          </CardTitle>
          <CardDescription>
            Lets refunds settle automatically. In your Razorpay Dashboard →
            Settings → Webhooks, add a webhook for the{" "}
            <code>refund.processed</code> and <code>refund.failed</code> events,
            then paste its secret here.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleWebhookSubmit} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <Label>Webhook URL (paste into Razorpay)</Label>
              <code className="block overflow-x-auto rounded-md bg-muted px-3 py-2 text-xs">
                {webhookUrl}
              </code>
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="webhookSecret">Webhook Secret</Label>
              <Input
                id="webhookSecret"
                type="password"
                placeholder="The secret you set on the Razorpay webhook"
                value={webhookSecret}
                onChange={(e) => setWebhookSecret(e.target.value)}
                autoComplete="off"
              />
              <p className="text-xs text-muted-foreground">
                Encrypted before storage and never sent back to this page.
                Without it, refunds still work but stay in “processing” until you
                press “Complete refund” on the order.
              </p>
            </div>
            <Button
              type="submit"
              disabled={savingWebhook || !webhookSecret.trim()}
              className="self-start"
            >
              {savingWebhook
                ? "Saving…"
                : status?.webhookConfigured
                  ? "Update webhook secret"
                  : "Save webhook secret"}
            </Button>
          </form>
        </CardContent>
      </Card>

      <h2 className="-mb-2 text-sm font-semibold text-muted-foreground">
        Account
      </h2>

      <AccountCard />
    </div>
  );
}

// The signed-in admin's own details — account-level, not per-store, which
// is why the email no longer sits under the sidebar's store name (that
// corner is the store switcher now). Read-only: email/password changes go
// through Firebase's own flows, none of which this dashboard wires yet.
function AccountCard() {
  const { user } = useAuth();
  if (!user) return null;

  return (
    <Card>
      <CardHeader>
        <CardTitle>Your account</CardTitle>
        <CardDescription>
          The sign-in behind every store you own.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <dl className="flex flex-col gap-3 text-sm">
          <div className="flex flex-col gap-0.5">
            <dt className="text-xs text-muted-foreground">Email</dt>
            <dd>{user.email}</dd>
          </div>
          <div className="flex flex-col gap-0.5">
            <dt className="text-xs text-muted-foreground">User ID</dt>
            <dd>
              <code className="rounded bg-muted px-1.5 py-0.5 text-xs">
                {user.uid}
              </code>
            </dd>
          </div>
          {user.metadata.creationTime && (
            <div className="flex flex-col gap-0.5">
              <dt className="text-xs text-muted-foreground">Member since</dt>
              <dd>
                {new Date(user.metadata.creationTime).toLocaleDateString()}
              </dd>
            </div>
          )}
        </dl>
      </CardContent>
    </Card>
  );
}
