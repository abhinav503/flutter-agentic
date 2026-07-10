"use client";

import { TerminalPreview } from "@/components/preview/terminal-preview";
import { PreviewToolbar } from "@/components/preview/preview-toolbar";
import { DeviceStatus } from "@/components/preview/device-status";
import { LogPanel } from "@/components/preview/log-panel";
import { SetupPanel } from "@/components/setup/setup-panel";
import { CodeView } from "@/components/code/code-view";
import { useDevices } from "@/hooks/use-devices";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";
import { isWebDevice } from "@/lib/types";
import { cn } from "@/lib/utils";

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
      {/* Stays mounted across the Code <-> Preview toggle and is only
          CSS-hidden — unmounting would destroy the iframe, forcing the
          running web app to reboot from scratch on every switch back, which
          looks like a fresh launch even though nothing on the backend
          restarted. */}
      {web && (
        <div
          className={cn(
            "flex min-h-0 flex-1 flex-col",
            rightView === "code" && "hidden",
          )}
        >
          <TerminalPreview />
        </div>
      )}
      {!web && rightView !== "code" && <DeviceStatus />}
      {rightView === "code" && <CodeView />}
      <LogPanel />
    </div>
  );
}
