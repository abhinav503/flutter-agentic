"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { BatteryFull, SignalHigh, Wifi } from "lucide-react";
import type { DeviceFrame as DeviceFrameSpec } from "@/lib/device-frames";

// Breathing room kept between the scaled device and the pane edges.
const MARGIN = 24;

// Wraps the preview iframe in a device viewport sized to `device` — a native-
// style status bar (time + signal/wifi/battery), Dynamic Island (modern
// iPhones) or punch-hole camera (Android) — then scales the whole thing down
// (never up) so it always fits the pane and stays centered. The children keep
// true device pixels — only the visual is scaled. Deliberately no phone-case
// bezel/side-buttons: a thin ring + shadow reads as a device without the
// visual weight of a mockup.
export function DeviceFrame({
  device,
  children,
}: {
  device: DeviceFrameSpec;
  children: ReactNode;
}) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [avail, setAvail] = useState({ w: 0, h: 0 });

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    const observer = new ResizeObserver(([entry]) => {
      const { width, height } = entry.contentRect;
      setAvail({ w: width, h: height });
    });
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  // Fit to the smaller of the two axes; cap at 1 so we never upscale.
  const scale =
    avail.w > 0 && avail.h > 0
      ? Math.min(
          1,
          (avail.w - MARGIN) / device.width,
          (avail.h - MARGIN) / device.height,
        )
      : 1;

  // Older/small iPhones (SE) have a plain status bar, not a Dynamic Island.
  const hasIsland = device.platform === "ios" && device.height > 700;
  const hasPunchHole = device.platform === "android";

  // The previewed app has no real safe-area-inset-top to read (this status
  // bar is a CSS mockup, not physical hardware, so env(safe-area-inset-*)
  // inside the iframe stays 0) — without reserving this space, its own
  // content renders straight through and collides with it. Real safe-area-top
  // values: 59pt for Dynamic Island iPhones, 20pt for plain-bezel iOS (SE);
  // Android status bar height approximated at 28px.
  const topInset = hasIsland ? 59 : device.platform === "android" ? 28 : 20;

  return (
    <div
      ref={containerRef}
      className="flex min-h-0 flex-1 items-center justify-center overflow-hidden bg-muted/40"
    >
      <div
        className="relative shrink-0 overflow-hidden rounded-[32px] bg-white shadow-xl ring-1 ring-black/10"
        style={{
          width: device.width,
          height: device.height,
          transform: `scale(${scale})`,
          transformOrigin: "center",
        }}
      >
        {/* Native-style status bar, sized to topInset. Time on the left,
            signal/wifi/battery on the right — the same layout iOS and
            Android both use. */}
        <div
          className="pointer-events-none absolute inset-x-0 top-0 z-10 flex items-center justify-between px-6 text-[13px] font-semibold text-neutral-900"
          style={{ height: topInset }}
        >
          <span>9:41</span>
          <div className="flex items-center gap-1">
            <SignalHigh className="size-3.5" />
            <Wifi className="size-3.5" />
            <BatteryFull className="size-4" />
          </div>
        </div>

        {hasIsland && (
          <div
            className="pointer-events-none absolute left-1/2 z-10 h-[26px] w-[92px] -translate-x-1/2 rounded-full bg-black"
            style={{ top: (topInset - 26) / 2 }}
          />
        )}
        {hasPunchHole && (
          <div
            className="pointer-events-none absolute left-1/2 z-10 size-3.5 -translate-x-1/2 rounded-full bg-black"
            style={{ top: (topInset - 14) / 2 }}
          />
        )}

        {/* Reserves topInset so the status bar/notch never overlaps live
            content — the iframe's own box starts below it instead of being
            covered by it. */}
        <div className="absolute inset-x-0 bottom-0" style={{ top: topInset }}>
          {children}
        </div>
      </div>
    </div>
  );
}
