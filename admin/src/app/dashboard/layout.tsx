"use client";

import { useEffect } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { StoreSwitcher, CreateStoreForm } from "@/components/store-switcher";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const NAV_ITEMS = [
  { href: "/dashboard", label: "Overview" },
  { href: "/dashboard/categories", label: "Categories" },
  { href: "/dashboard/products", label: "Products" },
  { href: "/dashboard/banners", label: "Banners" },
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
  const { storeId, loading: storeLoading } = useStore();

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
        {/* The signed-in email lives in Settings → Account now; up here it
            crowded the store identity this corner is actually for. */}
        <div className="mb-6 -mx-2">
          <StoreSwitcher />
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
      {/* Remount every page on a store switch: pages fetch on mount keyed by
          the storeId they read at that moment, so without this a switch would
          keep showing the previous store's rows until a manual refresh. */}
      <main key={storeId} className="flex-1 overflow-auto p-8">
        {children}
      </main>
    </div>
  );
}

function CreateStoreGate() {
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
          <CreateStoreForm />
        </CardContent>
      </Card>
    </div>
  );
}
