"use client";

import { useEffect, useState, type FormEvent } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";

const NAV_ITEMS = [
  { href: "/dashboard", label: "Overview" },
  { href: "/dashboard/categories", label: "Categories" },
  { href: "/dashboard/products", label: "Products" },
  { href: "/dashboard/orders", label: "Orders" },
  { href: "/dashboard/settings", label: "Settings" },
];

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const { user, loading: authLoading, signOutUser } = useAuth();
  const { storeId, storeName, loading: storeLoading } = useStore();

  useEffect(() => {
    if (!authLoading && !user) {
      router.replace("/login");
    }
  }, [authLoading, user, router]);

  if (authLoading || !user || storeLoading) {
    return (
      <div className="flex flex-1 items-center justify-center">
        <p className="text-sm text-muted-foreground">Loading…</p>
      </div>
    );
  }

  if (!storeId) {
    return <CreateStoreGate />;
  }

  return (
    <div className="flex flex-1">
      <aside className="flex w-56 shrink-0 flex-col border-r border-border bg-muted/30 p-4">
        <div className="mb-6">
          <p className="text-sm font-semibold">{storeName ?? "Your store"}</p>
          <p className="text-xs text-muted-foreground">{user.email}</p>
        </div>
        <nav className="flex flex-1 flex-col gap-1">
          {NAV_ITEMS.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={`rounded-md px-3 py-2 text-sm font-medium transition ${
                pathname === item.href
                  ? "bg-primary text-primary-foreground"
                  : "text-foreground/80 hover:bg-muted"
              }`}
            >
              {item.label}
            </Link>
          ))}
        </nav>
        <Button variant="outline" size="sm" onClick={() => signOutUser()}>
          Sign out
        </Button>
      </aside>
      <main className="flex-1 overflow-auto p-8">{children}</main>
    </div>
  );
}

function CreateStoreGate() {
  const { createStore } = useStore();
  const [name, setName] = useState("");
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setSubmitting(true);
    try {
      await createStore(name.trim());
      toast.success("Store created");
    } catch {
      toast.error("Could not create store. Please try again.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="flex flex-1 items-center justify-center px-4">
      <Card className="w-full max-w-sm">
        <CardHeader>
          <CardTitle>Create your store</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="mb-4 text-sm text-muted-foreground">
            You&apos;ll manage its products and categories from here.
          </p>
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
            <Button type="submit" disabled={submitting || !name.trim()}>
              {submitting ? "Creating…" : "Create store"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
