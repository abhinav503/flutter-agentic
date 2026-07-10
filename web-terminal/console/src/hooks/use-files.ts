"use client";

import { useQuery } from "@tanstack/react-query";
import { getFile, getFileTree } from "@/lib/bridge";

// Source-file queries for the code view. Both are keyed per app; content is
// keyed per file so switching files in the tree is instant once cached.

export function useFileTree(app: string | null) {
  const query = useQuery({
    queryKey: ["files", app],
    queryFn: () => getFileTree(app!),
    enabled: !!app,
    staleTime: 10_000,
  });
  return { tree: query.data ?? [], isLoading: query.isLoading };
}

export function useFileContent(app: string | null, path: string | null) {
  const query = useQuery({
    queryKey: ["file", app, path],
    queryFn: () => getFile(app!, path!),
    enabled: !!app && !!path,
    staleTime: 10_000,
  });
  return { file: query.data ?? null, isLoading: query.isLoading };
}
