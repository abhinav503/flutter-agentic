"use client";

import { RotateCw, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { SetupItemTile } from "./setup-item-tile";
import { useSetup } from "@/hooks/use-setup";
import { useUiStore } from "@/stores/ui-store";

// Right-pane prerequisites checklist. Port of setup_panel.dart.
export function SetupPanel() {
  const { items, missingCount, isLoading, error, refresh } = useSetup();
  const setSetupOpen = useUiStore((s) => s.setSetupOpen);

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <div className="flex items-center gap-2 border-b px-3 py-2">
        <span className="text-sm font-medium">Setup</span>
        {missingCount > 0 && (
          <span className="text-muted-foreground text-xs">
            {missingCount} to install
          </span>
        )}
        <div className="ml-auto flex items-center gap-1">
          <Button size="icon" variant="ghost" className="size-7" onClick={refresh}>
            <RotateCw className="size-3.5" />
          </Button>
          <Button
            size="icon"
            variant="ghost"
            className="size-7"
            onClick={() => setSetupOpen(false)}
          >
            <X className="size-3.5" />
          </Button>
        </div>
      </div>

      <div className="min-h-0 flex-1 space-y-2 overflow-y-auto p-3">
        {isLoading && (
          <p className="text-muted-foreground text-sm">Checking prerequisites…</p>
        )}
        {error && (
          <p className="text-destructive text-sm">
            Couldn&apos;t load setup status.
          </p>
        )}
        {items.map((item) => (
          <SetupItemTile key={item.id} item={item} />
        ))}
      </div>
    </div>
  );
}
