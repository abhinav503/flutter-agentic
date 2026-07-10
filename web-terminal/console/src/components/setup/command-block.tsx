"use client";

import { useState } from "react";
import { Check, Copy, Play } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { useTerminalStore } from "@/stores/terminal-store";

// A runnable shell command: Copy to clipboard, or Run to type it into the live
// terminal session. Port of command_block.dart.
export function CommandBlock({ command }: { command: string }) {
  const sendInput = useTerminalStore((s) => s.sendInput);
  const [copied, setCopied] = useState(false);

  const copy = async () => {
    await navigator.clipboard.writeText(command);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };

  const run = () => {
    sendInput(`${command}\r`);
    toast.success("Sent to terminal");
  };

  return (
    <div className="bg-muted flex items-center gap-2 rounded-md p-2">
      <code className="flex-1 overflow-x-auto font-mono text-xs whitespace-pre">
        {command}
      </code>
      <Button size="icon" variant="ghost" className="size-7" onClick={copy}>
        {copied ? <Check className="size-3.5" /> : <Copy className="size-3.5" />}
      </Button>
      <Button size="icon" variant="ghost" className="size-7" onClick={run}>
        <Play className="size-3.5" />
      </Button>
    </div>
  );
}
