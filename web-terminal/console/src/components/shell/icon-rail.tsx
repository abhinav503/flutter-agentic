"use client";

import { useState, type ComponentType, type ReactNode } from "react";
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
import { useSetup } from "@/hooks/use-setup";
import { useUiStore } from "@/stores/ui-store";
import { cn } from "@/lib/utils";

// Collapsed slot width the rail reserves in the layout, and the width the
// overlay grows to on hover.
const RAIL_WIDTH = 48;
const EXPANDED_WIDTH = 208;

const PLACEHOLDER_ITEMS: { icon: ComponentType; label: string }[] = [
  { icon: LayoutGrid, label: "Dashboard" },
  { icon: SquarePen, label: "New project" },
  { icon: Search, label: "Search" },
  { icon: FolderClosed, label: "Files" },
  { icon: Wand2, label: "Visual edit" },
];

function RailItem({
  icon: Icon,
  label,
  onClick,
  active = false,
  expanded,
  badge,
}: {
  icon: ComponentType<{ className?: string }>;
  label: string;
  onClick: () => void;
  active?: boolean;
  expanded: boolean;
  badge?: ReactNode;
}) {
  // No tooltips — hovering expands the rail and shows the labels directly.
  return (
    <Button
      variant={active ? "secondary" : "ghost"}
      className={cn(
        "h-9 w-full justify-start gap-0 overflow-hidden px-2.5",
        !active && "text-muted-foreground",
      )}
      onClick={onClick}
      aria-label={label}
    >
      <span className="relative grid size-4 shrink-0 place-items-center">
        <Icon className="size-4" />
        {badge}
      </span>
      <span
        className={cn(
          "ml-2.5 truncate text-sm transition-opacity duration-150",
          expanded ? "opacity-100" : "opacity-0",
        )}
      >
        {label}
      </span>
    </Button>
  );
}

// Far-left navigation rail (Rocket.new-style). Collapsed it's an icon strip;
// on hover it expands as an overlay on top of the panes (the layout slot stays
// RAIL_WIDTH wide). It contracts on mouse-leave and right after any item is
// clicked. Only Setup is functional today; the rest are visible placeholders
// so the layout is future-proof.
export function IconRail() {
  const [expanded, setExpanded] = useState(false);
  const setupOpen = useUiStore((s) => s.setupOpen);
  const toggleSetup = useUiStore((s) => s.toggleSetup);
  const { missingCount } = useSetup();

  // Collapse after any selection; no mouseenter re-fires until the pointer
  // leaves and comes back, so the rail stays closed under the cursor.
  const select = (action: () => void) => () => {
    action();
    setExpanded(false);
  };

  const comingSoon = (label: string) => toast.info(`${label} — coming soon`);

  return (
    <div className="relative shrink-0" style={{ width: RAIL_WIDTH }}>
      <nav
        className={cn(
          "absolute inset-y-0 left-0 z-40 flex flex-col gap-1 border-r bg-background px-1.5 py-3 transition-[width] duration-200",
          expanded && "shadow-xl",
        )}
        style={{ width: expanded ? EXPANDED_WIDTH : RAIL_WIDTH }}
        onMouseEnter={() => setExpanded(true)}
        onMouseLeave={() => setExpanded(false)}
      >
        <div className="mb-2 flex items-center overflow-hidden">
          <div className="grid size-8 shrink-0 place-items-center rounded-lg bg-primary text-primary-foreground">
            <Rocket className="size-4" />
          </div>
          <span
            className={cn(
              "ml-2 truncate text-sm font-semibold transition-opacity duration-150",
              expanded ? "opacity-100" : "opacity-0",
            )}
          >
            FlutterAgentic
          </span>
        </div>

        {PLACEHOLDER_ITEMS.map(({ icon, label }) => (
          <RailItem
            key={label}
            icon={icon}
            label={label}
            expanded={expanded}
            onClick={select(() => comingSoon(label))}
          />
        ))}

        <RailItem
          icon={ListChecks}
          label="Setup"
          active={setupOpen}
          expanded={expanded}
          onClick={select(toggleSetup)}
          badge={
            missingCount > 0 ? (
              <span className="absolute -top-1.5 -right-1.5 grid size-4 place-items-center rounded-full bg-destructive text-[10px] font-medium text-white">
                {missingCount}
              </span>
            ) : undefined
          }
        />

        <div className="mt-auto flex flex-col gap-1">
          <RailItem
            icon={Bell}
            label="Notifications"
            expanded={expanded}
            onClick={select(() => comingSoon("Notifications"))}
          />
          <div className="flex items-center overflow-hidden">
            <div className="grid size-8 shrink-0 place-items-center rounded-full bg-muted text-xs font-semibold text-muted-foreground">
              FA
            </div>
            <span
              className={cn(
                "ml-2 truncate text-xs text-muted-foreground transition-opacity duration-150",
                expanded ? "opacity-100" : "opacity-0",
              )}
            >
              Account
            </span>
          </div>
        </div>
      </nav>
    </div>
  );
}
