import type { Metadata } from "next";
import { Geist } from "next/font/google";
import { jetBrainsMono } from "@/lib/fonts";
import { QueryProvider } from "@/lib/query-provider";
import { TooltipProvider } from "@/components/ui/tooltip";
import { Toaster } from "@/components/ui/sonner";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-sans",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "FlutterAgentic Console",
  description: "FlutterAgentic builder console",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${jetBrainsMono.variable} h-full antialiased`}
    >
      <body className="min-h-full">
        <QueryProvider>
          <TooltipProvider>{children}</TooltipProvider>
          <Toaster />
        </QueryProvider>
      </body>
    </html>
  );
}
