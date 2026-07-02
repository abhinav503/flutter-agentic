"use client";

import type { ComponentType } from "react";
import {
  Bell,
  FolderClosed,
  LayoutGrid,
  ListChecks,
  Rocket,
  Search,
  SquarePen,
  Wand2,
} from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import { useSetup } from "@/hooks/use-setup";
import { useUiStore } from "@/stores/ui-store";
import { cn } from "@/lib/utils";

// Far-left navigation rail (Rocket.new-style). Only Setup is functional
// today; the rest are visible placeholders so the layout is future-proof.
const PLACEHOLDER_ITEMS: { icon: ComponentType; label: string }[] = [
  { icon: LayoutGrid, label: "Dashboard" },
  { icon: SquarePen, label: "New project" },
  { icon: Search, label: "Search" },
  { icon: FolderClosed, label: "Files" },
  { icon: Wand2, label: "Visual edit" },
];

function RailButton({
  icon: Icon,
  label,
  onClick,
  active = false,
  children,
}: {
  icon: ComponentType<{ className?: string }>;
  label: string;
  onClick: () => void;
  active?: boolean;
  children?: React.ReactNode;
}) {
  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <Button
          size="icon"
          variant={active ? "secondary" : "ghost"}
          className={cn("relative", !active && "text-muted-foreground")}
          onClick={onClick}
          aria-label={label}
        >
          <Icon className="size-4" />
          {children}
        </Button>
      </TooltipTrigger>
      <TooltipContent side="right">{label}</TooltipContent>
    </Tooltip>
  );
}

export function IconRail() {
  const setupOpen = useUiStore((s) => s.setupOpen);
  const toggleSetup = useUiStore((s) => s.toggleSetup);
  const { missingCount } = useSetup();

  const comingSoon = (label: string) => toast.info(`${label} — coming soon`);

  return (
    <nav className="flex w-12 shrink-0 flex-col items-center gap-1 border-r py-3">
      <div className="mb-2 grid size-8 place-items-center rounded-lg bg-primary text-primary-foreground">
        <Rocket className="size-4" />
      </div>

      {PLACEHOLDER_ITEMS.map(({ icon, label }) => (
        <RailButton
          key={label}
          icon={icon}
          label={label}
          onClick={() => comingSoon(label)}
        />
      ))}

      <RailButton
        icon={ListChecks}
        label="Setup"
        active={setupOpen}
        onClick={toggleSetup}
      >
        {missingCount > 0 && (
          <span className="absolute -top-0.5 -right-0.5 grid size-4 place-items-center rounded-full bg-destructive text-[10px] font-medium text-white">
            {missingCount}
          </span>
        )}
      </RailButton>

      <div className="mt-auto flex flex-col items-center gap-2">
        <RailButton
          icon={Bell}
          label="Notifications"
          onClick={() => comingSoon("Notifications")}
        />
        <div className="grid size-8 place-items-center rounded-full bg-muted text-xs font-semibold text-muted-foreground">
          FA
        </div>
      </div>
    </nav>
  );
}
