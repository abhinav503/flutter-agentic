import Link from "next/link";
import { BrandMark } from "./BrandMark";

const columns = [
  {
    title: "Product",
    links: [
      { href: "#templates", label: "Templates" },
      { href: "#features", label: "Shopper features" },
      { href: "#admin", label: "Admin console" },
      { href: "#pricing", label: "Pricing" },
    ],
  },
  {
    title: "Resources",
    links: [
      { href: "/docs", label: "Documentation" },
      { href: "#how-it-works", label: "How it works" },
      { href: "#faq", label: "FAQ" },
      { href: "#trust", label: "Security and trust" },
    ],
  },
  {
    title: "Legal",
    links: [
      { href: "/privacy", label: "Privacy policy" },
      { href: "/terms", label: "Terms of service" },
      { href: "/app-privacy", label: "App privacy" },
      { href: "/delete-account", label: "Delete your account" },
    ],
  },
];

export function SiteFooter() {
  return (
    <footer className="border-t border-border bg-surface-2/60 py-14">
      <div className="mx-auto grid w-full max-w-6xl gap-10 px-5 sm:px-8 md:grid-cols-[1.4fr_repeat(3,1fr)]">
        <div>
          <Link href="/" className="flex items-center gap-2.5 font-extrabold tracking-tight text-ink">
            <BrandMark />
            CordeliaApps
          </Link>
          <p className="mt-4 max-w-xs text-sm leading-6 text-muted-foreground">
            Branded shopping apps for Indian grocery and retail stores. Zero commission, Razorpay
            settlement into your own account.
          </p>
          <a
            href="mailto:support@cordeliaapps.com"
            className="mt-4 inline-block text-sm font-semibold text-primary hover:underline"
          >
            support@cordeliaapps.com
          </a>
        </div>

        {columns.map((col) => (
          <nav key={col.title} aria-label={col.title}>
            <h2 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              {col.title}
            </h2>
            <ul className="mt-4 space-y-2.5">
              {col.links.map((l) => (
                <li key={l.href}>
                  <a
                    href={l.href}
                    className="text-sm text-foreground/85 transition-colors hover:text-primary"
                  >
                    {l.label}
                  </a>
                </li>
              ))}
            </ul>
          </nav>
        ))}
      </div>

      <div className="mx-auto mt-12 w-full max-w-6xl px-5 sm:px-8">
        <p className="border-t border-border pt-6 text-xs text-muted-foreground">
          © {new Date().getFullYear()} CordeliaApps. All rights reserved.
        </p>
      </div>
    </footer>
  );
}
