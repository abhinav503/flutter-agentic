"use client";

import { useEffect, useState, type FormEvent } from "react";
import { Sparkles } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { PublishStoreCard } from "@/components/publish-store-card";
import { getStore } from "@/lib/stores";
import { getTemplates } from "@/lib/templates";
import { currencySymbol } from "@/lib/money";
import { postalGuidanceFor } from "@/lib/postal-examples";
import {
  STORE_CURRENCIES,
  STORE_CURRENCY_LABELS,
  STORE_LANGUAGES,
  STORE_LANGUAGE_LABELS,
  type Template,
} from "@/lib/types";
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
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/components/ui/tabs";
import { ImageUploadField } from "@/components/image-upload-field";
import { GenerateGroceryDataDialog } from "@/components/generate-grocery-data-dialog";
import { DeveloperSettings } from "@/components/developer-settings";
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
  const [address, setAddress] = useState("");
  const [logoUrl, setLogoUrl] = useState("");
  const [keywords, setKeywords] = useState("");
  const [templateId, setTemplateId] = useState("");
  const [language, setLanguage] = useState<string>("en");
  const [currency, setCurrency] = useState<string>("INR");
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
          setAddress(store.address);
          setLogoUrl(store.logoUrl);
          setKeywords(store.searchKeywords.join(", "));
          setTemplateId(store.templateId);
          setLanguage(store.language);
          setCurrency(store.currency);
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
          address: address.trim(),
          logoUrl: logoUrl.trim(),
          searchKeywords: keywords
            .split(",")
            .map((k) => k.trim())
            .filter(Boolean),
          templateId,
          language,
          currency,
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
          // Two columns once there is room for them, so a wide screen doesn't
          // leave the form as one narrow ribbon. Description, the logo and the
          // template picker span both — they read as one wide thing; Language
          // and Currency pair off, which is also how they're described.
          <form
            onSubmit={handleSubmit}
            className="grid grid-cols-1 items-start gap-4 sm:grid-cols-2"
          >
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
            <div className="flex flex-col gap-2 sm:col-span-2">
              <Label htmlFor="store-profile-description">Description</Label>
              <Textarea
                id="store-profile-description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder="A short line shoppers see under your store name"
              />
            </div>
            <div className="flex flex-col gap-2 sm:col-span-2">
              <Label htmlFor="store-profile-address">Store address</Label>
              <Textarea
                id="store-profile-address"
                required
                rows={3}
                maxLength={300}
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                placeholder={"12 Residency Road\nBengaluru, Karnataka 560025\nIndia"}
              />
              <p className="text-xs text-muted-foreground">
                Where you trade from. Required before you can publish — a
                marketplace has to say who is selling and from where. This
                doesn&apos;t decide where you deliver; that&apos;s{" "}
                <span className="font-medium">Settings → Delivery</span>.
              </p>
            </div>
            <div className="sm:col-span-2">
              <ImageUploadField
                id="store-profile-logo"
                label="Logo"
                storeId={storeId}
                kind="store"
                value={logoUrl}
                onChange={setLogoUrl}
                previewSize="lg"
              />
            </div>
            <div className="flex flex-col gap-2 sm:col-span-2">
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
            <div className="flex flex-col gap-2">
              <Label htmlFor="store-profile-language">Language</Label>
              <Select value={language} onValueChange={setLanguage}>
                <SelectTrigger id="store-profile-language" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {STORE_LANGUAGES.map((code) => (
                    <SelectItem key={code} value={code}>
                      {STORE_LANGUAGE_LABELS[code]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <p className="text-xs text-muted-foreground">
                The language your storefront&apos;s buttons and labels use, on
                every template. Shoppers can still switch languages on their
                own device from the storefront&apos;s Profile.
              </p>
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="store-profile-currency">Currency</Label>
              <Select value={currency} onValueChange={setCurrency}>
                <SelectTrigger id="store-profile-currency" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {STORE_CURRENCIES.map((code) => (
                    <SelectItem key={code} value={code}>
                      {STORE_CURRENCY_LABELS[code]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <p className="text-xs text-muted-foreground">
                What your prices are shown in. Separate from Language — a
                shopper reading your store in another language still sees this
                currency. This changes the display only; it does not convert
                the prices in your catalog.
              </p>
            </div>
            <Button
              type="submit"
              disabled={saving || !name.trim() || !templateId}
              className="justify-self-start sm:col-span-2"
            >
              {saving ? "Saving…" : "Save profile"}
            </Button>
          </form>
        )}
      </CardContent>
    </Card>
  );
}

// How a shopper reaches this store when an order goes wrong. On the Store
// tab rather than its own: this is published to shoppers exactly like the
// name and description above it, and an owner setting up a store should meet
// it while they are still thinking about what shoppers see.
//
// Nothing here is required. An owner who fills in none of it still has
// shoppers reaching the CordeliaApps address, which the app always offers
// underneath — so the cost of leaving it empty is a slower answer, not an
// unanswerable one.
function SupportCard({ storeId }: { storeId: string }) {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [hours, setHours] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    let active = true;
    getStore(storeId)
      .then((store) => {
        if (!active) return;
        if (store) {
          setEmail(store.support.email);
          setPhone(store.support.phone);
          setHours(store.support.hours);
        }
        setLoading(false);
      })
      .catch(() => {
        if (active) setLoading(false);
        toast.error("Could not load support settings");
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
        body: JSON.stringify({ support: { email, phone, hours } }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(body.error ?? "Could not save support");
      toast.success("Support contact saved");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSaving(false);
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Support contact</CardTitle>
        <CardDescription>
          How shoppers reach you about an order. Shown in the app under Help &
          Support, and offered again from any order they are tracking — with
          the order number already filled in.
        </CardDescription>
      </CardHeader>
      <CardContent>
        {loading ? (
          <p className="text-sm text-muted-foreground">Loading…</p>
        ) : (
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <div className="flex flex-col gap-2">
                <Label htmlFor="support-email">Support email</Label>
                <Input
                  id="support-email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="orders@yourstore.com"
                />
                <p className="text-xs text-muted-foreground">
                  Where order problems arrive. Leave empty and shoppers write
                  to CordeliaApps instead, who will forward them to you.
                </p>
              </div>
              <div className="flex flex-col gap-2">
                <Label htmlFor="support-phone">Support phone</Label>
                <Input
                  id="support-phone"
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="+91 98765 43210"
                />
                <p className="text-xs text-muted-foreground">
                  Dialled straight from the app, so include the country code.
                  Leave empty to offer email only.
                </p>
              </div>
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="support-hours">When you answer</Label>
              <Input
                id="support-hours"
                value={hours}
                onChange={(e) => setHours(e.target.value)}
                placeholder="Mon–Sat, 9am–7pm"
                maxLength={120}
              />
              <p className="text-xs text-muted-foreground">
                Printed to shoppers exactly as you write it, in your
                store&apos;s language — so a message sent at midnight does not
                read as one being ignored.
              </p>
            </div>
            <Button type="submit" disabled={saving} className="self-start">
              {saving ? "Saving…" : "Save support contact"}
            </Button>
          </form>
        )}
      </CardContent>
    </Card>
  );
}

// What the store charges to deliver, and where it delivers at all. Its own
// card rather than a row inside the profile: the profile is what shoppers
// read, this is what they get charged, and the areas field needs room.
//
// The server recomputes both halves when it prices a cart — nothing here is
// trusted at checkout — so this form is the policy, not the arithmetic.
function DeliveryCard({ storeId }: { storeId: string }) {
  const { user } = useAuth();
  const { storeCurrency, storeLanguage } = useStore();
  const [loading, setLoading] = useState(true);
  const [fee, setFee] = useState("0");
  const [freeAbove, setFreeAbove] = useState("0");
  const [areas, setAreas] = useState("");
  const [saving, setSaving] = useState(false);

  const symbol = currencySymbol(storeCurrency);
  // The store's own market decides what a code looks like and what it's
  // called — a German store types 10115, a US one a ZIP. Both inputs come
  // from the store doc the sidebar already watches, so this costs no read.
  const postal = postalGuidanceFor(storeLanguage, storeCurrency);

  useEffect(() => {
    let active = true;
    getStore(storeId)
      .then((store) => {
        if (!active) return;
        if (store) {
          setFee(String(store.delivery.fee));
          setFreeAbove(String(store.delivery.freeAbove));
          // One per line: an owner pastes these from a courier's coverage
          // list, and commas in that source are inconsistent.
          setAreas(store.delivery.areas.join("\n"));
        }
        setLoading(false);
      })
      .catch(() => {
        if (active) setLoading(false);
        toast.error("Could not load delivery settings");
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
          delivery: {
            fee: Number(fee),
            freeAbove: Number(freeAbove),
            // Split on newlines *or* commas so either paste shape works; the
            // server normalizes case, spacing and duplicates.
            areas: areas.split(/[\n,]/),
          },
        }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(body.error ?? "Could not save delivery");
      // Re-render from what the server stored, not from what was typed —
      // normalization drops duplicates and over-long entries, and the owner
      // should see the list they actually have.
      const saved = body.store?.delivery;
      if (saved) setAreas((saved.areas as string[]).join("\n"));
      toast.success("Delivery settings saved");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSaving(false);
    }
  }

  const areaCount = areas.split(/[\n,]/).filter((a) => a.trim()).length;

  return (
    <Card>
      <CardHeader>
        <CardTitle>Delivery</CardTitle>
        <CardDescription>
          What you charge to deliver an order, and the {postal.nounPlural} you
          deliver to. Shoppers see the fee in their cart before checkout, in
          your store&apos;s currency and language.
        </CardDescription>
      </CardHeader>
      <CardContent>
        {loading ? (
          <p className="text-sm text-muted-foreground">Loading…</p>
        ) : (
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <div className="flex flex-col gap-2">
                <Label htmlFor="delivery-fee">Delivery fee ({symbol})</Label>
                <Input
                  id="delivery-fee"
                  type="number"
                  min="0"
                  step="0.01"
                  value={fee}
                  onChange={(e) => setFee(e.target.value)}
                />
                <p className="text-xs text-muted-foreground">
                  0 means you never charge for delivery.
                </p>
              </div>
              <div className="flex flex-col gap-2">
                <Label htmlFor="delivery-free-above">
                  Free delivery above ({symbol})
                </Label>
                <Input
                  id="delivery-free-above"
                  type="number"
                  min="0"
                  step="0.01"
                  value={freeAbove}
                  onChange={(e) => setFreeAbove(e.target.value)}
                />
                <p className="text-xs text-muted-foreground">
                  0 means no threshold — the fee always applies. Measured on
                  the basket after any coupon, so a discount can put an order
                  back under it.
                </p>
              </div>
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="delivery-areas">Delivery areas</Label>
              <Textarea
                id="delivery-areas"
                rows={5}
                value={areas}
                onChange={(e) => setAreas(e.target.value)}
                placeholder={postal.examples.join("\n")}
                className="font-mono text-xs"
              />
              <p className="text-xs text-muted-foreground">
                One {postal.noun} per line. A partial code covers everything
                starting with it — <code>{postal.prefix}</code> covers{" "}
                {postal.prefixCovers}.{" "}
                <strong>Leave empty to deliver everywhere.</strong> Checkout is
                blocked for an address outside this list.
                {areaCount > 0 && ` Currently ${areaCount}.`}
              </p>
            </div>
            <Button type="submit" disabled={saving} className="self-start">
              {saving ? "Saving…" : "Save delivery"}
            </Button>
          </form>
        )}
      </CardContent>
    </Card>
  );
}

// Fills an empty store with a market's bundled grocery catalog. It lives here
// rather than on Products because it writes categories, brands, coupons and
// banners too — and because setting a store up is what this page is for.
// The dialog reads the currency and the current counts itself.
function SampleDataCard({ storeId }: { storeId: string }) {
  const [open, setOpen] = useState(false);

  return (
    <Card>
      <CardHeader>
        <CardTitle>Sample data</CardTitle>
        <CardDescription>
          Fill this store with a ready-made grocery catalog — categories,
          brands, products with photos, coupons and promo banners — so you can
          see the storefront working before entering your own. Pick the market
          that matches your currency; prices are that country&apos;s real shelf
          prices, not converted.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <Button variant="outline" onClick={() => setOpen(true)}>
          <Sparkles aria-hidden="true" className="size-3.5" />
          Generate sample data
        </Button>
      </CardContent>

      {open && (
        <GenerateGroceryDataDialog
          storeId={storeId}
          onClose={() => setOpen(false)}
        />
      )}
    </Card>
  );
}
type PaymentProvider = "razorpay" | "stripe";

type ProviderStatus = {
  configured: boolean;
  keyId: string | null;
  isTest: boolean;
  webhookConfigured: boolean;
};

type PaymentStatus = {
  activeProvider: PaymentProvider | null;
  razorpay: ProviderStatus;
  stripe: ProviderStatus;
  configured: boolean;
};

// Per-provider copy. The provider is never inferred here from what the owner
// typed — the server reads it off the key prefix — so this table only drives
// labels, placeholders and the help text pointing at the right dashboard.
const PROVIDERS: Record<
  PaymentProvider,
  {
    label: string;
    blurb: string;
    keyIdLabel: string;
    keyIdPlaceholder: string;
    keySecretLabel: string;
    keySecretPlaceholder: string;
    webhookPath: string;
    webhookPlaceholder: string;
    webhookHelp: React.ReactNode;
  }
> = {
  razorpay: {
    label: "Razorpay",
    blurb: "Cards, UPI, netbanking and wallets. INR only.",
    keyIdLabel: "Key ID",
    keyIdPlaceholder: "rzp_test_xxxxxxxxxxxxxx",
    keySecretLabel: "Key Secret",
    keySecretPlaceholder: "Never shown again after saving",
    webhookPath: "razorpay",
    webhookPlaceholder: "The secret you set on the Razorpay webhook",
    webhookHelp: (
      <>
        In your Razorpay Dashboard → Settings → Webhooks, add a webhook for the{" "}
        <code>refund.processed</code> and <code>refund.failed</code> events,
        then paste its secret here.
      </>
    ),
  },
  stripe: {
    label: "Stripe",
    blurb: "Cards and wallets in INR, EUR, GBP or USD.",
    keyIdLabel: "Publishable key",
    keyIdPlaceholder: "pk_test_xxxxxxxxxxxxxx",
    keySecretLabel: "Secret key",
    keySecretPlaceholder: "sk_test_… or rk_test_…",
    webhookPath: "stripe",
    webhookPlaceholder: "whsec_…",
    webhookHelp: (
      <>
        In your Stripe Dashboard → Developers → Webhooks, add an endpoint for
        the <code>charge.refunded</code>, <code>refund.updated</code> and{" "}
        <code>refund.failed</code> events, then paste its signing secret
        (<code>whsec_…</code>) here.
      </>
    ),
  },
};

// Both payment cards in one component so the payment-config fetch and the
// forms stay together — the tab that shows them owns their state, and nothing
// is fetched until an owner opens it.
//
// Credentials for BOTH providers are kept server-side at once; this screen
// edits one slot at a time and separately chooses which slot takes payments.
// Saving Stripe keys does not disconnect Razorpay — deliberately, because
// refunding an order paid through Razorpay needs those keys forever.
function PaymentsSettings({ storeId }: { storeId: string }) {
  const { user } = useAuth();
  const [status, setStatus] = useState<PaymentStatus | null>(null);
  const [loading, setLoading] = useState(true);
  // Which provider's form is on screen — a view concern only. It starts on the
  // active provider and never itself changes what shoppers are charged
  // through; that is the Activate action.
  const [provider, setProvider] = useState<PaymentProvider>("razorpay");
  const [keyId, setKeyId] = useState("");
  const [keySecret, setKeySecret] = useState("");
  const [saving, setSaving] = useState(false);
  const [webhookSecret, setWebhookSecret] = useState("");
  const [savingWebhook, setSavingWebhook] = useState(false);
  const [busy, setBusy] = useState(false);

  const copy = PROVIDERS[provider];
  const slot = status?.[provider];
  const isActive = status?.activeProvider === provider;

  const webhookUrl =
    typeof window !== "undefined"
      ? `${window.location.origin}/api/stores/${storeId}/webhooks/${copy.webhookPath}`
      : "";

  useEffect(() => {
    if (!user) return;
    let active = true;
    (async () => {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}/payment-config`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (!active) return;
      if (res.ok) {
        const body = (await res.json()) as PaymentStatus;
        setStatus(body);
        if (body.activeProvider) setProvider(body.activeProvider);
      }
      setLoading(false);
    })();
    return () => {
      active = false;
    };
  }, [user, storeId]);

  // Every mutation on this screen is the same PUT with a different body shape,
  // and every one answers with the full status — so one helper covers saving
  // keys, saving a webhook secret, activating and disconnecting.
  async function submit(
    body: Record<string, unknown>,
    okMessage: string,
    setPending: (v: boolean) => void,
  ): Promise<boolean> {
    if (!user) return false;
    setPending(true);
    try {
      const token = await user.getIdToken();
      const res = await fetch(`/api/stores/${storeId}/payment-config`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(body),
      });
      const payload = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(payload.error ?? "Something went wrong");
      setStatus(payload);
      toast.success(okMessage);
      return true;
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
      return false;
    } finally {
      setPending(false);
    }
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    const ok = await submit(
      { keyId: keyId.trim(), keySecret: keySecret.trim() },
      `${copy.label} keys saved`,
      setSaving,
    );
    if (ok) {
      setKeyId("");
      setKeySecret("");
    }
  }

  async function handleWebhookSubmit(e: FormEvent) {
    e.preventDefault();
    const ok = await submit(
      { provider, webhookSecret: webhookSecret.trim() },
      "Webhook secret saved",
      setSavingWebhook,
    );
    if (ok) setWebhookSecret("");
  }

  return (
    <>
      <Card>
        <CardHeader>
          <CardTitle>Payments</CardTitle>
          <CardDescription>
            {loading
              ? "Loading…"
              : status?.activeProvider
                ? `Shoppers are charged through ${PROVIDERS[status.activeProvider].label}. Keys for both providers are kept, so you can switch without re-entering them.`
                : "Not connected yet. Add keys for Razorpay or Stripe below."}
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-4">
          {/* Both providers' state at a glance — which are connected, and
              which one is actually taking money. */}
          <div className="grid gap-3 sm:grid-cols-2">
            {(Object.keys(PROVIDERS) as PaymentProvider[]).map((id) => {
              const s = status?.[id];
              const selected = provider === id;
              return (
                <button
                  key={id}
                  type="button"
                  onClick={() => {
                    setProvider(id);
                    // The half-typed keys belong to the other provider.
                    setKeyId("");
                    setKeySecret("");
                    setWebhookSecret("");
                  }}
                  className={`flex flex-col gap-2 rounded-lg border p-3 text-left transition-colors ${
                    selected
                      ? "border-primary bg-primary/5"
                      : "hover:bg-muted/50"
                  }`}
                >
                  <span className="flex flex-wrap items-center gap-2">
                    <span className="font-medium">{PROVIDERS[id].label}</span>
                    {!loading && status?.activeProvider === id && (
                      <Badge variant="success" className="gap-1">
                        <span className="size-1.5 rounded-full bg-current" />
                        Taking payments
                      </Badge>
                    )}
                    {!loading && s?.configured && status?.activeProvider !== id && (
                      <Badge variant="secondary">Saved</Badge>
                    )}
                    {!loading && !s?.configured && (
                      <Badge variant="outline">Not connected</Badge>
                    )}
                    {!loading && s?.configured && (
                      <Badge variant={s.isTest ? "secondary" : "default"}>
                        {s.isTest ? "Test" : "Live"}
                      </Badge>
                    )}
                  </span>
                  <span className="text-xs break-all text-muted-foreground">
                    {s?.configured ? s.keyId : PROVIDERS[id].blurb}
                  </span>
                </button>
              );
            })}
          </div>

          {/* Switching what shoppers are charged through is its own explicit
              action — saving keys must never silently redirect live money. */}
          {!loading && slot?.configured && !isActive && (
            <div className="flex flex-wrap items-center gap-3 rounded-md border border-amber-500/40 bg-amber-500/10 px-3 py-2">
              <p className="text-xs">
                {copy.label} is configured but not taking payments.
              </p>
              <Button
                type="button"
                size="sm"
                disabled={busy}
                onClick={() =>
                  submit(
                    { provider, activate: true },
                    `Now charging through ${copy.label}`,
                    setBusy,
                  )
                }
              >
                Use {copy.label} for checkout
              </Button>
              <Button
                type="button"
                size="sm"
                variant="outline"
                disabled={busy}
                onClick={() =>
                  submit(
                    { provider, disconnect: true },
                    `${copy.label} disconnected`,
                    setBusy,
                  )
                }
              >
                Disconnect
              </Button>
            </div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="keyId">
                {copy.label} · {copy.keyIdLabel}
              </Label>
              <Input
                id="keyId"
                placeholder={copy.keyIdPlaceholder}
                value={keyId}
                onChange={(e) => setKeyId(e.target.value)}
                autoComplete="off"
              />
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="keySecret">{copy.keySecretLabel}</Label>
              <Input
                id="keySecret"
                type="password"
                placeholder={copy.keySecretPlaceholder}
                value={keySecret}
                onChange={(e) => setKeySecret(e.target.value)}
                autoComplete="off"
              />
              <p className="text-xs text-muted-foreground">
                Your secret is encrypted before it is stored and is never sent
                back to this page.
                {provider === "stripe" &&
                  " A restricted key (rk_…) scoped to write PaymentIntents and Refunds is safer than a full secret key."}
              </p>
            </div>
            <Button
              type="submit"
              disabled={saving || !keyId.trim() || !keySecret.trim()}
              className="self-start"
            >
              {saving
                ? "Saving…"
                : slot?.configured
                  ? `Update ${copy.label} keys`
                  : `Save ${copy.label} keys`}
            </Button>
          </form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="flex flex-wrap items-center gap-2">
            {copy.label} webhook
            {!loading &&
              (slot?.webhookConfigured ? (
                <Badge variant="success" className="gap-1">
                  <span className="size-1.5 rounded-full bg-current" />
                  Configured
                </Badge>
              ) : (
                <Badge variant="outline">Not configured</Badge>
              ))}
          </CardTitle>
          <CardDescription>
            Lets refunds settle automatically. {copy.webhookHelp}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleWebhookSubmit} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <Label>Webhook URL (paste into {copy.label})</Label>
              <code className="block overflow-x-auto rounded-md bg-muted px-3 py-2 text-xs">
                {webhookUrl}
              </code>
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="webhookSecret">Webhook Secret</Label>
              <Input
                id="webhookSecret"
                type="password"
                placeholder={copy.webhookPlaceholder}
                value={webhookSecret}
                onChange={(e) => setWebhookSecret(e.target.value)}
                autoComplete="off"
              />
              <p className="text-xs text-muted-foreground">
                Encrypted before storage and never sent back to this page.
                Without it, refunds still work but stay in “processing” until
                you press “Complete refund” on the order.
              </p>
            </div>
            <Button
              type="submit"
              disabled={savingWebhook || !webhookSecret.trim()}
              className="self-start"
            >
              {savingWebhook
                ? "Saving…"
                : slot?.webhookConfigured
                  ? "Update webhook secret"
                  : "Save webhook secret"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </>
  );
}

const TABS = [
  { value: "store", label: "Store" },
  { value: "delivery", label: "Delivery" },
  { value: "sample-data", label: "Sample data" },
  { value: "payments", label: "Payments" },
  { value: "developers", label: "Developers" },
  { value: "account", label: "Account" },
] as const;

export default function SettingsPage() {
  const { storeId } = useStore();

  if (!storeId) return null;

  return (
    <div className="flex max-w-5xl flex-col gap-6">
      <div>
        <h1 className="text-lg font-semibold">Settings</h1>
        <p className="text-sm text-muted-foreground">
          This store&apos;s public profile, support contact, storefront template,
          delivery, sample data, payment account and API tokens — plus the
          account you sign in with.
        </p>
      </div>

      {/* Keyed on the store so switching stores in the sidebar remounts every
          tab's state — otherwise the previous store's payment status and
          half-typed profile edits survive the switch. */}
      <Tabs key={storeId} defaultValue="store">
        <TabsList>
          {TABS.map((tab) => (
            <TabsTrigger key={tab.value} value={tab.value}>
              {tab.label}
            </TabsTrigger>
          ))}
        </TabsList>

        <TabsContent value="store" className="space-y-6">
          <StoreProfileCard storeId={storeId} />
          <SupportCard storeId={storeId} />
          {/* Under the profile, not on its own tab: the checklist is mostly
              about fields edited right above it, and a publish gate hidden
              behind a tab is one nobody finds. */}
          <PublishStoreCard storeId={storeId} />
        </TabsContent>

        <TabsContent value="delivery" className="max-w-2xl">
          <DeliveryCard storeId={storeId} />
        </TabsContent>

        {/* Only the store profile has enough fields to earn the full width.
            The rest are a short form or a read-out, and a 24-character key in
            an input five times its length reads as a mistake. */}
        <TabsContent value="sample-data" className="max-w-2xl">
          <SampleDataCard storeId={storeId} />
        </TabsContent>

        <TabsContent value="payments" className="max-w-2xl">
          <PaymentsSettings storeId={storeId} />
        </TabsContent>

        <TabsContent value="developers" className="max-w-2xl">
          <DeveloperSettings storeId={storeId} />
        </TabsContent>

        <TabsContent value="account" className="max-w-2xl">
          <AccountCard />
        </TabsContent>
      </Tabs>
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
