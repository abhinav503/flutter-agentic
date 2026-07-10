"use client";

import { useEffect, useRef, useState } from "react";
import { ChevronDown, ChevronRight, FileCode2, Folder } from "lucide-react";
import { cn } from "@/lib/utils";
import type { FileNode } from "@/lib/types";

interface TreeProps {
  nodes: FileNode[];
  selectedPath: string | null;
  onSelect: (path: string) => void;
}

function TreeNode({
  node,
  depth,
  selectedPath,
  onSelect,
}: {
  node: FileNode;
  depth: number;
  selectedPath: string | null;
  onSelect: (path: string) => void;
}) {
  const containsSelection =
    !!selectedPath && selectedPath.startsWith(node.path + "/");
  // lib/ is where readers land, so it starts open.
  const [open, setOpen] = useState(node.path === "lib" || containsSelection);

  // Auto-expand when an outside jump (code icon in edit mode) selects a file
  // inside this folder.
  const [lastSelected, setLastSelected] = useState(selectedPath);
  if (selectedPath !== lastSelected) {
    setLastSelected(selectedPath);
    if (containsSelection && !open) setOpen(true);
  }

  const indent = { paddingLeft: depth * 12 + 8 };

  // Hooks must run before the dir/file branch split. The ref is only attached
  // by the file branch; for a dir the effect never fires (a dir is never the
  // selected path, which is always a file).
  const selected = node.path === selectedPath;
  const ref = useRef<HTMLButtonElement>(null);
  useEffect(() => {
    if (selected) ref.current?.scrollIntoView({ block: "nearest" });
  }, [selected]);

  if (node.type === "dir") {
    return (
      <div>
        <button
          className="hover:bg-muted flex w-full items-center gap-1 rounded-md py-1 pr-2 text-left text-xs"
          style={indent}
          onClick={() => setOpen((o) => !o)}
        >
          {open ? (
            <ChevronDown className="text-muted-foreground size-3 shrink-0" />
          ) : (
            <ChevronRight className="text-muted-foreground size-3 shrink-0" />
          )}
          <Folder className="text-muted-foreground size-3.5 shrink-0" />
          <span className="truncate">{node.name}</span>
        </button>
        {open &&
          node.children?.map((child) => (
            <TreeNode
              key={child.path}
              node={child}
              depth={depth + 1}
              selectedPath={selectedPath}
              onSelect={onSelect}
            />
          ))}
      </div>
    );
  }

  return (
    <button
      ref={ref}
      className={cn(
        "flex w-full items-center gap-1 rounded-md py-1 pr-2 text-left text-xs",
        selected ? "bg-secondary font-medium" : "hover:bg-muted",
      )}
      style={indent}
      onClick={() => onSelect(node.path)}
    >
      <span className="w-3 shrink-0" />
      <FileCode2 className="text-muted-foreground size-3.5 shrink-0" />
      <span className="truncate">{node.name}</span>
    </button>
  );
}

export function FileTree({ nodes, selectedPath, onSelect }: TreeProps) {
  return (
    <div className="space-y-px p-1.5">
      {nodes.map((node) => (
        <TreeNode
          key={node.path}
          node={node}
          depth={0}
          selectedPath={selectedPath}
          onSelect={onSelect}
        />
      ))}
    </div>
  );
}
