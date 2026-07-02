"use client";

import { useEffect } from "react";
import { Play, Smartphone } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { DeviceFrame } from "@/components/preview/device-frame";
import { PreviewToolbar } from "@/components/preview/preview-toolbar";
import { deviceFrameById } from "@/lib/device-frames";
import { DEFAULT_PREVIEW_URL } from "@/lib/config";
import { useApps, useRunApp } from "@/hooks/use-apps";
import { useDevices } from "@/hooks/use-devices";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";

// Empty canvas shown inside the frame until the selected app is running (or
// the user points the address bar somewhere).
function PreviewPlaceholder({ appName }: { appName: string | null }) {
  const { devices } = useDevices();
  const runApp = useRunApp();
  const selectedDeviceId = useSelectionStore((s) => s.selectedDeviceId);
  const device = devices.find((d) => d.id === selectedDeviceId) ?? devices[0];

  const onRun = () => {
    if (!appName || !device) return;
    runApp.mutate(
      {
        name: appName,
        deviceId: device.id,
        platform: device.platform,
        kind: device.kind,
      },
      { onError: (e) => toast.error(e.message) },
    );
  };

  return (
    <div className="flex h-full flex-col items-center justify-center gap-3 bg-white p-6 text-center">
      <div className="grid size-12 place-items-center rounded-2xl bg-neutral-100">
        <Smartphone className="size-6 text-neutral-400" />
      </div>
      <div>
        <p className="text-sm font-medium text-neutral-800">
          Your app will appear here
        </p>
        <p className="mt-1 text-xs text-neutral-500">
          {appName
            ? `Run ${appName} to start the live preview.`
            : "Run an app to start the live preview."}
        </p>
      </div>
      {appName && device && (
        <Button size="sm" onClick={onRun}>
          <Play className="size-3.5" />
          Run {appName}
        </Button>
      )}
    </div>
  );
}

// Right pane for web targets: Rocket-style toolbar + live iframe, framed in a
// phone shell or filling the pane. The iframe reloads by re-keying on
// reloadToken.
export function TerminalPreview() {
  const { apps } = useApps();
  const previewUrl = useSelectionStore((s) => s.previewUrl);
  const reloadToken = useSelectionStore((s) => s.reloadToken);
  const pointPreviewAt = useSelectionStore((s) => s.pointPreviewAt);
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const selectedDeviceFrameId = useSelectionStore(
    (s) => s.selectedDeviceFrameId,
  );
  const previewMode = useUiStore((s) => s.previewMode);
  const device = deviceFrameById(selectedDeviceFrameId);

  // When the selected app goes live on a web target, point the iframe at it.
  const app = apps.find((a) => a.name === selectedAppName);
  useEffect(() => {
    if (
      app &&
      app.status === "running" &&
      app.target === "web" &&
      app.previewPort
    ) {
      pointPreviewAt(`http://localhost:${app.previewPort}`);
    }
  }, [app, pointPreviewAt]);

  // Only guess "nothing to show" while the address bar is untouched; a manual
  // URL always wins over the placeholder.
  const appLive = app?.status === "running" || app?.status === "starting";
  const showPlaceholder = previewUrl === DEFAULT_PREVIEW_URL && !appLive;

  const iframe = (
    <iframe
      key={`${previewUrl}#${reloadToken}`}
      src={previewUrl}
      className="h-full w-full border-0"
      title="App preview"
    />
  );

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <PreviewToolbar />
      {previewMode === "fill" ? (
        <div className="min-h-0 flex-1 bg-white">
          {showPlaceholder ? (
            <PreviewPlaceholder appName={app?.name ?? null} />
          ) : (
            iframe
          )}
        </div>
      ) : (
        <DeviceFrame device={device}>
          {showPlaceholder ? (
            <PreviewPlaceholder appName={app?.name ?? null} />
          ) : (
            iframe
          )}
        </DeviceFrame>
      )}
    </div>
  );
}
