"use client";

import {
  ResizableHandle,
  ResizablePanel,
  ResizablePanelGroup,
} from "@/components/ui/resizable";
import { IconRail } from "@/components/shell/icon-rail";
import { ProjectHeader } from "@/components/terminal/project-header";
import { RunBar } from "@/components/terminal/run-bar";
import { TerminalConsole } from "@/components/terminal/terminal-console";
import { RightPane } from "@/components/right-pane";
import { useMediaQuery } from "@/hooks/use-media-query";
import { SPLIT_BREAKPOINT } from "@/lib/config";

function TerminalPane() {
  return (
    <div className="flex h-full min-h-0 flex-1 flex-col">
      <ProjectHeader />
      <RunBar />
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
    <main className="flex h-dvh">
      <IconRail />
      <div className="min-w-0 flex-1">
        <ResizablePanelGroup orientation="horizontal">
          <ResizablePanel defaultSize={42} minSize={25}>
            <TerminalPane />
          </ResizablePanel>
          <ResizableHandle withHandle />
          <ResizablePanel defaultSize={58} minSize={30}>
            <div className="flex h-full min-h-0 flex-col">
              <RightPane />
            </div>
          </ResizablePanel>
        </ResizablePanelGroup>
      </div>
    </main>
  );
}
