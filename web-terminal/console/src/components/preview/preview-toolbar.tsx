"use client";

import { useEffect, useState } from "react";
import {
  Braces,
  Camera,
  Code2,
  Eye,
  Maximize2,
  MoreHorizontal,
  Pencil,
  Plug,
  RotateCw,
  Rocket,
  UserPlus,
} from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import { DEVICE_FRAMES } from "@/lib/device-frames";
import { useApps } from "@/hooks/use-apps";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";
import { cn } from "@/lib/utils";

const comingSoon = (label: string) => toast.info(`${label} — coming soon`);

function StubIconButton({
  icon: Icon,
  label,
}: {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
}) {
  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <Button
          size="icon-sm"
          variant="ghost"
          className="text-muted-foreground"
          onClick={() => comingSoon(label)}
          aria-label={label}
        >
          <Icon className="size-3.5" />
        </Button>
      </TooltipTrigger>
      <TooltipContent side="bottom">{label}</TooltipContent>
    </Tooltip>
  );
}

// Rocket-style toolbar above the right pane: Preview/Full-screen toggle,
// overflow menu (Code opens the code view), address bar with reload, Edit-mode
// toggle, viewport picker, and the Launch button. Always mounted (also above
// the code view), so it owns the point-at-live-app effect.
export function PreviewToolbar() {
  const previewMode = useUiStore((s) => s.previewMode);
  const setPreviewMode = useUiStore((s) => s.setPreviewMode);
  const rightView = useUiStore((s) => s.rightView);
  const setRightView = useUiStore((s) => s.setRightView);
  const editMode = useUiStore((s) => s.editMode);
  const toggleEditMode = useUiStore((s) => s.toggleEditMode);
  const openCode = useUiStore((s) => s.openCode);

  const { apps } = useApps();
  const previewUrl = useSelectionStore((s) => s.previewUrl);
  const setPreviewUrl = useSelectionStore((s) => s.setPreviewUrl);
  const pointPreviewAt = useSelectionStore((s) => s.pointPreviewAt);
  const reloadPreview = useSelectionStore((s) => s.reloadPreview);
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const selectedDeviceFrameId = useSelectionStore(
    (s) => s.selectedDeviceFrameId,
  );
  const setSelectedDeviceFrame = useSelectionStore(
    (s) => s.setSelectedDeviceFrame,
  );

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

  // Local address-bar text, resynced whenever the store URL changes from the
  // outside (e.g. a web app going live).
  const [draft, setDraft] = useState(previewUrl);
  const [lastUrl, setLastUrl] = useState(previewUrl);
  if (previewUrl !== lastUrl) {
    setLastUrl(previewUrl);
    setDraft(previewUrl);
  }

  const navigate = () => {
    setPreviewUrl(draft);
    reloadPreview();
  };

  const showPreview = (mode: "device" | "fill") => {
    setPreviewMode(mode);
    setRightView("preview");
  };

  const inPreview = rightView === "preview";

  return (
    <div className="flex flex-wrap items-center gap-1.5 border-b px-2 py-1.5">
      <div className="flex items-center rounded-lg border p-0.5">
        <Button
          size="xs"
          variant={inPreview && previewMode === "device" ? "secondary" : "ghost"}
          className={cn(
            !(inPreview && previewMode === "device") && "text-muted-foreground",
          )}
          onClick={() => showPreview("device")}
        >
          <Eye className="size-3.5" />
          Preview
        </Button>
        <Button
          size="xs"
          variant={inPreview && previewMode === "fill" ? "secondary" : "ghost"}
          className={cn(
            !(inPreview && previewMode === "fill") && "text-muted-foreground",
          )}
          onClick={() => showPreview("fill")}
        >
          <Maximize2 className="size-3.5" />
          Full screen
        </Button>
        <Button
          size="xs"
          variant={rightView === "code" ? "secondary" : "ghost"}
          className={cn(rightView !== "code" && "text-muted-foreground")}
          onClick={() => openCode()}
        >
          <Code2 className="size-3.5" />
          Code
        </Button>
      </div>

      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            size="icon-sm"
            variant="ghost"
            className="text-muted-foreground"
            aria-label="More panels"
          >
            <MoreHorizontal className="size-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="start">
          <DropdownMenuItem onSelect={() => openCode()}>
            <Code2 />
            Code
          </DropdownMenuItem>
          <DropdownMenuItem onSelect={() => comingSoon("Connectors")}>
            <Plug />
            Connectors
          </DropdownMenuItem>
          <DropdownMenuItem onSelect={() => comingSoon("APIs")}>
            <Braces />
            APIs
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>

      <form
        className="relative mx-auto min-w-40 flex-1 basis-48 sm:max-w-sm"
        onSubmit={(e) => {
          e.preventDefault();
          navigate();
        }}
      >
        <Input
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          className="h-7 rounded-full bg-muted/60 pr-8 text-xs"
          spellCheck={false}
          aria-label="Preview URL"
        />
        <Button
          type="button"
          size="icon-xs"
          variant="ghost"
          className="absolute top-1/2 right-1 -translate-y-1/2 rounded-full text-muted-foreground"
          onClick={navigate}
          aria-label="Reload preview"
        >
          <RotateCw className="size-3" />
        </Button>
      </form>

      <Button
        size="xs"
        variant={editMode ? "secondary" : "ghost"}
        className={cn(!editMode && "text-muted-foreground")}
        onClick={toggleEditMode}
      >
        <Pencil className="size-3.5" />
        Edit
      </Button>
      <StubIconButton icon={Camera} label="Screenshot" />
      <StubIconButton icon={UserPlus} label="Invite" />

      {inPreview && previewMode === "device" && (
        <Select
          value={selectedDeviceFrameId}
          onValueChange={setSelectedDeviceFrame}
        >
          <SelectTrigger size="sm" className="w-[150px] text-xs">
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
      )}

      <Button
        size="sm"
        className="bg-orange-600 text-white hover:bg-orange-500"
        onClick={() => comingSoon("Launch (deploy to web)")}
      >
        <Rocket className="size-3.5" />
        Launch
      </Button>
    </div>
  );
}
