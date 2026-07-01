import { create } from "zustand";
import type { TerminalAgent, TerminalStatus } from "@/lib/types";

// Mirrors TerminalState + the reconnect/agent events from terminal_bloc.dart.
// The live xterm Terminal and WebSocket are owned by useTerminalSocket; this
// store holds only the observable status and wires a sendInput bridge so other
// components (e.g. the setup command blocks) can type into the shell.
interface TerminalStore {
  status: TerminalStatus;
  message: string | null;
  agent: TerminalAgent;
  reconnectNonce: number;
  sendInput: (data: string) => void;

  setStatus: (status: TerminalStatus, message?: string | null) => void;
  setAgent: (agent: TerminalAgent) => void;
  reconnect: () => void;
  registerSendInput: (fn: (data: string) => void) => void;
}

export const useTerminalStore = create<TerminalStore>((set) => ({
  status: "connecting",
  message: null,
  agent: "claude",
  reconnectNonce: 0,
  sendInput: () => {},

  setStatus: (status, message = null) => set({ status, message }),
  // Switching agent restarts the session so the new agent launches cleanly.
  setAgent: (agent) =>
    set((s) => ({ agent, reconnectNonce: s.reconnectNonce + 1 })),
  reconnect: () => set((s) => ({ reconnectNonce: s.reconnectNonce + 1 })),
  registerSendInput: (fn) => set({ sendInput: fn }),
}));
