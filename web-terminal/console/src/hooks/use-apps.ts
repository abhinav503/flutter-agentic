"use client";

import {
  useMutation,
  useQuery,
  useQueryClient,
} from "@tanstack/react-query";
import { getApps, reloadApp, runApp, stopApp } from "@/lib/bridge";
import type { AppState, RunAppInput } from "@/lib/types";

const APPS_KEY = ["apps"] as const;

// Port of AppsCubit. The refetch loop replaces _pollUntilSettled: while any app
// is `starting`, TanStack Query re-polls /apps every 2s until it settles.
export function useApps() {
  const query = useQuery({
    queryKey: APPS_KEY,
    queryFn: getApps,
    refetchInterval: (q) => {
      const apps = q.state.data;
      return apps?.some((a) => a.status === "starting") ? 2000 : false;
    },
  });

  const apps = query.data ?? [];
  return { apps, isLoading: query.isLoading, error: query.error };
}

export function useRunApp() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (input: RunAppInput) => runApp(input),
    onSuccess: (app) => {
      qc.setQueryData<AppState[]>(APPS_KEY, (prev) =>
        prev?.map((a) => (a.name === app.name ? app : a)) ?? [app],
      );
      qc.invalidateQueries({ queryKey: APPS_KEY });
    },
  });
}

// Hot-restarts a running app; resolves once flutter reports the rebuild done
// (or `ok: false` with a reason), so the caller can reload the preview iframe.
export function useReloadApp() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (name: string) => reloadApp(name),
    onSuccess: (result) => {
      // A failed hot restart usually means the flutter process already died
      // (crash, port conflict, …) after the cache last saw it `running` —
      // polling stops once an app looks `running`, so nothing would otherwise
      // refresh the stale state. Refetch so the UI drops back to Run.
      if (!result.ok) qc.invalidateQueries({ queryKey: APPS_KEY });
    },
  });
}

export function useStopApp() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (name: string) => stopApp(name),
    onSuccess: (app) => {
      qc.setQueryData<AppState[]>(APPS_KEY, (prev) =>
        prev?.map((a) => (a.name === app.name ? app : a)) ?? [app],
      );
      qc.invalidateQueries({ queryKey: APPS_KEY });
    },
  });
}
