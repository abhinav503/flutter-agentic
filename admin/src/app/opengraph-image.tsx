import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { ImageResponse } from "next/og";

/**
 * The social share card — the picture WhatsApp, LinkedIn, Slack and X render
 * beside a cordeliaapps.com link.
 *
 * Generated rather than exported from a design tool for three reasons: the
 * copy stays greppable and reviewable in git, the palette is the brand's own
 * rather than a screenshot of it, and there is no second artefact to forget to
 * re-export when the headline changes.
 *
 * It sits at the `app/` root, so **every** route inherits it. That is the
 * point: before this, only `/` declared an `og:image` (pointing at a
 * `/og.png` that was never created and 404'd in production), which left the
 * legal pages — including the two URLs submitted to Google Play — with no card
 * at all.
 *
 * Design constraints worth knowing before editing:
 *
 * - **It is read at thumbnail size.** In a WhatsApp forward this is a few
 *   hundred pixels wide, so the headline carries it and everything else is
 *   support. Resist adding a fourth line.
 * - **Satori is not a browser.** Any element with more than one child needs an
 *   explicit `display: flex`, and there is no cascade — every style is inline.
 * - **The palette is hard-coded hex, not the CSS vars.** `globals.css` states
 *   the brand in `oklch()`, which Satori cannot parse. These values are the
 *   sRGB equivalents; the two teals are lifted verbatim from the gradient
 *   stops in `public/brand/mark.svg`, so the card and the logo cannot drift.
 */

// The mark's gradient stops (public/brand/mark.svg), and the ink/paper the
// landing page is drawn on.
const TEAL_DEEP = "#007A60";
const TEAL_LIGHT = "#2DA987";
const INK = "#0A1714";
const MUTED = "#5F706D";
const PAPER = "#FAFDFB";

export const size = { width: 1200, height: 630 };
export const contentType = "image/png";
export const alt =
  "CordeliaApps — a branded shopping app for your grocery or retail store, with zero commission";

export default async function OpengraphImage() {
  // process.cwd() is the Next project directory. Read inside the handler, per
  // the ImageResponse docs — the route is statically optimized, so this runs
  // at build time, once.
  const fontDir = join(process.cwd(), "src/assets/fonts");
  const [manropeExtraBold, manropeMedium] = await Promise.all([
    readFile(join(fontDir, "Manrope-ExtraBold.ttf")),
    readFile(join(fontDir, "Manrope-Medium.ttf")),
  ]);

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
          padding: "72px 80px",
          background: PAPER,
          fontFamily: "Manrope",
          position: "relative",
        }}
      >
        {/* The hero's wash, flattened to something Satori can paint: a soft
            teal bloom off the top-right corner. */}
        <div
          style={{
            position: "absolute",
            top: -260,
            right: -220,
            width: 760,
            height: 760,
            borderRadius: 760,
            background: `radial-gradient(circle, ${TEAL_LIGHT}33 0%, ${PAPER}00 70%)`,
          }}
        />

        {/* Wordmark. The mark is inlined rather than <img src="/brand/mark.svg">
            because at build time there is no server to fetch that path from. */}
        <div style={{ display: "flex", alignItems: "center" }}>
          <svg width="58" height="38" viewBox="5.16 11.23 69.05 45.26" fill="none">
            <defs>
              <linearGradient
                id="wing"
                x1="6.67"
                y1="10"
                x2="71.07"
                y2="27.26"
                gradientUnits="userSpaceOnUse"
              >
                <stop stopColor={TEAL_DEEP} />
                <stop offset="1" stopColor={TEAL_LIGHT} />
              </linearGradient>
            </defs>
            <path d="M38.8691 18.6277L60.931 47.8329L5.16044 32.8892L38.8691 18.6277Z" fill="url(#wing)" />
            <path d="M44.0395 25.9964L74.212 43.791L26.8067 56.4932L44.0395 25.9964Z" fill="url(#wing)" />
            <path d="M52.4438 23.7331L38.8122 26.9321L46.1321 11.2344L52.4438 23.7331Z" fill="url(#wing)" />
          </svg>
          <div
            style={{
              marginLeft: 18,
              fontSize: 34,
              fontWeight: 800,
              letterSpacing: "-0.02em",
              color: INK,
            }}
          >
            CordeliaApps
          </div>
        </div>

        {/* The headline, matching the site's own <h1> word for word. */}
        <div style={{ display: "flex", flexDirection: "column" }}>
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              fontSize: 82,
              fontWeight: 800,
              lineHeight: 1.06,
              letterSpacing: "-0.035em",
              color: INK,
            }}
          >
            <div>Your store.</div>
            <div>Your own shopping app.</div>
            {/* Solid teal, not the site's gradient text: Satori's support for
                background-clip on text is unreliable, and a half-rendered
                headline is a worse failure than a flat one. */}
            <div style={{ color: TEAL_DEEP }}>Zero commission.</div>
          </div>

          <div
            style={{
              marginTop: 28,
              fontSize: 29,
              fontWeight: 500,
              lineHeight: 1.4,
              color: MUTED,
              maxWidth: 880,
            }}
          >
            Catalog, cart, coupons and Razorpay checkout for grocery and retail
            stores in India.
          </div>
        </div>

        <div style={{ display: "flex", alignItems: "center" }}>
          {[
            ["₹0", "to use"],
            ["No app", "to submit"],
            ["Minutes", "to launch"],
          ].map(([value, label], i) => (
            <div
              key={value}
              style={{
                display: "flex",
                alignItems: "baseline",
                marginLeft: i === 0 ? 0 : 56,
              }}
            >
              <div style={{ fontSize: 34, fontWeight: 800, color: INK }}>{value}</div>
              <div style={{ marginLeft: 10, fontSize: 26, fontWeight: 500, color: MUTED }}>
                {label}
              </div>
            </div>
          ))}
        </div>

        {/* Brand rule along the bottom edge. */}
        <div
          style={{
            position: "absolute",
            bottom: 0,
            left: 0,
            width: 1200,
            height: 12,
            background: `linear-gradient(90deg, ${TEAL_DEEP} 0%, ${TEAL_LIGHT} 100%)`,
          }}
        />
      </div>
    ),
    {
      ...size,
      fonts: [
        { name: "Manrope", data: manropeExtraBold, weight: 800, style: "normal" },
        { name: "Manrope", data: manropeMedium, weight: 500, style: "normal" },
      ],
    },
  );
}
