"use client";

import { useEffect, useState } from "react";
import { RotateCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { DeviceFrame } from "@/components/preview/device-frame";
import { DEVICE_FRAMES, deviceFrameById } from "@/lib/device-frames";
import { useApps } from "@/hooks/use-apps";
import { useSelectionStore } from "@/stores/selection-store";

// Right pane for web targets: editable address bar + live iframe. Port of
// terminal_preview.dart — the iframe reloads by re-keying on reloadToken.
export function TerminalPreview() {
  const { apps } = useApps();
  const previewUrl = useSelectionStore((s) => s.previewUrl);
  const reloadToken = useSelectionStore((s) => s.reloadToken);
  const setPreviewUrl = useSelectionStore((s) => s.setPreviewUrl);
  const pointPreviewAt = useSelectionStore((s) => s.pointPreviewAt);
  const reloadPreview = useSelectionStore((s) => s.reloadPreview);
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const selectedDeviceFrameId = useSelectionStore((s) => s.selectedDeviceFrameId);
  const setSelectedDeviceFrame = useSelectionStore((s) => s.setSelectedDeviceFrame);
  const device = deviceFrameById(selectedDeviceFrameId);

  // Local address-bar text, resynced whenever the store URL changes from the
  // outside (e.g. a web app going live). Adjust-during-render is React's
  // recommended alternative to a setState-in-effect for prop-derived state.
  const [draft, setDraft] = useState(previewUrl);
  const [lastUrl, setLastUrl] = useState(previewUrl);
  if (previewUrl !== lastUrl) {
    setLastUrl(previewUrl);
    setDraft(previewUrl);
  }

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

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <form
        className="flex items-center gap-2 border-b px-3 py-2"
        onSubmit={(e) => {
          e.preventDefault();
          setPreviewUrl(draft);
          reloadPreview();
        }}
      >
        <Input
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          className="h-8"
          spellCheck={false}
        />
        <Button
          type="button"
          size="sm"
          variant="outline"
          onClick={() => {
            setPreviewUrl(draft);
            reloadPreview();
          }}
        >
          <RotateCw className="size-3.5" />
          Reload
        </Button>
        <Select
          value={device.id}
          onValueChange={setSelectedDeviceFrame}
        >
          <SelectTrigger size="sm" className="ml-auto w-[190px]">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {DEVICE_FRAMES.map((d) => (
              <SelectItem key={d.id} value={d.id}>
                {d.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </form>
      <DeviceFrame device={device}>
        <iframe
          key={`${previewUrl}#${reloadToken}`}
          src={previewUrl}
          className="border-0"
          style={{ width: device.width, height: device.height }}
          title="App preview"
        />
      </DeviceFrame>
    </div>
  );
}
