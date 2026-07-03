"use client";

import { TerminalPreview } from "@/components/preview/terminal-preview";
import { PreviewToolbar } from "@/components/preview/preview-toolbar";
import { DeviceStatus } from "@/components/preview/device-status";
import { SetupPanel } from "@/components/setup/setup-panel";
import { CodeView } from "@/components/code/code-view";
import { useDevices } from "@/hooks/use-devices";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";
import { isWebDevice } from "@/lib/types";

// Right pane: the setup panel wins when open; otherwise the Rocket-style
// toolbar stays on top of whichever view is active — the code browser, the
// web preview, or the run-status view for native devices.
export function RightPane() {
  const setupOpen = useUiStore((s) => s.setupOpen);
  const rightView = useUiStore((s) => s.rightView);
  const { devices } = useDevices();
  const selectedDeviceId = useSelectionStore((s) => s.selectedDeviceId);

  if (setupOpen) return <SetupPanel />;

  const device = devices.find((d) => d.id === selectedDeviceId);
  const web = device ? isWebDevice(device) : true;

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <PreviewToolbar />
      {rightView === "code" ? (
        <CodeView />
      ) : web ? (
        <TerminalPreview />
      ) : (
        <DeviceStatus />
      )}
    </div>
  );
}
