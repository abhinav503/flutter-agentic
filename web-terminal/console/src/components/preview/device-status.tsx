"use client";

import { useApps } from "@/hooks/use-apps";
import { useSelectionStore } from "@/stores/selection-store";
import { useDevices } from "@/hooks/use-devices";
import type { AppRunStatus } from "@/lib/types";

// Right pane for native targets — there is no iframe, just the run status of
// the app on the selected device. Port of terminal_device_status.dart.
export function DeviceStatus() {
  const { apps } = useApps();
  const { devices } = useDevices();
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const selectedDeviceId = useSelectionStore((s) => s.selectedDeviceId);

  const app = apps.find((a) => a.name === selectedAppName);
  const device = devices.find((d) => d.id === selectedDeviceId);
  const status: AppRunStatus = app?.status ?? "stopped";
  const deviceName = device?.name ?? "this device";

  const view: Record<AppRunStatus, { title: string; subtitle: string }> = {
    running: {
      title: `Running on ${deviceName}`,
      subtitle: "The app is launching on the device window, tiled to the right.",
    },
    starting: {
      title: `Starting on ${deviceName}…`,
      subtitle: "Waiting for the device to come up.",
    },
    failed: {
      title: `Couldn't run on ${deviceName}`,
      subtitle: app?.message ?? "The run did not start. Press Run to try again.",
    },
    stopped: {
      title: `Ready to run on ${deviceName}`,
      subtitle: "Press Run to launch the app on this device.",
    },
  };

  const { title, subtitle } = view[status];

  return (
    <div className="flex min-h-0 flex-1 items-center justify-center p-8">
      <div className="max-w-sm text-center">
        <p className="font-medium">{title}</p>
        <p className="text-muted-foreground mt-1 text-sm">{subtitle}</p>
      </div>
    </div>
  );
}
