"use client";

import { Check, ChevronDown, CircleAlert } from "lucide-react";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";
import { CommandBlock } from "./command-block";
import { cn } from "@/lib/utils";
import type { SetupItem } from "@/lib/types";

// One prerequisite row: status icon, name/detail, and expandable install steps.
// Port of setup_item_tile.dart + setup_tile.dart.
export function SetupItemTile({ item }: { item: SetupItem }) {
  return (
    <Collapsible className="rounded-lg border">
      <CollapsibleTrigger className="flex w-full items-center gap-3 p-3 text-left">
        {item.installed ? (
          <Check className="size-4 shrink-0 text-emerald-500" />
        ) : (
          <CircleAlert className="text-destructive size-4 shrink-0" />
        )}
        <div className="min-w-0 flex-1">
          <p className="text-sm font-medium">{item.name}</p>
          <p className="text-muted-foreground truncate text-xs">
            {item.installed && item.detail ? item.detail : item.description}
          </p>
        </div>
        <ChevronDown className="text-muted-foreground size-4 shrink-0 transition-transform data-[state=open]:rotate-180" />
      </CollapsibleTrigger>
      <CollapsibleContent className="space-y-3 border-t p-3">
        {item.steps.map((step, i) => (
          <div key={i} className="space-y-1.5">
            <p className="text-muted-foreground text-xs font-medium">
              {step.label}
            </p>
            {step.note && (
              <p className="text-muted-foreground text-xs">{step.note}</p>
            )}
            {step.command && !step.manual && (
              <CommandBlock command={step.command} />
            )}
            {step.manual && (
              <span
                className={cn(
                  "bg-muted text-muted-foreground inline-block rounded px-2 py-0.5 text-xs",
                )}
              >
                Manual step
              </span>
            )}
          </div>
        ))}
      </CollapsibleContent>
    </Collapsible>
  );
}
