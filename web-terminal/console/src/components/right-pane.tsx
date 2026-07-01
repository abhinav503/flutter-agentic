"use client";

import { TerminalPreview } from "@/components/preview/terminal-preview";
import { DeviceStatus } from "@/components/preview/device-status";
import { SetupPanel } from "@/components/setup/setup-panel";
import { useDevices } from "@/hooks/use-devices";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";
import { isWebDevice } from "@/lib/types";

// Mirrors _RightPane in home_screen.dart: setup panel wins; otherwise show the
// web preview for web targets or the run-status view for native devices.
export function RightPane() {
  const setupOpen = useUiStore((s) => s.setupOpen);
  const { devices } = useDevices();
  const selectedDeviceId = useSelectionStore((s) => s.selectedDeviceId);

  if (setupOpen) return <SetupPanel />;

  const device = devices.find((d) => d.id === selectedDeviceId);
  const web = device ? isWebDevice(device) : true;
  return web ? <TerminalPreview /> : <DeviceStatus />;
}
