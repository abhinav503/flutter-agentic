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
  return useMutation({
    mutationFn: (name: string) => reloadApp(name),
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
