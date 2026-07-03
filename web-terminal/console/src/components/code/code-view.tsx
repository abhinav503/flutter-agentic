"use client";

import { useEffect, useRef, useState } from "react";
import Editor, { type OnMount } from "@monaco-editor/react";
import { X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { LoaderCircle } from "lucide-react";
import { FileTree } from "./file-tree";
import { useFileContent, useFileTree } from "@/hooks/use-files";
import { useSelectionStore } from "@/stores/selection-store";
import { useUiStore } from "@/stores/ui-store";
import type { FileNode } from "@/lib/types";

const LANGUAGES: Record<string, string> = {
  ".dart": "dart",
  ".yaml": "yaml",
  ".yml": "yaml",
  ".json": "json",
  ".arb": "json",
  ".md": "markdown",
  ".html": "html",
  ".css": "css",
  ".js": "javascript",
  ".ts": "typescript",
  ".xml": "xml",
  ".plist": "xml",
  ".kts": "kotlin",
  ".gradle": "groovy",
  ".swift": "swift",
};

function languageFor(path: string): string {
  const ext = path.slice(path.lastIndexOf("."));
  return LANGUAGES[ext] ?? "plaintext";
}

function firstDartFile(nodes: FileNode[]): string | null {
  for (const node of nodes) {
    if (node.type === "file" && node.path.endsWith(".dart")) return node.path;
    if (node.type === "dir") {
      const hit = firstDartFile(node.children ?? []);
      if (hit) return hit;
    }
  }
  return null;
}

// Read-only source browser for the selected app: file tree + Monaco. Opened
// from the toolbar's Code button or the edit-overlay's jump-to-code action
// (which also targets a line via ui-store.codeTarget).
export function CodeView() {
  const selectedAppName = useSelectionStore((s) => s.selectedAppName);
  const codeTarget = useUiStore((s) => s.codeTarget);
  const closeCode = useUiStore((s) => s.closeCode);

  const { tree, isLoading } = useFileTree(selectedAppName);
  const [selectedPath, setSelectedPath] = useState<string | null>(
    codeTarget?.path ?? null,
  );

  // Follow jump-to-code targets that arrive while already open.
  const [lastTarget, setLastTarget] = useState(codeTarget);
  if (codeTarget !== lastTarget) {
    setLastTarget(codeTarget);
    if (codeTarget) setSelectedPath(codeTarget.path);
  }

  // Land somewhere useful when opened without a target.
  const defaultPath =
    tree.length > 0 ? (firstDartFile(tree) ?? tree[0].path) : null;
  const path = selectedPath ?? defaultPath;

  const { file, isLoading: fileLoading } = useFileContent(
    selectedAppName,
    path,
  );

  // Reveal + highlight the target line once its file is the one on screen. A
  // persistent decoration (not just the caret's current-line box, which
  // vanishes on the next click) marks where the jump landed; a flash class
  // plays once and is dropped after ~1.5s, leaving the quiet band behind.
  const editorRef = useRef<Parameters<OnMount>[0] | null>(null);
  const monacoRef = useRef<Parameters<OnMount>[1] | null>(null);
  const decorationsRef = useRef<ReturnType<
    Parameters<OnMount>[0]["createDecorationsCollection"]
  > | null>(null);
  const flashTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const revealTargetLine = () => {
    const editor = editorRef.current;
    const monaco = monacoRef.current;
    if (!editor || !monaco) return;

    // Clear the highlight whenever the visible file isn't the target file, so
    // switching away (or closing) never leaves a stale band behind.
    if (!codeTarget?.line || file?.path !== codeTarget.path) {
      if (flashTimerRef.current) clearTimeout(flashTimerRef.current);
      decorationsRef.current?.clear();
      return;
    }

    const line = codeTarget.line;
    const maxCol = editor.getModel()?.getLineMaxColumn(line) ?? 1;
    const col = Math.min(codeTarget.column ?? 1, maxCol);
    const range = new monaco.Range(line, 1, line, maxCol);

    const persistent = {
      range,
      options: {
        isWholeLine: true,
        className: "edit-target-line",
        glyphMarginClassName: "edit-target-glyph",
      },
    };
    decorationsRef.current ??= editor.createDecorationsCollection();
    decorationsRef.current.set([
      {
        ...persistent,
        options: {
          ...persistent.options,
          className: "edit-target-line edit-target-flash",
        },
      },
    ]);
    editor.revealRangeInCenterIfOutsideViewport(range);
    editor.setPosition({ lineNumber: line, column: col });

    if (flashTimerRef.current) clearTimeout(flashTimerRef.current);
    flashTimerRef.current = setTimeout(
      () => decorationsRef.current?.set([persistent]),
      2000,
    );
  };
  useEffect(revealTargetLine, [file?.path, codeTarget]);

  useEffect(
    () => () => {
      if (flashTimerRef.current) clearTimeout(flashTimerRef.current);
      decorationsRef.current?.clear();
    },
    [],
  );

  if (!selectedAppName) {
    return (
      <div className="text-muted-foreground grid min-h-0 flex-1 place-items-center text-sm">
        Select an app to browse its code.
      </div>
    );
  }

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <div className="flex items-center gap-2 border-b px-3 py-1.5">
        <span className="truncate font-mono text-xs">
          {selectedAppName}
          {path ? ` / ${path}` : ""}
        </span>
        <Button
          size="icon-xs"
          variant="ghost"
          className="text-muted-foreground ml-auto"
          onClick={closeCode}
          aria-label="Close code view"
        >
          <X className="size-3.5" />
        </Button>
      </div>

      <div className="flex min-h-0 flex-1">
        <div className="w-56 shrink-0 overflow-y-auto border-r">
          {isLoading ? (
            <p className="text-muted-foreground p-3 text-xs">Loading files…</p>
          ) : (
            <FileTree
              nodes={tree}
              selectedPath={path}
              onSelect={setSelectedPath}
            />
          )}
        </div>

        <div className="min-w-0 flex-1">
          {fileLoading ? (
            <div className="text-muted-foreground grid h-full place-items-center">
              <LoaderCircle className="size-5 animate-spin" />
            </div>
          ) : file ? (
            <Editor
              height="100%"
              path={file.path}
              language={languageFor(file.path)}
              value={file.content}
              onMount={(editor, monaco) => {
                editorRef.current = editor;
                monacoRef.current = monaco;
                revealTargetLine();
              }}
              options={{
                readOnly: true,
                minimap: { enabled: false },
                fontSize: 12.5,
                glyphMargin: true,
                scrollBeyondLastLine: false,
                renderLineHighlight: "all",
                wordWrap: "off",
              }}
            />
          ) : (
            <div className="text-muted-foreground grid h-full place-items-center text-sm">
              Select a file to view it.
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
