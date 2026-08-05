"use client";

import { useRef, useState, type ChangeEvent } from "react";
import Image from "next/image";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { uploadCatalogImage, type CatalogImageKind } from "@/lib/storage";
import { cn } from "@/lib/utils";
import { toast } from "sonner";

// The thumbnail beside the URL box. `sm` is the dialog size — a glance-check
// that the right file landed. `lg` is for a page-level form with room for it,
// where the preview is the thing being judged rather than confirmed.
//
// They also crop differently, and that's the reason the sizes are named rather
// than passed as a number: at 48px a cropped edge is invisible, at 128px it is
// the whole point, so the large one contains the image on a plate instead of
// filling the square with it. A wordmark logo is the case that breaks under
// `cover`.
const PREVIEW = {
  sm: { px: 48, box: "size-12", fit: "object-cover" },
  lg: { px: 128, box: "size-32 bg-muted p-1", fit: "object-contain" },
} as const;

export function ImageUploadField({
  id,
  label,
  storeId,
  kind,
  value,
  onChange,
  previewSize = "sm",
}: {
  id: string;
  label: string;
  storeId: string;
  kind: CatalogImageKind;
  value: string;
  onChange: (url: string) => void;
  previewSize?: keyof typeof PREVIEW;
}) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);
  const preview = PREVIEW[previewSize];

  async function handleFileChange(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    event.target.value = ""; // lets the same file be re-selected later
    if (!file) return;
    if (!file.type.startsWith("image/")) {
      toast.error("Please choose an image file");
      return;
    }
    setUploading(true);
    try {
      const url = await uploadCatalogImage(storeId, kind, file);
      onChange(url);
      toast.success("Image uploaded");
    } catch {
      toast.error("Could not upload image");
    } finally {
      setUploading(false);
    }
  }

  return (
    <div className="flex flex-col gap-1.5">
      <Label htmlFor={id}>{label}</Label>
      <div className="flex items-center gap-3">
        {value ? (
          <Image
            src={value}
            alt=""
            width={preview.px}
            height={preview.px}
            unoptimized
            className={cn(
              "shrink-0 rounded-md border border-border",
              preview.box,
              preview.fit,
            )}
          />
        ) : (
          <div
            className={cn(
              "shrink-0 rounded-md border border-dashed border-border",
              preview.box,
            )}
          />
        )}
        <div className="flex flex-1 flex-col gap-2">
          <Input
            id={id}
            value={value}
            onChange={(e) => onChange(e.target.value)}
            placeholder="https://… or upload a file"
          />
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            className="hidden"
            onChange={handleFileChange}
          />
          <Button
            type="button"
            variant="outline"
            size="sm"
            disabled={uploading}
            onClick={() => fileInputRef.current?.click()}
            className="self-start"
          >
            {uploading ? "Uploading…" : "Upload from device"}
          </Button>
        </div>
      </div>
    </div>
  );
}
