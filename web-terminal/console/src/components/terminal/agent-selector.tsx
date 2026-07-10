"use client";

import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useTerminalStore } from "@/stores/terminal-store";
import type { TerminalAgent } from "@/lib/types";

const AGENTS: { value: TerminalAgent; label: string; hint: string }[] = [
  { value: "terminal", label: "Terminal", hint: "Plain login shell" },
  { value: "claude", label: "Claude", hint: "Launch claude on connect" },
  { value: "codex", label: "Codex", hint: "Launch codex on connect" },
];

export function AgentSelector() {
  const agent = useTerminalStore((s) => s.agent);
  const setAgent = useTerminalStore((s) => s.setAgent);
  const current = AGENTS.find((a) => a.value === agent);

  return (
    <Select value={agent} onValueChange={(v) => setAgent(v as TerminalAgent)}>
      <SelectTrigger size="sm" className="w-[110px]">
        {/* Children override ItemText so the closed trigger shows only the
            label, not the two-line label+hint rendered in the list. */}
        <SelectValue>{current?.label}</SelectValue>
      </SelectTrigger>
      <SelectContent>
        {AGENTS.map((a) => (
          <SelectItem key={a.value} value={a.value}>
            <span className="flex flex-col">
              <span>{a.label}</span>
              <span className="text-muted-foreground text-xs">{a.hint}</span>
            </span>
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}
