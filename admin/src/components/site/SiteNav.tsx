"use client";

import Link from "next/link";

/**
 * Site navigation. Interactive (mobile menu) — mark as a client component.
 */
import { useState } from "react";
import { Menu, X } from "lucide-react";
import { AuthCta } from "./AuthCta";

const anchors = [
  { href: "#templates", label: "Templates" },
  { href: "#features", label: "Features" },
  { href: "#how-it-works", label: "How it works" },
  { href: "#faq", label: "FAQ" },
];

export function SiteNav() {
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-50 border-b border-border bg-background/85 backdrop-blur-md">
      <nav aria-label="Primary" className="mx-auto flex w-full max-w-6xl items-center gap-4 px-5 py-3.5 sm:px-8">
        <Link href="/" className="flex items-center gap-2.5 font-extrabold tracking-tight text-ink">
          <span
            aria-hidden="true"
            className="grid size-8 place-items-center rounded-xl bg-[image:var(--gradient-brand)] text-sm font-black text-primary-foreground"
          >
            C
          </span>
          <span className="text-[0.98rem]">CordeliaApps</span>
        </Link>

        <ul className="ml-6 hidden items-center gap-6 lg:flex">
          {anchors.map((a) => (
            <li key={a.href}>
              <a
                href={a.href}
                className="text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
              >
                {a.label}
              </a>
            </li>
          ))}
        </ul>

        <div className="ml-auto hidden items-center gap-2 md:flex">
          <Link
            href="/docs"
            className="rounded-full px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
          >
            Documentation
          </Link>
          <AuthCta mode="login" variant="navGhost">
            Log in
          </AuthCta>
          <AuthCta mode="signup" variant="navPrimary">
            Start free
          </AuthCta>
        </div>

        <button
          type="button"
          onClick={() => setOpen((v) => !v)}
          aria-expanded={open}
          aria-controls="mobile-menu"
          className="ml-auto grid size-10 place-items-center rounded-xl border border-border bg-surface text-foreground md:hidden"
        >
          <span className="sr-only">{open ? "Close menu" : "Open menu"}</span>
          {open ? <X className="size-5" aria-hidden="true" /> : <Menu className="size-5" aria-hidden="true" />}
        </button>
      </nav>

      {open ? (
        <div id="mobile-menu" className="border-t border-border bg-background md:hidden">
          <ul className="mx-auto flex w-full max-w-6xl flex-col gap-1 px-5 py-4 sm:px-8">
            {anchors.map((a) => (
              <li key={a.href}>
                <a
                  href={a.href}
                  onClick={() => setOpen(false)}
                  className="block rounded-xl px-3 py-2.5 text-sm font-medium text-foreground hover:bg-secondary"
                >
                  {a.label}
                </a>
              </li>
            ))}
            <li>
              <Link href="/docs" className="block rounded-xl px-3 py-2.5 text-sm font-medium text-foreground hover:bg-secondary">
                Documentation
              </Link>
            </li>
            <li className="mt-2 flex gap-2">
              <AuthCta
                mode="login"
                variant="navGhost"
                className="flex-1"
                onOpen={() => setOpen(false)}
              >
                Log in
              </AuthCta>
              <AuthCta
                mode="signup"
                variant="navPrimary"
                className="flex-1"
                onOpen={() => setOpen(false)}
              >
                Start free
              </AuthCta>
            </li>
          </ul>
        </div>
      ) : null}
    </header>
  );
}
