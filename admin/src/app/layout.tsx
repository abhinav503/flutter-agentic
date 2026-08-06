import type { Metadata } from "next";
import { Geist_Mono, Manrope } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/auth-context";
import { StoreProvider } from "@/lib/store-context";
import { Toaster } from "@/components/ui/sonner";
import { SiteAnalytics } from "@/components/site-analytics";
import { SITE_URL } from "@/lib/site";

// Geist Sans is gone: the dashboard used to run on it, and now runs on the
// brand's Manrope like everything else. Geist Mono stays for --font-mono.
const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

// The brand typeface — the marketing site's, and since the palette merge the
// dashboard's too (globals.css binds --font-sans to it). Self-hosted through
// next/font rather than the Google Fonts <link> the design shipped with: no
// render-blocking request, no layout shift.
const manrope = Manrope({
  variable: "--font-manrope",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  // Declared here, not on the home page, so every route inherits it. While it
  // lived on `/` alone, only that page resolved `alternates.canonical` to an
  // absolute URL — /docs and /privacy emitted a relative `href="/docs"`, which
  // is a weaker signal and disagreed with the homepage's own absolute one.
  metadataBase: new URL(SITE_URL),
  // The fallback title for any route that doesn't set its own — the dashboard
  // pages use it, and it read "FlutterAgentic Admin" long after the rebrand.
  title: "CordeliaApps",
  description: "Store admin console for CordeliaApps.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistMono.variable} ${manrope.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <AuthProvider>
          <StoreProvider>{children}</StoreProvider>
        </AuthProvider>
        <SiteAnalytics />
        <Toaster />
      </body>
    </html>
  );
}
