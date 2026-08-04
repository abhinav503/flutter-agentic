import type { Metadata } from "next";
import { Geist, Geist_Mono, Manrope } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/auth-context";
import { StoreProvider } from "@/lib/store-context";
import { Toaster } from "@/components/ui/sonner";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

// The marketing site's typeface. Self-hosted through next/font rather than
// the Google Fonts <link> the design shipped with — no render-blocking
// request, no layout shift — and scoped to `.site` in globals.css so the
// dashboard keeps Geist.
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
      className={`${geistSans.variable} ${geistMono.variable} ${manrope.variable} h-full antialiased`}
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
