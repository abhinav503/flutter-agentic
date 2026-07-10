"use client";

import { useEffect, useRef, useState } from "react";
import type { Terminal } from "@xterm/xterm";
import type { FitAddon } from "@xterm/addon-fit";
import { resolveWsUrl } from "@/lib/bridge";
import { TERMINAL_SCROLLBACK } from "@/lib/config";
import { jetBrainsMono } from "@/lib/fonts";
import { useTerminalStore } from "@/stores/terminal-store";
import type { TerminalAgent, TerminalServerMessage } from "@/lib/types";

const AGENT_COMMAND: Record<TerminalAgent, string | null> = {
  terminal: null,
  claude: "claude",
  codex: "codex",
};

// Owns the xterm Terminal + PTY WebSocket. Port of terminal_bloc.dart:
// output streams straight into the terminal (no React re-render), input/resize
// go up the socket, and the selected agent auto-launches on the first output.
export function useTerminalSocket(
  container: React.RefObject<HTMLDivElement | null>,
) {
  const setStatus = useTerminalStore((s) => s.setStatus);
  const registerSendInput = useTerminalStore((s) => s.registerSendInput);
  const reconnectNonce = useTerminalStore((s) => s.reconnectNonce);

  const termRef = useRef<Terminal | null>(null);
  const fitRef = useRef<FitAddon | null>(null);
  const wsRef = useRef<WebSocket | null>(null);
  const [termReady, setTermReady] = useState(false);

  const sendResize = () => {
    const term = termRef.current;
    if (term && wsRef.current?.readyState === WebSocket.OPEN) {
      wsRef.current.send(
        JSON.stringify({ type: "resize", cols: term.cols, rows: term.rows }),
      );
    }
  };

  // Create the terminal once and keep it alive across reconnects.
  useEffect(() => {
    let disposed = false;
    let observer: ResizeObserver | null = null;

    (async () => {
      const [{ Terminal }, { FitAddon }, { WebLinksAddon }] = await Promise.all([
        import("@xterm/xterm"),
        import("@xterm/addon-fit"),
        import("@xterm/addon-web-links"),
      ]);
      if (disposed || !container.current) return;

      const term = new Terminal({
        scrollback: TERMINAL_SCROLLBACK,
        fontFamily: `${jetBrainsMono.style.fontFamily}, monospace`,
        fontSize: 13,
        lineHeight: 1.15,
        cursorBlink: true,
        theme: { background: "#0b0e14", foreground: "#e6e6e6" },
      });
      const fit = new FitAddon();
      term.loadAddon(fit);
      term.loadAddon(new WebLinksAddon());
      term.open(container.current);
      fit.fit();

      term.onData((data) =>
        wsRef.current?.send(JSON.stringify({ type: "input", data })),
      );

      termRef.current = term;
      fitRef.current = fit;
      registerSendInput((data) =>
        wsRef.current?.send(JSON.stringify({ type: "input", data })),
      );

      observer = new ResizeObserver(() => {
        try {
          fit.fit();
          sendResize();
        } catch {
          /* container detached mid-resize */
        }
      });
      observer.observe(container.current);
      setTermReady(true);
    })();

    return () => {
      disposed = true;
      observer?.disconnect();
      termRef.current?.dispose();
      termRef.current = null;
      fitRef.current = null;
      setTermReady(false);
    };
  }, [container, registerSendInput]);

  // (Re)connect the socket whenever the terminal is ready or a reconnect is
  // requested (Reconnect button / agent switch bumps reconnectNonce).
  useEffect(() => {
    if (!termReady) return;
    let cancelled = false;
    let agentLaunched = false;

    termRef.current?.reset();
    setStatus("connecting");

    (async () => {
      let ws: WebSocket;
      try {
        const url = await resolveWsUrl();
        if (cancelled) return;
        ws = new WebSocket(url);
      } catch (err) {
        if (!cancelled) setStatus("error", (err as Error).message);
        return;
      }
      wsRef.current = ws;

      ws.onopen = () => sendResize();
      ws.onmessage = (event) => {
        const msg = JSON.parse(event.data as string) as TerminalServerMessage;
        const term = termRef.current;
        if (msg.type === "output") {
          term?.write(msg.data);
          if (useTerminalStore.getState().status !== "connected") {
            setStatus("connected");
          }
          if (!agentLaunched) {
            agentLaunched = true;
            const cmd = AGENT_COMMAND[useTerminalStore.getState().agent];
            if (cmd) ws.send(JSON.stringify({ type: "input", data: `${cmd}\r` }));
          }
        } else if (msg.type === "exit") {
          term?.write(`\r\n\x1b[90m[process exited with code ${msg.code}]\x1b[0m\r\n`);
          setStatus("exited");
        }
      };
      ws.onerror = () => {
        if (!cancelled) setStatus("error", "Connection error");
      };
      ws.onclose = () => {
        if (cancelled) return;
        const status = useTerminalStore.getState().status;
        if (status !== "error" && status !== "exited") setStatus("exited");
      };
    })();

    return () => {
      cancelled = true;
      const ws = wsRef.current;
      wsRef.current = null;
      if (ws && ws.readyState <= WebSocket.OPEN) ws.close();
    };
  }, [termReady, reconnectNonce, setStatus]);
}
