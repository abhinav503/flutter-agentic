"use client";

import { useRef } from "react";
import "@xterm/xterm/css/xterm.css";
import { useTerminalSocket } from "@/hooks/use-terminal-socket";

// The left pane: the xterm surface streaming the PTY session.
export function TerminalConsole() {
  const container = useRef<HTMLDivElement | null>(null);
  useTerminalSocket(container);

  return (
    <div className="min-h-0 flex-1 bg-[#0b0e14] p-2">
      <div ref={container} className="h-full w-full" />
    </div>
  );
}
