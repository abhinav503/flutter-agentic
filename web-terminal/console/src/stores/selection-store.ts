import { create } from "zustand";
import { DEFAULT_PREVIEW_URL, WEB_DEVICE_ID } from "@/lib/config";
import { DEFAULT_DEVICE_FRAME_ID } from "@/lib/device-frames";

// Selected preview app + run target + the iframe address bar state.
// Port of AppsCubit.selected / DevicesCubit.selected + TerminalPreview URL.
interface SelectionStore {
  selectedAppName: string | null;
  selectedDeviceId: string;
  // The phone viewport the preview iframe is framed in (client-only, distinct
  // from selectedDeviceId which is a Flutter run target).
  selectedDeviceFrameId: string;
  previewUrl: string;
  reloadToken: number;

  setSelectedApp: (name: string | null) => void;
  setSelectedDevice: (id: string) => void;
  setSelectedDeviceFrame: (id: string) => void;
  setPreviewUrl: (url: string) => void;
  pointPreviewAt: (url: string) => void;
  reloadPreview: () => void;
}

export const useSelectionStore = create<SelectionStore>((set) => ({
  selectedAppName: null,
  selectedDeviceId: WEB_DEVICE_ID,
  selectedDeviceFrameId: DEFAULT_DEVICE_FRAME_ID,
  previewUrl: DEFAULT_PREVIEW_URL,
  reloadToken: 0,

  setSelectedApp: (name) => set({ selectedAppName: name }),
  setSelectedDevice: (id) => set({ selectedDeviceId: id }),
  setSelectedDeviceFrame: (id) => set({ selectedDeviceFrameId: id }),
  setPreviewUrl: (url) => set({ previewUrl: url }),
  // Force the iframe to a new URL and reload it (used when a web app goes live).
  pointPreviewAt: (url) =>
    set((s) => ({ previewUrl: url, reloadToken: s.reloadToken + 1 })),
  reloadPreview: () => set((s) => ({ reloadToken: s.reloadToken + 1 })),
}));
