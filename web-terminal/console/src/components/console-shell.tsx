"use client";

import {
  ResizableHandle,
  ResizablePanel,
  ResizablePanelGroup,
} from "@/components/ui/resizable";
import { TerminalStatusBar } from "@/components/terminal/terminal-status-bar";
import { AppsBar } from "@/components/terminal/apps-bar";
import { TerminalConsole } from "@/components/terminal/terminal-console";
import { RightPane } from "@/components/right-pane";
import { useMediaQuery } from "@/hooks/use-media-query";
import { SPLIT_BREAKPOINT } from "@/lib/config";

function TerminalPane() {
  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <TerminalStatusBar />
      <AppsBar />
      <TerminalConsole />
    </div>
  );
}

export function ConsoleShell() {
  const isSplit = useMediaQuery(`(min-width: ${SPLIT_BREAKPOINT}px)`);

  if (!isSplit) {
    return (
      <main className="flex h-dvh flex-col">
        <TerminalPane />
      </main>
    );
  }

  return (
    <main className="h-dvh">
      <ResizablePanelGroup orientation="horizontal">
        <ResizablePanel defaultSize={50} minSize={30}>
          <TerminalPane />
        </ResizablePanel>
        <ResizableHandle withHandle />
        <ResizablePanel defaultSize={50} minSize={25}>
          <div className="flex h-full min-h-0 flex-col">
            <RightPane />
          </div>
        </ResizablePanel>
      </ResizablePanelGroup>
    </main>
  );
}
