"use client";

import { useEffect } from "react";
import { Play, Square } from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { useApps, useRunApp, useStopApp } from "@/hooks/use-apps";
import { useDevices } from "@/hooks/use-devices";
import { useSelectionStore } from "@/stores/selection-store";
import type { AppRunStatus } from "@/lib/types";

// Run-target row under the project header: device select + Run/Stop for the
// app picked in ProjectHeader.
export function RunBar() {
  const { apps } = useApps();
  const { devices } = useDevices();
  const runApp = useRunApp();
  const stopApp = useStopApp();

  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const setSelectedApp = useSelectionStore((s) => s.setSelectedApp);
  const selectedDeviceId = useSelectionStore((s) => s.selectedDeviceId);
  const setSelectedDevice = useSelectionStore((s) => s.setSelectedDevice);

  // Default to the first app once the list loads.
  useEffect(() => {
    if (!selectedAppName && apps.length > 0) setSelectedApp(apps[0].name);
  }, [apps, selectedAppName, setSelectedApp]);

  if (apps.length === 0) return null;

  const app = apps.find((a) => a.name === selectedAppName) ?? apps[0];
  const device =
    devices.find((d) => d.id === selectedDeviceId) ?? devices[0];
  const status: AppRunStatus = app.status;

  const onRun = () => {
    if (!device) return;
    runApp.mutate(
      {
        name: app.name,
        deviceId: device.id,
        platform: device.platform,
        kind: device.kind,
      },
      { onError: (e) => toast.error(e.message) },
    );
  };

  const onStop = () =>
    stopApp.mutate(app.name, { onError: (e) => toast.error(e.message) });

  return (
    <div className="flex flex-wrap items-center gap-2 border-b px-3 py-1.5 text-sm">
      <span className="text-muted-foreground text-xs">Run on</span>
      <Select value={device?.id} onValueChange={setSelectedDevice}>
        <SelectTrigger size="sm" className="w-[180px]">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          {devices.map((d) => (
            <SelectItem key={d.id} value={d.id}>
              {d.name}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <div className="ml-auto">
        {status === "running" ? (
          <Button size="sm" variant="destructive" onClick={onStop}>
            <Square className="size-3.5" />
            Stop
          </Button>
        ) : status === "starting" ? (
          <Button size="sm" disabled>
            Starting…
          </Button>
        ) : (
          <Button size="sm" onClick={onRun}>
            <Play className="size-3.5" />
            Run
          </Button>
        )}
      </div>
    </div>
  );
}
