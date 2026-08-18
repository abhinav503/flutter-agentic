import type { SVGProps } from "react";

/**
 * App-icon badges for the payment providers we integrate.
 *
 * Inlined as SVG rather than fetched or imported from an icon package: two
 * glyphs that never change shouldn't cost a render-blocking third-party
 * request on the marketing page's critical path.
 *
 * Both are badges — a brand-coloured rounded tile with the mark knocked out in
 * white — because that is what Stripe's own asset is, and a bare monochrome
 * glyph beside a badge reads as the odd one out. Colour is baked into the
 * artwork rather than driven by a CSS token: a self-contained badge is legible
 * on any surface, so it needs no light/dark variant, and a brand mark should
 * not inherit whatever colour its container happens to be.
 *
 * Sizing note: render these at an INTEGER pixel size. The first cut used
 * `size-[1.35rem]` (21.6px) against a 24-unit viewBox, and the fractional
 * scale is what made the edges look soft.
 */

type BadgeProps = Omit<SVGProps<SVGSVGElement>, "viewBox" | "fill">;

/**
 * Razorpay — the mark from their brand assets (#3395FF, the blue their own
 * wordmark uses), on a tile whose corner radius matches Stripe's badge
 * proportionally (6.48/28.87 of the side).
 *
 * The glyph is full-bleed in its source viewBox, so it is inset by a computed
 * transform: scaled to 13 of 24 units tall and centred, which sits it at the
 * same optical weight as the S in the Stripe badge beside it.
 */
export function RazorpayBadge(props: BadgeProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" aria-hidden="true" focusable="false" {...props}>
      <rect width="24" height="24" rx="5.387" fill="#3395FF" />
      <g transform="translate(5.5 5.5) scale(0.5417)">
        <path
          fill="#FFFFFF"
          d="M22.436 0l-11.91 7.773-1.174 4.276 6.625-4.297L11.65 24h4.391l6.395-24zM14.26 10.098L3.389 17.166 1.564 24h9.008l3.688-13.902Z"
        />
      </g>
    </svg>
  );
}

/** Stripe — their published badge, unaltered. */
export function StripeBadge(props: BadgeProps) {
  return (
    <svg viewBox="0 0 28.87 28.87" fill="none" aria-hidden="true" focusable="false" {...props}>
      <rect width="28.87" height="28.87" rx="6.48" ry="6.48" fill="#6772E5" />
      <path
        fill="#FFFFFF"
        fillRule="evenodd"
        d="M13.3 11.2c0-.69.57-1 1.49-1a9.84 9.84 0 0 1 4.37 1.13V7.24a11.6 11.6 0 0 0-4.36-.8c-3.56 0-5.94 1.86-5.94 5 0 4.86 6.68 4.07 6.68 6.17 0 .81-.71 1.07-1.68 1.07A11.06 11.06 0 0 1 9 17.25v4.19a12.19 12.19 0 0 0 4.8 1c3.65 0 6.17-1.8 6.17-5 .03-5.21-6.67-4.27-6.67-6.24z"
      />
    </svg>
  );
}
