import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // The Docker image builds with NEXT_OUTPUT=standalone so the runtime stage
  // ships .next/standalone instead of the full node_modules; local `next dev`
  // and `next start` are unaffected when the variable is unset.
  ...(process.env.NEXT_OUTPUT === "standalone"
    ? { output: "standalone" as const }
    : {}),
};

export default nextConfig;
