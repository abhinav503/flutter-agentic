// Selectable phone viewports for the preview pane. These are CSS logical-pixel
// sizes (device_preview / Chrome device-mode style) — the iframe is sized to
// width×height so the Flutter web app lays out as it would on that phone. This
// is purely a client-side viewport concept, distinct from a Flutter run target.
export interface DeviceFrame {
  id: string;
  name: string;
  platform: "ios" | "android";
  width: number;
  height: number;
}

// Order matches the preview device dropdown in the design.
export const DEVICE_FRAMES: DeviceFrame[] = [
  { id: "galaxy-s23", name: "Samsung Galaxy S23", platform: "android", width: 360, height: 780 },
  { id: "iphone-se", name: "iPhone SE", platform: "ios", width: 375, height: 667 },
  { id: "iphone-14-pro", name: "iPhone 14 Pro", platform: "ios", width: 393, height: 852 },
  { id: "iphone-16-pro", name: "iPhone 16 Pro", platform: "ios", width: 402, height: 874 },
  { id: "iphone-16-pro-max", name: "iPhone 16 Pro Max", platform: "ios", width: 440, height: 956 },
  { id: "iphone-17-pro", name: "iPhone 17 Pro", platform: "ios", width: 402, height: 874 },
];

export const DEFAULT_DEVICE_FRAME_ID = "iphone-16-pro";

export function deviceFrameById(id: string): DeviceFrame {
  return (
    DEVICE_FRAMES.find((d) => d.id === id) ??
    DEVICE_FRAMES.find((d) => d.id === DEFAULT_DEVICE_FRAME_ID) ??
    DEVICE_FRAMES[0]
  );
}
