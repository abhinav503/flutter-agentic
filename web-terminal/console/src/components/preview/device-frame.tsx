"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { cn } from "@/lib/utils";
import type { DeviceFrame as DeviceFrameSpec } from "@/lib/device-frames";

// Bezel thickness around the app, and the breathing room kept between the
// scaled device and the pane edges.
const BEZEL = 12;
const MARGIN = 24;

// Wraps the preview iframe in a minimal phone bezel sized to `device`, then
// scales the whole thing down (never up) so it always fits the pane and stays
// centered. The children keep true device pixels — only the visual is scaled.
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

  return (
    <div
      ref={containerRef}
      className="flex min-h-0 flex-1 items-center justify-center overflow-hidden bg-muted/30"
    >
      <div
        className={cn(
          "rounded-[2.2rem] border bg-card p-3 shadow-xl",
          "shrink-0",
        )}
        style={{
          width: frameW,
          height: frameH,
          transform: `scale(${scale})`,
          transformOrigin: "center",
        }}
      >
        <div
          className="overflow-hidden rounded-[1.4rem] bg-white"
          style={{ width: device.width, height: device.height }}
        >
          {children}
        </div>
      </div>
    </div>
  );
}
