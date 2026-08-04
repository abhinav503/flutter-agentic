"use client";

import { useEffect } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
  Award,
  BadgePercent,
  Images,
  LayoutGrid,
  LogOut,
  Package,
  ReceiptText,
  Settings,
  Star,
  Tags,
} from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { StoreSwitcher, CreateStoreForm } from "@/components/store-switcher";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const NAV_ITEMS = [
  { href: "/dashboard", label: "Overview", icon: LayoutGrid },
  { href: "/dashboard/categories", label: "Categories", icon: Tags },
  { href: "/dashboard/brands", label: "Brands", icon: Award },
  { href: "/dashboard/products", label: "Products", icon: Package },
  { href: "/dashboard/banners", label: "Banners", icon: Images },
  { href: "/dashboard/coupons", label: "Coupons", icon: BadgePercent },
  { href: "/dashboard/orders", label: "Orders", icon: ReceiptText },
  { href: "/dashboard/reviews", label: "Reviews", icon: Star },
  { href: "/dashboard/settings", label: "Settings", icon: Settings },
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
    // /login is the marketing page with the sign-in dialog already open —
    // there is no separate sign-in screen to land on.
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
      {/* The console's only navigation, and it stays on the left — the
          marketing site's top bar is for visitors, not for working. */}
      <aside className="flex w-60 shrink-0 flex-col border-r border-border bg-sidebar p-4">
        <Link
          href="/"
          className="mb-5 flex items-center gap-2.5 px-1 font-extrabold tracking-tight text-ink"
        >
          <span
            aria-hidden="true"
            className="grid size-8 place-items-center rounded-xl bg-[image:var(--gradient-brand)] text-sm font-black text-primary-foreground"
          >
            C
          </span>
          <span className="text-[0.95rem]">CordeliaApps</span>
        </Link>

        {/* The signed-in email lives in Settings → Account now; up here it
            crowded the store identity this corner is actually for. */}
        <div className="mb-5 -mx-1">
          <StoreSwitcher />
        </div>

        <nav className="flex flex-1 flex-col gap-0.5">
          {NAV_ITEMS.map((item) => {
            const active = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                aria-current={active ? "page" : undefined}
                className={`flex items-center gap-2.5 rounded-full px-3 py-2 text-sm font-semibold transition-colors ${
                  active
                    ? "bg-primary text-primary-foreground shadow-[var(--shadow-soft)]"
                    : "text-muted-foreground hover:bg-primary-soft hover:text-accent-foreground"
                }`}
              >
                <item.icon aria-hidden="true" className="size-4 shrink-0" />
                {item.label}
              </Link>
            );
          })}
        </nav>

        <button
          type="button"
          onClick={() => signOutUser()}
          className="mt-4 flex items-center justify-center gap-2 rounded-full border border-border-strong bg-surface px-4 py-2 text-sm font-semibold text-foreground transition-colors hover:bg-secondary"
        >
          <LogOut aria-hidden="true" className="size-4" />
          Sign out
        </button>
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
