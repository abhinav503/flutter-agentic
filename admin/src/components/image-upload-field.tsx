"use client";

import { useRef, useState, type ChangeEvent } from "react";
import Image from "next/image";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { uploadCatalogImage } from "@/lib/storage";
import { toast } from "sonner";

export function ImageUploadField({
  id,
  label,
  storeId,
  kind,
  value,
  onChange,
}: {
  id: string;
  label: string;
  storeId: string;
  kind: "categories" | "products";
  value: string;
  onChange: (url: string) => void;
}) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);

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
            width={48}
            height={48}
            unoptimized
            className="size-12 shrink-0 rounded-md border border-border object-cover"
          />
        ) : (
          <div className="size-12 shrink-0 rounded-md border border-dashed border-border" />
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
