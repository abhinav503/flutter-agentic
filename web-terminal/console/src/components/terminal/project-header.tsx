"use client";

import { RotateCw } from "lucide-react";
import { Button } from "@/components/ui/button";
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
import { cn } from "@/lib/utils";
import { useApps } from "@/hooks/use-apps";
import { useSelectionStore } from "@/stores/selection-store";
import { useTerminalStore } from "@/stores/terminal-store";
import { AgentSelector } from "./agent-selector";
import type { TerminalStatus } from "@/lib/types";

const LABELS: Record<TerminalStatus, string> = {
  connecting: "Connecting to local shell…",
  connected: "Connected",
  exited: "Session ended",
  error: "Connection error",
};

const DOT: Record<TerminalStatus, string> = {
  connecting: "bg-muted-foreground animate-pulse",
  connected: "bg-emerald-500",
  exited: "bg-destructive",
  error: "bg-destructive",
};

// Top of the left pane: the project (app) picker styled as a title, the
// PTY connection status, and the agent selector. Replaces the old status bar;
// the app select used to live in the apps bar.
export function ProjectHeader() {
  const { apps } = useApps();
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const setSelectedApp = useSelectionStore((s) => s.setSelectedApp);

  const status = useTerminalStore((s) => s.status);
  const message = useTerminalStore((s) => s.message);
  const reconnect = useTerminalStore((s) => s.reconnect);

  const canReconnect = status === "exited" || status === "error";
  const label = status === "error" && message ? message : LABELS[status];
  const app = apps.find((a) => a.name === selectedAppName) ?? apps[0];

  return (
    <div className="flex items-center gap-2 border-b px-2 py-2">
      {app ? (
        <Select value={app.name} onValueChange={setSelectedApp}>
          <SelectTrigger
            size="sm"
            className="max-w-[200px] border-0 bg-transparent pl-1.5 font-semibold shadow-none dark:bg-transparent"
          >
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {apps.map((a) => (
              <SelectItem key={a.name} value={a.name}>
                {a.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      ) : (
        <span className="pl-1.5 text-sm font-semibold">Console</span>
      )}

      <Tooltip>
        <TooltipTrigger asChild>
          <span
            className={cn("size-2 shrink-0 rounded-full", DOT[status])}
            aria-label={label}
          />
        </TooltipTrigger>
        <TooltipContent side="bottom">{label}</TooltipContent>
      </Tooltip>
      {status !== "connected" && (
        <span className="text-muted-foreground truncate text-xs">{label}</span>
      )}

      <div className="ml-auto flex items-center gap-2">
        {canReconnect && (
          <Button size="sm" variant="outline" onClick={reconnect}>
            <RotateCw className="size-3.5" />
            Reconnect
          </Button>
        )}
        <AgentSelector />
      </div>
    </div>
  );
}
