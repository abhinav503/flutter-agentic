"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { getSetup } from "@/lib/bridge";
import { useUiStore } from "@/stores/ui-store";

const SETUP_KEY = ["setup"] as const;

// Port of SetupCubit: lazy-load the prerequisites only once the panel opens,
// cache the result, and expose a refresh (re-probe after running a step).
export function useSetup() {
  const setupOpen = useUiStore((s) => s.setupOpen);
  const qc = useQueryClient();

  const query = useQuery({
    queryKey: SETUP_KEY,
    queryFn: getSetup,
    enabled: setupOpen,
    staleTime: Infinity,
  });

  const items = query.data ?? [];
  const missingCount = items.filter((i) => !i.installed).length;

  return {
    items,
    missingCount,
    isLoading: query.isLoading && setupOpen,
    error: query.error,
    refresh: () => qc.invalidateQueries({ queryKey: SETUP_KEY }),
  };
}
