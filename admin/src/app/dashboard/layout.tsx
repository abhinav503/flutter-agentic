"use client";

import { useEffect } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
  Award,
  BadgePercent,
  Bell,
  Images,
  LayoutGrid,
  LogOut,
  Megaphone,
  Package,
  ReceiptText,
  Settings,
  Store,
  Star,
  Tags,
} from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { useStore } from "@/lib/store-context";
import { StoreSwitcher, CreateStoreForm } from "@/components/store-switcher";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BrandMark } from "@/components/site/BrandMark";

const NAV_ITEMS = [
  { href: "/dashboard", label: "Overview", icon: LayoutGrid },
  { href: "/dashboard/categories", label: "Categories", icon: Tags },
  { href: "/dashboard/brands", label: "Brands", icon: Award },
  { href: "/dashboard/products", label: "Products", icon: Package },
  { href: "/dashboard/banners", label: "Banners", icon: Images },
  { href: "/dashboard/coupons", label: "Coupons", icon: BadgePercent },
  { href: "/dashboard/orders", label: "Orders", icon: ReceiptText },
  { href: "/dashboard/reviews", label: "Reviews", icon: Star },
  { href: "/dashboard/notifications", label: "Notifications", icon: Bell },
  { href: "/dashboard/settings", label: "Settings", icon: Settings },
];

// Rendered only for a superadmin, below a divider — it addresses every store's
// shoppers, not the one in the switcher above, and sitting inside the same
// list would read as another store-scoped page.
const PLATFORM_NAV_ITEMS = [
  {
    href: "/dashboard/stores",
    label: "Stores",
    icon: Store,
  },
  {
    href: "/dashboard/platform-notifications",
    label: "Admin notifications",
    icon: Megaphone,
  },
];

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const { user, loading: authLoading, signOutUser } = useAuth();
  const { storeId, isSuperAdmin, loading: storeLoading } = useStore();

  useEffect(() => {
    // Home, not /login — that route is gone, and the sign-in dialog only ever
    // opens from a click now. A signed-out visitor lands on the marketing page
    // and signs in from its nav.
    if (!authLoading && !user) {
      router.replace("/");
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
          <BrandMark />
          <span className="text-[0.95rem]">CordeliaApps</span>
        </Link>

        {/* The signed-in email lives in Settings → Account now; up here it
            crowded the store identity this corner is actually for. */}
        <div className="mb-5 -mx-1">
          <StoreSwitcher />
        </div>

        <nav className="flex flex-1 flex-col gap-0.5">
          {NAV_ITEMS.map((item) => (
            <NavLink key={item.href} item={item} pathname={pathname} />
          ))}

          {isSuperAdmin && (
            <>
              <p className="mt-5 px-3 pb-1 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                Platform
              </p>
              {PLATFORM_NAV_ITEMS.map((item) => (
                <NavLink key={item.href} item={item} pathname={pathname} />
              ))}
            </>
          )}
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

function NavLink({
  item,
  pathname,
}: {
  item: { href: string; label: string; icon: React.ElementType };
  pathname: string;
}) {
  const active = pathname === item.href;
  return (
    <Link
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
