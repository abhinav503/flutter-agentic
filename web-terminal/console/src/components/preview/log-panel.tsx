"use client";

import { useEffect, useRef } from "react";
import { ChevronDown, ChevronUp, ScrollText } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAppLogs } from "@/hooks/use-app-logs";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";

// Collapsible run-log strip docked at the bottom of the right pane: the
// buffered output of the selected app's `flutter run` process (build
// progress, hot-restart results, prints, crashes), polled while open.
export function LogPanel() {
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const logsOpen = useUiStore((s) => s.logsOpen);
  const toggleLogs = useUiStore((s) => s.toggleLogs);
  const { seq, text } = useAppLogs(selectedAppName, logsOpen);

  const scrollRef = useRef<HTMLPreElement>(null);
  // Follow new output unless the user scrolled up to read something.
  const stickToBottom = useRef(true);

  useEffect(() => {
    const el = scrollRef.current;
    if (el && stickToBottom.current) el.scrollTop = el.scrollHeight;
  }, [seq, logsOpen]);

  if (!selectedAppName) return null;

  const onScroll = () => {
    const el = scrollRef.current;
    if (!el) return;
    stickToBottom.current =
      el.scrollHeight - el.scrollTop - el.clientHeight < 24;
  };

  // Always terminal-dark (same #0b0e14 as the terminal pane), independent of
  // the console theme — build logs read like a terminal, not a document.
  return (
    <div className="border-t bg-[#0b0e14]">
      <Button
        variant="ghost"
        size="sm"
        onClick={toggleLogs}
        className="h-7 w-full justify-start gap-1.5 rounded-none px-3 text-xs text-zinc-400 hover:bg-white/5 hover:text-zinc-200"
      >
        <ScrollText className="size-3.5" />
        Logs
        {logsOpen ? (
          <ChevronDown className="ml-auto size-3.5" />
        ) : (
          <ChevronUp className="ml-auto size-3.5" />
        )}
      </Button>
      {logsOpen && (
        <pre
          ref={scrollRef}
          onScroll={onScroll}
          className="h-48 overflow-auto px-3 py-2 font-mono text-[11px] leading-relaxed whitespace-pre-wrap text-zinc-300"
        >
          {text || "No run output yet — press Run to start the app."}
        </pre>
      )}
    </div>
  );
}
