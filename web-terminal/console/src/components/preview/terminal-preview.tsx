"use client";

import { useRef } from "react";
import { Play, Smartphone } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { DeviceFrame } from "@/components/preview/device-frame";
import { EditOverlay } from "@/components/preview/edit-overlay";
import { RocketLoader } from "@/components/ui/rocket-loader";
import { deviceFrameById } from "@/lib/device-frames";
import { DEFAULT_PREVIEW_URL } from "@/lib/config";
import { useApps, useRunApp } from "@/hooks/use-apps";
import { useDevices } from "@/hooks/use-devices";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";

// The dev server binds loopback on the machine running the bridge, so a remote
// browser can't reach it directly — and edit mode must read the iframe's DOM,
// which the browser only allows same-origin. Both are solved by rerouting local
// preview URLs through /preview-proxy/ (the console server fetches loopback).
// Non-local URLs pass through untouched (the overlay just can't inspect them).
function toSameOrigin(previewUrl: string): string {
  try {
    const url = new URL(previewUrl);
    if (url.hostname === "localhost" || url.hostname === "127.0.0.1") {
      // No trailing slash — Next 308-redirects "/preview-proxy/" to it anyway.
      return `/preview-proxy?port=${url.port || "80"}`;
    }
  } catch {
    /* leave malformed URLs alone */
  }
  return previewUrl;
}

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

// The live preview canvas: iframe (re-keyed on reloadToken to reload), framed
// in a phone shell or filling the pane, plus the edit-mode inspection overlay.
export function TerminalPreview() {
  const { apps } = useApps();
  const previewUrl = useSelectionStore((s) => s.previewUrl);
  const reloadToken = useSelectionStore((s) => s.reloadToken);
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const selectedDeviceFrameId = useSelectionStore(
    (s) => s.selectedDeviceFrameId,
  );
  const previewMode = useUiStore((s) => s.previewMode);
  const editMode = useUiStore((s) => s.editMode);
  const device = deviceFrameById(selectedDeviceFrameId);
  const iframeRef = useRef<HTMLIFrameElement | null>(null);

  const app = apps.find((a) => a.name === selectedAppName);
  // Only guess "nothing to show" while the address bar is untouched; a manual
  // URL always wins over the placeholder.
  const appLive = app?.status === "running" || app?.status === "starting";
  const showPlaceholder = previewUrl === DEFAULT_PREVIEW_URL && !appLive;

  const src = toSameOrigin(previewUrl);

  let content: React.ReactNode;
  if (showPlaceholder) {
    content = <PreviewPlaceholder appName={app?.name ?? null} />;
  } else if (app?.status === "starting") {
    // The dev server isn't serving yet — a bare iframe would just show a
    // connection error, so hold the launch loader until it's running.
    content = (
      <RocketLoader
        label={`Launching ${app.name}…`}
        sublabel="Starting the preview server"
      />
    );
  } else {
    content = (
      <div className="relative h-full w-full bg-white">
        <iframe
          key={`${src}#${reloadToken}`}
          ref={iframeRef}
          src={src}
          className="h-full w-full border-0"
          title="App preview"
        />
        {editMode && <EditOverlay iframeRef={iframeRef} />}
      </div>
    );
  }

  if (previewMode === "fill") {
    return <div className="min-h-0 flex-1 bg-white">{content}</div>;
  }
  return <DeviceFrame device={device}>{content}</DeviceFrame>;
}
