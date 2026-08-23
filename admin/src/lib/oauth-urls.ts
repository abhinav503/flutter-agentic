import { SITE_URL } from "@/lib/site";

// The origin the OAuth metadata names. Production is the canonical site
// (so a preview deployment can't mint discovery documents pointing at
// itself); a local run uses its own origin so the flow works end to end
// on localhost. NEXT_PUBLIC_SITE_URL overrides both.
export function publicOrigin(request: Request): string {
  const override = process.env.NEXT_PUBLIC_SITE_URL?.replace(/\/$/, "");
  if (override) return override;
  const origin = new URL(request.url).origin;
  if (/^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin)) return origin;
  return SITE_URL;
}
