import { create } from "zustand";

// "device" shows the preview inside a phone frame; "fill" stretches the
// iframe to the whole pane (the toolbar's Full screen toggle).
export type PreviewMode = "device" | "fill";

// What the right pane shows (setup panel, when open, wins over both).
export type RightView = "preview" | "code";

// A file (and optional line/column) the code view should open at.
export interface CodeTarget {
  path: string;
  line?: number;
  column?: number;
}

interface UiStore {
  setupOpen: boolean;
  previewMode: PreviewMode;
  rightView: RightView;
  editMode: boolean;
  codeTarget: CodeTarget | null;
  logsOpen: boolean;

  toggleLogs: () => void;
  toggleSetup: () => void;
  setSetupOpen: (open: boolean) => void;
  setPreviewMode: (mode: PreviewMode) => void;
  setRightView: (view: RightView) => void;
  toggleEditMode: () => void;
  setEditMode: (on: boolean) => void;
  // Jump the right pane to the code view, optionally at a file/line.
  openCode: (target?: CodeTarget) => void;
  // Return to the preview and drop the target so no stale highlight lingers.
  closeCode: () => void;
}

export const useUiStore = create<UiStore>((set) => ({
  setupOpen: false,
  previewMode: "device",
  rightView: "preview",
  editMode: false,
  codeTarget: null,
  logsOpen: false,

  toggleLogs: () => set((s) => ({ logsOpen: !s.logsOpen })),
  toggleSetup: () => set((s) => ({ setupOpen: !s.setupOpen })),
  setSetupOpen: (open) => set({ setupOpen: open }),
  setPreviewMode: (mode) => set({ previewMode: mode }),
  setRightView: (view) => set({ rightView: view }),
  toggleEditMode: () =>
    set((s) => ({ editMode: !s.editMode, rightView: "preview" })),
  setEditMode: (on) => set({ editMode: on }),
  openCode: (target) =>
    set({ rightView: "code", codeTarget: target ?? null, setupOpen: false }),
  closeCode: () => set({ rightView: "preview", codeTarget: null }),
}));
