import { create } from "zustand";

// "device" shows the preview inside a phone frame; "fill" stretches the
// iframe to the whole pane (the toolbar's Full screen toggle).
export type PreviewMode = "device" | "fill";

// Right-pane toggle for the setup checklist (port of SetupCubit.isOpen) plus
// the preview display mode.
interface UiStore {
  setupOpen: boolean;
  previewMode: PreviewMode;
  toggleSetup: () => void;
  setSetupOpen: (open: boolean) => void;
  setPreviewMode: (mode: PreviewMode) => void;
}

export const useUiStore = create<UiStore>((set) => ({
  setupOpen: false,
  previewMode: "device",
  toggleSetup: () => set((s) => ({ setupOpen: !s.setupOpen })),
  setSetupOpen: (open) => set({ setupOpen: open }),
  setPreviewMode: (mode) => set({ previewMode: mode }),
}));
