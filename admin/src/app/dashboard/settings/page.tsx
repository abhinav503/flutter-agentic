"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { toast } from "sonner";

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
          Connect your Razorpay account. Payments for your store settle
          directly into this account.
        </p>
      </div>

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
    </div>
  );
}
