"use client";

import { ListChecks } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useSetup } from "@/hooks/use-setup";
import { useUiStore } from "@/stores/ui-store";

// Top-bar toggle for the setup checklist, with a missing-count badge.
export function SetupButton() {
  const setupOpen = useUiStore((s) => s.setupOpen);
  const toggleSetup = useUiStore((s) => s.toggleSetup);
  const { missingCount } = useSetup();

  return (
    <Button
      size="sm"
      variant={setupOpen ? "secondary" : "outline"}
      onClick={toggleSetup}
    >
      <ListChecks className="size-3.5" />
      Setup
      {missingCount > 0 && (
        <Badge variant="destructive" className="ml-1 px-1.5">
          {missingCount}
        </Badge>
      )}
    </Button>
  );
}
