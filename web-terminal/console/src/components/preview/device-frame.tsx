"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import type { DeviceFrame as DeviceFrameSpec } from "@/lib/device-frames";

// Bezel thickness around the app, and the breathing room kept between the
// scaled device and the pane edges.
const BEZEL = 12;
const MARGIN = 24;

// Wraps the preview iframe in a phone shell sized to `device` — dark bezel,
// Dynamic Island (modern iPhones) or punch-hole camera (Android), and side
// buttons — then scales the whole thing down (never up) so it always fits the
// pane and stays centered. The children keep true device pixels — only the
// visual is scaled.
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

  const frameW = device.width + BEZEL * 2;
  const frameH = device.height + BEZEL * 2;

  // Fit to the smaller of the two axes; cap at 1 so we never upscale.
  const scale =
    avail.w > 0 && avail.h > 0
      ? Math.min(1, (avail.w - MARGIN) / frameW, (avail.h - MARGIN) / frameH)
      : 1;

  // Older/small iPhones (SE) have a plain bezel, not a Dynamic Island.
  const hasIsland = device.platform === "ios" && device.height > 700;
  const hasPunchHole = device.platform === "android";

  return (
    <div
      ref={containerRef}
      className="flex min-h-0 flex-1 items-center justify-center overflow-hidden bg-muted/40"
    >
      <div
        className="relative shrink-0 rounded-[44px] bg-neutral-900 p-3 shadow-2xl ring-1 ring-black/20"
        style={{
          width: frameW,
          height: frameH,
          transform: `scale(${scale})`,
          transformOrigin: "center",
        }}
      >
        {/* side buttons */}
        <div className="absolute top-24 -left-[3px] h-10 w-[3px] rounded-l-sm bg-neutral-700" />
        <div className="absolute top-38 -left-[3px] h-14 w-[3px] rounded-l-sm bg-neutral-700" />
        <div className="absolute top-30 -right-[3px] h-16 w-[3px] rounded-r-sm bg-neutral-700" />

        <div
          className="relative overflow-hidden rounded-[32px] bg-white"
          style={{ width: device.width, height: device.height }}
        >
          {children}
          {hasIsland && (
            <div className="pointer-events-none absolute top-2 left-1/2 z-10 h-[26px] w-[92px] -translate-x-1/2 rounded-full bg-black" />
          )}
          {hasPunchHole && (
            <div className="pointer-events-none absolute top-2.5 left-1/2 z-10 size-3.5 -translate-x-1/2 rounded-full bg-black" />
          )}
        </div>
      </div>
    </div>
  );
}
