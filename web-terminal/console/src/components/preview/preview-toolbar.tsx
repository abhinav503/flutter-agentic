"use client";

import { useState } from "react";
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

// Rocket-style toolbar above the preview canvas: Preview/Full-screen toggle,
// overflow menu (Code / Connectors / APIs — stubs), address bar with reload,
// stub actions, viewport picker, and the Launch button.
export function PreviewToolbar() {
  const previewMode = useUiStore((s) => s.previewMode);
  const setPreviewMode = useUiStore((s) => s.setPreviewMode);

  const previewUrl = useSelectionStore((s) => s.previewUrl);
  const setPreviewUrl = useSelectionStore((s) => s.setPreviewUrl);
  const reloadPreview = useSelectionStore((s) => s.reloadPreview);
  const selectedDeviceFrameId = useSelectionStore(
    (s) => s.selectedDeviceFrameId,
  );
  const setSelectedDeviceFrame = useSelectionStore(
    (s) => s.setSelectedDeviceFrame,
  );

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

  return (
    <div className="flex flex-wrap items-center gap-1.5 border-b px-2 py-1.5">
      <div className="flex items-center rounded-lg border p-0.5">
        <Button
          size="xs"
          variant={previewMode === "device" ? "secondary" : "ghost"}
          className={cn(previewMode !== "device" && "text-muted-foreground")}
          onClick={() => setPreviewMode("device")}
        >
          <Eye className="size-3.5" />
          Preview
        </Button>
        <Button
          size="xs"
          variant={previewMode === "fill" ? "secondary" : "ghost"}
          className={cn(previewMode !== "fill" && "text-muted-foreground")}
          onClick={() => setPreviewMode("fill")}
        >
          <Maximize2 className="size-3.5" />
          Full screen
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
          <DropdownMenuItem onSelect={() => comingSoon("Code view")}>
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

      <StubIconButton icon={Pencil} label="Visual edit" />
      <StubIconButton icon={Camera} label="Screenshot" />
      <StubIconButton icon={UserPlus} label="Invite" />

      {previewMode === "device" && (
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
