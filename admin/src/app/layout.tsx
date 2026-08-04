import type { Metadata } from "next";
import { Geist_Mono, Manrope } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/auth-context";
import { StoreProvider } from "@/lib/store-context";
import { Toaster } from "@/components/ui/sonner";

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
  title: "FlutterAgentic Admin",
  description: "Store admin console for FlutterAgenticEcommerce",
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
        <Toaster />
      </body>
    </html>
  );
}
