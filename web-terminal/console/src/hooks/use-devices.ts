"use client";

import { useQuery } from "@tanstack/react-query";
import { useEffect, useRef } from "react";
import { toast } from "sonner";
import { getDevices } from "@/lib/bridge";
import { WEB_DEVICE_ID } from "@/lib/config";
import type { DeviceInfo } from "@/lib/types";

// The synthetic "Web preview" target, always available even if /devices fails.
// Matches DevicesCubit.webPreview.
export const WEB_PREVIEW: DeviceInfo = {
  id: WEB_DEVICE_ID,
  name: "Web preview",
  platform: "web",
  kind: "web",
  isEmulator: false,
};

// Port of DevicesCubit: seed with the web preview, keep it on failure, and
// surface a single toast if the device probe errors.
export function useDevices() {
  const query = useQuery({
    queryKey: ["devices"],
    queryFn: getDevices,
    placeholderData: [WEB_PREVIEW],
  });

  const warned = useRef(false);
  useEffect(() => {
    if (query.error && !warned.current) {
      warned.current = true;
      toast.error("Couldn't list devices — showing Web preview only.");
    }
    if (!query.error) warned.current = false;
  }, [query.error]);

  const devices = query.error ? [WEB_PREVIEW] : query.data ?? [WEB_PREVIEW];
  return { devices, isLoading: query.isLoading };
}
