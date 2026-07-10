"use client";

import { useQuery } from "@tanstack/react-query";
import { getAppLogs } from "@/lib/bridge";

// Polls the buffered `flutter run` output for an app while the log panel is
// open. The buffer is capped server-side (~64 KB), so refetching the whole
// thing every second is cheap and keeps the client stateless — no cursor
// bookkeeping to lose on remount.
export function useAppLogs(app: string | null, enabled: boolean) {
  const query = useQuery({
    queryKey: ["app-logs", app],
    queryFn: () => getAppLogs(app!),
    enabled: !!app && enabled,
    refetchInterval: 1000,
  });
  return { seq: query.data?.seq ?? 0, text: query.data?.text ?? "" };
}
