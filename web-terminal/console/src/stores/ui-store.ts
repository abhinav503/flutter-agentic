import { create } from "zustand";

// Right-pane toggle for the setup checklist. Port of SetupCubit.isOpen.
interface UiStore {
  setupOpen: boolean;
  toggleSetup: () => void;
  setSetupOpen: (open: boolean) => void;
}

export const useUiStore = create<UiStore>((set) => ({
  setupOpen: false,
  toggleSetup: () => set((s) => ({ setupOpen: !s.setupOpen })),
  setSetupOpen: (open) => set({ setupOpen: open }),
}));
