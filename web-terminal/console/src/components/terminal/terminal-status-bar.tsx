"use client";

import { RotateCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { useTerminalStore } from "@/stores/terminal-store";
import { AgentSelector } from "./agent-selector";
import { SetupButton } from "@/components/setup/setup-button";
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

export function TerminalStatusBar() {
  const status = useTerminalStore((s) => s.status);
  const message = useTerminalStore((s) => s.message);
  const reconnect = useTerminalStore((s) => s.reconnect);

  const canReconnect = status === "exited" || status === "error";
  const label = status === "error" && message ? message : LABELS[status];

  return (
    <div className="flex items-center gap-2 border-b px-3 py-2">
      <span className={cn("size-2 shrink-0 rounded-full", DOT[status])} />
      <span className="text-muted-foreground truncate text-sm">{label}</span>
      <div className="ml-auto flex items-center gap-2">
        {canReconnect && (
          <Button size="sm" variant="outline" onClick={reconnect}>
            <RotateCw className="size-3.5" />
            Reconnect
          </Button>
        )}
        <AgentSelector />
        <SetupButton />
      </div>
    </div>
  );
}
