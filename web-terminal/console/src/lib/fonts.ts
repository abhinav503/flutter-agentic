import { JetBrains_Mono } from "next/font/google";

// Bundled monospace for the terminal (matches the Flutter app's bundled
// JetBrains Mono). We pass the resolved `.style.fontFamily` to xterm so its
// canvas glyph measurement uses a concrete family, not a CSS variable.
export const jetBrainsMono = JetBrains_Mono({
  subsets: ["latin"],
  weight: ["400", "700"],
  variable: "--font-jetbrains-mono",
});
