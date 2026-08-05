"use client";

import { useEffect, useState, type FormEvent } from "react";
import { CheckIcon, ChevronsUpDownIcon, PlusIcon } from "lucide-react";
import { useStore } from "@/lib/store-context";
import { getTemplates } from "@/lib/templates";
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
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";

/**
 * The sidebar's store control: the current store's name as a dropdown
 * listing every store this admin owns, plus a "New store" action — always a
 * dropdown, even with a single store, so adding the second one is
 * discoverable from day one. Selecting a store re-points the whole
 * dashboard (every page reads `useStore().storeId`).
 */
export function StoreSwitcher() {
  const { stores, storeId, storeName, selectStore } = useStore();
  const [creating, setCreating] = useState(false);

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <button
            type="button"
            className="flex w-full items-center justify-between gap-2 rounded-md px-2 py-1.5 text-left text-sm font-semibold transition hover:bg-muted"
            aria-label="Switch store"
          >
            <span className="truncate">{storeName ?? "Your store"}</span>
            <ChevronsUpDownIcon className="size-3.5 shrink-0 text-muted-foreground" />
          </button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="start" className="w-52">
          <DropdownMenuLabel>Your stores</DropdownMenuLabel>
          {stores.map((store) => (
            <DropdownMenuItem
              key={store.id}
              onSelect={() => selectStore(store.id)}
            >
              <span className="flex-1 truncate">
                {store.name || "Untitled store"}
              </span>
              {store.id === storeId && (
                <CheckIcon className="text-muted-foreground" />
              )}
            </DropdownMenuItem>
          ))}
          <DropdownMenuSeparator />
          <DropdownMenuItem onSelect={() => setCreating(true)}>
            <PlusIcon className="text-muted-foreground" />
            New store
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>

      <Dialog open={creating} onOpenChange={setCreating}>
        <DialogContent className="sm:max-w-sm">
          <DialogHeader>
            <DialogTitle>Create a store</DialogTitle>
            <DialogDescription>
              It gets its own catalog, orders, and storefront — the dashboard
              switches to it once it&apos;s created.
            </DialogDescription>
          </DialogHeader>
          <CreateStoreForm
            submitLabel="Create store"
            onCreated={() => setCreating(false)}
          />
        </DialogContent>
      </Dialog>
    </>
  );
}

/**
 * Name + template → `createStore`. Shared by the first-run gate (no store
 * yet) and the switcher's "New store" dialog, so the two can't drift.
 */
export function CreateStoreForm({
  submitLabel = "Create store",
  onCreated,
}: {
  submitLabel?: string;
  onCreated?: () => void;
}) {
  const { createStore } = useStore();
  const [name, setName] = useState("");
  const [templates, setTemplates] = useState<Template[]>([]);
  const [templateId, setTemplateId] = useState("");
  const [language, setLanguage] = useState<string>("en");
  const [currency, setCurrency] = useState<string>("INR");
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    getTemplates()
      .then((fetched) => {
        setTemplates(fetched);
        setTemplateId((current) => current || fetched[0]?.id || "");
      })
      .catch(() => toast.error("Could not load templates"));
  }, []);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setSubmitting(true);
    try {
      await createStore(name.trim(), templateId, language, currency);
      toast.success("Store created");
      setName("");
      onCreated?.();
    } catch {
      toast.error("Could not create store. Please try again.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-4">
      <div className="flex flex-col gap-1.5">
        <Label htmlFor="store-name">Store name</Label>
        <Input
          id="store-name"
          required
          value={name}
          onChange={(event) => setName(event.target.value)}
          placeholder="e.g. Gravia Grocers"
        />
      </div>
      <div className="flex flex-col gap-1.5">
        <Label htmlFor="store-template">Template</Label>
        <Select value={templateId} onValueChange={setTemplateId}>
          <SelectTrigger id="store-template" className="w-full">
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
      </div>
      <div className="flex flex-col gap-1.5">
        <Label htmlFor="store-language">Language</Label>
        <Select value={language} onValueChange={setLanguage}>
          <SelectTrigger id="store-language" className="w-full">
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
      </div>
      <div className="flex flex-col gap-1.5">
        <Label htmlFor="store-currency">Currency</Label>
        <Select value={currency} onValueChange={setCurrency}>
          <SelectTrigger id="store-currency" className="w-full">
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
      </div>
      <Button type="submit" disabled={submitting || !name.trim() || !templateId}>
        {submitting ? "Creating…" : submitLabel}
      </Button>
    </form>
  );
}
